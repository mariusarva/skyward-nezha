# Skyward for the Xiaomi 17 Ultra (nezha)

The 17 Ultra is one of the phones upstream Skyward names, and the configuration
upstream ships for it is the one used here — nothing in it was changed apart
from turning its own online update off.

```
device.toml   the phone's configuration, as upstream ships it (+ update = false)
mk.sh         builds the binary and packs a recovery image
```

## Where the shell comes from

A recovery image is Skyward's binary inside the phone's **own stock recovery
ramdisk**: the props, the fstab and the init rules the phone boots by, plus the
AVB footer and vbmeta. `mk.sh` takes such an image as its second argument and
replaces only `system/bin/recovery` and `skyward/device.toml`.

Upstream publishes a build for this phone, so an image of theirs serves as that
shell: it is the same stock ramdisk with Skyward's files already in it.

```
curl -LO https://github.com/kirklin/skyward/releases/download/v0.3.1/skyward-v0.3.1-nezha-OS4.0.4.0.XPACNXM.zip
unzip skyward-v0.3.1-nezha-OS4.0.4.0.XPACNXM.zip
./mk.sh 0.3.12 skyward-v0.3.1-nezha-OS4.0.4.0.XPACNXM.img
```

The phone's own dump of its recovery partition
(`dd if=/dev/block/bootdevice/by-name/recovery`) works just as well and is the
better long-term source: it is also how the phone is put back.

## How this phone opens its data partition

Upstream's configuration leaves the key programs alone: the installed system's
own partitions say which ones are started and how, and the recovery starts them
in that order. Unlike the 17, nothing is excluded (`[keys] leave_out` is absent)
and no files are carried alongside — the phone's secure element and weaver are
expected to run as its own init runs them.

Upstream's author verified this phone decrypts with that configuration. The build
here differs from theirs only in the Skyward version it carries.
