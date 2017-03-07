note
	description: "An example usage of the neural network library."
	date: "2017-03-06 21:45:37"
	revision: "17w10"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_neural_network: NEURAL_NETWORK
			l_training_list: LIST[TUPLE[input1, input2, output: REAL_64]]
			l_input, l_output: LIST[REAL_64]
			l_path: PATH
			l_raw_file: RAW_FILE
		do
			-- Initializing
			create {ARRAYED_LIST[TUPLE[input1, input2, output: REAL_64]]} l_training_list.make(4)
			create {ARRAYED_LIST[REAL_64]} l_input.make_filled(2)
			create {ARRAYED_LIST[REAL_64]} l_output.make_filled(1)
			create l_neural_network.make(list_from_array(<<2, 5, 1>>))
			print("The XOR network has been created.%N")
			l_training_list.extend([0.0, 0.0, 0.0])
			l_training_list.extend([0.0, 1.0, 1.0])
			l_training_list.extend([1.0, 0.0, 1.0])
			l_training_list.extend([1.0, 1.0, 0.0])
			-- Learning the XOR 10 000 times
			print("The XOR network is learning...%N")
			across 1 |..| 10000 as la_nothing loop
				across l_training_list as la_train loop
					l_input[1] := la_train.item.input1
					l_input[2] := la_train.item.input2
					l_output[1] := la_train.item.output
					l_neural_network.learn_back_propagate(l_input, l_output)
				end
			end
			-- Printing it's output
			print("The network's behavior%N")
			print("X1%TX2%TY%TPredicted%N")
			across l_training_list as la_train loop
				l_input[1] := la_train.item.input1
				l_input[2] := la_train.item.input2
				io.put_double(l_input[1])
				print("%T")
				io.put_double(l_input[2])
				print("%T")
				io.put_double(la_train.item.output)
				print("%T")
				l_output := l_neural_network.use_network(l_input)
				io.put_double(l_output.first)
				io.put_new_line
			end
			-- Creating a copy in a file and verifying the copied's output
			create l_raw_file.make_open_write("test.bin")
			l_raw_file.independent_store(l_neural_network)
			l_raw_file.close
			create l_raw_file.make_open_read("test.bin")
			if attached {NEURAL_NETWORK} l_raw_file.retrieved as la_neural_network then
				print("The copied network's behavior%N")
				print("X1%TX2%TY%TPredicted%N")
				across l_training_list as la_train loop
					l_input[1] := la_train.item.input1
					l_input[2] := la_train.item.input2
					io.put_double(l_input[1])
					print("%T")
					io.put_double(l_input[2])
					print("%T")
					io.put_double(la_train.item.output)
					print("%T")
					l_output := la_neural_network.use_network(l_input)
					io.put_double(l_output.first)
					io.put_new_line
				end
			end
		end

feature -- Access

	list_from_array(a_array: ARRAY[INTEGER]): LIST[INTEGER]
			-- Converts an {ARRAY} to a {LIST}
		do
			create {ARRAYED_LIST[INTEGER]} Result.make_from_array(a_array)
		end

end
