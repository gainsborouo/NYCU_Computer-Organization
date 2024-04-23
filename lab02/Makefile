.PHONY: part1
part1:
	make clean
	verilator --build ./SingleCycleCPU.v --exe ./example_testbench.cpp -cc --trace -Wall
	./obj_dir/VSingleCycleCPU

.PHONY: clean
clean:
	rm -rf obj_dir
	rm -f waveform.vcd