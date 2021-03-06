#################################################################################################
########################### NetVLAD1024 (FC, cg, MOE, cg, 1e-6) #################################
number 156144 | Avg_Hit@1: 0.898 | Avg_PERR: 0.815 | MAP: 0.520 | GAP: 0.872 | Avg_Loss: 3.514028
#################################################################################################
####################### NetVLAD1024 (FC, cg, MOE, cg, 1e-4) #####################################
number 244700 | Avg_Hit@1: 0.895 | Avg_PERR: 0.808 | MAP: 0.506 | GAP: 0.868 | Avg_Loss: 3.604132
#################################################################################################
######################## NetVLAD512 (FC, cg, MOE, cg, 1e-6) #####################################
number 211457 | Avg_Hit@1: 0.894 | Avg_PERR: 0.810 | MAP: 0.508 | GAP: 0.869 | Avg_Loss: 3.577316
#################################################################################################
##################### NetVLAD (1024FC, cg, 1024FC, cg, MOE, cg, 1e-6) ###########################
number 165020 | Avg_Hit@1: 0.898 | Avg_PERR: 0.812 | MAP: 0.512 | GAP: 0.870 | Avg_Loss: 3.565501
#################################################################################################
################# NetVLAD (1024FC, BN-RELU, 1024FC+FC, cg, MOE, cg, 1e-6) #######################
number 201757 | Avg_Hit@1: 0.896 | Avg_PERR: 0.811 | MAP: 0.514 | GAP: 0.870 | Avg_Loss: 3.595682
#################################################################################################
################# NetVLAD (512FC, BN-RELU, 512FC+FC, cg, MOE, cg, 1e-6) #########################
number 197090 | Avg_Hit@1: 0.895 | Avg_PERR: 0.808 | MAP: 0.510 | GAP: 0.867 | Avg_Loss: 3.620851
#################################################################################################
############## NetVLAD [BN-RELU*(512FC,1024FC,2048FC), cg, MOE, cg, 1e-6] #######################
number 169599 | Avg_Hit@1: 0.894 | Avg_PERR: 0.806 | MAP: 0.500 | GAP: 0.866 | Avg_Loss: 3.622756
#################################################################################################
############## NetVLAD [+1024 before vlad, 1024FC, cg, MOE, cg, 1e-6] ###########################
number 205980 | Avg_Hit@1: 0.897 | Avg_PERR: 0.812 | MAP: 0.513 | GAP: 0.871 | Avg_Loss: 3.572899
1024*256*512=128m
Conclusion:
- Residual Connection does not improve the performance. It slows down the training and gives same performance at last.
- Multiple FC layers after NetVLAD decrease the performance. FC layers before NetVLAD decrease a smaller margin. Reasons could be followings:
  1. Network is not deep.
  2. NetVLAD layer gives similar functionality as FC layers
- Bottleneck FC layers does not work well.

