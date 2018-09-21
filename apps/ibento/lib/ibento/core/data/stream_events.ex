defmodule Ibento.Core.Data.StreamEvents do
  @moduledoc """
  stream-events data model
  """

  def create_stream_event(attrs) do
    attrs
    |> Ibento.Core.Data.StreamEvent.create_changeset()
    |> Ibento.Repo.insert()
  end
end
