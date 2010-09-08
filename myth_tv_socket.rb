require 'socket'
require 'command_string_builder'
require 'command_response_builder'

server = '192.168.1.10'
port = 6543
initial_protocol_version = 50
client_name = 'baba_booey'
delimiter = '[]:[]'
reject = 'REJECT'
ok = 'OK'

version_command = 'MYTH_PROTO_VERSION %s'
ann_command = 'ANN Playback %s 0'
free_recorder_count_command = 'GET_FREE_RECORDER_COUNT'
done_command = 'DONE'

puts 'Initial Version %s' % initial_protocol_version

connection = TCPSocket::new(server, port)

connection.write(CommandStringBuilder.build(version_command % initial_protocol_version))
bytes = CommandResponseBuilder.build(connection)
response = bytes.split(delimiter)

actual_protocol_version = response[1]
puts 'Actual Protocol %s' % actual_protocol_version

if response[0] == reject
  connection.close
  connection = TCPSocket::new(server, port)
  connection.write(CommandStringBuilder.build(version_command % actual_protocol_version))
	bytes = CommandResponseBuilder.build(connection)
end

connection.write(CommandStringBuilder.build(ann_command % client_name))
bytes = CommandResponseBuilder.build(connection)
response = bytes.split(delimiter)

if response[0] == ok
  puts 'ANN Playback is ok'
end

connection.write(CommandStringBuilder.build(free_recorder_count_command))
bytes = CommandResponseBuilder.build(connection)
response = bytes.split(delimiter)

puts 'Free recorder count is %s' % response[0]

connection.write(CommandStringBuilder.build(done_command))

connection.close
