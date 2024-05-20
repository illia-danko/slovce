defmodule Slivce.WordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Slivce.Words` context.
  """

  @doc """
  Generate a word.
  """
  def word_fixture(attrs \\ %{}) do
    {:ok, word} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Slivce.Words.create_word()

    word
  end
end
