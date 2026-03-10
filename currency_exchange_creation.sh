#!/bin/bash
set -e

# =========================
# Configurable variables
# =========================
BASE_URL="http://localhost:8020"
#BASE_URL="https://brand1.crm-dev.fynxt.com"

#TENANT_ID="5a62b693-c1d2-436d-8644-854b08fc4c7c"
TENANT_ID="5a62b693-c1d2-436d-8644-854b08fc4c7c"

COMMON_HEADER=(-H "x-tenant-id: ${TENANT_ID}")
JSON_HEADER=(-H "Content-Type: application/json")

# echo "🚀 Provisioning tenant meta objects for tenant: ${TENANT_ID}"

# =========================
# 1. Provision tenant
# =========================
#curl -s -X POST \
#  "${BASE_URL}/api/core/meta/objects/provision" \
#  "${COMMON_HEADER[@]}"

# echo "✅ Tenant provisioned"

# =========================
# 2. Create currency_pair
# =========================
curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/bundle" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "object": {
      "entity_name": "currency_pair",
      "label": "Currency Pairs",
      "description": "---",
      "entity_type": "CORE",
      "entity_strength": "STRONG_ENTITY",
      "allow_multiple_instance": true,
      "parent": ""
    },
    "fields": [
      {
        "field_name": "conversion_rate",
        "field_label": "Conversion Rate",
        "field_type": "CUSTOM",
        "field_data_type": "DECIMAL"
      },
      {
        "field_name": "is_active",
        "field_label": "Is Active",
        "field_type": "CORE",
        "field_data_type": "BOOLEAN"
      },
      {
        "field_name": "markup_pips",
        "field_label": "Markup Value( in pips)",
        "field_type": "CUSTOM",
        "field_data_type": "INTEGER"
      },
      {
        "field_name": "markup_on_deposit",
        "field_label": "Markup on Deposit",
        "field_type": "CUSTOM",
        "field_data_type": "BOOLEAN"
      },
      {
        "field_name": "markup_on_withdrawal",
        "field_label": "Markup on Withdrawal",
        "field_type": "CUSTOM",
        "field_data_type": "BOOLEAN"
      },
      {
        "field_name": "markup_on_internal",
        "field_label": "Markup on Internal Transfer",
        "field_type": "CUSTOM",
        "field_data_type": "BOOLEAN"
      },
      {
        "field_name": "manual_rate_enable",
        "field_label": "Manual Rate Enabled",
        "field_type": "CUSTOM",
        "field_data_type": "BOOLEAN"
      }
    ]
  }'

echo "✅ currency_pair created"

# =========================
# 3. Create currency_symbol
# =========================
curl -s -X POST \
  "${BASE_URL}/api/core/meta/objects/bundle" \
  "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
  -d '{
    "object": {
      "entity_name": "currency_symbol",
      "label": "Currency Symbols",
      "description": "---",
      "entity_type": "CORE",
      "entity_strength": "STRONG_ENTITY",
      "allow_multiple_instance": true,
      "parent": ""
    },
    "fields": [
      {
        "field_name": "code",
        "field_label": "Currency Code",
        "field_type": "CUSTOM",
        "field_data_type": "TEXT",
        "required": true,
        "is_indexed": true
      },
      {
        "field_name": "source_type",
        "field_label": "Source Type",
        "field_type": "CUSTOM",
        "field_data_type": "TEXT",
        "required": true,
        "is_indexed": false
      }, 
      {
        "field_name": "name",
        "field_label": "Currency Name",
        "field_type": "CUSTOM",
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
# 4. Create currency_rate_config
# =========================
# curl -s -X POST \
#   "${BASE_URL}/api/core/meta/objects/bundle" \
#   "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}" \
#   -d '{
#     "object": {
#       "entity_name": "currency_rate_config",
#       "label": "Currency Rate Config",
#       "description": "---",
#       "entity_type": "CORE",
#       "entity_strength": "STRONG_ENTITY",
#       "allow_multiple_instance": true,
#       "parent": ""
#     },
#     "fields": [
#       {
#         "field_name": "polling_minutes",
#         "field_label": "Polling Interval",
#         "field_type": "CORE",
#         "field_data_type": "INTEGER",
#         "required": true
#       },
#       {
#         "field_name": "provider",
#         "field_label": "Provider",
#         "field_type": "CORE",
#         "field_data_type": "TEXT",
#         "required": true
#       }
#     ]
#   }'

# echo "✅ currency_rate_config created"


# =========================
# 6. Publish objects
# =========================
for ENTITY in currency_pair currency_symbol; do # currency_rate_config
  curl -s -X POST \
    "${BASE_URL}/api/core/meta/objects/name/${ENTITY}/publish" \
    "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}"
  echo "📦 Published ${ENTITY}"
done

echo "🎉 Provisioning completed successfully!"


# =========================
# 5. Create relations
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

echo "✅ Relations created"

# =========================
# 6. Publish objects
# =========================
for ENTITY in currency_pair currency_symbol; do # currency_rate_config
  curl -s -X POST \
    "${BASE_URL}/api/core/meta/objects/name/${ENTITY}/publish" \
    "${COMMON_HEADER[@]}" "${JSON_HEADER[@]}"
  echo "📦 Published ${ENTITY}"
done

echo "🎉 Provisioning completed successfully!"


## Actions

{
    "name": "sync_pairs",
    "label": "Sync pairs",
    "input_form_id": null
}

{
    "name": "find_pair",
    "label": "Find pair",
    "parameters": [
        {
            "name": "base_symbol_id",
            "datatype": "uuid"
        },
        {
            "name": "quote_symbol_id",
            "datatype": "uuid"
        }
    ],
    "input_form_id": null
}
