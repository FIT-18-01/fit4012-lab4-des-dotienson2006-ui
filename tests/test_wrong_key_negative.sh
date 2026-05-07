set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

if [[ ! -x ./des ]]; then
  g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des
fi

PLAINTEXT="0001001000110100010101100111100010011010101111001101111011110001"
CORRECT_KEY="0001001100110100010101110111100110011011101111001101111111110001"
WRONG_KEY="1111000011001100101010101111010101010110011001111000111100001111"

ENC_OUT=$(printf '1\n%s\n%s\n' "$PLAINTEXT" "$CORRECT_KEY" | ./des 2>&1)
CIPHERTEXT=$(printf '%s\n' "$ENC_OUT" | grep -oE '[01]{64,}' | tail -n 1)

DEC_OUT=$(printf '2\n%s\n%s\n' "$CIPHERTEXT" "$WRONG_KEY" | ./des 2>&1)
RECOVERED=$(printf '%s\n' "$DEC_OUT" | grep -oE '[01]{64,}' | tail -n 1)

if [[ "$RECOVERED" != "$PLAINTEXT" ]]; then
  echo "[PASS] Wrong key negative test: incorrect key does not recover original plaintext (as expected)."
else
  echo "[FAIL] Wrong key negative test: wrong key unexpectedly decrypted to original plaintext."
  exit 1
fi
