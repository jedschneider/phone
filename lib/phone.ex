defmodule Phone do
  @moduledoc ~S"""
  Phone is a real telephone number parser, that will help you get useful information from numbers.


  ## How to use

  Very simple to use:
      iex> Phone.parse("555112345678")
      {:ok, %{a2: "BR", a3: "BRA", country: "Brazil", international_code: "55", area_code: "51", number: "12345678"}}
  """

  import Phone.Helper.Parser

  @doc """
  Parses a string or integer and returns a map with information about that number.

  ```
    iex> Phone.parse("555112345678")
    {:ok, %{a2: "BR", a3: "BRA", country: "Brazil", international_code: "55", area_code: "51", number: "12345678"}}

    iex> Phone.parse("+55(51)1234-5678")
    {:ok, %{a2: "BR", a3: "BRA", country: "Brazil", international_code: "55", area_code: "51", number: "12345678"}}

    iex> Phone.parse("55 51 1234-5678")
    {:ok, %{a2: "BR", a3: "BRA", country: "Brazil", international_code: "55", area_code: "51", number: "12345678"}}

    iex> Phone.parse(555112345678)
    {:ok, %{a2: "BR", a3: "BRA", country: "Brazil", international_code: "55", area_code: "51", number: "12345678"}}

  ```
  """
  @spec parse(String.t) :: {:ok, Map.t}
  def parse(number) when is_bitstring(number) do
    number = clear(number)
    number = try do
      number |> String.to_integer |> Integer.to_string
    rescue
      _ -> ""
    end
    Phone.Countries.build(number)
  end

  @spec parse(pos_integer) :: {:ok, Map.t}
  def parse(number) when is_integer(number) do
    number = Integer.to_string(number)
    parse(number)
  end

  def parse(_) do
    {:error, "Not a valid parameter, only string or integer."}
  end

  defp clear(number) when is_bitstring(number) do
    remove = String.graphemes("+()- ")

    number
    |> String.graphemes
    |> Enum.filter(fn(n)-> ! Enum.any?(remove,fn(r)-> r == n end) end)
    |> Enum.join("")
  end

  @doc """
  Same as `parse(number)` but the number doesn't have the international code, instead you specify country as an atom with two-letters code.

  For NANP countries you can use the atom `:nanp` or two-letter codes for any country in NANP.

  For United Kingdom is possible to use the more known acronym `:uk` or the official two-letter code `:gb`.

  ```
  iex> Phone.parse(:br, "5112345678")
  {:ok, %{a2: "BR", a3: "BRA", country: "Brazil", international_code: "55", area_code: "51", number: "12345678"}}

  iex> Phone.parse(:br, "(51)1234-5678")
  {:ok, %{a2: "BR", a3: "BRA", country: "Brazil", international_code: "55", area_code: "51", number: "12345678"}}

  iex> Phone.parse(:br, "51 1234-5678")
  {:ok, %{a2: "BR", a3: "BRA", country: "Brazil", international_code: "55", area_code: "51", number: "12345678"}}

  iex> Phone.parse(:br, 5112345678)
  {:ok, %{a2: "BR", a3: "BRA", country: "Brazil", international_code: "55", area_code: "51", number: "12345678"}}

  ```
  """
  @spec parse(Atom.t, String.t) :: {:ok, Map.t}
  @spec parse(Atom.t, pos_integer) :: {:ok, Map.t}
  country_parser
end
