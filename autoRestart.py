import os
import time


while True:
    start = time.time()
    os.system('gcloud compute instances start instance-1 > startResult.txt')
    end = time.time()
    if end - start > 13:
        os.system('gcloud compute ssh chenbowen9612@instance-1 --command="source startup.txt > trainLog.txt')
    time.sleep(600)
#os.system('gcloud compute instances start instance-1 & gcloud compute ssh chenbowen9612@instance-1 --command="bash"')
#os.system('gcloud compute instances start instance-1 & gcloud compute ssh chenbowen9612@instance-1 --command="source startup.txt"')
