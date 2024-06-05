defmodule Slivce.Utils.TimeTZ do
  def next_day_duration_ms() do
    current_datetime = Timex.now(get_timzone())

    next_day = Timex.shift(current_datetime, days: 1)
    beginning_of_next_day = Timex.beginning_of_day(next_day)

    datatime_to_unix(beginning_of_next_day) - datatime_to_unix(current_datetime)
  end

  def year_day_now(timezone \\ get_timzone()) do
    %{year: year, month: month, day: day} =
      timezone
      |> Timex.now()

    {data, ""} =
      [year, month, day]
      |> Enum.map_join(&String.pad_leading(to_string(&1), 2, "0"))
      |> Integer.parse()

    data
  end

  defp datatime_to_unix(t), do: DateTime.to_unix(t, :millisecond)
  defp get_timzone(), do: Slivce.config([:system, :timezone])
end
