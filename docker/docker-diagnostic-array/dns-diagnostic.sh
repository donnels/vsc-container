#!/bin/bash

# Warp Bubble DNS Diagnostic Array
# Comprehensive DNS resolution testing for Star Trek themed services

echo "========================================"
echo "🖖 WARP BUBBLE DNS DIAGNOSTIC ARRAY 🖖"
echo "========================================"
echo "Stardate: $(date)"
echo "Diagnostic Array initializing..."
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test results counters
PASSED=0
FAILED=0

# Function to run test and track results
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_pattern="$3"
    
    echo -e "${BLUE}Testing: ${test_name}${NC}"
    
    if eval "$command" > /tmp/test_output 2>&1; then
        if [ -n "$expected_pattern" ]; then
            if grep -q "$expected_pattern" /tmp/test_output; then
                echo -e "${GREEN}✅ PASS: ${test_name}${NC}"
                ((PASSED++))
            else
                echo -e "${RED}❌ FAIL: ${test_name} (pattern not found)${NC}"
                echo "Expected pattern: $expected_pattern"
                echo "Output:"
                cat /tmp/test_output
                ((FAILED++))
            fi
        else
            echo -e "${GREEN}✅ PASS: ${test_name}${NC}"
            ((PASSED++))
        fi
    else
        echo -e "${RED}❌ FAIL: ${test_name}${NC}"
        echo "Command failed:"
        cat /tmp/test_output
        ((FAILED++))
    fi
    echo
}

echo "🔍 INTERNAL WARP BUBBLE SERVICE DISCOVERY"
echo "=========================================="

# Test internal service discovery via Docker aliases
WARP_SERVICES=(
    "engineering-console.warp.vsagcrd.org"
    "deflector.warp.vsagcrd.org"
    "transporter.warp.vsagcrd.org"
    "shuttlebay.warp.vsagcrd.org"
    "console.warp.vsagcrd.org"
    "optical-data-network.warp.vsagcrd.org"
)

for service in "${WARP_SERVICES[@]}"; do
    run_test "Forward DNS: $service" "nslookup $service" "Name:"
    
    # Get IP for reverse lookup
    IP=$(nslookup $service | grep "Address:" | tail -1 | awk '{print $2}')
    if [ -n "$IP" ] && [ "$IP" != "127.0.0.1" ]; then
        run_test "Reverse DNS: $IP" "nslookup $IP" "$service"
    fi
done

echo "🌐 EXTERNAL INTERNET CONNECTIVITY"
echo "=================================="

# Test external DNS resolution
EXTERNAL_SERVICES=(
    "google.com"
    "github.com"
    "docker.io"
    "debian.org"
    "letsencrypt.org"
)

for service in "${EXTERNAL_SERVICES[@]}"; do
    run_test "External DNS: $service" "nslookup $service" "Address:"
    run_test "Connectivity: $service" "ping -c 1 $service" "1 received"
done

echo "🔗 SERVICE CONNECTIVITY MATRIX"
echo "==============================="

# Test direct container connectivity via aliases
for service in "${WARP_SERVICES[@]}"; do
    # Skip ping test if service doesn't exist (some may not be running)
    if nslookup $service > /dev/null 2>&1; then
        run_test "Ping: $service" "ping -c 1 $service" "1 received"
    else
        echo -e "${YELLOW}⚠️  SKIP: $service (service not running)${NC}"
        echo
    fi
done

echo "📊 DNS CONFIGURATION ANALYSIS"
echo "=============================="

echo "DNS Servers in use:"
cat /etc/resolv.conf

echo
echo "Network interfaces:"
ip addr show

echo
echo "Routing table:"
ip route show

echo "=========================================="
echo "🖖 DIAGNOSTIC ARRAY SCAN COMPLETE 🖖"
echo "=========================================="
echo -e "Tests Passed: ${GREEN}$PASSED${NC}"
echo -e "Tests Failed: ${RED}$FAILED${NC}"
echo -e "Total Tests:  $((PASSED + FAILED))"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL SYSTEMS NOMINAL - WARP BUBBLE OPERATIONAL${NC}"
    exit 0
else
    echo -e "${RED}⚠️  ANOMALIES DETECTED - REVIEW FAILED TESTS${NC}"
    exit 1
fi
