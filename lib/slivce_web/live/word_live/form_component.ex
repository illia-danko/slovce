defmodule SlivceWeb.WordLive.FormComponent do
  use SlivceWeb, :live_component

  alias Slivce.Words

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage word records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="word-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Word</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{word: word} = assigns, socket) do
    changeset = Words.change_word(word)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"word" => word_params}, socket) do
    changeset =
      socket.assigns.word
      |> Words.change_word(word_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"word" => word_params}, socket) do
    save_word(socket, socket.assigns.action, word_params)
  end

  defp save_word(socket, :edit, word_params) do
    case Words.update_word(socket.assigns.word, word_params) do
      {:ok, word} ->
        notify_parent({:saved, word})

        {:noreply,
         socket
         |> put_flash(:info, "Word updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_word(socket, :new, word_params) do
    case Words.create_word(word_params) do
      {:ok, word} ->
        notify_parent({:saved, word})

        {:noreply,
         socket
         |> put_flash(:info, "Word created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
