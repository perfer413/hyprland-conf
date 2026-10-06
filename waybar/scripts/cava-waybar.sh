#!/bin/bash

CONFIG_FILE="/tmp/cava-waybar-config"

cat > "$CONFIG_FILE" << 'EOF'
[general]
framerate = 60
bars = 12
autosens = 0
sensitivity = 200

[input]
method = pulse

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
bar_delimiter = 32
EOF

cava -p "$CONFIG_FILE" | sed -u 's/0/▁/g; s/1/▂/g; s/2/▃/g; s/3/▄/g; s/4/▅/g; s/5/▆/g; s/6/▇/g; s/7/█/g'
