#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
IMG_DIR="lp1/images"
CWEBP="tools/cwebp.exe"
Q=92

declare -A CAP=(
  [image1.png]=400 [image2.png]=400 [image3.png]=400 [image4.png]=400 [image5.png]=400
  [interview-1.png]=900 [interview-2.png]=900 [interview-3.png]=900 [interview-4.png]=900
  [interview-5.png]=900 [interview-6.png]=900 [interview-7.png]=900 [interview-8.png]=900
  [interview-10.png]=900 [interview-13.png]=900 [interview-15.png]=900 [interview-16.png]=900
  [interview-17.png]=900 [interview-18.png]=900
  [career-1.png]=700 [career-2.png]=700 [career-3.png]=700 [career-4.png]=700
  [career-5.png]=700 [career-6.png]=700 [career-7.png]=700 [career-8.png]=700
  [support-01.png]=1000 [support-02.png]=1000 [support-03.png]=1000 [support-04.png]=1000
  [member.png]=1100
  [firstview-1.png]=1600
  [rental-pc.png]=2200
  [rental-pc-mobile.png]=900
  [step.png]=2048
  [step-mobile.png]=900
  [seminar-guidance-2.png]=1800
  [cadgaku-lp-fast.png]=1400
  [logo-cadgaku.png]=800
  [line-site.png]=1920
  [reason1.png]=1200
)

SKIP="favicon.png apple-touch-icon.png ogp.png"

log="tools/convert-log.csv"
echo "file,before_bytes,after_bytes,reduction_pct" > "$log"

total_before=0
total_after=0

for src in "$IMG_DIR"/*.png; do
  name=$(basename "$src")
  case " $SKIP " in *" $name "*) continue ;; esac

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
echo "Total before: $total_before bytes ($(awk -v b=$total_before 'BEGIN{printf "%.1f", b/1024/1024}') MB)"
echo "Total after:  $total_after bytes ($(awk -v a=$total_after 'BEGIN{printf "%.1f", a/1024/1024}') MB)"
