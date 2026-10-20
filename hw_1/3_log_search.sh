#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Использование: $0 <лог-файл> <ключевое слово>"
    exit 1
fi

LOG_FILE=$1
KEYWORD=$2
COUNT_FILE="found_count.txt"
LINES_FILE="found_lines.txt"

if [ ! -f "$LOG_FILE" ]; then
    echo "Ошибка: файл $LOG_FILE не найден"
    exit 1
fi

COUNT=$(grep -c "$KEYWORD" "$LOG_FILE")
grep "$KEYWORD" "$LOG_FILE" > "$LINES_FILE"
echo "Количество строк с '$KEYWORD' в файле $LOG_FILE: $COUNT" > "$COUNT_FILE"

echo "Найдено строк с '$KEYWORD': $COUNT"
echo "Количество сохранено в файл $COUNT_FILE"
echo "Найденные строки сохранены в файл $LINES_FILE"
