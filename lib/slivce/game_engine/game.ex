defmodule Slivce.Game do
  @derive Jason.Encoder
  defstruct guesses: [],
            result: :playing,
            allowed_guesses: 6,
            current_word_index: nil,
            played_timestamp: nil,
            over?: false

  @type char_info() :: %{char: String.t(), state: :correct | :incorrect | :invalid | :empty}
  @type guess() :: list(char_info())

  @type t() :: %__MODULE__{
          guesses: list(guess),
          result: :playing | :lost | :won,
          allowed_guesses: Integer.t(),
          current_word_index: Integer.t(),
          over?: Boolean.t()
        }

  @spec new(Integer.t()) :: t()
  def new(current_word_index) do
    %__MODULE__{current_word_index: current_word_index}
  end
end
