require 'socket'

def build_command_string(command)
  return "%-8d%s" % [command.length, command]
end

server = '192.168.1.10'
port = 6543
initial_version = 50
delimiter = '[]:[]'
reject = 'REJECT'
ok = 'OK'

version_command = '21      MYTH_PROTO_VERSION %s'
ann_command = '23      ANN Playback sycamore 0'
free_recorder_count_command = '23      GET_FREE_RECORDER_COUNT'

puts 'Initial Version %s' % initial_version

connection = TCPSocket::new(server, port)

connection.write(version_command % initial_version)
byte_count = Integer(connection.recv(8))

bytes_received = 0
bytes = ''

while bytes_received < byte_count
  bytes += connection.recv(byte_count - bytes_received)
  bytes_received = bytes.length
end

puts bytes

response = bytes.split(delimiter)

actual_version = response[1]
puts 'Actual Protocol %s' % actual_version

if response[0] == reject
  connection.close
  connection = TCPSocket::new(server, port)
  connection.write(version_command % actual_version)
  byte_count = Integer(connection.recv(8))

  bytes_received = 0
  bytes = ''

  while bytes_received < byte_count
    bytes += connection.recv(byte_count - bytes_received)
    bytes_received = bytes.length
  end
end

puts bytes

connection.write(ann_command)
byte_count = Integer(connection.recv(8))

bytes_received = 0
bytes = ''

while bytes_received < byte_count
  bytes += connection.recv(byte_count - bytes_received)
  bytes_received = bytes.length
end

puts bytes

response = bytes.split(delimiter)

if response[0] == ok
  puts 'ANN Playback is ok'
end

connection.write(free_recorder_count_command)
byte_count = Integer(connection.recv(8))

bytes_received = 0
bytes = ''

while bytes_received < byte_count
  bytes += connection.recv(byte_count - bytes_received)
  bytes_received = bytes.length
end

puts bytes

response = bytes.split(delimiter)

puts 'Free recorder count is %s' % response[0]

connection.close
