defmodule Pento.Constants do
  @birth_years 1900..Date.utc_today.year
  @genders ["male", "female", "other", "prefer not to say"]
  @stars 1..5

  def birth_years(), do: @birth_years

  def genders(), do: @genders

  def stars(), do: @stars
end
