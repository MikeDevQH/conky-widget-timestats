#!/bin/bash
# Mike TimeStats Conky — Interactive Installer
set -e

WIDGET_NAME="mike-timestats-conky"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.config/conky/$WIDGET_NAME"

echo "=============================================="
echo "  Mike TimeStats Conky — Interactive Installer"
echo "=============================================="
echo ""

# ── 1. Color ──
echo "Choose accent color for titles (day, month, AM/PM)"
echo "   (currently these are blue; default = all white)"
echo ""
echo "  1) White (no accent — all in default text color)"
echo "  2) Blue   (4d84f4)"
echo "  3) Red    (e74c3c)"
echo "  4) Green  (2ecc71)"
echo "  5) Purple (9b59b6)"
echo "  6) Orange (e67e22)"
echo "  7) Teal   (1abc9c)"
echo "  8) Pink   (e91e63)"
echo ""
read -p "  Choice [1-8] (default 1): " COLOR_CHOICE
COLOR_CHOICE="${COLOR_CHOICE:-1}"
echo ""

# ── 2. Language ──
echo "Choose widget language:"
echo "  1) English"
echo "  2) Spanish"
echo "  3) French"
echo "  4) German"
echo "  5) Italian"
echo "  6) Portuguese"
echo "  7) Dutch"
echo ""
read -p "  Choice [1-7] (default 1): " LANG_CHOICE
LANG_CHOICE="${LANG_CHOICE:-1}"
echo ""

# ── 3. Temperature units ──
echo "Choose temperature units:"
echo "  1) Celsius (°C)"
echo "  2) Fahrenheit (°F)"
echo ""
read -p "  Choice [1-2] (default 1): " UNIT_CHOICE
UNIT_CHOICE="${UNIT_CHOICE:-1}"
echo ""

# ── Resolve selections ──

case "$COLOR_CHOICE" in
  2) ACCENT="\${color 4d84f4}" ;;
  3) ACCENT="\${color e74c3c}" ;;
  4) ACCENT="\${color 2ecc71}" ;;
  5) ACCENT="\${color 9b59b6}" ;;
  6) ACCENT="\${color e67e22}" ;;
  7) ACCENT="\${color 1abc9c}" ;;
  8) ACCENT="\${color e91e63}" ;;
  *) ACCENT="" ;;  # White (empty means it uses default color)
esac

# Language
case "$LANG_CHOICE" in
  2) LOCALE="es_MX.UTF-8";   LANG_CODE="es"; FEEL="Sensación:";   HUM="Humedad:"    ;;
  3) LOCALE="fr_FR.UTF-8";   LANG_CODE="fr"; FEEL="Ressenti:";    HUM="Humidité:"   ;;
  4) LOCALE="de_DE.UTF-8";   LANG_CODE="de"; FEEL="Gefühlt:";     HUM="Luftfeuchte:";;
  5) LOCALE="it_IT.UTF-8";   LANG_CODE="it"; FEEL="Percepita:";   HUM="Umidità:"    ;;
  6) LOCALE="pt_BR.UTF-8";   LANG_CODE="pt"; FEEL="Sensação:";    HUM="Umidade:"    ;;
  7) LOCALE="nl_NL.UTF-8";   LANG_CODE="nl"; FEEL="Gevoeld:";     HUM="Vochtigheid:";;
  *) LOCALE="en_US.UTF-8";   LANG_CODE="en"; FEEL="Feels:";       HUM="Hum:"        ;;
esac

# Units and Icons
case "$UNIT_CHOICE" in
  2) WTTU="u"; UNIT_ICON="" ;;  # Fahrenheit icon (U+F045)
  *) WTTU="m"; UNIT_ICON="" ;;  # Celsius icon (U+F03C)
esac

echo "────────────────────────────────────────────────"
if [ -z "$ACCENT" ]; then
    echo "  Color:    White (no accent)"
else
    DISP_COLOR=$(echo "$ACCENT" | grep -o '[0-9a-f]\{6\}')
    echo "  Color:    #$DISP_COLOR"
fi
echo "  Language: ${LANG_CODE} ($LOCALE)"
echo "  Units:    $([ "$WTTU" = "u" ] && echo "Fahrenheit" || echo "Celsius")"
echo "────────────────────────────────────────────────"
echo ""

# ── Install fonts (User Local) ──
FONT_DIR="$HOME/.local/share/fonts/$WIDGET_NAME"
echo "Installing fonts to $FONT_DIR..."
mkdir -p "$FONT_DIR"
if cp "$SCRIPT_DIR/fonts/"*.ttf "$FONT_DIR/" 2>/dev/null; then
    fc-cache -f "$FONT_DIR"
else
    echo "  No .ttf fonts found in $SCRIPT_DIR/fonts/ - skipping."
fi

# ── Copy widget folder ──
echo "Copying widget to $DEST..."
mkdir -p "$DEST"
cp "$SCRIPT_DIR/Mike_TimeStats" "$DEST/Mike_TimeStats"

CONFIG="$DEST/Mike_TimeStats"
echo "Configuring..."

# ── Replace Placeholders safely ──
sed -i "s|__ACCENT_COLOR__|$ACCENT|g" "$CONFIG"
sed -i "s|__LOCALE__|$LOCALE|g" "$CONFIG"
sed -i "s|__LANG_CODE__|$LANG_CODE|g" "$CONFIG"
sed -i "s|__UNIT_MODE__|$WTTU|g" "$CONFIG"
sed -i "s|__UNIT_ICON__|$UNIT_ICON|g" "$CONFIG"
sed -i "s|__LBL_FEELS__|$FEEL|g" "$CONFIG"
sed -i "s|__LBL_HUM__|$HUM|g" "$CONFIG"

echo ""
echo "✔  Installation Complete!"
echo ""
echo "To run your widget:"
echo "  conky -c ~/.config/conky/$WIDGET_NAME/Mike_TimeStats"
echo ""
echo "For autostart, add this to your DE autostart settings:"
echo "  conky -c ~/.config/conky/$WIDGET_NAME/Mike_TimeStats &"
