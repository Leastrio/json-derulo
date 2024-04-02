defmodule JsonDerulo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {JsonDerulo.ConnectionListener, port: get_port(:tcp_port)},
      {DynamicSupervisor, name: JsonDerulo.DynamicSupervisor, strategy: :one_for_one},
      JsonDerulo.Writer,
      {JsonDerulo.Cluster, strategy: :gossip},
      {Plug.Cowboy, scheme: :http, plug: JsonDerulo.Plug, options: [port: get_port(:http_port)]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JsonDerulo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def get_port(type) do
    case Application.fetch_env(:json_derulo, type) do
      {:ok, port} -> port
      :error -> case System.fetch_env(String.upcase(Atom.to_string(type))) do
        {:ok, port} -> case Integer.parse(port) do
          {pport, _} -> pport
          :error -> raise "Invalid port set in the system env!"
        end
        :error -> case type do
          :tcp_port -> 8000
          :http_port -> 8080
        end
      end
    end
  end
end
