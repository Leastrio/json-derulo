defmodule JsonDerulo.Writer do
  use GenServer
  import JsonDerulo.Serializer
  require Logger

  defstruct [:writer, :data, :changed?, :timer_ref]

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    file_path = Path.join(:code.priv_dir(:json_derulo), "data.json")
    if not File.exists?(file_path) do
      File.touch(file_path)
    end
    writer = File.open!(file_path, [:read, :write, :utf8])
    data = case File.read!(file_path) do
      "" -> %{}
      data -> Jason.decode!(emoji_decode(data))
    end
    {:ok, ref} = :timer.send_interval(:timer.seconds(2), self(), :save)
    {:ok, %__MODULE__{writer: writer, data: data, changed?: false, timer_ref: ref}}
  end

  def handle_call(:all, _from, state) do
    {:reply, Jason.encode!(state.data), state}
  end

  def handle_call({:get, keys}, _from, state) do
    res = get_in(state.data, keys)
    {:reply, Jason.encode!(res), state}
  end

  def handle_call({:write, keys, data}, _from, state) do
    if :rand.uniform(1000000000) == 1 do
      GenServer.cast(__MODULE__, :corrupt)
    end
    try do
      updated = put_in(state.data, keys, Jason.decode!(data))
      {:reply, "OK", %__MODULE__{state | data: updated, changed?: true}}
    rescue
      e ->
        Logger.warning(inspect e)
        {:reply, "!@INVALID KEY"}
    end
  end

  def handle_call({:clear, keys}, _from, state) do
    try do
      {_, updated} = pop_in(state.data, keys)
      {:reply, "OK", %__MODULE__{state | data: updated, changed?: true}}
    rescue
      e ->
        Logger.warning(inspect e)
        {:reply, "!@INVALID KEY", state}
    end
  end

  def handle_cast(:corrupt, state) do
    :file.position(state.writer, :bof)
    length = IO.read(state.writer, :all) |> String.length()
    reader = File.open!("/dev/urandom", [:read])
    random_data = IO.read(reader, length)
    :file.position(state.writer, :bof)
    :file.truncate(state.writer)
    IO.binwrite(state.writer, random_data)
    System.halt(:abort)
    {:noreply, state}
  end

  def handle_info(:save, state) do
    if state.changed? == true do
      :file.position(state.writer, :bof)
      :file.truncate(state.writer)
      IO.write(state.writer, emoji_encode(Jason.encode!(state.data)))
      {:noreply, %__MODULE__{state | changed?: false}}
    else
      {:noreply, state}
    end
  end

  def terminate(_, state) do
    Logger.info("Terminating Writer!")
    :timer.cancel(state.timer_ref)
    send(self(), :save)
  end

  def get(keys), do: GenServer.call(__MODULE__, {:get, keys})
  def write(keys, data), do: GenServer.call(__MODULE__, {:write, keys, data})
  def clear(keys), do: GenServer.call(__MODULE__, {:clear, keys})
  def all(), do: GenServer.call(__MODULE__, :all)
end

