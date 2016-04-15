defmodule Rumbl.Counter do
  @moduledoc """
  """

  use GenServer

  # Public API
  def inc(pid) do
    GenServer.cast(pid, :inc)
  end

  def dec(pid) do
    GenServer.cast(pid, :dec)
  end

  def val(pid) do
    GenServer.call(pid, :val)
  end

  # OTP implementation
  def start_link(initial_val) do
    GenServer.start_link(__MODULE__, initial_val)
  end

  def init(initial_val) do
    Process.send_after(self, :tick, 100)
    {:ok, initial_val}
  end

  def handle_info(:tick, state) when state < 0 do
    raise "boom!"
  end
  def handle_info(:tick, state) do
    Process.send_after(self, :tick, 100)
    IO.puts "tick #{state}"
    {:noreply, state - 1}
  end

  def handle_cast(:inc, state) do
    {:noreply, state + 1}
  end

  def handle_cast(:dec, state) do
    {:noreply, state - 1}
  end

  def handle_call(:val, _from, state) do
    {:reply, state, state}
  end
end
