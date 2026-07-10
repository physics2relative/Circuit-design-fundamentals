# Xcelium waveform setup for STA behavioral simulations.
database -open waves -shm -default
probe -create -database waves -all -depth all
run
exit
