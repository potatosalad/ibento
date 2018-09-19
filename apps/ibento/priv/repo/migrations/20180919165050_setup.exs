defmodule Ibento.Repo.Migrations.Setup do
  use Ecto.Migration

  def change() do
    create(table(:streams, primary_key: false)) do
      add(:id, :bigserial, null: false, primary_key: true)
      add(:source, :text, null: false)
      add(:inserted_at, :timestamp, null: false, default: fragment("(now() at time zone 'utc')"))
    end

    create(unique_index(:streams, [:source]))

    create(table(:events, primary_key: false)) do
      add(:id, :uuid, null: false, primary_key: true, default: fragment("ulid_generate()"))
      add(:type, :text, null: false)
      add(:correlation, :text)
      add(:causation, :text)
      # could also be a bytea if we wanted to do term_to_binary/1
      add(:data, :jsonb, null: false)
      add(:metadata, :jsonb)
      add(:inserted_at, :timestamp, null: false, default: fragment("(now() at time zone 'utc')"))
    end

    execute("CREATE OR REPLACE RULE no_update_events AS ON UPDATE TO events DO INSTEAD NOTHING")
    execute("CREATE OR REPLACE RULE no_delete_events AS ON DELETE TO events DO INSTEAD NOTHING")

    create(table(:stream_events, primary_key: false)) do
      add(:event_id, references(:events, type: :uuid), null: false, primary_key: true)
      add(:stream_id, references(:streams, type: :bigint), null: false, primary_key: true)
    end
  end
end
