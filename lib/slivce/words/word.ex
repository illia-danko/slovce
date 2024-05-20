defmodule Slivce.Words.Word do
  use Ecto.Schema
  import Ecto.Changeset

  schema "words" do
    field(:title, :string)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(word, attrs) do
    word
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
