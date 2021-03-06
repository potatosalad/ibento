defmodule Ibento.GraphQL.Application do
  @behaviour :application

  # See http://erlang.org/doc/apps/kernel/application.html
  # for more information on OTP Applications
  @impl :application
  def start(_type, _args) do
    Ibento.GraphQL.Supervisor.start_link()
  end

  @impl :application
  def stop(_state) do
    :ok
  end
end
