import os
import time


while True:
    start = time.time()
    os.system('gcloud compute instances start instance-1')
    end = time.time()
    time.sleep(13)
    if end - start > 13:
        os.system('gcloud compute ssh chenbowen9612@instance-1 --command="source startup.txt"')
    time.sleep(600)
