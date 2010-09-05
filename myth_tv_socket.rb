require 'socket'

def buildCommandString(command)
  return "%-8d%s" % [command.length, command]
end

server = '192.168.1.10'
port = 6543
initialVersion = 50
delimiter = '[]:[]'
reject = 'REJECT'
ok = 'OK'

versioncommand = '21      MYTH_PROTO_VERSION %s'
anncommand = '23      ANN Playback sycamore 0'
freerecordercountcommand = '23      GET_FREE_RECORDER_COUNT'

puts 'Initial Version %s' % initialVersion

connection = TCPSocket::new(server, port)

connection.write(versioncommand % initialVersion)
byteCount = Integer(connection.recv(8))

bytesReceived = 0
bytes = ''

while bytesReceived < byteCount
  bytes += connection.recv(byteCount - bytesReceived)
  bytesReceived = bytes.length
end

puts bytes

response = bytes.split(delimiter)

actualVersion = response[1]
puts 'Actual Protocol %s' % actualVersion

if response[0] == reject
  connection.close
  connection = TCPSocket::new(server, port)
  connection.write(versioncommand % actualVersion)
  byteCount = Integer(connection.recv(8))

  bytesReceived = 0
  bytes = ''

  while bytesReceived < byteCount
    bytes += connection.recv(byteCount - bytesReceived)
    bytesReceived = bytes.length
  end
end

puts bytes

connection.write(anncommand)
byteCount = Integer(connection.recv(8))

bytesReceived = 0
bytes = ''

while bytesReceived < byteCount
  bytes += connection.recv(byteCount - bytesReceived)
  bytesReceived = bytes.length
end

puts bytes

response = bytes.split(delimiter)

if response[0] == ok
  puts 'ANN Playback is ok'
end

connection.write(freerecordercountcommand)
byteCount = Integer(connection.recv(8))

bytesReceived = 0
bytes = ''

while bytesReceived < byteCount
  bytes += connection.recv(byteCount - bytesReceived)
  bytesReceived = bytes.length
end

puts bytes

response = bytes.split(delimiter)

puts 'Free recorder count is %s' % response[0]

connection.close
