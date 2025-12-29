#!/bin/bash

# Validate all n8n workflow JSON files against the schema
# Requires: npm install -g ajv-cli

SCHEMA_FILE="workflow-schema.json"
WORKFLOW_DIR="../workflows"

if [ ! -f "$SCHEMA_FILE" ]; then
    echo "Error: Schema file '$SCHEMA_FILE' not found"
    exit 1
fi

echo "Validating workflows against schema: $SCHEMA_FILE"
echo "=================================================="

VALID_COUNT=0
INVALID_COUNT=0

for workflow_file in "$WORKFLOW_DIR"/*.json; do
    if [ -f "$workflow_file" ]; then
        echo ""
        echo "Validating: $workflow_file"
        
        if ajv validate -s "$SCHEMA_FILE" -d "$workflow_file"; then
            echo "✓ VALID"
            ((VALID_COUNT++))
        else
            echo "✗ INVALID"
            ((INVALID_COUNT++))
        fi
    fi
done

echo ""
echo "=================================================="
echo "Summary: $VALID_COUNT valid, $INVALID_COUNT invalid"

if [ $INVALID_COUNT -gt 0 ]; then
    exit 1
fi

exit 0
