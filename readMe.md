# 可电击复律心律自动判别算法

### 运行环境
windows x64
环境 [WFDB](https://archive.physionet.org/physiotools/matlab/wfdb-app-matlab/)， 
Matlab 2018a


### 文件结构

- SAA
    - 1.read_preprocessing  读取数据和预处理
    - 2.segment_solve       数据分段和计算特征
    - 3.train_test          训练和测试
    -    Auxiliary           
    辅助函数，特征计算函数，结果展示函数等。 
    -    data                
    运行得到的数据都存在这里



##### 典型运行流程                                                                    
reading.m --> segment_signal.m --> cal_feature.m --> trainClassifier.m

# 心肺复苏干扰的滤除

### 运行环境

python                 3.5
scipy                  1.4.1
jupyter                1.0.0
notebook               6.0.3
scikit-learn           0.23.1
(缺少什么[package]  用pip install [package] 安装即可)

主要文件CPR.ipynb

单个文件比较大，整个文件包含七个部分

* 第一部分是头文件

* 第二部分是我定义的许多数字信号处理会用到的一些函数，
    例如 巴特沃斯数字滤波器，重采样，信号标准化，一个简易的LMS自适应滤波器，白化，正弦波发生器等。

* 第三部分是比较综合一些数字信号处理的方法，部分是摘自别处，文件中都有参考的链接，可自行查看。
例如频谱分析，时频分析，EMD算法，求信号包络，求峰值等等。

* 第四部分主要是复现论文方法及自己的自适应滤波方法，具体见相关论文

* 第五部分是定义的读取文件函数和常用的小函数
例如显示信号show(x)

* 第六部分是使用信号处理方法分析信号特点，我得出一些结论在文件中有记录

* 第七部分是对滤波算法的测试


文件可复用比较高的是第二部分，第三部分，后面文件可能需要自己调整。



