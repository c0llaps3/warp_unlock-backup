# 【刷 WARP IP】 - 为 WARP 解锁流媒体而生
Born to make stream media unlock by WARP 

* * *

# 目录

- [更新信息和 TODO](README.md#更新信息和-todo)
- [脚本特点](README.md#脚本特点)
- [运行脚本](README.md#运行脚本)
- [鸣谢](README.md#鸣谢下列作者的文章和项目)

* * *

## 更新信息和 TODO
TODO: Support TG bot 人形支持

2022.1.30 1.03 1. Suppport pass parameter. You can run like this:```bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/t.sh) -E -A us -4 -N nd -M 2```; 2. Improve log details     
1. 支持传参，你可以这样运行脚本:  ```bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/t.sh) -E -A us -4 -N nd -M2```; 2. 把日志详细

2022.1.29 1.02 1. Support Disney+ 1. 支持 Disney+

2022.1.28 1.01 1. Add two ways to unlock; 2. Add running logs file 1. 增加两种解锁方式; 2. 加入运行日志
```
2022-01-30 19:30:05. IP: 8.38.147.6. Country: Singapore. ASN: CLOUDFLARENET.
2022-01-30 19:30:06. IP: 8.38.147.6. Country: Singapore. ASN: CLOUDFLARENET. Netflix: No.
2022-01-30 19:30:16. IP: 8.29.105.162. Country: United States. ASN: CLOUDFLARENET. Netflix: No.
2022-01-30 19:30:26. IP: 8.30.234.152. Country: Singapore. ASN: CLOUDFLARENET. Netflix: No.
2022-01-30 19:30:34. IP: 8.29.105.171. Country: United States. ASN: CLOUDFLARENET. Netflix: No.
2022-01-30 19:30:43. IP: 8.30.234.205. Country: Singapore. ASN: CLOUDFLARENET. Netflix: No.
2022-01-30 19:30:52. IP: 8.29.105.35. Country: United States. ASN: CLOUDFLARENET. Netflix: No.
2022-01-30 19:31:01. IP: 8.30.234.5. Country: Singapore. ASN: CLOUDFLARENET. Netflix: No.
2022-01-30 19:31:14. IP: 8.25.96.123. Country: Singapore. ASN: CLOUDFLARENET. Netflix: Yes.
2022-01-30 19:35:05. IP: 8.25.96.123. Country: Singapore. ASN: CLOUDFLARENET.
2022-01-30 19:35:08. IP: 8.25.96.123. Country: Singapore. ASN: CLOUDFLARENET. Netflix: Yes.
2022-01-30 19:40:05. IP: 8.25.96.123. Country: Singapore. ASN: CLOUDFLARENET.
2022-01-30 19:40:09. IP: 8.25.96.123. Country: Singapore. ASN: CLOUDFLARENET. Netflix: Yes.
2022-01-30 19:45:04. IP: 8.25.96.123. Country: Singapore. ASN: CLOUDFLARENET.
2022-01-30 19:45:08. IP: 8.25.96.123. Country: Singapore. ASN: CLOUDFLARENET. Netflix: Yes.
```

beta 2022.1.26 Media unlock daemon. Check it every 5 minutes. If unlocked, the scheduled task exits immediately. If it is not unlocked, it will be swiped successfully in the background. Advantages: Minimized use of system resources. ~Disadvantage: Can't see the results as intuitively as screen~

## 脚本特点
* 支持多种主流串流影视检测，可以单选或多选
* 多种方式解锁: 1.每 5 分钟检测一次状态; 2. screen 后台运行; 3. nohup & 后台运行 (已经是天花板，有本事来 [issue](https://github.com/fscarmen/warp_unlock/issues) 挑战)
* 支持 WARP Socks5 Proxy 检测和更换 IP 
* 日志输出

<img src="https://user-images.githubusercontent.com/62703343/151651669-92d5263e-bfa2-4c2c-9928-683b678d9956.png" width="70%" />

## 运行脚本

### 1.菜单方式 (menu)
```
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/warp_unlock/main/unlock.sh)
```
### 2.带参数 (pass parameter)
  | paremeter 参数 | value 值 | describe 具体动作说明 |
  | ----------|------- | --------------- |
  | -E || English 英文 |
  | -C || Chinese 中文 |
  | -U || Uninstall 卸载  |
  | -4 || Brush IPv4 IP 刷 IPv4 |
  | -6 || Brush IPv6 IP 刷 IPv6 |
  | -S || Brush Socks5  刷 Socks5 |
  | -M | 1 | Mode 1: detect every 5   minute 每5分钟检测 |
  | -M | 2 | Mode 2: run by screen   以 screen 方式运行 |
  | -M | 3 | Mode 2: run by nohup &   以 hup & 方式运行 |
  | -A | ** | region abbreviation,such as us. 地区简码,如 us |
  | -N | n | Unlock Neflix 解锁奈飞 |
  | -N | d | Unlock Disney+ 解锁迪士尼 |
  | -N | ud | Unlock Neflix and Disney+ 解锁奈飞和迪士尼 |

For example 1: Language is Chinese. Unlock area is Singapore. Brush WARP IPv4. Unlock Netflix and detect every 5 minute when successed
举例1: 用中文，解锁新加坡奈飞，当成功的时候每5分钟检测一次
```
bash -x  <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/t.sh) -C -A sg -4 -N n -M 1
```
For example 2: Display and uninstall in English
举例2: 用英文卸载
```
bash -x  <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/t.sh) -E -U
```


## 鸣谢下列作者的文章和项目

互联网永远不会忘记，但人们会。

技术文章和相关项目（排名不分先后）:
* luoxue-bot 的成熟作品: https://github.com/luoxue-bot/warp_auto_change_ip
* lmc999 的成熟作品: https://github.com/lmc999/RegionRestrictionCheck

服务提供（排名不分先后）:
* CloudFlare Warp(+): https://1.1.1.1/
* WGCF 项目原作者: https://github.com/ViRb3/wgcf/
* 获取公网 IP 及归属地查询: https://ip.gs/
* 统计PV网:https://hits.seeyoufarm.com/
