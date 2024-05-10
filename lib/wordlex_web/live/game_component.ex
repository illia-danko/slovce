defmodule WordlexWeb.GameComponent do
  use WordlexWeb, :component

  def header(assigns) do
    ~H"""
    <div class="px-2 sm:px-4 border-b border-gray-300">
      <div class="flex items-center justify-between overflow-hidden max-w-xl mx-auto">
        <h1 class="py-2 text-center text-xl text-gray-800 font-semibold uppercase tracking-widest dark:text-white md:text-3xl">
          Слівце
        </h1>

        <div class="mt-2">
          <button type="button" phx-click={show_help_modal()}>
            <span class="sr-only">Show help</span>
            <svg
              class="w-6 h-6 md:w-8 md:h-8 dark:text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
              >
              </path>
            </svg>
          </button>
          <button type="button" phx-click={show_info_modal()}>
            <span class="sr-only">Show stats</span>
            <svg
              class="w-6 h-6 md:w-8 md:h-8 dark:text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
              >
              </path>
            </svg>
          </button>
          <button type="button" phx-click={show_settings_modal()}>
            <span class="sr-only">Show settings</span>
            <svg
              class="w-6 h-6 md:w-8 md:h-8 dark:text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
              >
              </path>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z">
              </path>
            </svg>
          </button>
        </div>
      </div>
    </div>
    """
  end

  def alert(assigns) do
    ~H"""
    <div class="rounded bg-gray-800 p-4 dark:bg-gray-50">
      <div class="flex items-center justify-center">
        <p class="text-white text-xl dark:text-gray-800"><%= @message %></p>
      </div>
    </div>
    """
  end

  def grid(assigns) do
    offsset =
      if assigns.game_over? do
        0
      else
        1
      end

    count = max(6 - length(assigns.past_guesses) - offsset, 0)
    empty_tiles = List.duplicate(%{char: "", state: :empty}, 5) |> List.duplicate(count)

    ~H"""
    <div class="grid grid-rows-6 gap-1">
      <%= if @revealing? do %>
        <.tile_rows guesses={Enum.slice(@past_guesses, 0..-2//1)} />
        <.tile_rows guesses={[List.last(@past_guesses)]} animate_class="animate-flip" />
      <% else %>
        <.tile_rows guesses={@past_guesses} />
      <% end %>

      <%= if not @game_over? do %>
        <div id="keyboard-input" phx-hook="KeyboardInput">
          <.tile_row animate_class={if(@valid_guess?, do: "", else: "animate-shake")}>
            <%= for index <- 0..4 do %>
              <.input_guess_tile index={index} />
            <% end %>
          </.tile_row>
        </div>
      <% end %>

      <.tile_rows guesses={empty_tiles} />
    </div>
    """
  end

  defp tile_rows(assigns) do
    ~H"""
    <%= for guess <- @guesses do %>
      <.tile_row animate_class={"#{assigns[:animate_class] || ""}"}>
        <%= for %{char: char, state: state} <- guess do %>
          <.guess_tile char={char} state={state} />
        <% end %>
      </.tile_row>
    <% end %>
    """
  end

  defp tile_row(assigns) do
    ~H"""
    <div class={"flex grid grid-cols-5 gap-1 #{@animate_class}"}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def tile(assigns) do
    ~H"""
    <div id={@id} class={"w-14 h-14 flex justify-center items-center #{@extra_classes} sm:w-16 sm:h-16"}>
      <div class="text-3xl uppercase font-bold"><%= @char %></div>
    </div>
    """
  end

  def guess_tile(assigns) do
    extra_classes =
      case assigns.state do
        :empty ->
          empty_tile_classes()

        :correct ->
          "text-white bg-green-500"

        :incorrect ->
          "text-white bg-yellow-500"

        :invalid ->
          "text-white bg-gray-500"
      end

    ~H"""
    <.tile char={@char} id={nil} extra_classes={extra_classes} />
    """
  end

  def input_guess_tile(assigns) do
    ~H"""
    <.tile char="" id={"input-tile-#{@index}"} extra_classes={empty_tile_classes()} />
    """
  end

  def keyboard(assigns) do
    lines = [
      ~w(Й Ц У К Е Н Г Ґ Ш Щ З Х Ї),
      ~w(Ф І В А П Р О Л Д Ж Є '),
      ~w(Enter Я Ч С М И Т Ь Б Ю Backspace)
    ]

    ~H"""
    <div class="flex flex-col items-center gap-1">
      <%= for line <- lines do %>
        <div class="flex items-center gap-1">
          <%= for key <- line do %>
            <.key letter_map={@letter_map} key={key} />
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  defp empty_tile_classes do
    "bg-white text-gray-800 border-2 border-gray-300 dark:bg-gray-800 dark:border-gray-500 dark:text-white"
  end

  defp key(%{letter_map: letter_map, key: key} = assigns) do
    classes =
      cond do
        Enum.member?(letter_map.correct, key) -> "bg-green-500 hover:bg-green-400"
        Enum.member?(letter_map.incorrect, key) -> "bg-yellow-500 hover:bg-yellow-400"
        Enum.member?(letter_map.invalid, key) -> "bg-gray-400 hover:bg-gray-300"
        true -> "bg-gray-300 hover:bg-gray-200"
      end

    body =
      case key do
        "Backspace" ->
          ~H"""
          <svg fill="none" class="h-6 w-6" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M12 9.75 14.25 12m0 0 2.25 2.25M14.25 12l2.25-2.25M14.25 12 12 14.25m-2.58 4.92-6.374-6.375a1.125 1.125 0 0 1 0-1.59L9.42 4.83c.21-.211.497-.33.795-.33H19.5a2.25 2.25 0 0 1 2.25 2.25v10.5a2.25 2.25 0 0 1-2.25 2.25h-9.284c-.298 0-.585-.119-.795-.33Z"
            />
          </svg>
          """

        _ ->
          ~H"""
          <%= @key %>
          """
      end

    size_classes =
      case key do
        "Backspace" -> "h-10 w-10 sm:w-14 sm:h-14"
        "Enter" -> "h-10 w-16 sm:h-14 sm:w-24"
        _ -> "h-10 w-6 sm:w-10 sm:h-14"
      end

    ~H"""
    <button
      phx-click={JS.dispatch("keyboard:clicked", to: "#keyboard-input", detail: %{key: @key})}
      class={
        "#{size_classes} #{classes} p-2 rounded text-gray-700 text-md flex font-bold justify-center items-center uppercase focus:ring-2"
      }
    >
      <%= body %>
    </button>
    """
  end

  def show_info_modal(), do: show_modal("info-modal")
  def show_settings_modal(), do: show_modal("settings-modal")
  def show_help_modal(), do: show_modal("help-modal")

  def show_modal(id) do
    JS.show(%JS{},
      transition: {"ease-out duration-300", "opacity-0", "opacity-100"},
      to: "##{id}"
    )
  end

  def hide_modal(id) do
    JS.hide(%JS{},
      transition: {"ease-in duration-200", "opacity-100", "opacity-0"},
      to: "##{id}"
    )
  end

  def modal(assigns) do
    class =
      if Map.get(assigns, :open?, false) do
        "fixed z-10 inset-0 overflow-y-auto"
      else
        "fixed z-10 inset-0 overflow-y-auto hidden"
      end

    ~H"""
    <div id={@modal_id} class={class} aria-labelledby="modal-title" role="dialog" aria-modal="true">
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
        <!-- This element is to trick the browser into centering the modal contents. -->
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
        <div class="mb-24 w-full inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:p-6 dark:bg-gray-800">
          <div class="absolute top-0 right-0 pt-4 pr-4">
            <button
              type="button"
              phx-click={hide_modal(@modal_id)}
              class="bg-white rounded-md text-gray-600 hover:text-gray-800 dark:bg-gray-800 dark:text-white dark:hover:text-gray-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              <span class="sr-only">Close</span>
              <!-- Heroicon name: outline/x -->
              <svg
                class="h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                aria-hidden="true"
              >
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <div class="mt-8"><%= render_slot(@inner_block) %></div>
        </div>
      </div>
    </div>
    """
  end

  def help_modal(assigns) do
    ~H"""
    <.modal modal_id="help-modal">
      <div class="text-sm text-gray-800 dark:text-white">
        <h2 class="text-xl font-bold text-center">Як грати</h2>
        <h1 class="text-lg font-medium mt-6">Відгадати Слівце з 6 спроб.</h1>
        <ul class="list-disc list-inside mt-2 leading-loose">
          <li>Кожна спроба повинна буди справжнім словом з <strong>5</strong> літер.</li>
          <li>Колір клітинки змінюється і відображає як близько ви до розв'язання слова.</li>
        </ul>
        <div class="mt-6">
          <p1 class="text-lg font-medium">Приклади:</p1>
        </div>

        <% extra_classes = [
          "text-gray-100 bg-green-500",
          "border-2 border-gray-500",
          "border-2 border-gray-500",
          "border-2 border-gray-500",
          "border-2 border-gray-500"
        ] %>
        <.help_modal_example word="осінь" extra_classes={extra_classes}>
          <strong>О</strong> в цьому Cлівці та знаходиться на правильній позиції.
        </.help_modal_example>

        <% extra_classes = [
          "border-2 border-gray-500",
          "text-gray-100 bg-yellow-500",
          "border-2 border-gray-500",
          "border-2 border-gray-500",
          "border-2 border-gray-500"
        ] %>
        <.help_modal_example word="дужий" extra_classes={extra_classes}>
          <strong>У</strong> є в цьому Cлівці, але знаходиться на іншій позиції.
        </.help_modal_example>

        <% extra_classes = [
          "border-2 border-gray-500",
          "border-2 border-gray-500",
          "border-2 border-gray-500",
          "text-gray-100 bg-gray-500",
          "border-2 border-gray-500"
        ] %>
        <.help_modal_example word="бігти" extra_classes={extra_classes}>
          <strong>Т</strong> немає в цьому Cлівці ні на якій позиції.
        </.help_modal_example>

        <div class="mt-6">
          <p1>Кожен день з'являється <strong>3</strong> нових слова.</p1>
        </div>
      </div>
    </.modal>
    """
  end

  def help_modal_example(assigns) do
    examples =
      assigns.word
      |> String.upcase()
      |> String.graphemes()
      |> Enum.zip(assigns.extra_classes)

    ~H"""
    <div class="mt-2 flex gap-1 items-center font-bold">
      <%= for {char, extra_classes} <- examples  do %>
        <div class={"w-6 h-6 flex items-center justify-center #{extra_classes}"}>
          <div><%= char %></div>
        </div>
      <% end %>
    </div>
    <div class="mt-2">
      <p1><%= render_slot(@inner_block) %></p1>
    </div>
    """
  end

  def info_modal(assigns) do
    won_count =
      Enum.reduce(assigns.stats.guess_distribution, 0, fn {_, value}, acc -> acc + value end)

    played = won_count + assigns.stats.lost
    show_guess_dist? = played > 0
    win_percent = floor(won_count / max(played, 1) * 100)

    ~H"""
    <.modal modal_id="info-modal" open?={@open?}>
      <div class="flex flex-col items-center space-y-4">
        <h2 class="text-gray-800 text-lg font-semibold uppercase dark:text-white">Статистика</h2>
        <div class="flex items-start space-x-4 md:space-x-6">
          <.stat value={played} label_first="Зіграно" label_second="" />
          <.stat value={win_percent} label_first="Виграно" label_second="%" />
          <.stat value="Н/Д" label_first="Поточна" label_second="Смуга" />
          <.stat value="Н/Д" label_first="Найбільша" label_second="Смуга" />
        </div>
        <h2 class="mt-2 text-gray-800 text-lg font-semibold uppercase dark:text-white">Розподіл припущень</h2>
        <%= if show_guess_dist? do %>
          <.guess_distribution stats={@stats} />
        <% else %>
          <pre class="text-gray-700 text-sm dark:text-white">Відсутні Дані</pre>
        <% end %>
        <%= if @show_countdown? do %>
          <h2 class="mt-2 text-gray-800 text-lg font-semibold uppercase dark:text-white">Настпупне слово за</h2>
          <.countdown />
        <% end %>
      </div>
    </.modal>
    """
  end

  def settings_modal(assigns) do
    ~H"""
    <.modal modal_id="settings-modal">
      <div class="space-y-4">
        <div class="pb-4 flex justify-between border-b border-gray-200 dark:border-gray-400">
          <p class="text-md text-gray-800 font-semibold dark:text-white">Застосувати Темну Тему</p>
          <button
            phx-click="toggle_theme"
            type="button"
            class={
              "#{if(@checked?, do: "bg-green-600", else: "bg-gray-200")} relative inline-flex flex-shrink-0 h-6 w-11 border-2 border-transparent rounded-full cursor-pointer transition-colors ease-in-out duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            }
            role="switch"
            aria-checked="false"
          >
            <span class="sr-only">Toggle theme</span>
            <span
              aria-hidden="true"
              class={
                "#{if(@checked?, do: "translate-x-5", else: "translate-x-0")} pointer-events-none inline-block h-5 w-5 rounded-full bg-white shadow transform ring-0 transition ease-in-out duration-200"
              }
            >
            </span>
          </button>
        </div>
      </div>
    </.modal>
    """
  end

  def stat(assigns) do
    ~H"""
    <div class="flex flex-col items-center space-y-2">
      <div class="text-gray-800 text-3xl font-semibold dark:text-white"><%= @value %></div>
      <div class="flex flex-col items-center">
        <pre class="text-gray-700 text-xs dark:text-gray-200"><%= @label_first %></pre>
        <pre class="text-gray-700 text-xs dark:text-gray-200"><%= @label_second %></pre>
      </div>
    </div>
    """
  end

  def guess_distribution(assigns) do
    ~H"""
    <div class="space-y-1">
      <%= for {key, value} <- @stats.guess_distribution do %>
        <div class="flex flex-row items-center justify-start space-x-2 font-mono">
          <div class="text-sm text-gray-700 dark:text-white"><%= key %></div>
          <div class={
            "#{stat_bg_class(@stats, key)} font-semibold text-white text-medium text-right #{dist_bar_width(value)}"
          }>
            <div class="ml-1 mr-1"><%= value %></div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def countdown(assigns) do
    ~H"""
    <div id="countdown" phx-hook="Countdown" class="h-8 font-mono dark:text-white"></div>
    """
  end

  defp stat_bg_class(%{guessed_at_attempt: guessed_at_attempt}, key) do
    if guessed_at_attempt != nil and Integer.to_string(guessed_at_attempt) == key do
      "bg-green-600"
    else
      "bg-gray-500"
    end
  end

  defp dist_bar_width(0), do: "w-[1rem]"
  defp dist_bar_width(1), do: "w-[1rem]"
  defp dist_bar_width(2), do: "w-[2rem]"
  defp dist_bar_width(3), do: "w-[3rem]"
  defp dist_bar_width(4), do: "w-[4rem]"
  defp dist_bar_width(5), do: "w-[5rem]"
  defp dist_bar_width(6), do: "w-[6rem]"
  defp dist_bar_width(7), do: "w-[7rem]"
  defp dist_bar_width(8), do: "w-[8rem]"
  defp dist_bar_width(9), do: "w-[9rem]"
  defp dist_bar_width(10), do: "w-[10rem]"
  defp dist_bar_width(11), do: "w-[11rem]"
  defp dist_bar_width(12), do: "w-[12rem]"
  defp dist_bar_width(13), do: "w-[13rem]"
  defp dist_bar_width(14), do: "w-[14rem]"
  defp dist_bar_width(15), do: "w-[15rem]"
  defp dist_bar_width(_key), do: "w-full"
end
