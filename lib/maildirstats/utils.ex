defmodule Maildirstats.Utils do

  def interval(from, until), do: Timex.Interval.new(from: from, until: until)

end
