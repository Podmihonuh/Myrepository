#!/bin/bash
# Скрипт генерирует случайный пароль длиной 8 символов

LENGTH=16

# Способ 1: из /dev/urandom (только буквы и цифры)
password=$(tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c "$LENGTH")

echo "Сгенерированный пароль: $password"