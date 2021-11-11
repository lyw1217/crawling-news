#!/bin/bash

DIR_PATH="/home/leeyw/문서/github/crawling-news"
LOG_PATH="${DIR_PATH}/log"
LOG_NAME="nohup.log"
VENV_PATH="${DIR_PATH}/venv/bin"
EXE_PY="${DIR_PATH}/src/main.py"
CMD="CRAWLER"
# sudo check
if [ $(id -u) -ne 0 ]; then exec sudo bash "$0" "$@"; exit; fi

echo ""
echo "----------------------------------"
echo "          [ CRAWLER RUN ]         "
echo "----------------------------------"
echo ""

sleep 0.5

echo "> 현재 구동중인 애플리케이션 pid 확인"
sleep 0.5

CURRENT_PID=$(pgrep -f ${CMD})

echo "현재 구동중인 어플리케이션 pid: $CURRENT_PID"
sleep 0.5

if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 구동중인 애플리케이션이 없음"
	echo ""
else
    echo "> kill -15 $CURRENT_PID"
    kill -15 $CURRENT_PID
	sleep 0.5
	
	for cnt in {1..${WAIT_TIME}}
	do
		CURRENT_PID=$(pgrep -f ${CMD})
		if [ -z "$CURRENT_PID" ]; then
			echo "> 어플리케이션 종료 성공!"
			echo ""
			break
		fi
		sleep 0.5
		
		if [ ${cnt} == ${WAIT_TIME} ]; then
			echo "> 어플리케이션 종료 실패.. 다시 시도하세요"
			echo ""
			exit 1
		fi
	done
fi

echo "> 디렉토리 이동"
echo ""
cd ${DIR_PATH}
sleep 0.5

echo "> 현재 디렉토리 : "`pwd`
echo ""
sleep 0.5

echo "> GIT PULL"
echo ""
git pull

echo ""
echo "> 가상 환경 활성화"
echo ""
source ${VENV_PATH}/activate
sleep 0.5

echo "> 파이썬 모듈 실행"
echo ""
nohup /usr/bin/python3 ${EXE_PY} ${CMD} > ${LOG_PATH}/${LOG_NAME} 2>&1 &
sleep 0.5

echo ""
echo "----------------------------------"
echo "     [ CRAWLER RUN COMPLETE ]     "
echo "----------------------------------"
echo " P I D : $(pgrep -f ${CMD})"
echo ""

echo ""
exit 0
