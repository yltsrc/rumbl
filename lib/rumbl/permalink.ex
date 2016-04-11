defmodule Rumbl.Permalink do
  @moduledoc """
  """

  @behaviour Ecto.Type

  def type do
    :uuid
  end

  def cast(<<_::64, ?-, _::32, ?-, _::32, ?-, _::32, ?-, _::96>> = binary) when is_binary(binary) do
    {:ok, binary}
  end
  def cast(<<a::64, ?-, b::32, ?-, c::32, ?-, d::32, ?-, e::96, _rest::binary>> = binary) when is_binary(binary) do
    {:ok, <<a::64, ?-, b::32, ?-, c::32, ?-, d::32, ?-, e::96>>}
  end
  def cast(_) do
    :error
  end

  def dump(binary) do
    Ecto.UUID.dump(binary)
  end

  def load(binary) do
    Ecto.UUID.load(binary)
  end

  def generate do
    Ecto.UUID.bingenerate()
    |> Ecto.UUID.encode()
  end

  def autogenerate do
    %Ecto.Query.Tagged{type: :uuid, value: Ecto.UUID.bingenerate()}
  end
end
