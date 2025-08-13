#!/bin/bash

echo "🚀 COMPREHENSIVE DOCKER IMAGE TESTING SCRIPT"
echo "=============================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    
    echo -e "${BLUE} Testing: $test_name${NC}"
    
    result=$(eval "$test_command" 2>&1)
    exit_code=$?
    
    if [ $exit_code -eq 0 ] && [[ "$result" =~ $expected_pattern ]]; then
        echo -e "${GREEN} PASSED: $test_name${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED} FAILED: $test_name${NC}"
        echo "   Expected pattern: $expected_pattern"
        echo "   Got: $result"
        ((TESTS_FAILED++))
    fi
    echo ""
}

echo "1.  DOCKER IMAGE TESTS"
echo "========================"

# Test 1: Check if image exists
run_test "Docker image exists" \
    "sudo docker images minatofourth/flask-docker-cicd:latest --format '{{.Repository}}:{{.Tag}}'" \
    "minatofourth/flask-docker-cicd:latest"

# Test 2: Check image size (should be reasonable)
run_test "Docker image size check" \
    "sudo docker images minatofourth/flask-docker-cicd:latest --format '{{.Size}}' | grep -E '[0-9]+MB'" \
    "MB"

echo "2.  APPLICATION ENDPOINT TESTS"
echo "================================"

# Test 3: Main endpoint
run_test "Main endpoint (/) returns success" \
    "curl -s http://localhost:5000/ | jq -r '.status'" \
    "success"

# Test 4: Health endpoint
run_test "Health endpoint returns healthy" \
    "curl -s http://localhost:5000/health | jq -r '.status'" \
    "healthy"

# Test 5: Info endpoint
run_test "Info endpoint returns app name" \
    "curl -s http://localhost:5000/info | jq -r '.name'" \
    "Flask Docker CI/CD Demo"

# Test 6: 404 handling
run_test "404 error handling works" \
    "curl -s http://localhost:5000/nonexistent | jq -r '.status_code'" \
    "404"

echo "3.  CONTAINER HEALTH TESTS"
echo "============================"

# Test 7: Container is running
run_test "Container is running" \
    "sudo docker-compose ps flask-docker-cicd-web | grep 'Up'" \
    "Up"

# Test 8: Database container is healthy
run_test "Database container is healthy" \
    "sudo docker-compose ps flask-docker-cicd-db | grep 'healthy'" \
    "healthy"

# Test 9: Redis container is healthy
run_test "Redis container is healthy" \
    "sudo docker-compose ps flask-docker-cicd-redis | grep 'healthy'" \
    "healthy"

echo "4.  PERFORMANCE TESTS"
echo "======================"

# Test 10: Response time test
start_time=$(date +%s%N)
curl -s http://localhost:5000/ > /dev/null
end_time=$(date +%s%N)
response_time=$(( (end_time - start_time) / 1000000 )) # Convert to milliseconds

if [ $response_time -lt 1000 ]; then
    echo -e "${GREEN} PASSED: Response time under 1 second ($response_time ms)${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED} FAILED: Response time too slow ($response_time ms)${NC}"
    ((TESTS_FAILED++))
fi
echo ""

echo "5. FINAL RESULTS"
echo "==================="
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo -e "Total Tests: $((TESTS_PASSED + TESTS_FAILED))"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN} ALL TESTS PASSED! Your Docker deployment is working perfectly!${NC}"
    exit 0
else
    echo -e "${RED}  Some tests failed. Please check the issues above.${NC}"
    exit 1
fi
