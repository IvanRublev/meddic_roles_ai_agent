#!/bin/sh
N8N_LOCAL_ROOT_PATH="../container_data/n8n/"
TARGET_LOCAL_PATH="../"
N8N_CONTAINER_ROOT_PATH="/home/node/.n8n/"
WORKFLOW_SUBDIRECTORY="workflows"

docker compose exec -T n8n n8n export:workflow --backup --output="${N8N_CONTAINER_ROOT_PATH}${WORKFLOW_SUBDIRECTORY}"

# require jq
if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required to extract workflow names. Install jq and retry." >&2
    exit 1
fi

for file in "${N8N_LOCAL_ROOT_PATH}${WORKFLOW_SUBDIRECTORY}"/*.json; do
    [ -e "$file" ] || continue

    name=$(jq -r '.name // empty' "$file" 2>/dev/null)
    [ -z "$name" ] && continue

    # sanitize name to a safe filename
    sanitized=$(printf '%s' "$name" | sed 's/[^A-Za-z0-9_-]/_/g')

    dest_dir="${N8N_LOCAL_ROOT_PATH}${WORKFLOW_SUBDIRECTORY}"
    newpath="${dest_dir}/${sanitized}.json"

    if [ -f "$newpath" ]; then
        echo "❌ Error: File already exists $newpath"
        exit 1
    fi

    mv -f -- "$file" "$newpath"
done

cp -fr "${N8N_LOCAL_ROOT_PATH}${WORKFLOW_SUBDIRECTORY}" "${TARGET_LOCAL_PATH}"
rm -- "${N8N_LOCAL_ROOT_PATH}${WORKFLOW_SUBDIRECTORY}"/*
