defmodule Starling.CLI do
  @default_count 10

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean], aliases: [ h: :help])
    case parse do
      { [ help: true], _, _ }
        -> :help
      { _, [ suburb, state, postcode ], _ }
        -> { suburb, state, postcode }
      _
        -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: starling <suburb> <state> <postcode>
    """
    System.halt(0)
  end

  def process({suburb, state, postcode}) do
    Starling.Domain.fetch(suburb, state, postcode)
    |> decode_response
    |> Enum.take(@default_count)
    |> process(headers())
    |> display_table(headers())
  end

  def headers do
    ["AdId", "DisplayableAddress", "DisplayPrice", "PropertyType", "Bedrooms", "Bathrooms", "Carspaces"]
  end

  def decode_response({:ok, body}) do
    body
    |> Map.get("ListingResults")
    |> Map.get("Listings")
  end

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Domain: #{message}"
    System.halt(2)
  end

  def process(listings, headers) do
    Enum.map listings, fn listing ->
      for header <- headers do
        listing[header]
      end
    end
  end

  def display_table(listings, headers) do
    TableRex.quick_render!(listings, headers)
    |> IO.puts
  end
end
