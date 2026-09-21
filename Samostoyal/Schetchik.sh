#!/bin/bash
# Скрипт подсчитывает количество строк в указанном файле

echo "Введите путь к файлу:"
read filepath

if [ ! -f "$filepath" ]; then
    echo "Файл '$filepath' не найден!"
    exit 1
fi

lines=$(wc -l < "$filepath")
echo "Файл: $filepath"
echo "Количество строк: $lines"