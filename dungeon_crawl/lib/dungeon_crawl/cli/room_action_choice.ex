defmodule DungeonCrawl.CLI.RoomActionsChoice do
  @moduledoc """
  Room logic controller processes room actions, by borrowing helpers
  from base_commands returns the room and the action chosen
  """
  alias Mix.Shell.IO, as: Shell
  import Dungeon.Crawl.CLI.BaseCommands

  def start(room) do
    # A single random room map
    # list of action functions
    room_actions = room.actions
    find_action_by_index = &Enum.at(room_actions, &1)

    Shell.info(room.description())

    chosen_action =
      room_actions
      |> display_options
      |> generate_question
      |> Shell.prompt()
      |> parse_answer
      |> find_action_by_index.()

    {room, chosen_action}
  end
end
