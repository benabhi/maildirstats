defmodule Maildirstats.Maildir do
  defstruct account: nil,
            path: nil,
            owner: nil,
            size: 0,
            fdates: {0, 0, 0},
            quota: 0,
            date: Timex.now()
end
