defmodule Ibento.Edge.Data.Event do
  @moduledoc """
    Event struct
  """
  @type t() :: %__MODULE__{}

  defstruct [:id, :type, :correlation, :causation, :data, :metadata]
end
