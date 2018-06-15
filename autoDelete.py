# 
# Auto delete checkpoint files.
# Only keep newest two checkpoints
# And checkpoints that are far away by at least $INTERVAL steps to each other
#
import os
import shutil
from os import listdir
from os.path import isfile, join

INTERVAL = 30000

def getNumber(fileName):
    return int(fileName.split('.')[1][5:])

path = os.path.join(os.path.expanduser('~'), 'yt8m', 'v2', 'models', 'frame', 'NetVLADModelLF')
files = [f for f in listdir(path) if isfile(join(path, f)) and 'model.ckpt-' in f]
numbers = list(set([getNumber(f) for f in files]))
numbers.sort(reverse=True)


maintain = [numbers[0], numbers[1]]

for num in numbers:
    if num <= maintain[-1] - INTERVAL:
            maintain.append(num)

for f in files:
    if getNumber(f) not in maintain:
            os.remove(join(path, f))


if os.path.exists(join(path, 'export')):
    shutil.rmtree(join(path, 'export'))

files = [f for f in listdir(path) if isfile(join(path, f))]
files.sort()
for f in files:
    print(f)