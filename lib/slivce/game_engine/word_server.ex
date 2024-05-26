defmodule Slivce.WordServer do
  use GenServer
  alias Slivce.Words

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def words_to_guess() do
    GenServer.call(__MODULE__, :get_words)
  end

  def valid_guess?(guess) do
    GenServer.call(__MODULE__, {:valid_guess?, guess})
  end

  ## Callbacks

  @impl true
  def init(:ok) do
    {:ok, scheduller_words_of_the_day()}
  end

  @impl true
  def handle_call(:get_words, _from, %{words: words} = state) do
    words =
      words
      |> get_words_of_the_day()
      |> normalize_words()

    {:reply, words, state}
  end

  @impl true
  def handle_call({:valid_guess?, guess}, _from, state) do
    guess = String.downcase(guess)
    valid? = guess in state.lookup
    {:reply, valid?, state}
  end

  @impl true
  def handle_info(:scheduller_words, %{words: words}) do
    current_words = get_words_of_the_day(words)
    {_, nil} = Words.update_timestamp(current_words)

    {:noreply, scheduller_words_of_the_day()}
  end

  defp get_words_of_the_day(words) do
    words
    |> Enum.take(get_words_of_the_day_number())
  end

  defp scheduller_words_of_the_day(duration \\ next_day_duration_ms()) do
    words = Words.list_words()
    lookup = MapSet.new(normalize_words(words))
    state = %{words: words, lookup: lookup}

    Process.send_after(self(), :scheduller_words, duration)
    state
  end

  defp next_day_duration_ms() do
    current_datetime = Timex.now(get_timzone())

    next_day = Timex.shift(current_datetime, days: 1)
    beginning_of_next_day = Timex.beginning_of_day(next_day)

    datatime_to_unix(beginning_of_next_day) - datatime_to_unix(current_datetime)
  end

  defp normalize_words(words), do: words |> Enum.map(fn word -> word.title end)
  defp datatime_to_unix(t), do: DateTime.to_unix(t, :millisecond)
  defp get_words_of_the_day_number(), do: Slivce.config([:game, :words_of_the_day_number])
  defp get_timzone(), do: Slivce.config([:system, :timezone])
end
