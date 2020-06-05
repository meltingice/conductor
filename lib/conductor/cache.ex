defmodule Conductor.Cache do
  import Conductor.Redix, only: [command: 1]

  def fetch(key, func) do
    fetch(key, nil, func)
  end

  def fetch(key, expire, func) do
    case read(key) do
      # Key not stored
      {:ok, nil} ->
        store(key, expire, func.())

      # Key cached
      {:ok, data} ->
        case Jason.decode(data) do
          # Data wasn't encoded as JSON, return the raw value
          {:error, _} -> {:ok, data}
          # Data is JSON, return encoded value
          {:ok, decoded_data} -> {:ok, decoded_data}
        end

      # Fetch failed, silently continue
      {:error, _} ->
        func.()
    end
  end

  def read(key) do
    command(["GET", key])
  end

  def delete(key) do
    command(["DEL", key])
  end

  def write(key, data) when is_map(data) do
    command(["SET", key, Jason.encode!(data)])
  end

  def write(key, data) do
    command(["SET", key, data])
  end

  def write(key, data, expire) do
    command(["SET", key, data, "EX", expire])
  end

  defp store(key, expire, data) when is_nil(expire) do
    case data do
      {:ok, d} ->
        write(key, d)
        {:ok, d}

      _ ->
        data
    end
  end

  defp store(key, expire, data) do
    case data do
      {:ok, d} ->
        # We don't check the result of this because we don't care if it fails
        write(key, d, expire)
        {:ok, d}

      _ ->
        data
    end
  end
end
