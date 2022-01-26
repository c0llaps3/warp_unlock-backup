#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin:/bin
export LANG=en_US.UTF-8

# 自定义字体彩色，read 函数，友道翻译函数
red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
yellow(){ echo -e "\033[33m\033[01m$1\033[0m"; }
reading(){ read -rp "$(green "$1")" "$2"; }
translate(){ [[ -n "$1" ]] && curl -sm8 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$1" | cut -d \" -f18 2>/dev/null; }

# 期望解锁地区传参
[[ $1 =~ ^[A-Za-z]{2}$ ]] && EXPECT="$1"

declare -A T

T[E0]="\n Language:\n  1.English (default) \n  2.简体中文\n"
T[C0]="${T[E0]}"
T[E1]=""
T[C1]=""
T[E2]="The script must be run as root, you can enter sudo -i and then download and run again. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C2]="必须以root方式运行脚本，可以输入 sudo -i 后重新下载运行，问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E3]="Choose:"
T[C3]="请选择:"
T[E4]="\n Neither the WARP network interface nor Socks5 are installed, please select the installation script:\n 1. fscarmen (Default)\n 2. yyykg\n 3. P3terx\n 0. Exit\n"
T[C4]="\n WARP 网络接口和 Socks5 都没有安装，请选择安装脚本:\n 1. fscarmen (默认)\n 2. yyykg\n 3. P3terx\n 0. 退出\n"
T[E5]="The script supports Debian, Ubuntu, CentOS or Alpine systems only. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C5]="本脚本只支持 Debian、Ubuntu、CentOS 或 Alpine 系统,问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E6]="Please choose to brush WARP IP:\n 1. WARP Socks5 Proxy (Default)\n 2. WARP IPv6 Interface\n"
T[C6]="\n 请选择刷 WARP IP 方式:\n 1. WARP Socks5 代理 (默认)\n 2. WARP IPv6 网络接口\n"
T[E7]="Installing curl..."
T[C7]="安装curl中……"
T[E8]="It is necessary to upgrade the latest package library before install curl.It will take a little time,please be patiently..."
T[C8]="先升级软件库才能继续安装 curl，时间较长，请耐心等待……"
T[E9]="Failed to install curl. The script is aborted. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C9]="安装 curl 失败，脚本中止，问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E10]="Media unlock daemon installed successfully."
T[C10]="媒体解锁守护进程已安装成功"
T[E11]="The media unlock daemon is completely uninstalled."
T[C11]="媒体解锁守护进程已彻底卸载"
T[E12]="\n 1. Install the streaming media unlock daemon. Check it every 5 minutes.\n 2. Uninstall\n 0. Exit\n"
T[C12]="\n 1. 安装流媒体解锁守护进程,定时5分钟检查一次,遇到不解锁时更换 WARP IP，直至刷成功\n 2. 卸载\n 0. 退出\n"
T[E13]="The current Netflix region is \$REGION. Confirm press [y] . If you want another regions, please enter the two-digit region abbreviation. \(such as hk,sg. Default is \$REGION\):"
T[C13]="当前 Netflix 地区是:\$REGION，需要解锁当前地区请按 y , 如需其他地址请输入两位地区简写 \(如 hk ,sg，默认:\$REGION\):"
T[E14]="Wrong input. The script is aborted."
T[C14]="输入错误，脚本退出"
T[E15]=""
T[C15]=""
T[E16]=""
T[C16]=""
T[E17]=""
T[C17]=""

# 选择语言，先判断 /etc/wireguard/language 里的语言选择，没有的话再让用户选择，默认英语
case $(cat /etc/wireguard/language 2>&1) in
E ) L=E;;	C ) L=C;;
* ) L=E && yellow " ${T[${L}0]} " && reading " ${T[${L}3]} " LANGUAGE 
[[ $LANGUAGE = 2 ]] && L=C;;
esac

# 多方式判断操作系统，试到有值为止。只支持 Debian 10/11、Ubuntu 18.04/20.04 或 CentOS 7/8 ,如非上述操作系统，退出脚本
CMD=(	"$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)"
	"$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)"
	"$(lsb_release -sd 2>/dev/null)"
	"$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)"
	"$(grep . /etc/redhat-release 2>/dev/null)"
	"$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')"
	)

for i in "${CMD[@]}"; do
	SYS="$i" && [[ -n $SYS ]] && break
done

# 自定义 Alpine 系统若干函数
alpine_wgcf_restart(){ wg-quick down wgcf >/dev/null 2>&1; wg-quick up wgcf >/dev/null 2>&1; }

REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "'amazon linux'" "alpine")
RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS" "Alpine")
PACKAGE_UPDATE=("apt -y update" "apt -y update" "yum -y update" "yum -y update" "apk update -f")
PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install" "yum -y install" "apk add -f")
SYSTEMCTL_RESTART=("systemctl restart wg-quick@wgcf" "systemctl restart wg-quick@wgcf" "systemctl restart wg-quick@wgcf" "systemctl restart wg-quick@wgcf" "alpine_wgcf_restart")

for ((int=0; int<${#REGEX[@]}; int++)); do
	[[ $(echo "$SYS" | tr '[:upper:]' '[:lower:]') =~ ${REGEX[int]} ]] && SYSTEM="${RELEASE[int]}" && [[ -n $SYSTEM ]] && break
done
[[ -z $SYSTEM ]] && red " ${T[${L}5]} " && exit 1

# 安装 curl
type -P curl >/dev/null 2>&1 || (yellow " ${T[${L}7]} " && ${PACKAGE_INSTALL[int]} curl) || (yellow " ${T[${L}8]} " && ${PACKAGE_UPDATE[int]} && ${PACKAGE_INSTALL[int]} curl)
! type -P curl >/dev/null 2>&1 && yellow " ${T[${L}9]} " && exit 1

# 判断是否已经安装 WARP 网络接口或者 Socks5 代理,如已经安装组件尝试启动。再分情况作相应处理
type -P wg-quick >/dev/null 2>&1 && [[ -z $(wg 2>/dev/null) ]] && wg-quick up wgcf >/dev/null 2>&1
[[ -n $(wg 2>/dev/null) ]] && WGCFSTATUS=1 || WGCFSTATUS=0

type -P warp-cli >/dev/null 2>&1 && [[ ! $(ss -nltp) =~ 'warp-svc' ]] && warp-cli --accept-tos connect >/dev/null 2>&1
[[ $(ss -nltp) =~ 'warp-svc' ]] && SOCKS5STATUS=1 || SOCKS5STATUS=0

case $WGCFSTATUS$SOCKS5STATUS in
00 ) yellow " ${T[${L}4]} " && reading " ${T[${L}3]} " CHOOSE2
     case "$CHOOSE2" in
      2 ) wget -N https://cdn.jsdelivr.net/gh/kkkyg/CFwarp/CFwarp.sh && bash CFwarp.sh; exit;;
      3 ) bash <(curl -fsSL git.io/warp.sh) menu; exit;;
      0 ) exit;;
      * ) wget -N https://cdn.jsdelivr.net/gh/fscarmen/warp/menu.sh && bash menu.sh; exit;;
     esac;;
01 ) PROXYSOCKS5=$(ss -nltp | grep warp | grep -oP '127.0*\S+')
     NF="-s4m7 --socks5 $PROXYSOCKS5"
     RESTART="socks5_restart";;
10 ) NF='-4'
     RESTART="wgcf_restart";;
11 ) yellow " ${T[${L}6]} " && reading " ${T[${L}3]} " CHOOSE3
      case "$CHOOSE3" in
      2 ) NF='-6'; RESTART="wgcf_restart";;
      * ) PROXYSOCKS5=$(ss -nltp | grep warp | grep -oP '127.0*\S+')
          NF="-s4m7 --socks5 $PROXYSOCKS5"
	  RESTART="socks5_restart";;
      esac;;
 esac

input_region(){
	UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
	REGION=$(tr '[:lower:]' '[:upper:]' <<< $(curl --user-agent "${UA_Browser}" $NF -fs --max-time 10 --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g'))
	REGION=${REGION:-'US'}
	reading " $(eval echo "${T[${L}13]}") " EXPECT
	until [[ -z $EXPECT || $EXPECT = [Yy] || $EXPECT =~ ^[A-Za-z]{2}$ ]]; do
		reading " $(eval echo "${T[${L}13]}") " EXPECT
	done
	[[ -z $EXPECT || $EXPECT = Y ]] && EXPECT="$REGION"
	}

install(){
[[ -z "$EXPECT" ]] && input_region

# 流媒体解锁守护进程，定时5分钟检查一次，结果输出到 ip.log 文件
sed -i '/warp_unlock.sh/d' /etc/crontab && echo "*/5 * * * *  root bash /root/warp_unlock.sh $AREA 2>&1 | tee $PWD/ip.log " >> /etc/crontab

# 生成 warp_unlock.sh 文件，判断当前流媒体解锁状态，遇到不解锁时更换 WARP IP，直至刷成功。5分钟后还没有刷成功，将不会重复该进程而浪费系统资源
cat <<EOF >/root/warp_unlock.sh
if [[ \$(pgrep -laf ^[/d]*bash.*warp_unlock | awk -F, '{a[\$2]++}END{for (i in a) print i" "a[i]}') -le 2 ]]; then

wgcf_restart(){ systemctl restart wg-quick@wgcf && sleep 5; }
		
socks5_restart(){
warp-cli --accept-tos delete >/dev/null 2>&1 && warp-cli --accept-tos register >/dev/null 2>&1 && sleep 15 &&
[[ -e /etc/wireguard/license ]] && warp-cli --accept-tos set-license \$(cat /etc/wireguard/license) >/dev/null 2>&1 && sleep 2; }

check1(){
unset RESULT REGION1 R1
	RESULT1=\$(curl --user-agent "\${UA_Browser}" $NF -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567"  2>&1)
if [[ \$RESULT1 = 200 ]]; then
REGION1=\$(tr '[:lower:]' '[:upper:]' <<< \$(curl --user-agent "${UA_Browser}" $NF -fs --max-time 10 --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g'))
REGION1=\${REGION1:-'US'}
fi
echo "\$REGION1" | grep -qi "$EXPECT" || R1='0'
}

UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
check1
until [[ ! \$R1  =~ 0  ]]; do
$RESTART
check1
done
fi

EOF

# 输出执行结果
green " ${T[${L}10]} "
}

uninstall(){
type -P wg-quick >/dev/null 2>&1 && wg-quick down wgcf >/dev/null 2>&1
type -P warp-cli >/dev/null 2>&1 && warp-cli --accept-tos delete >/dev/null 2>&1 && sleep 1
sed -i '/warp_unlock.sh/d' /etc/crontab
kill -9 $(pgrep -f warp_unlock.sh) >/dev/null 2>&1
rm -f /root/warp_unlock.sh
type -P wg-quick >/dev/null 2>&1 && wg-quick up wgcf >/dev/null 2>&1
type -P warp-cli >/dev/null 2>&1 && warp-cli --accept-tos register >/dev/null 2>&1

# 输出执行结果
green " ${T[${L}11]} "
}

clear
green " https://github.com/fscarmen/tools/issues\n=========================================================== "
yellow " ${T[${L}12]} " && reading " ${T[${L}3]} " CHOOSE1
case "$CHOOSE1" in
1 ) install;;
2 ) uninstall;;
0 ) exit 0;;
* ) red " ${T[${L}14]} ";exit 1;;
esac
