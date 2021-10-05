defmodule AntFarmWeb.Origin do
  @spec check_origin(URI.t()) :: boolean
  def check_origin(%URI{} = origin),
    do: origin.authority in ["localhost:4000"]
end
