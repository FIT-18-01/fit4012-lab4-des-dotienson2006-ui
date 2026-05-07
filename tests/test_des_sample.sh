set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

if [[ ! -x ./des ]]; then
  g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des
fi

PLAINTEXT="0001001000110100010101100111100010011010101111001101111011110001"
KEY="0001001100110100010101110111100110011011101111001101111111110001"
EXPECTED="0111111010111111010001001001001100100011111110101111101011111000"

OUTPUT=$(printf '1\n%s\n%s\n' "$PLAINTEXT" "$KEY" | ./des 2>&1)
ACTUAL=$(printf '%s\n' "$OUTPUT" | grep -oE '[01]{64,}' | tail -n 1)

if [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "[PASS] DES sample test: ciphertext matches expected value."
else
  echo "[FAIL] DES sample test: expected $EXPECTED but got $ACTUAL"
  exit 1
fi
