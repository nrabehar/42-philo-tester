source utils.sh

# Test output directory
OUTPUT_DIR="outputs"
mkdir -p "$OUTPUT_DIR"
# Log files
LOG_FILE="test_log.txt"

# Test counters
TEST_ID=0
TEST_TOTAL=0
TEST_SUCCESS=0
TEST_FAIL=0
TEST_SKIP=0

# Test function

must_eat() {
    local file="$1"
    local expected="$2"
    local result=$(count_lines "$file" "is eating")
    if [ "$result" -eq "$expected" ]; then
        return 0
    else
        return 1
    fi
}
