class CommandStringBuilder
  def self.build(command_string)
    return "%-8d%s" % [command_string.length, command_string]
  end
end

