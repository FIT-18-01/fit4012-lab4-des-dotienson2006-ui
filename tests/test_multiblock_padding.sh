set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

if [[ ! -x ./des ]]; then
  g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des
fi

LONG_PT="00010010001101000101011001111000100110101011110011011110111100011010101010101010"
KEY="0001001100110100010101110111100110011011101111001101111111110001"
EXPECTED="01111110101111110100010010010011001000111111101011111010111110000100000010010001101001000010011111010110110001100000111000110100"

OUTPUT=$(printf '1\n%s\n%s\n' "$LONG_PT" "$KEY" | ./des 2>&1)
ACTUAL=$(printf '%s\n' "$OUTPUT" | grep -oE '[01]{64,}' | tail -n 1)

if [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "[PASS] Multi-block + zero padding test: 128-bit output matches expected ciphertext."
else
  echo "[FAIL] Multi-block test: expected $EXPECTED but got $ACTUAL"
  exit 1
fi
