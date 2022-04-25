import os
import time


count_to = 1
try:
    count_to = int(os.getenv("HOWHIGHTOCOUNT"))
except Exception as e:
    print(e)

if count_to is None:
    count_to = 30

for i in range(count_to):
    print(i)
    time.sleep(1)
