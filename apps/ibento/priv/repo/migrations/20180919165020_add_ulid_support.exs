defmodule Ibento.Repo.Migrations.AddUlidSupport do
  use Ecto.Migration

  def up() do
    execute("CREATE EXTENSION IF NOT EXISTS \"citext\"")
    execute("CREATE EXTENSION IF NOT EXISTS \"pg_trgm\"")
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"")
    execute("CREATE EXTENSION IF NOT EXISTS \"pgcrypto\"")

    execute(~S"""
    CREATE OR REPLACE FUNCTION ulid_encode_t(t bigint)
    RETURNS bytea
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
    SELECT
      set_byte(
        set_byte(
          set_byte(
            set_byte(
              set_byte(
                set_byte(
                  '\x000000000000'::bytea,
                  0, ((t >> 40) & 255)::integer
                ),
                1, ((t >> 32) & 255)::integer
              ),
              2, ((t >> 24) & 255)::integer
            ),
            3, ((t >> 16) & 255)::integer
          ),
          4, ((t >> 8) & 255)::integer
        ),
        5, ((t) & 255)::integer
      )
    $$
    """)

    execute(~S"""
    CREATE OR REPLACE FUNCTION ulid_generate(t bigint, r bytea)
    RETURNS uuid
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
    SELECT (encode(ulid_encode_t(t), 'hex') || substring(lpad(encode(r, 'hex'), 20, '0') FROM 1 FOR 20))::uuid
    $$
    """)

    execute(~S"""
    CREATE OR REPLACE FUNCTION ulid_generate(t bigint)
    RETURNS uuid
    LANGUAGE sql VOLATILE PARALLEL SAFE
    AS $$
    SELECT encode(overlay(set_byte(uuid_send(uuid_generate_v4()), 6, width_bucket(random(), 0, 1, 256) - 1) PLACING ulid_encode_t(t) FROM 1), 'hex')::uuid
    $$
    """)

    execute(~S"""
    CREATE OR REPLACE FUNCTION ulid_generate()
    RETURNS uuid
    LANGUAGE sql VOLATILE PARALLEL SAFE
    AS $$
    SELECT ulid_generate((extract(epoch FROM clock_timestamp()) * 1000)::bigint)
    $$
    """)
  end

  def down() do
    execute("DROP FUNCTION IF EXISTS ulid_encode_t(t bigint) CASCADE")
    execute("DROP FUNCTION IF EXISTS ulid_generate(t bigint, r bytea) CASCADE")
    execute("DROP FUNCTION IF EXISTS ulid_generate(t bigint) CASCADE")
    execute("DROP FUNCTION IF EXISTS ulid_generate() CASCADE")
  end
end
