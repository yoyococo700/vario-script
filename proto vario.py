import math
import random
import time
import sys

MAXPOINTS = 12
MAXPOINTSA = 12
tab = [0]*MAXPOINTS
tabA = [0]*MAXPOINTSA
lastTime = 0
lastAlti = 0
index = 0
var1 = 0





def deriv(dt,i):
    global tab
    return (tab[i] - tab[i-2])/(2*dt/100)

def moyderiv(dt):
    s=0
    dt2 = dt/(MAXPOINTS-2)
    for i in range (2,MAXPOINTS):
        s+=deriv(dt2,i)
    return s/(MAXPOINTS-2)

def getAverage():
    s=0
    for i in range(MAXPOINTSA):
        s+=tabA[i]
    return s/MAXPOINTSA

def background(alt,f):
    Alti = alt
    #print(alt)
    global lastTime
    global lastAlti
    global tab
    global index
    global var1
    tim = time.time()
    dt = (tim+1 - lastTime)*100
    tabA[index%MAXPOINTSA]=Alti
    
    #print(tab,index)
    if index%MAXPOINTS == 0:
        lastTime = tim
        print(f*1000,alt,moyderiv(dt),dt,sep="\t")
    tab[index%MAXPOINTS] = getAverage()
    index+=1    
        
f = 0.0

original_stdout = sys.stdout # Save a reference to the original standard output

with open('out.dat', 'w') as fa:
    sys.stdout = fa # Change the standard output to the file we created.
    for i in range(10000):
        f+=0.001
        alt = 100*math.cos(f)
        
        alt+=(random.random()-0.5)*10
        if i%1==0:
            background(alt,f)
    
    sys.stdout = original_stdout



