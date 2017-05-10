defmodule Starling.CLI do
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
    |> Enum.take(1)
    |> display_table
    # |> Enum.take(count)
    # |> print_table_for_columns(["number", "created_at", "title"])
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

  def display_table(listings) do
    # IO.puts(listings)
    Enum.each listings, fn listing ->
      listing
      |> Map.get("PropertyType")
      # |> IO.inspect
    end
    # Enum.sort list_of_issues,
    #   fn i1, i2 -> Map.get(i1, "created_at") <= Map.get(i2, "created_at") end
  end
end
