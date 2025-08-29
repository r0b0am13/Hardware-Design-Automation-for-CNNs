
from zynet import zynet
from zynet import utils
import numpy as np
filename = "weightsandbiaseszynet.txt"
def genMnistZynet(dataWidth,sigmoidSize,weightIntSize,inputIntSize,filename):
    model = zynet.model()
    model.add(zynet.layer("flatten",169))
    model.add(zynet.layer("Dense",64,"relu"))
    model.add(zynet.layer("Dense",32,"relu"))
    model.add(zynet.layer("Dense",10,"relu"))
    model.add(zynet.layer("Dense",10,"hardmax"))
    weightArray = utils.genWeightArray(filename)
    biasArray = utils.genBiasArray(filename)
    model.compile(pretrained='Yes',weights=weightArray,biases=biasArray,dataWidth=dataWidth,weightIntSize=weightIntSize,inputIntSize=inputIntSize,sigmoidSize=sigmoidSize)
    
if __name__ == "__main__":
    genMnistZynet(dataWidth=16,sigmoidSize=10,weightIntSize=2,inputIntSize=2,filename=filename)