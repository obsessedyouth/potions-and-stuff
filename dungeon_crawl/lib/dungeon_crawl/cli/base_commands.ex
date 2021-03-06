defmodule DungeonCrawl.CLI.BaseCommands do
  @moduledoc """
  Reusable custom helper function module, abstracted
  repetitive functionality from rooms and hero_choice
  """
  use Monad.Operators

  alias Mix.Shell.IO, as: Shell
  import Monad.Result, only: [success: 1, success?: 1, error: 1, return: 1]
  # note - success and return are equivalent

  def display_options(options) do
    # pretty print list of values to shell
    options
    |> Enum.with_index(1)
    |> Enum.each(fn {option, index} ->
      Shell.info("#{index} - #{option}")
    end)

    return(options)
  end

  def generate_question(options) do
    # generate number of items and return a pprint list
    options = Enum.join(1..Enum.count(options), ",")
    "Which one? [#{options}]\n"
  end

  def parse_answer(answer) do
    # take input from Shell.prompt// IO.get
    # parse it, and return the index value
    case Integer.parse(answer) do
      :error -> error("Invalid option")
      {option, _} -> success(option - 1)
    end
  end

  def find_option_by_index(index, options) do
    case Enum.at(options, index) do
      nil -> error("Invalid option")
      chosen_option -> success(chosen_option)
    end
  end

  def ask_for_option(options) do
    result =
      return(options)
      ~>> (&display_options/1)
      ~>> (&generate_question/1)
      ~>> (&Shell.prompt/1)
      ~>> (&parse_answer/1)
      ~>> (&find_option_by_index(&1, options))

    if success?(result) do
      result.value
    else
      display_error(result.error)
      ask_for_option(options)
    end
  end

  def display_error(message) do
    Shell.cmd("cls")
    Shell.error(message)
    Shell.prompt("Press Enter to continue")
    Shell.cmd("cls")
  end
end
