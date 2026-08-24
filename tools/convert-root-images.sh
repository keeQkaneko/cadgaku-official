#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
IMG_DIR="images"
CWEBP="tools/cwebp.exe"
Q=92

declare -A CAP=(
  [image1.png]=400 [image2.png]=400 [image3.png]=400 [image4.png]=400 [image5.png]=400
  [interview-2.png]=900 [interview-15.png]=900 [interview-16.png]=900
  [career-1.png]=700 [career-2.png]=700 [career-3.png]=700 [career-4.png]=700
  [career-5.png]=700 [career-6.png]=700 [career-7.png]=700 [career-8.png]=700
  [member.png]=1100
  [firstview-1.png]=1600
  [rental-pc.png]=2200
  [rental-pc-mobile.png]=900
  [step.png]=2048
  [step-mobile.png]=900
  [seminar-guidance-2.png]=1800
  [achievement.png]=1400
  [logo-cadgaku.png]=800
  [line-site.png]=1920
  [reason1.png]=1200
  [reason2.png]=1200
  [icon-1.png]=200 [icon-2.png]=200 [icon-3.png]=200 [icon-4.png]=200
)

SKIP="favicon.png apple-touch-icon.png ogp.png"

log="tools/convert-root-log.csv"
echo "file,before_bytes,after_bytes,reduction_pct" > "$log"
total_before=0
total_after=0

for name in $(grep -oE 'images/[A-Za-z0-9_.\-]+\.png' index.html | sed 's#images/##' | sort -u); do
  case " $SKIP " in *" $name "*) continue ;; esac
  src="$IMG_DIR/$name"
  [ -f "$src" ] || continue
  out="${src%.png}.webp"
  cap="${CAP[$name]:-0}"
  if [ "$cap" -gt 0 ]; then
    "$CWEBP" -q "$Q" -resize "$cap" 0 -m 6 "$src" -o "$out" >/dev/null 2>&1
  else
    "$CWEBP" -q "$Q" -m 6 "$src" -o "$out" >/dev/null 2>&1
  fi
  before=$(stat -c%s "$src")
  after=$(stat -c%s "$out")
  pct=$(awk -v b="$before" -v a="$after" 'BEGIN{printf "%.1f", (1-a/b)*100}')
  echo "$name,$before,$after,$pct%" >> "$log"
  total_before=$((total_before+before))
  total_after=$((total_after+after))
done

echo "---"
echo "Total before: $(awk -v b=$total_before 'BEGIN{printf "%.2f MB", b/1024/1024}')"
echo "Total after:  $(awk -v a=$total_after 'BEGIN{printf "%.2f MB", a/1024/1024}')"
