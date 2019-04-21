############################################################################################
############################## Ubuntu Setup Command Line ###################################
############################################################################################


sudo apt-get update
sudo apt-get install vim csh flex gfortran libgfortran3 g++ \
                     cmake xorg-dev patch zlib1g-dev libbz2-dev \
                     libboost-all-dev openssh-server libcairo2 \
                     libcairo2-dev libeigen3-dev lsb-core \
                     lsb-base net-tools network-manager \
                     git-core git-gui git-doc xclip gdebi-core\
                     build-essential dkms \
                     freeglut3 freeglut3-dev libxi-dev libxmu-dev \
                     python3-pip -y

https://www.nvidia.in/Download/index.aspx?lang=en-in

wget http://in.download.nvidia.com/XFree86/Linux-x86_64/418.56/NVIDIA-Linux-x86_64-418.56.run
wget http://in.download.nvidia.com/tesla/410.104/NVIDIA-Linux-x86_64-410.104.run
wget http://in.download.nvidia.com/XFree86/Linux-x86_64/418.56/NVIDIA-Linux-x86_64-418.56.run

chmod +x NVIDIA-Linux-x86_64-418.56.run
sudo ./NVIDIA-Linux-x86_64-418.56.run


wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux
chmod +x cuda_10.0.130_410.48_linux
sudo ./cuda_10.0.130_410.48_linux
gedit ~/.profile
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
source ~/.bashrc

sudo reboot

https://developer.nvidia.com/rdp/cudnn-download
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.5.0.56/prod/10.0_20190219/cudnn-10.0-linux-x64-v7.5.0.56.tgz 
cd Download
sudo tar -xzvf cudnn-10.0-linux-x64-v7.5.0.56.tgz 
sudo cp -P ./cuda/lib64/* /usr/local/cuda/lib64/
sudo cp  ./cuda/include/* /usr/local/cuda/include
sudo chmod a+r /usr/local/cuda/include/cudnn.h
gedit ~/.profile
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
export CUDA_HOME=/usr/local/cuda
source ~/.bashrc

sudo pip3 install virtualenv 
virtualenv -p python3.6 pytorch
source pytorch/bin/activate
pip3 install https://download.pytorch.org/whl/cu100/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl
pip3 install torchvision

git clone https://github.com/daniilidis-group/neural_renderer.git
cd neural_renderer
pip3 install .
# wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# bash Miniconda3-latest-Linux-x86_64.sh   
# source ~/.bashrc
# conda create -n tensorflow -y
# source activate tensorflow
# pip install tensorflow-gpu
rm cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
rm Miniconda3-latest-Linux-x86_64.sh
rm cudnn-9.0-linux-x64-v7.1.tgz
mkdir -p ~/yt8m/code
cd ~/yt8m/code
git clone https://github.com/chenbowen/youtube-8m.git
conda install scipy -y
pip install tensorflow-gpu
cd youtube-8m

vi ~/.vimrc
iset number


# cd ~/miniconda3/bin
# source activate tensorflow
# cd ~/yt8m/code/youtube-8m/




############################################################################################
############################## Training Command Line #######################################
############################################################################################




python train.py --train_data_pattern="gs://youtube8m-ml-us-east1/2/frame/train/train*.tfrecord,gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --model=NetVLADModelLF --train_dir ~/yt8m/v2/models/frame/NetVLAD1024 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=80 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --max_steps=500000 --export_model_steps=4000


# --start_new_model


#python train.py --train_data_pattern="gs://youtube8m-ml-us-east1/2/frame/train/train*.tfrecord,gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --model=NetVLADModelLF --train_dir ~/yt8m/v2/models/frame/gatedlightvladLF-256k-1024-80-0002-300iter-norelu-basic-gatedmoe --frame_features=True --feature_names="rgb,audio" --feature_sizes="1024,128" --batch_size=80 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --lightvlad=True --pruning_hparams=name=NetVLADModelLF_pruning,begin_pruning_step=10000,end_pruning_step=100000,target_sparsity=0.9,sparsity_function_begin_step=10000,sparsity_function_end_step=100000 --max_step=300000 --export_model_steps=4000




############################################################################################
################################# Eval Command Line ########################################
############################################################################################




python eval.py --eval_data_pattern="gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --train_dir ~/yt8m/v2/models/frame/NetVLAD1024 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=128 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --run_once=True

#python eval.py --eval_data_pattern="gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --train_dir ~/yt8m/v2/models/frame/gatedlightvladLF-256k-1024-80-0002-300iter-norelu-basic-gatedmoe --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=128 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --lightvlad=True --run_once=True --output_model_tgz=my_model.tgz




############################################################################################
############################### Inference Command Line #####################################
############################################################################################



python inference.py --train_dir ~/yt8m/v2/models/frame/NetVLADModelLF --output_file=NetVLADModelLF.csv --input_data_pattern="gs://youtube8m-ml-us-east1/2/frame/test/test*.tfrecord" --batch_size=1024 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --run_once=True --top_k=50 --output_model_tgz=my_model.tgz


gcloud compute scp ~/yt8m/v2/code/youtube-8m/train.py instance-3:/home/chenbowen9612/yt8m/code/youtube-8m/
gcloud compute scp C:/Users/utbow/yt8m/v2/code/youtube-8m/startup.sh instance-3:/home/chenbowen9612


