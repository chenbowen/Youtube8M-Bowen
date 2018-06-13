import os
import time


while True:
    time.sleep(600)
    os.system('gcloud compute instances start instance-1 & gcloud compute ssh chenbowen9612@instance-1 --command="source startup.txt"')
#os.system('gcloud compute instances start instance-1 & gcloud compute ssh chenbowen9612@instance-1 --command="bash"')
#os.system('gcloud compute instances start instance-1 & gcloud compute ssh chenbowen9612@instance-1 --command="source startup.txt"')
