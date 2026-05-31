-- View: a65215dc-52d0-40a6-b1cc-a68a84c78f92.users_view

-- DROP VIEW "a65215dc-52d0-40a6-b1cc-a68a84c78f92".users_view;

CREATE OR REPLACE VIEW "a65215dc-52d0-40a6-b1cc-a68a84c78f92".users_view
 AS
 SELECT users.id,
    users.first_name,
    users.last_name,
    users.date_of_birth,
    users.country,
    users.user_name,
    users.phone_number,
    users.reports_to,
    users.designation_id,
    users.gender,
    users.idp_user_id,
    users.is_locked,
    users.created_at,
    users.updated_at,
    users.path,
    users.is_suspended,
    users.user_type,
    users.email,
    (users.first_name::text || ' '::text) || users.last_name::text AS users_view_label,
    users.search,
    users.updated_at AS updated_on,
    users.created_by,
    users.updated_by,
    users.is_deleted
   FROM users
  WHERE users.tenant_id::text = 'a65215dc-52d0-40a6-b1cc-a68a84c78f92'::text AND users.is_deleted = false
UNION ALL
 SELECT cp_users.id,
    cp_users.first_name,
    cp_users.last_name,
    NULL::date AS date_of_birth,
    NULL::character varying(255) AS country,
    NULL::character varying(255) AS user_name,
    NULL::character varying(255) AS phone_number,
    NULL::uuid AS reports_to,
    NULL::uuid AS designation_id,
    NULL::character varying(255) AS gender,
    cp_users.idp_user_id,
    NULL::boolean AS is_locked,
    NULL::timestamp(6) with time zone AS created_at,
    NULL::timestamp(6) with time zone AS updated_at,
    NULL::ltree AS path,
    false AS is_suspended,
    'CP_USER'::character varying(20) AS user_type,
    cp_users.email,
    (cp_users.first_name::text || ' '::text) || cp_users.last_name::text AS users_view_label,
    to_tsvector('simple'::regconfig, ''::text) AS search,
    NULL::timestamp(6) with time zone AS updated_on,
    NULL::uuid AS created_by,
    NULL::uuid AS updated_by,
    false AS is_deleted
   FROM cp_users
  WHERE cp_users.tenant_id::text = 'a65215dc-52d0-40a6-b1cc-a68a84c78f92'::text;

ALTER TABLE "a65215dc-52d0-40a6-b1cc-a68a84c78f92".users_view
    OWNER TO "a65215dc-52d0-40a6-b1cc-a68a84c78f92";

GRANT ALL ON TABLE "a65215dc-52d0-40a6-b1cc-a68a84c78f92".users_view TO "a65215dc-52d0-40a6-b1cc-a68a84c78f92";
GRANT SELECT ON TABLE "a65215dc-52d0-40a6-b1cc-a68a84c78f92".users_view TO cw_user;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE "a65215dc-52d0-40a6-b1cc-a68a84c78f92".users_view TO fynxt_ru_uat;
GRANT SELECT ON TABLE "a65215dc-52d0-40a6-b1cc-a68a84c78f92".users_view TO readonly_all;

