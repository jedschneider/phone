defmodule Phone.ML do
  use Helper.Country
  field :regex, ~r/^(223)()(.{8})/
  field :country, "Mali"
  field :a2, "ML"
  field :a3, "MLI"
  match :regex
end
