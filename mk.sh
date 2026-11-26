#!/bin/sh
# Build Skyward for the Xiaomi 17 Ultra (nezha) and pack it into a recovery image.
#
# usage: ./mk.sh <version> <stock-recovery.img> [output-name]
#
# The stock recovery the phone ships is the shell: its ramdisk holds the props,
# the fstab and the init rules this phone boots with. `device.toml`'s [[file]]
# entries are copied into that ramdisk here -- a step a build that forgets it
# produces an image whose secure element service dies on its libraries and whose
# data partition therefore never opens (2026-11-17).
set -e
REL="$1"; STOCK="$2"; NAME=${3:-skyward-nezha-$REL-OS4.0.3.0.XAFCNXM.img}
[ -f "$STOCK" ] || { echo "no stock recovery at $STOCK" >&2; exit 1; }
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=${SKYWARD_SRC:-$HERE/../..}
export TZ=Asia/Shanghai
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
cd "$SRC"
export CARGO_HOME=${CARGO_HOME:-$HOME/.cargo}
export SKYWARD_RELEASE="$REL"
cargo build --release -p skyward --target aarch64-linux-android --offline
cd "$WORK"
cp "$STOCK" orig.img
python3 - <<'PY'
import struct
d = open('orig.img', 'rb').read()
kernel, ramdisk, _, _ = struct.unpack_from('<IIII', d, 8)
open('rd.lz4', 'wb').write(d[4096:4096 + ramdisk])
PY
lz4 -d -f rd.lz4 rd.cpio >/dev/null 2>&1
mkdir rd && (cd rd && cpio -id -m --no-absolute-filenames < ../rd.cpio 2>/dev/null)
cp "$SRC/target/aarch64-linux-android/release/skyward" rd/system/bin/recovery
chmod 755 rd/system/bin/recovery
cp "$HERE/device.toml" rd/skyward/device.toml
# What the configuration names is copied in: path is where it sits in the
# ramdisk, source is the copy this branch carries.
python3 - "$HERE" <<'PY'
import os, re, shutil, sys
here = sys.argv[1]
text = open(os.path.join(here, 'device.toml'), encoding='utf-8').read()
pairs = re.findall(r'\[\[file\]\]\s*\npath = "([^"]+)"\s*\nsource = "([^"]+)"', text)
for target, source in pairs:
    at = os.path.join('rd', target.lstrip('/'))
    os.makedirs(os.path.dirname(at), exist_ok=True)
    shutil.copyfile(os.path.join(here, source.replace('devices/nezha/files/', 'files/')), at)
    os.chmod(at, 0o644)
print(f'copied {len(pairs)} files')
PY
(cd rd && find . -print0 | cpio --null -o -H newc --owner=0:0 --reproducible 2>/dev/null > ../rd_new.cpio)
lz4 -l -12 -f rd_new.cpio rd_new.lz4 >/dev/null 2>&1
# The footer and vbmeta are the stock ones, with the descriptor's size and
# digest rewritten for what was just packed.
python3 - "$HERE" <<'PY'
import hashlib, struct, sys
orig = open('orig.img', 'rb').read()
raw = open('rd_new.lz4', 'rb').read()
header = bytearray(orig[:1584])
struct.pack_into('<I', header, 0x08, 0)
struct.pack_into('<I', header, 0x0c, len(raw))
struct.pack_into('<I', header, 0x62c, 0)
image = bytes(header) + b'\x00' * ((-1584) % 4096) + raw
image += b'\x00' * ((-len(image)) % 4096)
L = ((4096 + len(raw)) + 4095) // 4096 * 4096
# 原厂镜像自己的 vbmeta 在「它自己的」页对齐位置上：ramdisk 一变长，拿新
# 地址去读就会读到尾巴前的空洞，打出来的镜像里没有 AVB0（2026-11-26 修）。
stock_ramdisk = struct.unpack_from('<I', orig, 12)[0]
L_stock = ((4096 + stock_ramdisk) + 4095) // 4096 * 4096
vbmeta = bytearray(orig[L_stock:L_stock + 512])
assert vbmeta[:4] == b'AVB0', 'the stock recovery has no vbmeta at %d' % L_stock
footer = bytearray(orig[-64:])
struct.pack_into('>Q', vbmeta, 256 + 16, L)
vbmeta[256 + 140:256 + 172] = hashlib.sha256(image[:L]).digest()
struct.pack_into('>Q', footer, 12, L)
struct.pack_into('>Q', footer, 20, L)
struct.pack_into('>Q', footer, 28, 512)
out = image + bytes(vbmeta) + b'\x00' * (104857600 - L - 512 - 64) + bytes(footer)
open('out.img', 'wb').write(out)
print('wrote out.img', len(out))
PY
cp out.img "$NAME"
ls -l "$NAME"; sha256sum "$NAME"; md5sum "$NAME"
