#!/bin/bash
set -e

# Default to current directory if not provided
TEST_DIR=${1:-tests}

# Check if apigee-go-gen is available
if ! command -v apigee-go-gen &> /dev/null; then
    echo "apigee-go-gen could not be found"
    exit 1
fi

echo "Running tests in $TEST_DIR..."

for spec in "$TEST_DIR"/*.yaml; do
    [ -e "$spec" ] || continue
    filename=$(basename -- "$spec")
    name="${filename%.*}"
    
    echo "Processing $filename..."
    
    mkdir -p "$TEST_DIR/out/$name"
    
    apigee-go-gen render apiproxy \
        --template ./templates/oas3/apiproxy.yaml \
        --set-oas spec="$spec" \
        --include ./templates/oas3/*.tmpl \
        --output "$TEST_DIR/out/$name.zip" \
        -v false
        
    echo "Verified $name"
done

echo "All tests passed successfully!"
