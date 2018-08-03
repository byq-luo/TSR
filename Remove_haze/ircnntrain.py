#!/usr/bin/env python
# coding:utf-8

#import tensorflow
from keras.models import Model

from keras.layers import Input, Conv2D
from keras.layers.normalization import BatchNormalization
import numpy as np

import imageio
import numpy
from skimage import transform
#import matplotlib.pyplot as plt
N=1220
x=numpy.zeros([N,32,32,3])
x2=numpy.zeros([N,32,32,3])
for i in range(N):
    #print(i)
    j=imageio.imread('ircnn_train/'+str(i+1)+'.jpg')
    j=transform.resize(j,(32,32), mode='constant')
    j=numpy.array(j)
    x[i, :, :, :] = j
    j2=imageio.imread('ircnn_train2/'+str(i+1)+'.jpg')
    j2=transform.resize(j2,(32,32), mode='constant')
    j2=numpy.array(j2)
    x2[i, :, :, :] = j2

x_train=x
x_test =x
print (x_train.shape)

x_train = x_train.astype('float32')
x_test = x_test.astype('float32')

x_train = np.reshape(x_train, (len(x_train), 32, 32, 3))
x_test = np.reshape(x_test, (len(x_test), 32, 32, 3))

noise_factor = 0.1
x_train_noisy = x2
x_test_noisy = x2

x_train_noisy = np.clip(x_train_noisy, 0., 1.)
x_test_noisy = np.clip(x_test_noisy, 0., 1.)


input_img = Input(shape=(32, 32, 3))  

x = Conv2D(64, (3, 3), activation='relu', padding='same')(input_img)

#x = Conv2D(64, (2, 2), activation='relu', padding='same')(x)
x = Conv2D(64, (3, 3), activation='relu', padding='same',dilation_rate=(2, 2))(x)
x = BatchNormalization()(x)
x = Conv2D(64, (3, 3), activation='relu', padding='same',dilation_rate=(3, 3))(x)
x = BatchNormalization()(x)


x = Conv2D(64, (3, 3), activation='relu', padding='same',dilation_rate=(4, 4))(x)
x = BatchNormalization()(x)
x = Conv2D(64, (3, 3), activation='relu', padding='same',dilation_rate=(3, 3))(x)
x = BatchNormalization()(x)
x = Conv2D(64, (3, 3), activation='relu', padding='same',dilation_rate=(2, 2))(x)
x = BatchNormalization()(x)
#x = UpSampling2D((2, 2))(x)
#x = Conv2D(64, (1, 1), activation='relu',padding='same')(x)
#x = UpSampling2D((2, 2))(x)
decoded = Conv2D(3, (3, 3), activation='sigmoid', padding='same')(x)

autoencoder = Model(input_img, decoded)

autoencoder.summary()


autoencoder.compile(optimizer='adadelta', loss='mean_squared_error')



autoencoder.fit(x_train_noisy, x_train,
                epochs=200,
                batch_size=64,
                shuffle=True,
                validation_data=(x_test_noisy, x_test))


json_string = autoencoder.to_json()   
open('my_model_architectur3.json','w').write(json_string)    
autoencoder.save_weights('my_model_weight3.h5')    


