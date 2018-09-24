defprotocol Ibento.Edge.Protocols.EventTypeCast do
  @moduledoc """
    Event's type casting protocol.
    Casts the local events type to a Core-compatible type
  """

  @spec cast(any()) :: Ibento.Core.Data.Event.t()
  def cast(data)

  @spec load(Ibento.Core.Data.Event.t()) :: any()
  def load(data)
end
