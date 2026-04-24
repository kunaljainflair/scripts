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

echo "🚀 Starting update for tenant: ${TENANT_ID}"
