#!/bin/bash
set -e

# Load environment variables
set +a
source .env
set -a

echo "🚀 Starting setup..."

# Define paths
N8N_LOCAL_ROOT_PATH="container_data/n8n/"
N8N_CONTAINER_ROOT_PATH="/home/node/.n8n/"
POSTGRES_LOCAL_ROOT_PATH="container_data/postgres/"
POSTGRES_CONTAINER_ROOT_PATH="/var/lib/postgresql/data/"


CREDENTIALS_TEMPLATE_PATH="templates/n8n_credentials_template.json"
CREDENTIALS_FILE="credentials.json"
CREDENTIALS_PATH="${N8N_LOCAL_ROOT_PATH}${CREDENTIALS_FILE}"
CREDENTIALS_CONTAINER_PATH="${N8N_CONTAINER_ROOT_PATH}${CREDENTIALS_FILE}"

WORKFLOWS_DIRECTORY="workflows/"
WORKFLOW_PATH="${N8N_LOCAL_ROOT_PATH}${WORKFLOWS_DIRECTORY}"
WORKFLOW_CONTAINER_PATH="${N8N_CONTAINER_ROOT_PATH}${WORKFLOWS_DIRECTORY}"

SQL_TEMPLATE_PATH="templates/database_template.sql"
SQL_FILE="database.sql"
SQL_PATH="${POSTGRES_LOCAL_ROOT_PATH}${SQL_FILE}"
SQL_CONTAINER_PATH="${POSTGRES_CONTAINER_ROOT_PATH}${SQL_FILE}"

# Check if n8n container is running
if ! docker compose ps n8n | grep -q "Up"; then
    echo "⚠️  Warning: n8n container is not running. Please, make sure services are running with 'docker compose up' command."
    exit 1
fi

# ============================================
# STEP 1: Credentials
# ============================================
echo ""
echo "🔧 Step 1: Setting up n8n credentials..."

# Check if template exists
if [ ! -f "$CREDENTIALS_TEMPLATE_PATH" ]; then
    echo "❌ Error: Template file not found at $CREDENTIALS_TEMPLATE_PATH"
    exit 1
fi

# Extract all {{VARIABLE}} patterns from the template
echo "✓ Scanning template for required environment variables..."
required_vars=($(grep -oE '\{\{[A-Z_][A-Z0-9_]*\}\}' "$CREDENTIALS_TEMPLATE_PATH" | sed 's/{{//g; s/}}//g' | sort -u))

if [ ${#required_vars[@]} -eq 0 ]; then
    echo "⚠️  Warning: No environment variable placeholders found in template"
else
    echo "✓ Found ${#required_vars[@]} required variable(s): ${required_vars[*]}"
fi

# Check if all required environment variables are set
missing_vars=()
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -gt 0 ]; then
    echo "❌ Error: Missing required environment variables:"
    printf '   - %s\n' "${missing_vars[@]}"
    exit 1
fi

# Replace placeholders with environment variable values
echo "✓ Replacing template placeholders with environment variables..."
cp "$CREDENTIALS_TEMPLATE_PATH" "$CREDENTIALS_PATH"

for var in "${required_vars[@]}"; do
    value="${!var}"
    # Use a temporary file for safe multi-line replacement
    sed "s|{{${var}}}|${value}|g" "$CREDENTIALS_PATH" > "${CREDENTIALS_PATH}.tmp"
    mv "${CREDENTIALS_PATH}.tmp" "$CREDENTIALS_PATH"
done

echo "✅ Credentials file created at $CREDENTIALS_PATH"

# Import credentials into n8n
echo "📥 Importing credentials into n8n..."
set +e
docker compose exec -T n8n n8n import:credentials --input=${CREDENTIALS_CONTAINER_PATH}
EXIT_CODE=$?
set -e

if [ $EXIT_CODE -eq 0 ]; then
    # Delete the credentials file
    echo "🗑️  Removing credentials file..."
    rm -f "$CREDENTIALS_PATH"
    echo "✅ Credentials file deleted"
    echo "🎉 Step completed successfully!"
else
    echo "❌ Error: Failed to import credentials"
    echo "⚠️  Credentials file left at $CREDENTIALS_PATH for debugging"
    exit 1
fi

# ============================================
# STEP 2: Database
# ============================================
echo ""
echo "🔧 Step 2: Setting up PostgreSQL database..."

# Check if template exists
if [ ! -f "$SQL_TEMPLATE_PATH" ]; then
    echo "❌ Error: Template file not found at $SQL_TEMPLATE_PATH"
    exit 1
fi

# Extract all {{VARIABLE}} patterns from the template
echo "✓ Scanning template for required environment variables..."
required_vars=($(grep -oE '\{\{[A-Z_][A-Z0-9_]*\}\}' "$SQL_TEMPLATE_PATH" | sed 's/{{//g; s/}}//g' | sort -u))

if [ ${#required_vars[@]} -eq 0 ]; then
    echo "⚠️  Warning: No environment variable placeholders found in template"
else
    echo "✓ Found ${#required_vars[@]} required variable(s): ${required_vars[*]}"
fi

# Check if all required environment variables are set
missing_vars=()
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -gt 0 ]; then
    echo "❌ Error: Missing required environment variables:"
    printf '   - %s\n' "${missing_vars[@]}"
    exit 1
fi

# Replace placeholders with environment variable values
echo "✓ Replacing template placeholders with environment variables..."
cp "$SQL_TEMPLATE_PATH" "$SQL_PATH"

for var in "${required_vars[@]}"; do
    value="${!var}"
    # Use a temporary file for safe multi-line replacement
    sed "s|{{${var}}}|${value}|g" "$SQL_PATH" > "${SQL_PATH}.tmp"
    mv "${SQL_PATH}.tmp" "$SQL_PATH"
done

echo "✅ Credentials file created at $SQL_PATH"

# Check if environment variable are set
if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "❌ Error: POSTGRES_PASSWORD environment variable is not set"
    exit 1
fi
if [ -z "$POSTGRES_USER" ]; then
    echo "❌ Error: POSTGRES_USER environment variable is not set"
    exit 1
fi

# Import SQL
echo "📥 Importing database into PostgreSQL..."
set +e
docker compose exec -e PGPASSWORD=${POSTGRES_PASSWORD} -T postgres psql -q -U ${POSTGRES_USER} -d postgres -v ON_ERROR_STOP=1 -f ${SQL_CONTAINER_PATH}
EXIT_CODE=$?
set -e

if [ $EXIT_CODE -eq 0 ]; then
    # Delete the credentials file
    echo "🗑️  Removing SQL file..."
    rm -f "$SQL_PATH"
    echo "✅ SQL file deleted"
    echo "🎉 Step completed successfully!"
else
    echo "❌ Error: Failed to import database into PostgreSQL"
    echo "⚠️  SQL file left at $SQL_PATH for debugging"
    exit 1
fi


echo ""
echo "✨ All setup steps are complete."
