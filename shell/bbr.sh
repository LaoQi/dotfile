#!/bin/sh

status() {
	sysctl net.ipv4.tcp_available_congestion_control
	lsmod | grep bbr
}

start() {
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	sysctl -p
	status
}

stop() {
	sed -i '/net\.core\.default_qdisc=fq/d' /etc/sysctl.conf
	sed -i '/net\.ipv4\.tcp_congestion_control=bbr/d' /etc/sysctl.conf
	sysctl -p
}


case "$1" in
	start)
		start ;;
	stop)
		stop ;;
	status)
		status ;;
	*)
		echo "Usage bbr.sh [start|stop|status]"
		exit 2;;
esac
