#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Использование: $0 <ссылка на репозиторий> <ветка 1> <ветка 2>"
    exit 1
fi

REPO_URL=$1
BRANCH_1=$2
BRANCH_2=$3
REPORT_FILE="diff_report_${BRANCH_1//\//_}_vs_${BRANCH_2//\//_}.txt"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

git clone -q "$REPO_URL" "$TMP_DIR"
if [ $? -ne 0 ]; then
    echo "Ошибка: не удалось склонировать репозиторий $REPO_URL"
    exit 1
fi

CHANGES=$(git -C "$TMP_DIR" diff --name-status --no-renames "origin/$BRANCH_1" "origin/$BRANCH_2")
if [ $? -ne 0 ]; then
    echo "Ошибка: не удалось сравнить ветки $BRANCH_1 и $BRANCH_2"
    exit 1
fi

TOTAL=$(echo "$CHANGES" | grep -c .)
ADDED=$(echo "$CHANGES" | grep -c "^A")
DELETED=$(echo "$CHANGES" | grep -c "^D")
MODIFIED=$(echo "$CHANGES" | grep -c "^M")

cat > "$REPORT_FILE" << EOF
Отчет о различиях между ветками

================================
Репозиторий:    $REPO_URL
Ветка 1:        $BRANCH_1
Ветка 2:        $BRANCH_2
Дата генерации: $(date '+%Y-%m-%d %H:%M:%S')
================================

СПИСОК ИЗМЕНЕННЫХ ФАЙЛОВ:
$CHANGES

СТАТИСТИКА:
Всего измененных файлов: $TOTAL
Добавлено (A):    $ADDED
Удалено (D):      $DELETED
Изменено (M):     $MODIFIED
EOF

echo "Отчет сохранен в файл $REPORT_FILE"
