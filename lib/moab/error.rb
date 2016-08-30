module Moab
  # The root exception class that all Moab-specific exceptions inherit from
  class Error < StandardError; end

  # An exception raised when calling a Moab binary that exits with nonzero exit
  # status
  class CommandFailed < Error; end

  # An exception raised when calling a command that does not exist
  class InvalidCommand < Error; end
end
