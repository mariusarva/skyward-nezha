# 17 Ultra builds

| version | what |
|---|---|
| v0.5.15 | 与 pudding v0.5.15 同源：壁纸改成读自定文件夹（默认 `/storage/emulated/0/Skyward`，jpg/png 丢进去即可，正方形缩略图、选中打勾）；新增「前景」滑杆调页面薄纱浓淡；新增「磁贴底色」只管关着的磁贴（点亮仍用主色）；主题颜色页壁纸挪到最上，壁纸块与三组颜色可折叠并带「展开／收起」提示，五根滑杆并进一张卡；排序页支持按住拖动换位（跨栏、贴边自动滚、落点震动）；系统应用可点开详情、导出安装包、排队停用／启用，并新增「已停用的应用」页；修浅色／柔光下大标题与分区名压在深壁纸上看不清、切页闪黑、触摸屏到位前亮屏点不动、解锁页无壁纸、排序拖动闪退（band 高度不符）与拖动 50–92 ms 一帧 |
| v0.5.13 | 与 pudding v0.5.13 同源：首页自建分类与任意排序、「其他」可挪不可删（删分类的条目按原顺序落进来）；分类／条目／「其他」／首页标题都能改名且搜索认新名字；布局备份可导出到任意目录、导入任意 .json；文件传输进独立页开关；磁贴区删「高级工具」、补八枚并分两组；修掉名字页点输入框闪退。基座仍是上一版镜像，非原厂 recovery |
| v0.5.12 | 与 pudding v0.5.12 同源：WLAN 手动 IP（进页预填租约、网关须同网段、重启按它配置、详情页显示地址来源）；已保存的 WiFi 能真正删除；撤掉每秒重写 enable_touch_raw（改唤醒补写一次）；DHCP 失败日志带应答原文。mk.sh 产物名与 SRC 默认值修掉 |
| v0.5.9 | 与 17（pudding）同源：Root 管理（在线装 KernelSU / Magisk，写前备份原厂 boot，只升不降，卡上显示百分比与速度、滑回即取消）；模块管理换成 KernelSU/Magisk 那一套；合并 Kinaxie 的服务复用与 optional、解密现场、解锁多处读、keep 双槽、快照未合并不许离开；补表情字体（NotoColorEmoji / Flags）；修 mk.sh 取原厂 vbmeta 的地址（ramdisk 变长后原来读到空洞，镜像里没有 AVB0，2026-11-26） |
| 0.3.15 | same source line as the 17: read-only page for system apps, WLAN driver warmed earlier (2026-11-18) |
| — | upstream builds this phone from `v0.1.0` on |
| 0.3.12 | built here from the shared source line, on upstream's own image as the shell; upstream's configuration unchanged except `update = false` |

Not tried on a phone yet. What to watch for when it is: the same lines the other
phones showed — `… was ready in … s` for each key program, and
`no touch panel came up` if a driver is missing.
