#!/bin/bash
# demo-reset.sh - JIT WITH FALLBACK VERSION
# Tries to create scratch org JIT, falls back to pre-authenticated orgs if slow

set -e  # Exit on any error

# Colors for better UX
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PERMISSION_SET="Todo_Manager_Full_Access"
CREATE_TIMEOUT=45  # seconds
SCRATCH_DEF="config/project-scratch-def.json"

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "🔄 Resetting workstation..."

# Get current org from CLI
get_current_org() {
    sf config get target-org --json | jq -r '.result[0].value // "none"' 2>/dev/null || echo "none"
}

# Just clear current org (don't delete - these are shared/imported orgs)
current_org=$(get_current_org)
if [ "$current_org" != "none" ] && [ -n "$current_org" ]; then
    print_status "Found current org: $current_org"
    print_status "Clearing current org (not deleting - shared org pool)"
    sf org logout --target-org $current_org --no-prompt 2>/dev/null || true
else
    print_status "No current org found to clear"
fi

# Reset git repository (only force-app, not the script itself)
print_status "Resetting git repository..."
git checkout -- force-app/
git clean -fd force-app
print_success "Git repository reset complete"

# Get available pre-authenticated orgs from CLI (exclude JIT orgs)
get_available_orgs() {
    sf org list --json | jq -r '
        (.result.scratchOrgs[]? // empty | select(type == "object") | select(.isExpired == false and .alias != null and (.alias | test("^jit-") | not)) | .alias),
        (.result.nonScratchOrgs[]? // empty | select(type == "object") | select(.instanceUrl != null and (.instanceUrl | contains(".scratch.my.salesforce.com")) and .alias != null and (.alias | test("^jit-") | not)) | .alias),
        (.result.other[]? // empty | select(type == "object") | select(.instanceUrl != null and (.instanceUrl | contains(".scratch.my.salesforce.com")) and .alias != null and (.alias | test("^jit-") | not)) | .alias)
    ' 2>/dev/null | sort -u || true
}

    # Try to create a scratch org JIT with timeout and progress indicators
    try_create_scratch_org() {
        local alias="jit-org-$$-$(date +%s)"
        local templog=$(mktemp)
        
        echo "" >&2
        print_status "🚀 Attempting Just-In-Time scratch org creation..." >&2
        print_status "Timeout: ${CREATE_TIMEOUT} seconds" >&2
        print_status "Scratch Def: ${SCRATCH_DEF}" >&2
        
        # Check if config file exists
        if [ ! -f "$SCRATCH_DEF" ]; then
            print_error "Scratch org definition file not found: $SCRATCH_DEF" >&2
            return 1
        fi
        
        echo "" >&2
        
        # Run org creation in background (don't set as default yet)
        sf org create scratch \
            --definition-file "$SCRATCH_DEF" \
            --alias "$alias" \
            --duration-days 1 \
            --json > "$templog" 2>&1 &
        
        local pid=$!
        
        # Wait for completion or timeout with progress dots
        local count=0
        printf "⏳ Waiting: " >&2
        while [ $count -lt $CREATE_TIMEOUT ]; do
            if ! ps -p $pid > /dev/null 2>&1; then
                # Process finished
                wait $pid
                local exit_code=$?
                
                echo "" >&2  # New line after dots
                
                if [ $exit_code -eq 0 ]; then
                    # Success! The org was created with the alias we specified
                    print_success "✅ JIT org created in ${count}s: $alias" >&2
                    # Set as default org only now that we know it succeeded
                    sf config set target-org="$alias" >/dev/null 2>&1
                    rm -f "$templog"
                    echo "$alias"  # Output alias to stdout for capture
                    return 0
                fi
                
                # Failed
                print_warning "⚠️  JIT creation failed after ${count}s (exit code: $exit_code)" >&2
                print_status "Error output:" >&2
                cat "$templog" >&2
                rm -f "$templog"
                return 1
            fi
            
            # Show progress every 5 seconds
            if [ $((count % 5)) -eq 0 ] && [ $count -gt 0 ]; then
                printf "${count}s " >&2
            fi
            
            sleep 1
            count=$((count + 1))
        done
        
        # Timeout reached - kill the process
        echo "" >&2  # New line after dots
        print_warning "⏱️  Timeout reached! JIT creation took longer than ${CREATE_TIMEOUT}s" >&2
        print_status "Terminating scratch org creation process..." >&2
        kill $pid 2>/dev/null
        sleep 2
        kill -9 $pid 2>/dev/null
        wait $pid 2>/dev/null
        
        # Clean up any partially created org with this alias
        print_status "Cleaning up any partially created org: $alias" >&2
        # Check if the org exists before trying to delete it
        if sf org display --target-org "$alias" --json >/dev/null 2>&1; then
            print_status "Found partially created org, deleting..." >&2
            sf org delete scratch --target-org "$alias" --no-prompt 2>/dev/null || true
        else
            print_status "No org found to clean up (creation was interrupted early)" >&2
        fi
        
        rm -f "$templog"
        return 1
    }

# Try JIT creation first
next_org=""
next_username=""
use_fallback=false

if next_org=$(try_create_scratch_org); then
    # JIT creation succeeded
    next_username=$(sf org display --target-org "$next_org" --json | jq -r '.result.username' 2>/dev/null || echo "unknown")
    print_success "Using newly created org: $next_org"
else
    # JIT failed, fall back to pre-authenticated orgs
    print_warning "Org creation timed out or failed, using pre-authenticated org..."
    use_fallback=true
    
    available_orgs=$(get_available_orgs)
    
    if [ -z "$available_orgs" ]; then
        print_error "No available scratch orgs found!"
        print_status "All orgs:"
        sf org list
        echo ""
        print_error "Contact facilitator immediately!"
        exit 1
    fi
    
    # Get first available org
    next_org=$(echo "$available_orgs" | head -n 1)
    next_username=$(sf org display --target-org "$next_org" --json | jq -r '.result.username' 2>/dev/null || echo "unknown")
    
    # Set as target org for fallback case
    print_status "Switching to: $next_org"
    sf config set target-org="$next_org"
fi

# Clean up CLI files
rm -rf .sf 

# Save for reference (optional)
echo "$next_org" > current-org.txt

# Deploy metadata
print_status "Deploying metadata to: $next_org"
sf project deploy start --target-org $next_org --ignore-conflicts

# Assign permission set
print_status "Assigning Todo Manager app permission set to user"
sf org assign permset --name "$PERMISSION_SET" --target-org "$next_org" 2>&1 | grep -v "was already assigned" || true

# Install sf lightning dev plugin
sf plugins install @salesforce/plugin-lightning-dev@prerelease

# Kill any instances of component Local Dev
lsof -ti :3000 | xargs kill -9 2>/dev/null && echo "Killed Local Dev process on port 3000" || echo "No Local Dev process on port 3000"

# Success message
echo ""
if [ "$use_fallback" = true ]; then
    print_success "Your scratch org is ready! (from pre-authenticated pool)"
else
    print_success "Your scratch org is ready! (freshly created)"
fi
echo "   Username: $next_username"
echo "   Alias: $next_org"
echo ""
echo "📝 Next steps:"
echo "   1. Open the Agentforce Vibes extension"
echo "   2. Close all open files"
echo "   3. Open the Chrome browser to the activity instructions (bookmarked)"
echo ""

sf config set target-org=$next_org

# Show remaining count (only for fallback orgs)
if [ "$use_fallback" = true ]; then
    available_orgs=$(get_available_orgs)
    remaining=$(echo "$available_orgs" | wc -l)
    echo "💡 $remaining pre-authenticated orgs remaining"
    
    if [ "$remaining" -le 3 ]; then
        print_error "CRITICAL: Only $remaining orgs left! Contact facilitator NOW!"
    elif [ "$remaining" -le 10 ]; then
        print_warning "Queue getting low ($remaining orgs)"
    fi
fi