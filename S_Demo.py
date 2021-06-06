# This is a sample Python script for vehicle detection and vehicle classification.

import pandas as pd
import numpy as np
import cv2
from sklearn.ensemble import RandomForestClassifier
import joblib
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties #字体管理器
from mpl_toolkits.mplot3d import Axes3D

def my_dilate(X,l):
# 一维膨胀函数
# 输入：X=行向量  l=结构体长度
    half_l=int(np.floor(l/2))
    s=X.shape[1]
    #X_filt=X 址传递
    X_filt=np.zeros((1,s))
    for i in range(half_l):
        X_filt[0,i]=np.max(X[0,0:i + half_l + 1])
    for i in range(half_l,s-half_l):
        X_filt[0,i]=np.max(X[0,i-half_l:i+half_l+1])
    for i in range(s-half_l,s):
        X_filt[0,i]=np.max(X[0,i-half_l:s])
    return X_filt

def my_erode(X,l):
#一维腐蚀函数
#输入：X=行向量  l=结构体长度
    half_l=int(np.floor(l/2))
    s=X.shape[1]#
    X_filt=np.zeros((1,s))
    for i in range(half_l):
        X_filt[0,i]=np.min(X[0,0:i + half_l + 1])
    for i in range(half_l,s-half_l):
        X_filt[0,i]=np.min(X[0,i-half_l:i+half_l+1])
    for i in range(s-half_l,s):
        X_filt[0,i]=np.min(X[0,i-half_l:s])
    return X_filt

def medianfilt(X,l):
# 中值滤波
# 输入：X=行向量  l=结构体长度
    half_l=int(np.floor(l/2))
    s=X.size
    #X_filt=X 址传递
    X_filt=np.zeros((s))
    for i in range(half_l):
        X_filt[i]=np.median(X[0:i + half_l + 1])
    for i in range(half_l,s-half_l):
        X_filt[i]=np.median(X[i-half_l:i+half_l+1])
    for i in range(s-half_l,s):
        X_filt[i]=np.median(X[i-half_l:s])
    return X_filt

def medfilt(X,l):
#均值滤波
#输入：X=行向量  l=结构体长度
    half_l=int(np.floor(l/2))
    s=X.size#
    X_filt=np.zeros((s))
    for i in range(half_l):
        X_filt[i]=np.mean(X[0:i + half_l + 1])
    for i in range(half_l,s-half_l):
        X_filt[i]=np.mean(X[i-half_l:i+half_l+1])
    for i in range(s-half_l,s):
        X_filt[i]=np.mean(X[i-half_l:s])
    return X_filt

def vehicle_detection(original_data,l_g,w_thre):
    r_n=original_data.shape[0]
    r_mean=np.zeros((1,r_n))
    S=np.zeros((1,r_n))
    baseline=106
    for i in range(r_n):
        r_mean[0,i] = np.mean(original_data[i,1:])#% 均值
        thre = baseline * w_thre# 动态阈值
        if r_mean[0,i] > thre:
            S[0,i] = 1
        else:
            baseline = 0.8 * baseline + 0.2 * r_mean[0,i]# 更新基准线
    S_filt=my_dilate(my_erode(my_erode(my_dilate(S,l_g),l_g),l_g),l_g)#闭开运算
    S_filter_diff=np.append(S_filt,0)-np.insert(S_filt,0,0)#差分
    # figure;plot(500*S);hold on;plot(500*S_filt+600);hold on;plot(r_mean);
    # figure;plot(S_filter_diff);ylim([-2,2]);
    #统计起止时间
    numb=(np.where(S_filter_diff==-1))[0].size#车辆样本个数
    se_pairs=np.zeros([2,numb],dtype='int32')
    j=-1
    for i in range(r_n+1):
        if S_filter_diff[i]==1:
            t_start=i
            tag=1
        if S_filter_diff[i]==-1 and tag==1:
            t_end=i-1
            tag=0
            j=j+1
            se_pairs[...,j]=[t_start,t_end]#
    return se_pairs

def get_crests(signal):
#计算波峰
#输入：a Envelope data 1 * 827
# 输出：波峰 1 * 6 （按振幅大小排序）
    temp = medfilt(medianfilt(signal, 26), 13)#中值均值滤波
    temp_s= temp.size
    candidates = np.zeros((100, 2))#候选点
    z = 0
    for j in range(10,temp_s - 10):
        if any((temp[j] - temp[j - 1] > 0, temp[j] - temp[j - 2] > 0, temp[j] - temp[j - 3] > 0, temp[j] - temp[j - 4] > 0,\
            temp[j] - temp[j - 5] > 0, temp[j] - temp[j - 6] > 0, temp[j] - temp[j - 7] > 0, temp[j] - temp[j - 8] > 0,\
            temp[j] - temp[j - 9] > 0, temp[j] - temp[j - 10] > 0))\
             and any((temp[j] - temp[j +1] > 0, temp[j] - temp[j +2] > 0, temp[j] - temp[j + 3] > 0, temp[j] - temp[j + 4] > 0,\
                 temp[j] - temp[j + 5] > 0, temp[j] - temp[j + 6] > 0, temp[j] - temp[j + 7] > 0, temp[j] - temp[j + 8] > 0,\
                 temp[j] - temp[j + 9] > 0, temp[j] - temp[j + 10] > 0)):
            candidates[z, 0] = j#候选点下标
            candidates[z, 1] = temp[j]#候选点振幅
            z = z + 1
    crests = np.zeros((10, 2))#波峰
    reg_index = 0#当前区域序号
    reg_length = 1#当前区域长度
    for k in range(1,100):
        if candidates[k, 1] == 0:
            break
        if reg_index > 10:
            break
        if candidates[k, 0] == candidates[k - 1, 0] + 1 or candidates[k, 0] == candidates[k - 1, 0] + 2:
            reg_length = reg_length + 1
            crests[reg_index, 0] = candidates[int(k - np.floor(reg_length / 2)), 0]#区域中心
            crests[reg_index, 1] = candidates[int(k - np.floor(reg_length / 2)), 1]# 振幅
        else:
            if reg_length > 1:#如果上一个区域长度大于1
                reg_index = reg_index + 1#区域序号
            reg_length = 1#区域长度为1
    # % di_candidates_index = candidates(:, 1)-[0, candidates(1: end - 1, 1)];
    # % debug
    # plt.figure
    # plt.plot(temp)
    # plt.plot(candidates[..., 0], candidates[..., 1], '*')
    # plt.plot(crests[..., 0], crests[..., 1], '+')
    # plt.show()
    # % % 按振幅大小排序
    crests_sorted = np.zeros((6))
    com_index = np.argsort(crests[..., 1])[::-1]
    crests_sorted[0:3]=crests[com_index[0:3], 0]# 下标
    crests_sorted[3:6]=crests[com_index[0:3], 1]# 振幅
    return crests_sorted

def get_vehicle_height(vehicle_sample):
# %输入: 车辆样本  16*827
# %输出: 底盘高度
    n=vehicle_sample.shape[0]
    hs=np.zeros((n))
    for i in range(n):
        crests=get_crests(vehicle_sample[i,...])
        hs[i]=crests[0]*0.48+200 #mm
    vehicle_height=np.mean(hs)#底盘高度
    return vehicle_height

def vehicle_classification(X):
#车辆分类
#输入：原始车辆样本 ~*827
#输出：类别
    m=16#样本宽度
    crests=np.zeros((m*6))
    resize_X=cv2.resize(X,(827,m),interpolation=cv2.INTER_LINEAR)#调整大小
    for j in range(m):
        crests[6*j:6*(j+1)]=get_crests(resize_X[j,...])#计算波峰
    vehicle_height=get_vehicle_height(resize_X)#计算底盘高度
    rf_model=joblib.load('rf_model.pkl')#load the trained random forest model
    type=rf_model.predict(np.append(crests,vehicle_height).reshape(1,-1))
    return type

def load_data():
# %载入车辆数据集
    l_bus,l_car,l_SUV,l_truck=57,105,54,100
    X_bus=np.empty((l_bus),dtype=object)
    X_car=np.empty((l_car),dtype=object)
    X_SUV=np.empty((l_SUV),dtype=object)
    X_truck=np.empty((l_truck),dtype=object)
    for i in range(l_bus):
        X_bus[i]=pd.read_csv('vehicle_data_bus/'+str(i)+'.csv',header = None).values#载入
    for i in range(l_car):
        X_car[i]=pd.read_csv('vehicle_data_car/'+str(i)+'.csv',header = None).values#载入
    for i in range(l_SUV):
        X_SUV[i]=pd.read_csv('vehicle_data_SUV/'+str(i)+'.csv',header = None).values#载入
    for i in range(l_truck):
        X_truck[i]=pd.read_csv('vehicle_data_truck/'+str(i)+'.csv',header = None).values#载入
    X=np.hstack((X_car, X_SUV, X_bus, X_truck))#车辆数据集
    Y=np.hstack((0*np.ones((l_car),dtype='int'), 1*np.ones((l_SUV),dtype='int') , 2*np.ones((l_bus),dtype='int'), 3*np.ones((l_truck),dtype='int')))#标签
    return X,Y

def data_feature_extract(X):
# %计算特征集
# %输入：车辆数据集 cell(1,~)
# %输出：特征集 ~*m*6+1
    m=16
    samples_count=X.size
    X_F=np.zeros((samples_count,m*6+1))
    crests=np.zeros(m*6)
    for i in range(samples_count):
        a = np.asarray(X[i],dtype='float64')#
        resize_X=cv2.resize(a,(827,m),interpolation=cv2.INTER_LINEAR)#调整大小,a类型不能为int
        for j in range(m):
            crests[6*j:6*(j+1)]=get_crests(resize_X[j,...])#计算波峰
        vehicle_height=get_vehicle_height(resize_X)#计算底盘高度
        X_F[i,...]=np.append(crests,vehicle_height)
        # print_hi(str(i))
    return X_F

def train_rfmodel():
# %训练随机森林模型并保存
    X,Y=load_data()#载入车辆数据集
    X_F=data_feature_extract(X)#特征数据集
    clf = RandomForestClassifier(random_state=0)
    clf.fit(X_F, Y)
    joblib.dump(clf, 'rf_model.pkl')

def display(csv_data,se_pairs,types):
# %画车辆检测和车辆分类结果图
# %输入：原始数据，起止时间对，车型
    font = FontProperties(fname=r"c:\windows\fonts\simsun.ttc", size=15)
    r_mean= np.mean(csv_data[..., 1:],axis=1)  # % 均值
    plt.figure()
    plt.subplot(2,1,1)
    plt.pcolormesh(csv_data[...,1:].T)
    plt.title('雷达信号',fontproperties=font)
    plt.xlabel('Measurement Counts')
    plt.ylabel('Sample Counts')
    # plt.subplot(2,1,1)
    # ax = plt.axes(projection='3d')
    # X=np.arange(0,csv_data.shape[1]-1)
    # Y=np.arange(0,csv_data.shape[0])
    # X,Y=np.meshgrid(X,Y)
    # Z=np.array(list(csv_data[...,1:]))
    # ax.contour3D(X,Y,Z)
    # plt.show()
    plt.subplot(2,1,2)
    plt.plot(r_mean)
    plt.title('平均',fontproperties=font)
    plt.xlabel('Measurement Counts')
    plt.ylabel('Averaged Amplitude')
    #plt.show()
    plt.figure()
    plt.subplot(2,1,1)
    plt.plot(r_mean)
    plt.title('车辆检测结果',fontproperties=font)
    plt.xlabel('Measurement Counts')
    plt.ylabel('Averaged Amplitude')
    plt.plot(se_pairs[0,...],r_mean[se_pairs[0,...]],'s', markersize=10,markeredgecolor='g',markerfacecolor='g')
    plt.plot(se_pairs[1,...],r_mean[se_pairs[1,...]],'p', markersize=10,markeredgecolor='b',markerfacecolor='b')
    #plt.show()
    plt.subplot(2,1,2)
    plt.plot(r_mean)
    plt.title('车辆分类结果',fontproperties=font)
    plt.xlabel('Measurement Counts')
    plt.ylabel('Averaged Amplitude')
    # % hold on; plot(se_pairs(1,:),radar_mean(se_pairs(1,:)),'s', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
    # % hold on; plot(se_pairs(2,:),radar_mean(se_pairs(2,:)),'p', 'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');
    types_name=('Car', 'SUV', 'Bus', 'Middle-truck')
    for i in range(se_pairs.shape[1]):
        x_point=int(np.floor((se_pairs[0,i]+se_pairs[1,i])/2))
        y_point=r_mean[x_point]+10
        plt.text(x_point,y_point,types_name[types[i]],fontsize=12,fontweight='bold')
    plt.show()

if __name__ == '__main__':
    #train_rfmodel() #训练随机森林模型并保存
    csv_data = pd.read_csv('D:\TD_DATA\\2021-1-15_data\\20210115_103952_三辆_汽车.txt', header=None,dtype='float').values  # 第一行不为列名
    # csv_data=pd.read_csv('r_mesh_4.csv',header = None).values#第一行不为列名
    se_pairs=vehicle_detection(csv_data,17,1.2)#车辆检测
    numb=se_pairs.shape[1]#车辆个数
    types=np.zeros((numb),dtype='int')
    for i in range(numb):
        types[i]=vehicle_classification(csv_data[se_pairs[0,i]:se_pairs[1,i],1:])#车辆分类
    display(csv_data,se_pairs,types)#画车辆检测和车辆分类结果图
