defmodule Starling.Domain do
  @user_agent [ {"User-agent", "Starling"} ]
  @domain_url Application.get_env(:starling, :domain_url)

  def fetch(suburb, state, postcode) do
    search_url
    |> HTTPoison.get(@user_agent, params: search_params(suburb, state, postcode))
    |> handle_response
  end

  def search_url do
    "#{@domain_url}/searchservice.svc/search"
  end

  def search_params(suburb, state, postcode) do
    %{suburb: suburb, state: state, pcodes: postcode}
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_response({_, %{status_code: status, body: body}}) do
    {:error, Poison.Parser.parse!(body)}
  end
end
