#!/bin/bash
# Скрипт создаёт структуру папок для веб-проекта

echo "Введите имя проекта:"
read project_name

if [ -z "$project_name" ]; then
    echo "Имя проекта не может быть пустым!"
    exit 1
fi

if [ -d "$project_name" ]; then
    echo "Папка '$project_name' уже существует!"
    exit 1
fi

# Создаётся структура
mkdir -p "$project_name/css" "$project_name/js"

# Создаём пустые файлы
touch "$project_name/index.html" \
      "$project_name/css/style.css" \
      "$project_name/js/script.js"

echo "Структура проекта '$project_name' создана:"
echo
find "$project_name" | sed 's|[^/]*/|  |g'