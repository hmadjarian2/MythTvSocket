class CommandResponseBuilder
	def self.build(connection)
		byte_count_length = 8

		byte_count = Integer(connection.recv(byte_count_length))

		bytes_received = 0
		bytes = ''

		while bytes_received < byte_count
			bytes += connection.recv(byte_count - bytes_received)
			bytes_received = bytes.length
		end

		puts bytes

		return bytes
	end
end
