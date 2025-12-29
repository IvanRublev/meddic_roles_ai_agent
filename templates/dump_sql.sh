#!/bin/sh
set +a
source ../.env
set -a
OUTPUT_SQL_FILE=database_template.sql
PGPASSWORD=$POSTGRES_PASSWORD pg_dump -h localhost -U $POSTGRES_USER -d $POSTGRES_DB -p 5432 --create --schema-only --file=$OUTPUT_SQL_FILE

# Remove \restrict and \unrestrict lines from the SQL file so we can modify template
sed -i '' '/^\\restrict/d' "$OUTPUT_SQL_FILE"
sed -i '' '/^\\unrestrict/d' "$OUTPUT_SQL_FILE"

# Remove setting psql fails for
sed -i '' '/^SET transaction_timeout/d' "$OUTPUT_SQL_FILE"

# Remove database creation, it will be created on container start automatically
sed -i '' '/^CREATE DATABASE/d' "$OUTPUT_SQL_FILE"

# Replace all user values with pattern
sed -i '' "s/$POSTGRES_USER/{{POSTGRES_USER}}/g" "$OUTPUT_SQL_FILE"
