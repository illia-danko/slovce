defmodule Slivce.Game do
  @derive Jason.Encoder
  defstruct guesses: [], result: :playing, allowed_guesses: 6, over?: false

  @type char_info() :: %{char: String.t(), state: :correct | :incorrect | :invalid | :empty}
  @type guess() :: list(char_info())

  @type t() :: %__MODULE__{
          guesses: list(guess),
          result: :playing | :lost | :won,
          allowed_guesses: Integer.t(),
          over?: Boolean.t()
        }

  @spec new() :: t()
  def new() do
    %__MODULE__{}
  end
end
