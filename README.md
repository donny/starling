# starling

Starling is a CLI app written in Elixir to search for new properties for sale from Domain.

### Background

This project is part of [52projects](https://donny.github.io/52projects/) and the new stuff that I learn through this project: [TableRex](https://github.com/djm/table_rex).

### Project

Building from the last two projects, [Quail](https://github.com/donny/quail) and [Raven](https://github.com/donny/raven), and to have better understanding of Elixir; Starling allows a user to search and display properties based on a specified suburb from the terminal. The search results are displayed in a table and the screenshot below shows the app in action:

![Screenshot](https://raw.githubusercontent.com/donny/starling/master/screenshot.png)

### Implementation

Starling shows the search results in a table using [TableRex](https://github.com/djm/table_rex) which is an Elixir app that generates text-based tables for display. The main code of the app can be seen below:

```elixir
def process({suburb, state, postcode}) do
  Starling.Domain.fetch(suburb, state, postcode)
  |> decode_response
  |> Enum.take(@default_count)
  |> process_results(headers())
  |> display_table(headers())
end
```

Starling fetches the results from Domain, decode it, take the first 10 listings (by default), process the results, and display them. Using the pipe operator makes the code easy to read and understand. The other relevant functions can be seen below:

```elixir
def headers do
  ["AdId", "DisplayableAddress", "DisplayPrice", "PropertyType", "Bedrooms", "Bathrooms", "Carspaces"]
end

def process_results(listings, headers) do
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
```

### Conclusion

As can be seen from the code above, it is just one call to `TableRex.quick_render!` to display the results. It's very easy to use TableRex to display tables in CLI apps. Starling allows me to improve my understanding of Elixir. It's a great language and I like even more. I can't wait to play with Phoenix or OTP next time.
