# https://gist.github.com/rockneurotiko/c30c43b4a3485034037663e83094fb6e
defmodule ConductorWeb.StrongParams do
  def extract(params, allowed_fields, atomize \\ false)

  def extract(params, allowed_fields, atomize) when not is_list(allowed_fields),
    do: extract(params, [allowed_fields], atomize)

  def extract(params, allowed_fields, atomize)
      when is_map(params) and is_list(allowed_fields) do
    Enum.reduce(allowed_fields, %{}, fn field, acc ->
      case extract_field(field, params, atomize) do
        nil -> acc
        data -> deep_merge(acc, data)
      end
    end)
  end

  defp extract_field([], data, _), do: data

  defp extract_field([field | fields], params, atomize) do
    with true <- Map.has_key?(params, field),
         data when not is_nil(data) <- extract_field(fields, params[field], atomize) do
      field_name = maybe_atomize(atomize, field)
      %{field_name => data}
    else
      _ -> nil
    end
  end

  defp extract_field(field, params, atomize) do
    case Map.has_key?(params, field) do
      true ->
        field_name = maybe_atomize(atomize, field)
        %{field_name => params[field]}

      _ ->
        nil
    end
  end

  defp maybe_atomize(false, result), do: result
  defp maybe_atomize(true, result) when is_binary(result), do: String.to_existing_atom(result)
  defp maybe_atomize(:force, result) when is_binary(result), do: String.to_atom(result)
  defp maybe_atomize(_, result), do: result

  defp deep_merge(original, override), do: resolve(nil, original, override)

  defp resolve(_key, original, override) when is_map(original) and is_map(override) do
    Map.merge(original, override, &resolve/3)
  end

  defp resolve(_key, _original, override), do: override
end
