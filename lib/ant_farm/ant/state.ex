defmodule AntFarm.Ant.State do
  @type position :: {integer, integer}

  @type t :: %__MODULE__{
          id: integer,
          position: position
        }

  defstruct id: nil,
            position: {0, 0}
end
