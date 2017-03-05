note
	description: "An example usage of neural_network."
	date: "2016-07-03"
	revision: "16w26"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		do
			make_xor
		end

	make_test
		local
			l_neural_network: NEURAL_NETWORK
		do
			create l_neural_network.make(create {ARRAYED_LIST[INTEGER]}.make_from_array(<<2, 2, 2>>))
			set_layer_bias(l_neural_network, 1, 0)
			set_neuron_input_weight(l_neural_network, 2, 1, 1, 0.15)
			set_neuron_input_weight(l_neural_network, 2, 1, 2, 0.20)
			set_neuron_input_weight(l_neural_network, 2, 2, 1, 0.25)
			set_neuron_input_weight(l_neural_network, 2, 2, 2, 0.30)
			set_layer_bias(l_neural_network, 2, 0.35)
			set_neuron_input_weight(l_neural_network, 3, 1, 1, 0.40)
			set_neuron_input_weight(l_neural_network, 3, 1, 2, 0.45)
			set_neuron_input_weight(l_neural_network, 3, 2, 1, 0.50)
			set_neuron_input_weight(l_neural_network, 3, 2, 2, 0.55)
			set_layer_bias(l_neural_network, 3, 0.60)
			l_neural_network.learn_back_propagate(double_list_from_array(<<0.05, 0.10>>), double_list_from_array(<<0.01, 0.99>>))
		end

	make_xor
			-- Run application.
		local
			l_neural_network, l_neural_network2: NEURAL_NETWORK
			l_training_list: LIST[TUPLE[input1, input2, output: REAL_64]]
			l_input, l_output: LIST[REAL_64]
			l_path: PATH
		do
			create {ARRAYED_LIST[TUPLE[input1, input2, output: REAL_64]]} l_training_list.make(4)
			create {ARRAYED_LIST[REAL_64]} l_input.make_filled(2)
			create {ARRAYED_LIST[REAL_64]} l_output.make_filled(1)
			create l_neural_network.make(list_from_array(<<2, 5, 1>>))
			print("The XOR network has been created.%N")
			l_training_list.extend([0.0, 0.0, 0.0])
			l_training_list.extend([0.0, 1.0, 1.0])
			l_training_list.extend([1.0, 0.0, 1.0])
			l_training_list.extend([1.0, 1.0, 0.0])
			print("The XOR network is learning...%N")
			across 1 |..| 10000 as la_nothing loop
				across l_training_list as la_train loop
					l_input[1] := la_train.item.input1
					l_input[2] := la_train.item.input2
					l_output[1] := la_train.item.output
					l_neural_network.learn_back_propagate(l_input, l_output)
				end
			end
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
			create l_path.make_from_string("test.bin")
			l_neural_network.export_to_path(l_path)
			create l_neural_network2.make_from_file_path(l_path)
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
				l_output := l_neural_network2.use_network(l_input)
				io.put_double(l_output.first)
				io.put_new_line
			end
		end

feature -- Access

	list_from_array(a_array: ARRAY[INTEGER]): LIST[INTEGER]
		do
			create {ARRAYED_LIST[INTEGER]} Result.make_from_array(a_array)
		end

	double_list_from_array(a_array: ARRAY[REAL_64]): LIST[REAL_64]
		do
			create {ARRAYED_LIST[REAL_64]} Result.make_from_array(a_array)
		end

	set_neuron_input_weight(a_network: NEURAL_NETWORK; a_layer_numb, a_neuron_numb, a_input_numb: INTEGER; a_weight: REAL_64)
		do
			if attached {INPUT_CONNECTION} a_network.layers.at(a_layer_numb).at(a_neuron_numb).inputs.at(a_input_numb) as la_input then
				la_input.set_weight(a_weight)
			end
		end

	set_layer_bias(a_network: NEURAL_NETWORK; a_layer_numb: INTEGER; a_bias: REAL_64)
		do
			across a_network.layers.at(a_layer_numb) as la_neurons loop
				la_neurons.item.set_bias(a_bias)
			end
		end

end
