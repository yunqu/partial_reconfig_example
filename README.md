# Partial Reconfiguration Example

This is a demo with partial reconfiguration with the PYNQ framework. 
The PYNQ image version has to be v2.4 and above.
This is to be compatible with the 2018.3 or later Xilinx tools.

The demo will show different LED patterns on Pynq-Z1 / ZCU104 board.
To run the demo, copy the notebooks folder onto the board. For example,
on Pynq-Z1

```
git clone https://github.com/yunqu/partial_reconfig_example.git
cp -rf partial_reconfig_example/boards/Pynq-Z1/gpio_pr/notebooks/partial_reconfig /home/xilinx/jupyter_notebooks
```

Then you can try the demo notebook.
