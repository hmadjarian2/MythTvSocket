require 'rubygems'
require 'parseconfig'
require 'socket'

require 'myth_tv_protocol'
require 'command_string_builder'
require 'command_response_builder'

@config = ParseConfig.new('./config.cnf')

def open_connection
  server = "#{@config.params['server']['name']}"
  port = "#{@config.params['server']['port']}"
  initial_protocol_version = "#{@config.params['server']['protocol_version']}"

  @connection = TCPSocket::new(server, port)

  puts 'Initial Version %s' % initial_protocol_version

  version_command = 'MYTH_PROTO_VERSION %s'
  @connection.write(CommandStringBuilder.build(version_command % initial_protocol_version))
  response = CommandResponseBuilder.build(@connection)

  actual_protocol_version = response[1]
  puts 'Actual Protocol %s' % actual_protocol_version

  if response[0] == MythTvProtocol::REJECT
    close_connection
    @connection = TCPSocket::new(server, port)
    @connection.write(CommandStringBuilder.build(version_command % actual_protocol_version))
    response = CommandResponseBuilder.build(@connection)
  end
end

def close_connection
  done_command = 'DONE'
  @connection.write(CommandStringBuilder.build(done_command))
  @connection.close
end

client_name = "#{@config.params['client']['name']}"

ann_command = 'ANN Playback %s 0'
free_recorder_count_command = 'GET_FREE_RECORDER_COUNT'

open_connection

@connection.write(CommandStringBuilder.build(ann_command % client_name))
response = CommandResponseBuilder.build(@connection)

if response[0] == MythTvProtocol::OK
  puts 'ANN Playback is ok'
end

@connection.write(CommandStringBuilder.build(free_recorder_count_command))
response = CommandResponseBuilder.build(@connection)

puts 'Free recorder count is %s' % response[0]

close_connection


