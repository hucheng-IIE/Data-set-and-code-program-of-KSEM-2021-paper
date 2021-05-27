import pandas as pd
import  numpy as np
import csv
#随机森林
from sklearn.ensemble import RandomForestClassifier
#向量机
from sklearn import svm
#五折交叉验证
from sklearn.model_selection import KFold
from sklearn.metrics import confusion_matrix
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import GridSearchCV
#决策树
from sklearn import tree
#MLP多层网络感知模型
from sklearn.neural_network import MLPClassifier
#朴素贝叶斯
from sklearn.naive_bayes import GaussianNB
#AdaBoost
from sklearn.ensemble import AdaBoostClassifier
#逻辑回归
from sklearn import metrics
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction import DictVectorizer
from sklearn.metrics import classification_report

#获取数据
#D:\NLP实验室\AL-CPL-dataset-master\中间表格\Newton's Laws AB 特征.csv
#D:\NLP实验室\原始论文实验\Global Warming T.csv
#D:\NLP实验室\Final 特征值\Global Warming T 0.25 0.25 0.25 0.25.csv
path = r"D:\NLP实验室\结果\precalculus.csv"
clickstream = pd.read_csv(path)
# path1 = r"D:\NLP实验室\Final 特征值\除Public-key Cryp外的四类领域特征值的集合.csv"
# clickstream1 = pd.read_csv(path1)
#筛选特征值和目标值
#"Sum_of_all_transitions","Mean_of_weights",
x = clickstream[["weight","backwardweight","SUM","Diff","Normalized_weight","Normalized_backward_weight","Weight_greater_than_mean","Backward_weight_greater_than_mean"]]
y = clickstream["result"]
# # #数据处理
# # #转换成字典
#x = x.to_dict(orient="records")
#交叉验证法处理数据集
x = np.array(x)
y = np.array(y)
# x_train = x
# y_train = clickstream1["result"]
# x_test = clickstream[["weight","backwardweight","SUM","Diff","Sum_of_all_transitions","Mean_of_weights","Normalized_weight","Normalized_backward_weight","Weight_greater_than_mean","Backward_weight_greater_than_mean"]]
# y_test = y
#数据集划
acc_score=[]
p_score = []
r_score=[]
f1_score=[]

kf = KFold(n_splits=5,random_state=1, shuffle=True)
for train_index, test_index in kf.split(x):
    x_train, y_train = x[train_index], y[train_index]
    x_test,y_test = x[test_index], y[test_index]
    #创建模型
    clf = RandomForestClassifier(criterion='gini', n_estimators=9)
    #clf = GaussianNB()
    #clf = tree.DecisionTreeClassifier()
    #clf = MLPClassifier()
    #clf = svm.SVC(gamma='scale')
    #clf = LogisticRegression()
    #clf = AdaBoostClassifier(n_estimators=9)
    #训练模型
    clf.fit(x_train, y_train)
    y_predict = clf.predict(x_test)
    print("对比:\n",y_predict==y_test)
    tn, fp, fn, tp = confusion_matrix(y_test, y_predict).ravel()
    print("tn, fp, fn, tp:",tn, fp, fn, tp)
    #计算结果值
    score = clf.score(x_test, y_test)
    f1 = metrics.f1_score(y_test, y_predict, average="weighted")
    P = metrics.precision_score(y_test, y_predict, average="weighted")
    R = metrics.recall_score(y_test, y_predict, average="weighted")
    acc_score.append(score)
    p_score.append(P)
    r_score.append(R)
    f1_score.append(f1)
    print("score: "+str(score)+" F1-score: " + str(f1) + " Precision: " + str(
        P) + " Recall: " + str(R))
print("Accuracy：%f" % (np.mean(acc_score)))
print("Precision：%f" % (np.mean(p_score)))
print("Recall：%f" % (np.mean(r_score)))
print("F1-score：%f" % (np.mean(f1_score)))
#留出法
#x_train,x_test,y_train,y_test = train_test_split(x,y,test_size=0.2,random_state=22)
#特征工程,将特征值变为向量机制
# transfer = DictVectorizer()
# x_train = transfer.fit_transform(x_train)
# x_test = transfer.transform(x_test)
#随机森林准备
#朴素贝叶斯
#clf = GaussianNB()

#多层网络感知器
#clf = MLPClassifier()
#支持向量机
#clf = svm.SVC(gamma='scale')
#逻辑回归
#clf = LogisticRegression()
#AdaBoostClassifier
#clf = AdaBoostClassifier(n_estimators=11)
# 加入网格搜索
#参数准备
#param_dict = {"n_estimators":[250],"max_depth":[11]}
#cv交叉验证的网格搜索来优化
#estimator = GridSearchCV(estimator,param_grid=param_dict,cv = 5)
#clf = tree.DecisionTreeClassifier()

#5)模型评估
#直接比对真实值和预测值
#x_test,y_test = ros.fit_sample(x_test,y_test)
#D:\NLP实验室\Final 特征值

# for item in x_test:
#     with open(r"D:\NLP实验室\Final 特征值\Public-key Cryp_predict 0.25 0.25 0.25 0.25.csv", "a", encoding="utf-8-sig",
#                       newline="") as csvfile:
#         writer = csv.writer(csvfile)
#         writer.writerow(item)
# 直接计算准确率
# scores = cross_val_score(clf,x_test,y_test,cv=5,scoring='accuracy')
# print(scores)
# print(scores.mean())
