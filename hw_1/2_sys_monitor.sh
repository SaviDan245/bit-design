#!/bin/bash

PID_FILE="/tmp/sys_monitor.pid"

monitor() {
    while true; do
        REPORT_FILE="system_report_$(date '+%Y-%m-%d').csv"
        if [ ! -f "$REPORT_FILE" ]; then
            echo "timestamp;all_memory;free_memory;%memory_used;%cpu_used;%disk_used;load_average_1m" > "$REPORT_FILE"
        fi

        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        ALL_MEMORY=$(free -m | awk 'NR==2 {print $2}')
        FREE_MEMORY=$(free -m | awk 'NR==2 {print $4}')
        MEMORY_USED=$(free -m | awk 'NR==2 {printf "%.1f", $3 / $2 * 100}')
        CPU_USED=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15}')
        DISK_USED=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
        LOAD_AVERAGE=$(awk '{print $1}' /proc/loadavg)

        echo "$TIMESTAMP;$ALL_MEMORY;$FREE_MEMORY;$MEMORY_USED;$CPU_USED;$DISK_USED;$LOAD_AVERAGE" >> "$REPORT_FILE"
        sleep 600
    done
}

is_running() {
    [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

start() {
    if is_running; then
        echo "Скрипт уже запущен, PID: $(cat "$PID_FILE")"
        exit 1
    fi
    monitor &
    echo $! > "$PID_FILE"
    echo "Скрипт запущен, PID: $!"
}

stop() {
    if is_running; then
        kill "$(cat "$PID_FILE")"
        rm -f "$PID_FILE"
        echo "Скрипт остановлен"
    else
        echo "Скрипт не запущен"
    fi
}

status() {
    if is_running; then
        echo "Скрипт запущен, PID: $(cat "$PID_FILE")"
    else
        echo "Скрипт не запущен"
    fi
}

case "$1" in
    START)  start ;;
    STOP)   stop ;;
    STATUS) status ;;
    *)
        echo "Использование: $0 START|STOP|STATUS"
        exit 1
        ;;
esac
