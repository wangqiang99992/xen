#!/bin/bash

# Get the user's input for the ETH address
read -p "Please enter your ETH address: " eth_address

# Update system packages
sudo apt update

# Install required software packages
sudo apt install -y cmake python3-pip screen

# Clone the GitHub repository
if [ ! -d "XENGPUMiner" ]; then
    git clone https://github.com/shanhaicoder/XENGPUMiner
else
    echo "XENGPUMiner already exists, skipping the clone step."
fi

# Navigate into the directory
cd XENGPUMiner/

# Change permissions and compile
chmod +x build.sh
./build.sh -cuda_arch sm_70

# Install Python dependencies
pip3 install -U -r requirements.txt

# Run miner.py in the background using screen
screen -S miner -dm python3 miner.py --gpu=true --account=$eth_address

# Use a for loop to run xengpuminer three times and redirect each output to a different log file
for i in {1..3}
do
    nohup ./xengpuminer -b 1024 &> output_$i.log &
done

echo "Installation and compilation completed, miner.py is now running in a screen session!"
