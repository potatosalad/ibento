defmodule Ibento.GraphQL.Core.Schema.Types do
  use Absinthe.Schema.Notation

  scalar(:json, name: "JSON") do
    description("""
    The `JSON` scalar type represents a JSON Object as defined in [RFC 7159](https://tools.ietf.org/html/rfc7159).
    """)

    serialize(&serialize_json/1)
    parse(&parse_json/1)
  end

  @spec serialize_json(term()) :: binary() | nil
  defp serialize_json(map) when is_map(map) do
    OJSON.encode!(map)
  end

  defp serialize_json(_) do
    nil
  end

  @spec parse_json(Absinthe.Blueprint.Input.String.t()) :: {:ok, %{optional(binary()) => any()}} | :error
  @spec parse_json(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp parse_json(%Absinthe.Blueprint.Input.String{value: value}) when is_binary(value) do
    case OJSON.decode(value) do
      {:ok, map} when is_map(map) ->
        {:ok, map}

      _ ->
        :error
    end
  end

  defp parse_json(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_json(_) do
    :error
  end

  scalar(:uuid, name: "UUID") do
    description("""
    The `UUID` scalar type represents UUID values as specified by [RFC 4122](https://tools.ietf.org/html/rfc4122).
    """)

    serialize(&serialize_uuid/1)
    parse(&parse_uuid/1)
  end

  @spec serialize_uuid(term()) :: binary() | nil
  defp serialize_uuid(value) when is_binary(value) do
    case Ibento.UUID.string(value) do
      {:ok, uuid} ->
        uuid

      :error ->
        nil
    end
  end

  defp serialize_uuid(_) do
    nil
  end

  @spec parse_uuid(Absinthe.Blueprint.Input.String.t()) :: {:ok, Ibento.UUID.uuid_string()} | :error
  @spec parse_uuid(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp parse_uuid(%Absinthe.Blueprint.Input.String{value: value}) when is_binary(value) do
    Ibento.UUID.string(value)
  end

  defp parse_uuid(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_uuid(_) do
    :error
  end
end
