defmodule Ibento.GraphQL.Supervisor do
  @behaviour :supervisor

  # See http://erlang.org/doc/man/supervisor.html
  # for more information on OTP Supervisors
  def start_link() do
    :supervisor.start_link({:local, __MODULE__}, __MODULE__, [])
  end

  @impl :supervisor
  def init([]) do
    children = []

    Supervisor.init(children, strategy: :one_for_one, name: __MODULE__)
  end
end
