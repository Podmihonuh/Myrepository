#!/bin/bash
# github-stats.sh — анализ популярных репозиториев GitHub

# ─── Цвета ───────────────────────────────────────────
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ─── Проверка зависимостей ───────────────────────────
if ! command -v curl &> /dev/null; then
    echo -e "${RED} Ошибка: утилита 'curl' не установлена.${RESET}"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo -e "${RED} Ошибка: утилита 'jq' не установлена. Установите её командой: sudo apt install jq${RESET}"
    exit 1
fi

# ─── Проверка аргумента ──────────────────────────────
if [ $# -ne 1 ]; then
    echo -e "${YELLOW}Использование: $0 <owner/repo>${RESET}"
    echo -e "${YELLOW}Пример:       $0 tensorflow/tensorflow${RESET}"
    exit 1
fi

REPO="$1"

# ─── Заголовок ───────────────────────────────────────
echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║  🚀 GitHub Repository Analyzer         ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo

# ─── Запрос к GitHub API ─────────────────────────────
API_URL="https://api.github.com/repos/$REPO"
RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

# ─── Обработка ошибок ────────────────────────────────
case "$HTTP_CODE" in
    200) ;; # OK
    404)
        echo -e "${RED} Репозиторий '$REPO' не найден. Проверьте имя.${RESET}"
        exit 1
        ;;
    403)
        echo -e "${RED} Превышен лимит запросов к GitHub API (403).${RESET}"
        echo -e "${YELLOW}   Попробуйте позже или используйте токен.${RESET}"
        exit 1
        ;;
    *)
        echo -e "${RED} Ошибка API: HTTP $HTTP_CODE${RESET}"
        exit 1
        ;;
esac

# ─── Извлечение данных ───────────────────────────────
NAME=$(echo "$BODY"      | jq -r '.full_name')
STARS=$(echo "$BODY"     | jq -r '.stargazers_count')
FORKS=$(echo "$BODY"     | jq -r '.forks_count')
ISSUES=$(echo "$BODY"    | jq -r '.open_issues_count')
AUTHOR=$(echo "$BODY"    | jq -r '.owner.login')
UPDATED=$(echo "$BODY"   | jq -r '.updated_at')

# Форматирование чисел с разделителями тысяч
STARS_F=$(printf "%'d" "$STARS")
FORKS_F=$(printf "%'d" "$FORKS")
ISSUES_F=$(printf "%'d" "$ISSUES")

# Цвет для issues
if [ "$ISSUES" -gt 100 ]; then
    ISSUES_COLOR="$RED"
    ACTIVITY="Высокая"
else
    ISSUES_COLOR="$YELLOW"
fi

# ─── Вывод ───────────────────────────────────────────
echo -e "📦 Репозиторий: ${BOLD}$NAME${RESET}"
echo -e "⭐ Звёзды:       ${YELLOW}$STARS_F  (⭐)${RESET}"
echo -e "🔀 Форки:        ${GREEN}$FORKS_F  (🔀)${RESET}"
echo -e "🐛 Open Issues:  ${ISSUES_COLOR}$ISSUES_F  (🐛)${RESET}"
echo -e "👤 Автор:        ${CYAN}$AUTHOR${RESET}"
echo -e "📊 Активность:   $ACTIVITY (обновлён: $UPDATED)"
echo