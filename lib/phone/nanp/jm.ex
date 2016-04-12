defmodule Phone.NANP.JM do
  use Helper.Country
  field :regex, ~r/^(1)(876)([2-9].{6})/
  field :country, "Jamaica"
  field :a2, "JA"
  field :a3, "JAM"
  match :regex
end
