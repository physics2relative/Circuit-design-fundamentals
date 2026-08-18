# Xcelium waveform setup for CDC behavioral simulations.
# The run script launches xrun from each test-specific work directory,
# so this creates sim/xrun_work/<tb_name>/waves.shm.
database -open waves -shm -default
probe -create -database waves -all -depth all
run
exit
