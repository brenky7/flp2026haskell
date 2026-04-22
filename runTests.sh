#!/bin/bash
# Prejde vsetky interprety v moje_interprety/ a kazdy otestuje s flp-fun kontajnerom
# Vystup sa loguje do logs/<interpreter>.json.

set -euo pipefail

# Cesty k testom, parseru a interpretom
TESTS_DIR="$(pwd)/example_sol_tests"
PARSER_FILE="$(pwd)/my-parser.py"
INTERPRETERS_DIR="$(pwd)/moje_interprety"
LOGS_DIR="$(pwd)/logs"
INTERPRETER_SUFFIX="*.py" # Vzor pre priponu

mkdir -p "$LOGS_DIR"

shopt -s nullglob
interprets=("$INTERPRETERS_DIR"/$INTERPRETER_SUFFIX)
shopt -u nullglob

if [[ ${#interprets[@]} -eq 0 ]]; then
    echo "Ziadne interprety v $INTERPRETERS_DIR" >&2
    exit 1
fi

echo "Testujem ${#interprets[@]} interpretov, logy idu do $LOGS_DIR"
echo

for interpret in "${interprets[@]}"; do
    FILENAME=$(basename "$interpret")
    FILENAME="${FILENAME%.*}"  
    LOG_JSON="$LOGS_DIR/$FILENAME.json"
    LOG_ERR="$LOGS_DIR/$FILENAME.stderr"

    echo "--- Testujem interpret: $FILENAME ---"

    docker run --rm \
        -v "$TESTS_DIR":/data:ro \
        -v "$PARSER_FILE":/bin/parser:ro \
        -v "$interpret":/bin/interp:ro \
        flp-fun -p /bin/parser -t /bin/interp /data \
        > "$LOG_JSON" 2> "$LOG_ERR" || true 

    if [[ -s "$LOG_JSON" ]] && command -v python3 >/dev/null; then
        python3 - "$LOG_JSON" <<'PY'
import json, sys
try:
    d = json.load(open(sys.argv[1]))
    s = d.get("stats", {})
    passed = s.get("total_passed_tests", 0)
    total  = s.get("total_selected_tests", 0)
    rate   = f"{passed/total*100:.0f}%" if total else "n/a"
    print(f"  -> {passed}/{total} passed ({rate})")
except Exception as e:
    print(f"  -> (nepodarilo sa precitat JSON: {e})")
PY
    else
        echo "  -> (ziadny JSON vystup, pozri $LOG_ERR)"
    fi
done

echo
echo "Hotovo. Detaily: $LOGS_DIR/"
