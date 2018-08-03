
# coding:utf8


from keras.models import load_model ,model_from_json


import numpy as np


import imageio
import numpy
from skimage import transform
N=400


x2=numpy.zeros([N,32,32,3])
for i in range(N):
    

    j2=imageio.imread('train_noise/'+str(i+1)+'.jpg')
    j2=transform.resize(j2,(32,32))
    j2=numpy.array(j2)
    x2[i, :, :, :] = j2



print (x2.shape)


x_noisy = x2


x_noisy = np.clip(x_noisy, 0., 1.)


model = model_from_json(open('my_model_architectur3.json').read())    
model.load_weights('my_model_weight3.h5')   


model.summary()

decoded_imgs = model.predict(x_noisy)

for i in range(N):
    imageio.imwrite('ircnn_test_result/'+str(i+1)+'.jpg',decoded_imgs[i])


