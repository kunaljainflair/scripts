# # curl --location --request PUT 'https://brand1.crm-dev.fynxt.com/api/core/meta/objects/name/currency_pair/actions/edit_pair' \
# # --header 'Content-Type: application/json' \
# # --header 'x-tenant-id: 5a62b693-c1d2-436d-8644-854b08fc4c7c' \
# # --header 'x-user-id: 1ef2485b-0494-4465-b87c-617aac79deec' \
# # --header 'x-user-roles: b8838caf-b062-46c9-a171-5ed2e96a3c6c' \
# # --data '{
# #     "name": "edit_pair",
# #     "label": "f19c5eb2-82be-435c-b5f5-394e4f4424a5",
# #     "parameters": [],
# #     "action_entity_type": "CORE",
# #     "type": "ROW",
# #     "input_form_id":"cb0463cc-1cdd-4288-af45-274d18390833"
    
# # }'

# # curl --location --request PUT 'https://brand1.crm-dev.fynxt.com/api/core/meta/objects/name/currency_pair/actions/get_pair' \
# # --header 'Content-Type: application/json' \
# # --header 'x-tenant-id: 5a62b693-c1d2-436d-8644-854b08fc4c7c' \
# # --header 'x-user-id: 1ef2485b-0494-4465-b87c-617aac79deec' \
# # --header 'x-user-roles: b8838caf-b062-46c9-a171-5ed2e96a3c6c' \
# # --data '{
# #     "name": "get_pair",
# #     "label": null,
# #     "parameters": [],
# #     "action_entity_type": "CORE",
# #     "type": null,
# #     "input_form_id":null
    
# # }'


# # INT Seeding


# curl --location --request PUT 'https://brand1.crm-int.fynxt.com/api/core/meta/objects/name/currency_pair/actions/edit_pair' \
# --header 'Content-Type: application/json' \
# --header 'Authorization: Bearer 6d1d0a19-d20e-4e76-ba6e-a713d015821e:c95bb576-336a-4c3b-92fe-7fe7e956425c' \
# --data '{
#     "name": "edit_pair",
#     "label": "08080bc4-4d58-433a-bebc-458fde169733",
#     "parameters": [],
#     "action_entity_type": "CORE",
#     "type": "ROW",
#     "input_form_id":null
    
# }'

# curl --location --request PUT 'https://brand1.crm-int.fynxt.com/api/core/meta/objects/name/currency_pair/actions/get_pair' \
# --header 'Content-Type: application/json' \
# --header 'Authorization: Bearer 6d1d0a19-d20e-4e76-ba6e-a713d015821e:c95bb576-336a-4c3b-92fe-7fe7e956425c' \
# --data '{
#     "name": "get_pair",
#     "label": "49a5871b-d35e-4341-b589-6b41f7fa54fd",
#     "parameters": [],
#     "action_entity_type": "CORE",
#     "type": null,
#     "input_form_id":null
    
# }'

# # edit 08080bc4-4d58-433a-bebc-458fde169733
# # get 49a5871b-d35e-4341-b589-6b41f7fa54fd

# curl --location --request PUT 'https://brand1.crm-dev.fynxt.com/api/core/meta/objects/name/currency_pair/actions/create_pair' \
# --header 'Content-Type: application/json' \
# --header 'x-tenant-id: 5a62b693-c1d2-436d-8644-854b08fc4c7c' \
# --header 'x-user-id: 1ef2485b-0494-4465-b87c-617aac79deec' \
# --header 'x-user-roles: b8838caf-b062-46c9-a171-5ed2e96a3c6c' \
# --data '{
#     "name": "create_pair",
#     "label": "c00af20a-2b85-4c09-8720-e3eb1900dcf7",
#     "parameters": [],
#     "action_entity_type": "CORE",
#     "type": "SPECIAL",
#     "input_form_id":"d243d010-4d5e-48c2-be73-036791f83aa9"
# }'

# curl --location --request PUT 'https://brand1.crm-dev.fynxt.com/api/core/meta/objects/name/currency_pair/actions/get_pair' \
# --header 'Content-Type: application/json' \
# --header 'x-tenant-id: 5a62b693-c1d2-436d-8644-854b08fc4c7c' \
# --header 'x-user-id: 1ef2485b-0494-4465-b87c-617aac79deec' \
# --header 'x-user-roles: b8838caf-b062-46c9-a171-5ed2e96a3c6c' \
# --data '{
#     "name": "get_pair",
#     "parameters": [],
#     "action_entity_type": "CORE",
#     "type": null,
#     "input_form_id":"d243d010-4d5e-48c2-be73-036791f83aa9"
# }'