from __future__ import division
import os, math, numpy as np

def plot(X,Y):
	#get terminal dimensions
	height, width = os.popen('stty size', 'r').read().split()
	width = int(width)
	height = int(height) - 1

	#get plotting constants
	maxX = max(X)
	maxY = max(Y)
	minX = min(X)
	minY = min(Y)
	dX = (maxX-minX) / (width - 1.)
	dY = (maxY-minY) / (height - 1.)

	#plot array
	data = np.zeros((height, width), dtype=np.int)

	#fill the array
	for x,y in zip(X,Y):
		i = int(math.floor( (x-minX)/dX ))
		j = int(math.ceil( (y-minY)/dY ))
		#print i,j
		data[-1*(j+1)][i]=1
	

	os.system('clear')
	for line in data:
		output = ""
		for entry in line:
			if entry:
				output += "X"
			else:
				output += " "
		print output
	
#boiler plate example plot
if __name__ == '__main__':
	x = np.arange(0.0, 5.0, 0.01)
	y = np.sin(2*np.pi*x)
	plot(x,y)
