#!/bin/bash
# auth-scratch-orgs.sh - Import orgs from orgs-with-auth-urls.txt file

# Default file name
ORG_FILE="${1:-orgs-with-auth-urls.txt}"

echo "🔐 Importing orgs from: $ORG_FILE"
echo ""

line_number=0
while IFS=',' read -r original_alias sfdx_auth_url; do
    # Skip empty lines
    if [ -z "$original_alias" ] || [ -z "$sfdx_auth_url" ]; then
        continue
    fi
    
    ((line_number++))
    simple_alias="scratch-$line_number"
    
    echo "Processing: $original_alias -> $simple_alias"
    echo "$sfdx_auth_url" | sf org login sfdx-url --alias "$simple_alias" --sfdx-url-stdin
    
done < "$ORG_FILE"

echo ""
echo "✅ Import complete! Imported $line_number orgs"
echo ""
echo "Verifying:"
sf org list