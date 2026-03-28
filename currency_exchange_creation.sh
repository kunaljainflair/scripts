#!/bin/bash
set -euo pipefail

BASE_URL="http://localhost:8080"
TENANT_ID="5a62b693-c1d2-436d-8644-854b08fc4c7c"

COMMON_HEADER=(-H "x-tenant-id: ${TENANT_ID}")
JSON_HEADER=(-H "Content-Type: application/json")

USER_HEADER=(-H "x-user-id: 1ef2485b-0494-4465-b87c-617aac79deec" -H "x-user-roles: 123")

log_step() {
  echo ""
  echo "========================================"
  echo "➡️  $1"
  echo "========================================"
}

call_api() {
  RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" "$@")
  BODY=$(echo "$RESPONSE" | sed -e 's/HTTP_STATUS\:.*//g')
  STATUS=$(echo "$RESPONSE" | tr -d '\n' | sed -e 's/.*HTTP_STATUS://')

  echo "Status: $STATUS"
  echo "Response: $BODY"

  if [ "$STATUS" -ge 400 ]; then
    echo "❌ API FAILED"
    exit 1
  else
    echo "✅ API SUCCESS"
  fi
}

log_step "Create currency_pair"
call_api -X POST \
"${BASE_URL}/api/core/meta/objects/bundle" \
"${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
-d '{ ... currency_pair json ... }'

log_step "Create currency_symbol"
call_api -X POST \
"${BASE_URL}/api/core/meta/objects/bundle" \
"${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
-d '{ ... currency_symbol json ... }'

log_step "Create Relations"
call_api -X POST "${BASE_URL}/api/core/meta/objects/relations" "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" -d '{ ... quote relation ... }'
call_api -X POST "${BASE_URL}/api/core/meta/objects/relations" "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" -d '{ ... base relation ... }'

log_step "Publish Objects"
for ENTITY in currency_pair currency_symbol; do
  call_api -X POST \
  "${BASE_URL}/api/core/meta/objects/name/${ENTITY}/publish" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}"
done

log_step "Create Actions"

call_api -X POST "${BASE_URL}/api/meta/name/currency_pair/actions" \
"${COMMON_HEADER[@]}" "${USER_HEADER[@]}" "${JSON_HEADER[@]}" \
-d '{ "name": "sync_pairs", "label": "Sync Pairs", "type": "BULK", "input_form_id": null }'

call_api -X POST "${BASE_URL}/api/meta/name/currency_pair/actions" \
"${COMMON_HEADER[@]}" "${USER_HEADER[@]}" "${JSON_HEADER[@]}" \
-d '{ "name": "find_pair", "label": "Find Pair", "type": "ROW", "input_form_id": null,
      "parameters": [
        { "name": "base_symbol_id", "datatype": "uuid" },
        { "name": "quote_symbol_id", "datatype": "uuid" }
      ] }'

call_api -X POST "${BASE_URL}/api/meta/name/currency_pair/actions" \
"${COMMON_HEADER[@]}" "${USER_HEADER[@]}" "${JSON_HEADER[@]}" \
-d '{ "name": "get_pair", "label": "Get Pair", "type": "ROW", "input_form_id": null }'

call_api -X POST "${BASE_URL}/api/meta/name/currency_pair/actions" \
"${COMMON_HEADER[@]}" "${USER_HEADER[@]}" "${JSON_HEADER[@]}" \
-d '{ "name": "edit", "label": "Edit Currency Pair", "type": "ROW", "input_form_id": null }'

echo ""
echo "🎉 ALL PROVISIONING COMPLETED SUCCESSFULLY"