#!/usr/bin/env bash

# 哪吒的三个参数
NEZHA_SERVER=probe.nezha.org
NEZHA_PORT=5555
NEZHA_KEY=p2RYaBPrCEiFro7W0Y

# 检测是否已运行
check_run() {
  [[ $(pidof nezha-agent) ]] && echo "哪吒客户端正在运行中" && exit
}

# 三个变量不全则不安装哪吒客户端
check_variable() {
  [[ -z "${NEZHA_SERVER}" || -z "${NEZHA_PORT}" || -z "${NEZHA_KEY}" ]] && exit
}

# 下载最新版本 Nezha Agent
download_agent() {
  if [ ! -e nezha-agent ]; then
    URL=$(wget -qO- -4 "https://api.github.com/repos/naiba/nezha/releases/latest" | grep -o "https.*linux_amd64.zip")
    wget -t 2 -T 10 -N ${URL}
    unzip -qod ./ nezha-agent_linux_amd64.zip && rm -f nezha-agent_linux_amd64.zip
  fi
}

# 运行客户端
run() {
  [ -e nezha-agent ] && chmod +x nezha-agent && ./nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY}
}

check_run
check_variable
download_agent
run
wait
