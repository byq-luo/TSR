# TSR
Identification of traffic signs in haze weather based on deep learning




环境：   Keras 2.0.6      MATLAB R2014a



交通标志加霾去霾部分：    文件夹 Remove_haze 中

给交通标志随机加入不同程度的雾霾噪声：   g_noise_image.m
双边滤波器去除雾霾：    run_Bilateral_filters.m
IRCNN去除雾霾：    python ircnntrain.py
                  python ircnntest.py



交通标志识别部分：

数据：
      train数据：无雾霾干净交通标志图像
      val数据：
               data2：双边滤波器去除雾霾后的图像
               data3：IRCNN去除雾霾后的图像
               
               
多通道分类识别算法训练验证data2：  python mc_data2.py
tensorboard可视化： tensorboard --logdir mc_data2_logs/

多通道分类识别算法训练验证data3：  python mc_data3.py
tensorboard可视化： tensorboard --logdir mc_data3_logs/

训练存储模型：mc_weights2.hdf5
结果显示：     文件夹 train_test_result 中

