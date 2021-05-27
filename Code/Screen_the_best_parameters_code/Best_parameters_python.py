import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import KFold
from sklearn import metrics
df = pd.read_csv("D:/NLP实验室/筛选最佳参数/参数组合列表(不含为0的参数).csv")
df = pd.DataFrame(df.values,index=range(len(df)),columns=range(4))
path = 'D:/NLP实验室/筛选最佳参数/实验Meiosis数据.csv'
tz = pd.read_csv(path)
tz = pd.DataFrame(tz.values,index=range(len(tz)),columns=tz.columns)
score = list()
accuracy = list()
for index in range(3):
    x1 = df.loc[index,0]
    x2 = df.loc[index,1]
    x3=df.loc[index,2]
    x4=df.loc[index,3]
    score.append(x1)
    score.append(x2)
    score.append(x3)
    score.append(x4)
    for n in range(len(tz)):
        tz.loc[n,'weight'] = float(tz.loc[n,'weight1'])*x1+float(tz.loc[n,'weight2'])*x2+float(tz.loc[n,'weight3'])*x3+float(tz.loc[n,'weight4'])*x4
        tz.loc[n,'backwardweight'] = float(tz.loc[n,'backwardweight1'])*x1+float(tz.loc[n,'backwardweight2'])*x2+float(tz.loc[n,'backwardweight3'])*x3+float(tz.loc[n,'backwardweight4'])*x4
        tz.loc[n, 'Diff'] = float(tz.loc[n, 'Diff1']) * x1 + float(tz.loc[n, 'Diff2']) * x2 + float(tz.loc[n, 'Diff3']) * x3 + float(tz.loc[n, 'Diff4']) * x4
        tz.loc[n, 'SUM'] = float(tz.loc[n, 'SUM1']) * x1 + float(tz.loc[n, 'SUM2']) * x2 + float(tz.loc[n, 'SUM3']) * x3 + float(tz.loc[n, 'SUM4']) * x4
        tz.loc[n, 'Normalized_weight'] = float(tz.loc[n, 'Normalized_weight1']) * x1 + float(tz.loc[n, 'Normalized_weight2']) * x2 + float(tz.loc[n, 'Normalized_weight3']) * x3 + float(tz.loc[n, 'Normalized_weight4']) * x4
        tz.loc[n, 'Normalized_backward_weight'] = round(tz.loc[n, 'Normalized_backward_weight1'],3) * x1 + round(tz.loc[n, 'Normalized_backward_weight2'],3) * x2 + round(tz.loc[n, 'Normalized_backward_weight3'],3)*x3 + round(tz.loc[n, 'Normalized_backward_weight4'],3)* x4
    x = tz[["weight", "backwardweight", "SUM", "Diff", "Normalized_weight", "Normalized_backward_weight",
            "Weight_greater_than_mean", "Backward_weight_greater_than_mean"]]
    y = tz["result"]
    x = np.array(x)
    x = x.astype('float')
    y = np.array(y)
    y = y.astype('int')
    acc_score = []

    kf = KFold(n_splits=5, random_state=1, shuffle=True)
    for train_index, test_index in kf.split(x):
        x_train, y_train = x[train_index], y[train_index]
        x_test, y_test = x[test_index], y[test_index]
        # 创建模型
        clf = RandomForestClassifier(criterion='gini', n_estimators=9)
        # 训练模型
        clf.fit(x_train, y_train)
        y_predict = clf.predict(x_test)
        # 计算结果值
        acc = metrics.accuracy_score(y_test, y_predict)
        acc_score.append(acc)
    accuracy.append(np.mean(acc_score))
score = np.array(score)
score = score.reshape(int(len(score)/4),4)
print(score)
accuracy = np.array(accuracy)
print(accuracy)
max =  np.max(accuracy)
print(max)
max_index = np.argmax(accuracy)
print(max_index)
print(score[max_index])