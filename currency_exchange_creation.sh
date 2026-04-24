#!/bin/bash
set -e

# =========================
# Configurable variables
# =========================
BASE_URL="http://localhost:8080"
# BASE_URL="https://brand1.crm-dev.fynxt.com"


TENANT_ID="5a62b693-c1d2-436d-8644-854b08fc4c7c"
USER_ID="1ef2485b-0494-4465-b87c-617aac79deec"
USER_ROLES="b8838caf-b062-46c9-a171-5ed2e96a3c6c"

# Bearer token for auth (if needed)
# AUTH_TOKEN="6d1d0a19-d20e-4e76-ba6e-a713d015821e:c95bb576-336a-4c3b-92fe-7fe7e956425c"

COMMON_HEADER=(-H "x-tenant-id: ${TENANT_ID}" -H "x-user-id: ${USER_ID}" -H "x-user-roles: ${USER_ROLES}")
# COMMON_HEADER=(-H "Authorization: Bearer ${AUTH_TOKEN}")

JSON_HEADER=(-H "Content-Type: application/json")

echo "🚀 Starting provisioning for tenant: ${TENANT_ID}"

# =========================
# 1. Create currency_pair
# =========================
curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/bundle" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "object": {
      "entity_name": "currency_pair",
      "label": "Currency Pairs",
      "description": "A list of available currency pairs for exchange, along with their conversion rates and markup settings.",
      "entity_type": "CORE",
      "entity_strength": "STRONG_ENTITY",
      "allow_multiple_instance": true,
      "parent": ""
    },
    "fields": [
{
        "field_name": "base",
        "field_label": "f19c5eb2-82be-435c-b5f5-394e4f4424a5",
        "group_name": "Pair Symbols",
        "field_type": "CORE",
        "is_encrypted": false,
        "field_data_type": "TEXT",
        "required": false,
        "is_unique": false,
        "max_length":20
        },
        {
        "field_name": "quote",
        "field_label": "f19c5eb2-82be-435c-b5f5-394e4f4424a5",
        "group_name": "Pair Symbols",
        "field_type": "CORE",
        "is_encrypted": false,
        "field_data_type": "TEXT",
        "required": false,
        "is_unique": false,
        "max_length":20
        },
      {
        "field_name": "conversion_rate",
        "field_label": "Conversion Rate",
        "field_type": "CORE",
        "field_data_type": "DECIMAL",
        "max_length":30,
        "decimal_scale":15
      },
      {
        "field_name": "is_active",
        "field_label": "Is Active",
        "field_type": "CORE",
        "field_data_type": "BOOLEAN"
      },
      {
        "field_name": "markup_pips",
        "field_label": "Markup Value(in pips)",
        "field_type": "CORE",
        "field_data_type": "LONG_INTEGER"
      },
      {
        "field_name": "markup_on_deposit",
        "field_label": "Markup on Deposit",
        "field_type": "CORE",
        "field_data_type": "BOOLEAN"
      },
      {
        "field_name": "markup_on_withdrawal",
        "field_label": "Markup on Withdrawal",
        "field_type": "CORE",
        "field_data_type": "BOOLEAN"
      },
      {
        "field_name": "markup_on_internal",
        "field_label": "Markup on Internal Transfer",
        "field_type": "CORE",
        "field_data_type": "BOOLEAN"
      },
      {
        "field_name": "source_type",
        "field_label": "Source Type",
        "field_type": "CORE",
        "field_data_type": "PICKLIST"
        "required": false,
        "is_indexed": false
      },
      {
        "field_name": "manual_rate_enable",
        "field_label": "Manual Rate Enabled",
        "field_type": "CORE",
        "field_data_type": "BOOLEAN"
      }
    ],
    "actions":[
    ]
  }'
echo "✅ currency_pair created"

# =========================
# 2. Create currency_symbol
# =========================
curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/bundle" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "object": {
      "entity_name": "currency_symbol",
      "label": "Currency Symbols",
      "description": "A list of currency symbols representing different currencies, used for defining base and quote symbols in currency pairs.",
      "entity_type": "CORE",
      "entity_strength": "STRONG_ENTITY",
      "allow_multiple_instance": true,
      "parent": ""
    },
    "fields": [
      {
        "field_name": "code",
        "field_label": "Currency Code",
        "field_type": "CORE",
        "field_data_type": "TEXT",
        "required": true,
        "is_indexed": true
      },
      {
        "field_name": "source_type",
        "field_label": "Source Type",
        "field_type": "CORE",
        "field_data_type": "PICKLIST",
        "asset_id": "8efc913c-8e08-4d43-b7e7-dedd78b1a9f9",
        "options": [
            {
                "value": "Manual",
                "color_hex": null
            },
            {
                "value": "Fixer",
                "color_hex": null
            }
        ],
        "required": true,
        "is_indexed": false

      },
      {
        "field_name": "name",
        "field_label": "Currency Name",
        "field_type": "CORE",
        "field_data_type": "TEXT",
        "required": false
      },
      {
        "field_name": "is_active",
        "field_label": "Is Active",
        "field_type": "CORE",
        "field_data_type": "BOOLEAN"
      }
    ]
  }'
echo "✅ currency_symbol created"

# =========================
# 3. Publish objects (first pass)
# =========================
for ENTITY in currency_pair currency_symbol; do
  curl -s -X POST \
    "${BASE_URL}/api/core/meta/objects/name/${ENTITY}/publish" \
    "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}"
  echo "📦 Published ${ENTITY}"
done

# 4. Create relations
# =========================
# =========================
curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/relations" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "source_entity_name": "currency_symbol",
    "target_entity_name": "currency_pair",
    "reference_type": "ONE_TO_MANY",
    "relation_name": "quote_pair",
    "inverse_relation_name": "quote_symbol",
    "relation_label": "Associated quote pairs",
    "inverse_relation_label": "Associated quote symbols",
    "association_type": "ASSOCIATION",
    "is_association_nullable": true,
    "is_ownership_relation": false
  }'
echo "✅ quote_symbol relation created"

curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/relations" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "source_entity_name": "currency_symbol",
    "target_entity_name": "currency_pair",
    "reference_type": "ONE_TO_MANY",
    "relation_name": "base_pair",
    "inverse_relation_name": "base_symbol",
    "relation_label": "Associated base pair",
    "inverse_relation_label": "Associated base currency symbol",
    "association_type": "ASSOCIATION",
    "is_association_nullable": true,
    "is_ownership_relation": false
  }'
echo "✅ base_symbol relation created"

# =========================
# 5. Publish objects (second pass after relations)
# =========================
for ENTITY in currency_pair currency_symbol; do
  curl -s -X POST \
    "${BASE_URL}/api/core/meta/objects/name/${ENTITY}/publish" \
    "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}"
  echo "📦 Re-published ${ENTITY}"
done

# =========================
# 6. Register actions
# =========================

sync_pairs — BULK
✅ Type should be null
curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/name/currency_pair/actions" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "name": "sync_pairs",
    "label": "",
    "input_form_id": null,
    "type": ""
  }'
echo "✅ Action registered: sync_pairs"

# find_pair — ROW with parameters
curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/name/currency_pair/actions" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "name": "find_pair",
    "label": "",
    "input_form_id": null,
    "type": "",
    "parameters": [
      {
        "name": "base_symbol_id",
        "datatype": "uuid"
      },
      {
        "name": "quote_symbol_id",
        "datatype": "uuid"
      }
    ]
  }'
echo "✅ Action registered: find_pair"

# get_pair — ROW
curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/name/currency_pair/actions" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "name": "get_pair",
    "label": "",
    "input_form_id": null,
    "type": ""
  }'
echo "✅ Action registered: get_pair"

# edit — ROW
curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/name/currency_pair/actions" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "name": "edit_pair",
    "label": "Edit",
    "input_form_id": "",
    "type": "ROW"
  }'
echo "✅ Action registered: edit"

# create — null
curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/name/currency_pair/actions" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "name": "create_pair",
    "label": "New currency pair",
    "input_form_id": "",
    "type": "ROW"
  }'
echo "✅ Action registered: create_pair"

curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/name/currency_pair/actions" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "name": "delete_pair",
    "label": "Delete Pair",
    "action_entity_type": "CORE",
    "input_form_id": "",
    "type": "ROW"
  }'
echo "✅ Action registered: delete_pair"


curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/name/currency_pair/actions" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "name": "disable_pair",
    "label": "abbad23c-b9fe-40db-85b0-37d80e3a47cf",
    "action_entity_type": "CORE",
    "input_form_id": "",
    "type": "ROW"
  }'
echo "✅ Action registered: disable_pair"

echo "🎉 Provisioning completed successfully!"