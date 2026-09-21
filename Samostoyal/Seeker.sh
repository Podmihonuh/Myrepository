#!/bin/bash
# Скрипт ищет файлы по расширению в текущей директории

echo "Введите расширение (например, txt, sh, js):"
read ext

# Убираем точку, если пользователь её ввёл
ext="${ext#.}"

echo "Поиск файлов с расширением .$ext в $(pwd) ..."
echo

found=0
while IFS= read -r file; do
    echo "$file"
    found=$((found + 1))
done < <(find . -maxdepth 1 -type f -name "*.$ext")

if [ "$found" -eq 0 ]; then
    echo "Файлы с расширением .$ext не найдены."
else
    echo
    echo "Найдено файлов: $found"
fi