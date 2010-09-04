require 'socket'

server = '192.168.1.10'
port = 6543
versioncommand = '21      MYTH_PROTO_VERSION 50'
anncommand = '23      ANN Playback sycamore 0'

connection = TCPSocket::new(server, port)
connection.write(versioncommand)
puts connection.recv(30)

connection.write(anncommand)
puts connection.recv(30)

connection.close
