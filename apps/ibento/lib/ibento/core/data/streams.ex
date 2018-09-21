defmodule Ibento.Core.Data.Streams do
  @moduledoc """
  streams data model
  """
  import Ecto.Query

  def get_or_create_stream(source) do
    from(s in Ibento.Core.Data.Stream, where: s.source == ^source, select: s)
    |> Ibento.Repo.one()
    |> case do
      nil ->
        create_stream(%{source: source})
      stream ->
        {:ok, stream}
    end
  end

  ## Helpers

  defp create_stream(attrs) do
    attrs
    |> Ibento.Core.Data.Stream.create_changeset()
    |> Ibento.Repo.insert()
  end
end
