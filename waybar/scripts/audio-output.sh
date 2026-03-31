#!/bin/bash

# Получаем список устройств вывода с помощью pamixer
devices=$(pamixer --list-sinks | grep -E "^[0-9]" | awk '{print $1, $2}')

# Форматируем для wofi (ID + описание)
choices=$(echo "$devices" | while read id name; do
  echo "$id | $name"
done)

# Выводим меню через wofi
selected=$(echo "$choices" | wofi --show dmenu --prompt="Выберите устройство:" | cut -d '|' -f 1)

# Если выбрано устройство, переключаемся на него
if [ -n "$selected" ]; then
  pactl set-default-sink "$selected"
  notify-send "Аудио" "Устройство вывода изменено"
fi
