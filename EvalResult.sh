#################################################################################################
############## NetVLAD1024 (FC, no BN-RELU, cg, MOE, no cg, 1e-6) ###############################
#################################################################################################
number 179940 | Avg_Hit@1: 0.896 | Avg_PERR: 0.810 | MAP: 0.515 | GAP: 0.867 | Avg_Loss: 3.637377
number 213580 | Avg_Hit@1: 0.897 | Avg_PERR: 0.810 | MAP: 0.517 | GAP: 0.868 | Avg_Loss: 3.622439
number 233580 | Avg_Hit@1: 0.896 | Avg_PERR: 0.811 | MAP: 0.518 | GAP: 0.868 | Avg_Loss: 3.639893
number 258780 | Avg_Hit@1: 0.895 | Avg_PERR: 0.810 | MAP: 0.521 | GAP: 0.868 | Avg_Loss: 3.632878
number 268496 | Avg_Hit@1: 0.897 | Avg_PERR: 0.810 | MAP: 0.520 | GAP: 0.868 | Avg_Loss: 3.641347
#################################################################################################
################ NetVLAD1024 (FC, no BN-RELU, cg, MOE, cg, 1e-6) ################################
######################################## p100-2 #################################################
#################################################################################################
number 115021 | Avg_Hit@1: 0.897 | Avg_PERR: 0.812 | MAP: 0.513 | GAP: 0.868 | Avg_Loss: 3.588730
number 145930 | Avg_Hit@1: 0.897 | Avg_PERR: 0.812 | MAP: 0.517 | GAP: 0.870 | Avg_Loss: 3.557790
number 156144 | Avg_Hit@1: 0.898 | Avg_PERR: 0.815 | MAP: 0.520 | GAP: 0.872 | Avg_Loss: 3.514028
number 173705 | Avg_Hit@1: 0.898 | Avg_PERR: 0.814 | MAP: 0.519 | GAP: 0.872 | Avg_Loss: 3.549561
number 184150 | Avg_Hit@1: 0.898 | Avg_PERR: 0.812 | MAP: 0.519 | GAP: 0.872 | Avg_Loss: 3.548343
number 199160 | Avg_Hit@1: 0.897 | Avg_PERR: 0.813 | MAP: 0.519 | GAP: 0.871 | Avg_Loss: 3.574056
#################################################################################################
################ NetVLAD1024 (FC, no BN-RELU, cg, MOE, cg, 1e-4) ################################
######################################## p100-2 #################################################
#################################################################################################
python train.py --train_data_pattern="gs://youtube8m-ml-us-east1/2/frame/train/train*.tfrecord,gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --model=NetVLADModelLF --train_dir ~/yt8m/v2/models/frame/NetVLAD1024cgcge-4 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=80 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-4 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --max_steps=500000 --export_model_steps=5000
python eval.py --eval_data_pattern="gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --train_dir ~/yt8m/v2/models/frame/NetVLAD1024cgcge-4 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=128 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-4 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --run_once=True

#################################################################################################
############### NetVLAD1024 (FC, no BN-RELU, cg, MOE, cg, 1e-6) #################################
######################################## p100-2 #################################################
#################################################################################################
number 103500 | Avg_Hit@1: 0.895 | Avg_PERR: 0.808 | MAP: 0.506 | GAP: 0.867 | Avg_Loss: 3.620727
number 115510 | Avg_Hit@1: 0.894 | Avg_PERR: 0.808 | MAP: 0.506 | GAP: 0.867 | Avg_Loss: 3.614347
number 162309 | Avg_Hit@1: 0.897 | Avg_PERR: 0.814 | MAP: 0.518 | GAP: 0.871 | Avg_Loss: 3.542892
number 172546 | Avg_Hit@1: 0.898 | Avg_PERR: 0.814 | MAP: 0.521 | GAP: 0.872 | Avg_Loss: 3.518483                         
number 217145 | Avg_Hit@1: 0.897 | Avg_PERR: 0.814 | MAP: 0.519 | GAP: 0.871 | Avg_Loss: 3.584567
number 228270 | Avg_Hit@1: 0.898 | Avg_PERR: 0.813 | MAP: 0.518 | GAP: 0.871 | Avg_Loss: 3.585022
#################################################################################################
#################### NetVLAD512 (FC, no BN-RELU, cg, MOE, cg, 1e-6) #############################
######################################## instance-3 #############################################
#################################################################################################
number 116430 | Avg_Hit@1: 0.893 | Avg_PERR: 0.805 | MAP: 0.498 | GAP: 0.864 | Avg_Loss: 3.649766
number 164010 | Avg_Hit@1: 0.895 | Avg_PERR: 0.809 | MAP: 0.507 | GAP: 0.867 | Avg_Loss: 3.601083
number 178836 | Avg_Hit@1: 0.896 | Avg_PERR: 0.810 | MAP: 0.507 | GAP: 0.869 | Avg_Loss: 3.579602
number 199584 | Avg_Hit@1: 0.895 | Avg_PERR: 0.810 | MAP: 0.509 | GAP: 0.868 | Avg_Loss: 3.593650
number 211457 | Avg_Hit@1: 0.894 | Avg_PERR: 0.810 | MAP: 0.508 | GAP: 0.869 | Avg_Loss: 3.577316
number 232191 | Avg_Hit@1: 0.896 | Avg_PERR: 0.810 | MAP: 0.507 | GAP: 0.869 | Avg_Loss: 3.592527
#################################################################################################
####### NetVLAD (1024FC, no BN-RELU, cg, 1024FC, no BN-RELU, cg, MOE, cg, 1e-6) #################
######################################## instance-3 #############################################
#################################################################################################
python train.py --train_data_pattern="gs://youtube8m-ml-us-east1/2/frame/train/train*.tfrecord,gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --model=NetVLADModelLF --train_dir ~/yt8m/v2/models/frame/NetVLAD10241024 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=80 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --max_steps=500000 --export_model_steps=5000
python eval.py --eval_data_pattern="gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --train_dir ~/yt8m/v2/models/frame/NetVLAD1024rcg3 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=128 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --run_once=True