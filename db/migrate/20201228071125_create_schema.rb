class CreateSchema < ActiveRecord::Migration[6.0]
  def change
    create_table "account_deletions", force: :cascade do |t|
      t.bigint "company_id", null: false
      t.bigint "profile_id", null: false
      t.datetime "requested_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["company_id"], name: "index_account_deletions_on_company_id"
      t.index ["profile_id"], name: "index_account_deletions_on_profile_id"
    end

    create_table "accounts", force: :cascade do |t|
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end

    create_table "active_storage_attachments", force: :cascade do |t|
      t.string "name", null: false
      t.string "record_type", null: false
      t.bigint "record_id", null: false
      t.bigint "blob_id", null: false
      t.datetime "created_at", null: false
      t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
      t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    end

    create_table "active_storage_blobs", force: :cascade do |t|
      t.string "key", null: false
      t.string "filename", null: false
      t.string "content_type"
      t.text "metadata"
      t.bigint "byte_size", null: false
      t.string "checksum", null: false
      t.datetime "created_at", null: false
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end

    create_table "addresses", force: :cascade do |t|
      t.string "addressable_type", null: false
      t.integer "addressable_id", null: false
      t.string "line_1"
      t.string "line_2"
      t.string "city"
      t.string "province"
      t.string "postalcode"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "company_id", null: false
      t.string "country_code", default: "US", null: false
    end

    create_table "auth_credential_logs", force: :cascade do |t|
      t.string "provider", null: false
      t.integer "member_id", null: false
      t.string "token", null: false
      t.string "hashed_token", null: false
      t.string "refresh_token", null: false
      t.integer "expires_at"
      t.boolean "expires", default: true, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end

    create_table "auth_credentials", force: :cascade do |t|
      t.string "provider", null: false
      t.integer "member_id", null: false
      t.string "token", null: false
      t.string "hashed_token", null: false
      t.string "refresh_token", null: false
      t.integer "expires_at"
      t.boolean "expires", default: true, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "account_name", null: false
    end

    create_table "beta_requests", force: :cascade do |t|
      t.string "email", null: false
      t.boolean "interview", default: false, null: false
      t.boolean "beta_test", default: false, null: false
      t.boolean "unsubscribed", default: false, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "hashed_email", null: false
    end

    create_table "billing_charges", force: :cascade do |t|
      t.bigint "billing_source_id", null: false
      t.bigint "billing_payment_intent_id", null: false
      t.integer "amount", null: false
      t.integer "refund_amount", null: false
      t.boolean "captured", default: false, null: false
      t.integer "status", default: 0, null: false
      t.string "currency", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "failure_code"
      t.string "failure_reason"
      t.integer "billing_invoice_id", null: false
      t.index ["billing_payment_intent_id"], name: "index_billing_charges_on_billing_payment_intent_id"
      t.index ["billing_source_id"], name: "index_billing_charges_on_billing_source_id"
    end

    create_table "billing_customers", force: :cascade do |t|
      t.string "external_id", null: false
      t.integer "provider", default: 0, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "customerable_type"
      t.bigint "customerable_id"
      t.index ["customerable_type", "customerable_id"], name: "bc_customerable_id_and_type_idx"
    end

    create_table "billing_details", force: :cascade do |t|
      t.string "tax_number"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "entity_type", default: 0, null: false
      t.string "entity_name", null: false
      t.string "detailable_type", null: false
      t.bigint "detailable_id", null: false
      t.boolean "account_default", default: false, null: false
      t.index ["detailable_type", "detailable_id"], name: "index_billing_details_on_detailable_type_and_detailable_id"
    end

    create_table "billing_downgrades", force: :cascade do |t|
      t.bigint "profile_id", null: false
      t.bigint "billing_subscription_id", null: false
      t.datetime "downgraded_at", null: false
      t.text "reason"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.datetime "deleted_at"
      t.index ["billing_subscription_id"], name: "index_billing_downgrades_on_billing_subscription_id"
      t.index ["profile_id"], name: "index_billing_downgrades_on_profile_id"
    end

    create_table "billing_external_ids", force: :cascade do |t|
      t.string "external_id", null: false
      t.string "objectable_type"
      t.bigint "objectable_id"
      t.index ["objectable_type", "objectable_id"], name: "index_billing_external_ids_on_objectable_type_and_objectable_id"
    end

    create_table "billing_features", force: :cascade do |t|
      t.string "feature_name", null: false
      t.string "feature_key", null: false
      t.integer "default_type", default: 0, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "measuring_type", default: 0, null: false
      t.integer "quantity", default: 0, null: false
      t.boolean "enabled", default: false, null: false
      t.boolean "unlimited", default: false, null: false
    end

    create_table "billing_invoices", force: :cascade do |t|
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "status", default: 0, null: false
      t.string "currency_code", null: false
      t.integer "subtotal", null: false
      t.integer "tax", default: 0, null: false
      t.integer "total", null: false
      t.integer "amount_due", null: false
      t.integer "amount_paid", default: 0, null: false
      t.integer "amount_remaining", null: false
      t.string "invoiceable_type", null: false
      t.bigint "invoiceable_id", null: false
      t.string "number"
      t.index ["invoiceable_type", "invoiceable_id"], name: "index_billing_invoices_on_invoiceable_type_and_invoiceable_id"
      t.index ["number"], name: "index_billing_invoices_on_number", unique: true
    end

    create_table "billing_payment_intents", force: :cascade do |t|
      t.integer "payable_id", null: false
      t.string "payable_type", null: false
      t.datetime "started_at", null: false
      t.integer "profile_id"
      t.string "uuid", null: false
      t.datetime "terms_accepted_on"
      t.string "external_id"
      t.integer "billing_source_id"
      t.string "chargeable_type"
      t.bigint "chargeable_id"
      t.integer "status", default: 0, null: false
      t.string "targetable_type", null: false
      t.bigint "targetable_id", null: false
      t.string "billable_type", null: false
      t.bigint "billable_id", null: false
      t.integer "billing_invoice_id"
      t.index ["billable_type", "billable_id"], name: "index_billing_payment_intents_on_billable_type_and_billable_id"
      t.index ["chargeable_type", "chargeable_id"], name: "bpi_chargable_idx"
      t.index ["targetable_type", "targetable_id"], name: "bpi_targetable_idx"
    end

    create_table "billing_prices", force: :cascade do |t|
      t.string "interval", null: false
      t.integer "amount", null: false
      t.string "currency", null: false
      t.integer "billing_product_id", null: false
      t.boolean "active", default: true
      t.datetime "deleted_at"
    end

    create_table "billing_product_features", force: :cascade do |t|
      t.bigint "billing_product_id", null: false
      t.bigint "billing_feature_id", null: false
      t.integer "measuring_type", default: 0, null: false
      t.integer "quantity", null: false
      t.integer "enabled", default: 0, null: false
      t.boolean "unlimited", default: false, null: false
      t.index ["billing_feature_id"], name: "index_billing_product_features_on_billing_feature_id"
      t.index ["billing_product_id"], name: "index_billing_product_features_on_billing_product_id"
    end

    create_table "billing_products", force: :cascade do |t|
      t.boolean "visible", default: false, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "name", null: false
      t.string "description"
      t.boolean "subscription_default", default: false, null: false
      t.datetime "deleted_at"
    end

    create_table "billing_revenue_records", force: :cascade do |t|
      t.integer "date", null: false
      t.integer "period", null: false
      t.integer "collected", default: 0, null: false
      t.integer "uncollected", default: 0, null: false
      t.integer "total", default: 0, null: false
      t.index ["date", "period"], name: "index_billing_revenue_records_on_date_and_period", unique: true
    end

    create_table "billing_sources", force: :cascade do |t|
      t.integer "created_by_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "source_type", default: 0, null: false
      t.datetime "deleted_at"
      t.boolean "default", default: false, null: false
      t.integer "exp_year"
      t.integer "exp_month"
      t.string "brand"
      t.string "last_four"
      t.string "sourceable_type"
      t.bigint "sourceable_id"
      t.integer "billing_detail_id", null: false
      t.index ["sourceable_type", "sourceable_id"], name: "index_billing_sources_on_sourceable_type_and_sourceable_id"
    end

    create_table "billing_subscriptions", force: :cascade do |t|
      t.boolean "active", null: false
      t.string "subscribeable_type", null: false
      t.bigint "subscribeable_id", null: false
      t.integer "last_paid_date"
      t.integer "paid_until_date"
      t.datetime "cancelled_at"
      t.string "ownerable_type", null: false
      t.bigint "ownerable_id", null: false
      t.index ["ownerable_type", "ownerable_id"], name: "index_billing_subscriptions_on_ownerable_type_and_ownerable_id"
      t.index ["subscribeable_type", "subscribeable_id"], name: "index_subscribeable"
    end

    create_table "billing_vat_rates", force: :cascade do |t|
      t.string "display_name", null: false
      t.string "jurisdiction", null: false
      t.boolean "active", default: true, null: false
      t.integer "inclusive_type", default: 0, null: false
      t.integer "percentage", default: 0, null: false
      t.boolean "default_rate", default: false, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end

    create_table "billing_webhooks", force: :cascade do |t|
      t.integer "provider", default: 0, null: false
      t.datetime "processed_at"
      t.integer "process_status"
      t.text "process_result"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.text "payload", null: false
    end

    create_table "broken_auth_records", force: :cascade do |t|
      t.integer "member_id", null: false
      t.integer "provider", null: false
      t.string "error_type"
      t.string "error_message"
      t.datetime "disconnected_at", null: false
      t.datetime "reconnected_at"
      t.bigint "auth_credential_id", null: false
      t.index ["auth_credential_id"], name: "index_broken_auth_records_on_auth_credential_id"
    end

    create_table "companies", force: :cascade do |t|
      t.string "name", null: false
      t.string "hashed_name", null: false
      t.string "email_domain", null: false
      t.string "hashed_email_domain", null: false
      t.integer "auth_credential_id"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "provider", null: false
      t.datetime "deleted_at"
      t.integer "open_signups", default: 0, null: false
      t.integer "account_id"
      t.index ["hashed_name"], name: "index_companies_on_hashed_name"
    end

    create_table "contact_us_requests", force: :cascade do |t|
      t.string "email", null: false
      t.integer "category", null: false
      t.bigint "company_id"
      t.bigint "profile_id"
      t.text "request", null: false
      t.datetime "submitted_at", null: false
      t.datetime "resolved_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["company_id"], name: "index_contact_us_requests_on_company_id"
      t.index ["profile_id"], name: "index_contact_us_requests_on_profile_id"
    end

    create_table "external_profiles", force: :cascade do |t|
      t.string "email", null: false
      t.string "hashed_email", null: false
      t.string "name"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["hashed_email"], name: "index_external_profiles_on_hashed_email"
    end

    create_table "gdpr_exports", force: :cascade do |t|
      t.bigint "profile_id", null: false
      t.datetime "requested_at", null: false
      t.datetime "sent_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.boolean "downloaded", default: false, null: false
      t.boolean "file_scrubbed", default: false, null: false
      t.index ["profile_id"], name: "index_gdpr_exports_on_profile_id"
    end

    create_table "ichnaea_event_types", force: :cascade do |t|
      t.string "name"
    end

    create_table "ichnaea_events", force: :cascade do |t|
      t.integer "ichnaea_event_type_id", null: false
      t.datetime "event_time"
      t.integer "ichnaea_event_payload_id"
      t.integer "performed_by_id"
      t.integer "ichnaea_url_id"
      t.index ["performed_by_id"], name: "index_ichnaea_events_on_performed_by_id"
    end

    create_table "ichnaea_ips", force: :cascade do |t|
      t.string "ip_address"
      t.string "ip_hash", null: false
      t.index ["ip_address"], name: "index_ichnaea_ips_on_ip_address"
      t.index ["ip_hash"], name: "index_ichnaea_ips_on_ip_hash"
    end

    create_table "ichnaea_locations", force: :cascade do |t|
      t.string "city"
      t.string "region"
      t.string "country"
    end

    create_table "ichnaea_page_views", force: :cascade do |t|
      t.bigint "ichnaea_urls_id"
      t.bigint "ichnaea_utms_id"
      t.bigint "ichnaea_user_agents_id"
      t.integer "ichnaea_referrers_id"
      t.bigint "ichnaea_ips_id"
      t.integer "viewed_by_id"
      t.integer "ichnaea_query_strings_id"
      t.datetime "viewed_at"
      t.index ["ichnaea_ips_id"], name: "index_ichnaea_page_views_on_ichnaea_ips_id"
      t.index ["ichnaea_referrers_id"], name: "index_ichnaea_page_views_on_ichnaea_referrers_id"
      t.index ["ichnaea_urls_id"], name: "index_ichnaea_page_views_on_ichnaea_urls_id"
      t.index ["ichnaea_user_agents_id"], name: "index_ichnaea_page_views_on_ichnaea_user_agents_id"
      t.index ["ichnaea_utms_id"], name: "index_ichnaea_page_views_on_ichnaea_utms_id"
      t.index ["viewed_by_id"], name: "index_ichnaea_page_views_on_viewed_by_id"
    end

    create_table "ichnaea_payloads", force: :cascade do |t|
      t.string "payload_hash"
      t.json "payload"
      t.index ["payload_hash"], name: "index_ichnaea_payloads_on_payload_hash"
    end

    create_table "ichnaea_referrers", force: :cascade do |t|
      t.string "referrer_hash"
      t.string "referrer_host"
      t.string "referrer_path"
      t.index ["referrer_hash"], name: "index_ichnaea_referrers_on_referrer_hash"
    end

    create_table "ichnaea_urls", force: :cascade do |t|
      t.string "url_hash", null: false
      t.string "domain", null: false
      t.string "path"
      t.index ["url_hash"], name: "index_ichnaea_urls_on_url_hash"
    end

    create_table "ichnaea_user_agents", force: :cascade do |t|
      t.string "user_agent"
    end

    create_table "ichnaea_users", force: :cascade do |t|
      t.string "userable_type"
      t.bigint "userable_id"
      t.index ["userable_type", "userable_id"], name: "index_ichnaea_users_on_userable_type_and_userable_id"
    end

    create_table "ichnaea_utms", force: :cascade do |t|
      t.string "utm_hash"
      t.string "utm_source"
      t.string "utm_medium"
      t.string "utm_campaign"
      t.string "utm_term"
      t.string "utm_content"
      t.index ["utm_hash"], name: "index_ichnaea_utms_on_utm_hash"
    end

    create_table "members", force: :cascade do |t|
      t.string "hashed_email", null: false
      t.string "email", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "company_id", null: false
      t.datetime "remember_created_at"
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.inet "current_sign_in_ip"
      t.inet "last_sign_in_ip"
      t.datetime "deleted_at"
      t.integer "member_type", default: 0, null: false
      t.boolean "login_enabled", default: true, null: false
      t.string "uuid", null: false
      t.integer "provider", default: 0, null: false
      t.string "webauthn_id"
      t.string "otp_secret"
      t.index ["company_id"], name: "index_members_on_company_id"
      t.index ["uuid"], name: "index_members_on_uuid"
    end

    create_table "mobile_authenticators", force: :cascade do |t|
      t.bigint "two_factor_authentication_id"
      t.string "otp_base", null: false
      t.boolean "enabled", default: false, null: false
      t.datetime "last_otp_used_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.datetime "deleted_at"
      t.index ["two_factor_authentication_id"], name: "index_mobile_authenticators_on_two_factor_authentication_id"
    end

    create_table "notification_preferences", force: :cascade do |t|
      t.bigint "profile_id", null: false
      t.boolean "marketing_emails", default: false, null: false
      t.boolean "unsubscribed", default: false, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["profile_id"], name: "index_notification_preferences_on_profile_id"
    end

    create_table "password_confirmation_logs", force: :cascade do |t|
      t.bigint "member_id", null: false
      t.datetime "confirmed_at", null: false
      t.string "ip_address", null: false
      t.index ["member_id"], name: "index_password_confirmation_logs_on_member_id"
    end

    create_table "portunus_data_encryption_keys", force: :cascade do |t|
      t.string "encrypted_key", null: false
      t.string "master_keyname", null: false
      t.string "encryptable_type", null: false
      t.integer "encryptable_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.datetime "last_dek_rotation"
      t.datetime "last_kek_rotation"
      t.index ["encryptable_id", "encryptable_type"], name: "portunus_dek_on_encryptable_id_and_encryptable_type", unique: true
      t.index ["last_dek_rotation"], name: "index_portunus_data_encryption_keys_on_last_dek_rotation"
      t.index ["last_kek_rotation"], name: "index_portunus_data_encryption_keys_on_last_kek_rotation"
    end

    create_table "profiles", force: :cascade do |t|
      t.string "hashed_email", null: false
      t.string "email", null: false
      t.integer "member_id"
      t.integer "company_id"
      t.string "given_name"
      t.string "family_name"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.datetime "deleted_at"
      t.integer "team_id", null: false
      t.integer "role", default: 0, null: false
      t.string "timezone", null: false
      t.string "external_slug", null: false
      t.string "hashed_external_slug", null: false
      t.integer "status", default: 0, null: false
      t.index ["hashed_external_slug"], name: "index_profiles_on_hashed_external_slug", unique: true
      t.index ["team_id"], name: "index_profiles_on_team_id"
    end

    create_table "support_request_messages", force: :cascade do |t|
      t.string "sendable_type", null: false
      t.bigint "sendable_id", null: false
      t.bigint "support_request_id", null: false
      t.text "message", null: false
      t.datetime "sent_at", null: false
      t.integer "sent_by_staff", default: 0, null: false
      t.integer "hidden_from_customer", default: 1, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.datetime "deleted_at"
      t.boolean "trigger_resolved", default: false, null: false
      t.index ["sendable_type", "sendable_id"], name: "index_support_request_messages_on_sendable_type_and_sendable_id"
      t.index ["support_request_id"], name: "index_support_request_messages_on_support_request_id"
    end

    create_table "support_requests", force: :cascade do |t|
      t.string "supportable_type", null: false
      t.bigint "supportable_id", null: false
      t.bigint "company_id"
      t.datetime "submitted_at", null: false
      t.datetime "resolved_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "uuid", null: false
      t.string "resolvable_type"
      t.bigint "resolvable_id"
      t.datetime "deleted_at"
      t.index ["company_id"], name: "index_support_requests_on_company_id"
      t.index ["resolvable_type", "resolvable_id"], name: "index_support_requests_on_resolvable_type_and_resolvable_id"
      t.index ["supportable_type", "supportable_id"], name: "index_support_requests_on_supportable_type_and_supportable_id"
    end

    create_table "two_factor_auth_logs", force: :cascade do |t|
      t.bigint "member_id", null: false
      t.string "authenticatable_type", null: false
      t.bigint "authenticatable_id", null: false
      t.datetime "authed_on", null: false
      t.integer "auth_status", default: 0, null: false
      t.datetime "redeemed_at"
      t.string "redeemed_by"
      t.index ["authenticatable_type", "authenticatable_id"], name: "tfal_auth_id_and_auth_type_idx"
      t.index ["member_id"], name: "index_two_factor_auth_logs_on_member_id"
    end

    create_table "two_factor_authentications", force: :cascade do |t|
      t.bigint "member_id"
      t.integer "auth_type", default: 0, null: false
      t.boolean "primary", default: false, null: false
      t.boolean "enabled", default: false, null: false
      t.index ["member_id"], name: "index_two_factor_authentications_on_member_id"
    end

    create_table "unsubscribe_logs", force: :cascade do |t|
      t.bigint "profile_id", null: false
      t.integer "action", null: false
      t.datetime "acted_on", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["profile_id"], name: "index_unsubscribe_logs_on_profile_id"
    end

    create_table "webauthn_credentials", force: :cascade do |t|
      t.bigint "two_factor_authentication_id", null: false
      t.string "external_id", null: false
      t.string "public_key", null: false
      t.string "nickname"
      t.integer "used_count", default: 0, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.datetime "deleted_at"
      t.index ["two_factor_authentication_id"], name: "index_webauthn_credentials_on_two_factor_authentication_id"
    end

    add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  end
end
