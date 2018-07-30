defmodule FacebookMessenger.Attachments do
  @moduledoc false
  @derive [Poison.Encoder]
  defstruct [:mid, :seq, :attachments]

  @type t :: %FacebookMessenger.Attachments{
    mid: String.t,
    seq: integer,
    attachments: Map.t,

   }
end