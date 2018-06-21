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
conda install scipy -y
pip install tensorflow-gpu
cd youtube-8m

vi ~/.vimrc
iset number

#vi ~/startup.txt
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
export CUDA_HOME=/usr/local/cuda
source ~/.bashrc
cd ~/miniconda3/bin
source activate tensorflow
cd ~/yt8m/code/youtube-8m/


python train.py --train_data_pattern="gs://youtube8m-ml-us-east1/2/frame/train/train*.tfrecord,gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --model=NetVLADModelLF --train_dir ~/yt8m/v2/models/frame/NetVLADModelLF --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=80 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=512 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --max_steps=300000 --export_model_steps=4000 --start_new_model

#python train.py --train_data_pattern="gs://youtube8m-ml-us-east1/2/frame/train/train*.tfrecord,gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --model=NetVLADModelLF --train_dir ~/yt8m/v2/models/frame/gatedlightvladLF-256k-1024-80-0002-300iter-norelu-basic-gatedmoe --frame_features=True --feature_names="rgb,audio" --feature_sizes="1024,128" --batch_size=80 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --lightvlad=True --pruning_hparams=name=NetVLADModelLF_pruning,begin_pruning_step=10000,end_pruning_step=100000,target_sparsity=0.9,sparsity_function_begin_step=10000,sparsity_function_end_step=100000 --max_step=300000 --export_model_steps=4000


python eval.py --eval_data_pattern="gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --train_dir ~/yt8m/v2/models/frame/NetVLADModelLF --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=128 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=512 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --run_once=True

#python eval.py --eval_data_pattern="gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --train_dir ~/yt8m/v2/models/frame/gatedlightvladLF-256k-1024-80-0002-300iter-norelu-basic-gatedmoe --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=128 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --lightvlad=True --run_once=True --output_model_tgz=my_model.tgz


python inference.py --train_dir ~/yt8m/v2/models/frame/NetVLADModelLF --output_file=NetVLADModelLF.csv --input_data_pattern="gs://youtube8m-ml-us-east1/2/frame/test/test*.tfrecord" --batch_size=1024 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --run_once=True --top_k=50 --output_model_tgz=my_model.tgz


gcloud compute scp ~/yt8m/v2/code/youtube-8m/train.py instance-3:/home/chenbowen9612/yt8m/code/youtube-8m/
gcloud compute scp C:/Users/utbow/yt8m/v2/code/youtube-8m/startup.sh instance-3:/home/chenbowen9612


