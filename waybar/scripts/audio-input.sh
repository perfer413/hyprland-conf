#!/bin/bash

# Получаем список источников ввода (микрофонов) с помощью pamixer
# pamixer --list-sources показывает все источники, .monitor - это мониторы устройств вывода, их исключаем
devices=$(pamixer --list-sources | grep -E "^[0-9]" | grep -v ".monitor" | awk '{print $1, $2}')

# Форматируем для wofi (ID + описание)
choices=$(echo "$devices" | while read id name; do
  echo "$id | $name"
done)

# Выводим меню через wofi
selected=$(echo "$choices" | wofi --show dmenu --prompt="Выберите микрофон:" | cut -d '|' -f 1 | xargs)

# Если выбрано устройство, переключаемся на него
if [ -n "$selected" ]; then
  # Устанавливаем микрофон по умолчанию
  pactl set-default-source "$selected"
  
  # Перемещаем все текущие записи (если есть) на новый микрофон
  pactl list short source-outputs 2>/dev/null | while read stream; do
    streamId=$(echo $stream | cut '-d ' -f1)
    pactl move-source-output "$streamId" "$selected" 2>/dev/null
  done
  
  notify-send "Микрофон" "Устройство ввода изменено"
fi
