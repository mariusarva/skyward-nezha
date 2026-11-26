# 17 Ultra builds

| version | what |
| v0.5.9 | 与 17（pudding）同源：Root 管理（在线装 KernelSU / Magisk，写前备份原厂 boot，只升不降，卡上显示百分比与速度、滑回即取消）；模块管理换成 KernelSU/Magisk 那一套；合并 Kinaxie 的服务复用与 optional、解密现场、解锁多处读、keep 双槽、快照未合并不许离开；补表情字体（NotoColorEmoji / Flags）；修 mk.sh 取原厂 vbmeta 的地址（ramdisk 变长后原来读到空洞，镜像里没有 AVB0，2026-11-26） |
|---|---|
| 0.3.15 | same source line as the 17: read-only page for system apps, WLAN driver warmed earlier (2026-11-18) |
| — | upstream builds this phone from `v0.1.0` on |
| 0.3.12 | built here from the shared source line, on upstream's own image as the shell; upstream's configuration unchanged except `update = false` |

Not tried on a phone yet. What to watch for when it is: the same lines the other
phones showed — `… was ready in … s` for each key program, and
`no touch panel came up` if a driver is missing.
