#!/bin/bash

# 获取用户输入的ETH地址
read -p "请输入您的ETH地址: " eth_address

# 更新系统包
sudo apt update

# 安装所需的软件包
sudo apt install -y cmake python3-pip screen

# 克隆GitHub仓库
if [ ! -d "XENGPUMiner" ]; then
    git clone https://github.com/shanhaicoder/XENGPUMiner
else
    echo "XENGPUMiner已存在，跳过克隆步骤"
fi

# 进入目录
cd XENGPUMiner/

# 修改执行权限并编译
chmod +x build.sh
./build.sh -cuda_arch sm_70

# 安装Python依赖
pip3 install -U -r requirements.txt

# 使用screen在后台运行miner.py
screen -S miner -dm python3 miner.py --gpu=true --account=$eth_address

# 使用for循环运行xengpuminer三次并将每次的输出重定向到不同的日志文件
for i in {1..3}
do
    nohup ./xengpuminer -b 1024 &> output_$i.log &
done

echo "安装和编译完成，miner.py已在screen会话中开始运行！"
