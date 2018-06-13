sudo apt-get update
sudo apt-get install openjdk-8-jdk git python-dev python3-dev python-numpy python3-numpy build-essential python-pip python3-pip python-virtualenv swig python-wheel libcurl3-dev curl -y  
curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo dpkg -i ./cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda-9-0 -y
sudo reboot



wget https://s3.amazonaws.com/open-source-william-falcon/cudnn-9.0-linux-x64-v7.1.tgz  
sudo tar -xzvf cudnn-9.0-linux-x64-v7.1.tgz  
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
export CUDA_HOME=/usr/local/cuda
source ~/.bashrc
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh   

source ~/.bashrc
conda create -n tensorflow -y
source activate tensorflow
pip install tensorflow-gpu
rm cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
rm Miniconda3-latest-Linux-x86_64.sh
rm cudnn-9.0-linux-x64-v7.1.tgz
mkdir -p ~/yt8m/code
cd ~/yt8m/code
git clone https://github.com/chenbowen/youtube-8m.git
pip install tensorflow-gpu


#git clone https://github.com/google/youtube-8m.git
#git clone https://github.com/antoine77340/Youtube-8M-WILLOW.git
#mv -f Youtube-8M-WILLOW/frame_level_models.py youtube-8m/frame_level_models.py
cd youtube-8m
conda install scipy -y
vi ~/.vimrc
iset number

#vi ~/startup.txt
#i#! /bin/bash
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
export CUDA_HOME=/usr/local/cuda
source ~/.bashrc
#source activate tensorflow
cd miniconda3/bin
source activate tensorflow
cd ~/yt8m/code/youtube-8m/
pip install tensorflow-gpu
conda install scipy -y
#chmod +x ~/startup.sh


python train.py --train_data_pattern="gs://youtube8m-ml-us-east1/2/frame/train/train*.tfrecord" --model=NetVLADModelLF --train_dir ~/yt8m/v2/models/frame/NetVLADModelLF1 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=80 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --max_step=300000 --export_model_steps=2000 --start_new_model



gcloud compute scp ~/yt8m/v2/code/youtube-8m/train.py instance-3:/home/chenbowen9612/yt8m/code/youtube-8m/
gcloud compute scp C:/Users/utbow/yt8m/v2/code/youtube-8m/startup.sh instance-3:/home/chenbowen9612
