import random
from itertools import chain, cycle

import numpy as np

import tensorflow as tf
from imblearn.over_sampling import SMOTE

from keras.utils import to_categorical
from matplotlib import pyplot as plt
from sklearn import svm
from sklearn.ensemble import GradientBoostingClassifier, RandomForestClassifier

from sklearn.metrics import roc_auc_score, roc_curve, auc, accuracy_score, confusion_matrix, precision_recall_curve
from sklearn.model_selection import train_test_split
import tensorflow.python.keras.backend as K2
from sklearn.multiclass import OneVsRestClassifier
from sklearn.utils import class_weight
from tensorflow.python.keras import Input
from tensorflow.python.keras.activations import relu, softmax
from tensorflow.python.keras.callbacks import Callback, EarlyStopping
from tensorflow.python.keras.layers import SimpleRNN, Dense, Multiply, BatchNormalizationV2
from tensorflow.python.keras.losses import categorical_crossentropy
from tensorflow.python.keras.models import Model
import matplotlib as mpl
from collections import Counter
from imblearn import under_sampling
from tensorflow.python.keras.optimizer_v2.adam import Adam

r = 52
random.seed(r)
np.random.seed(r)
tf.random.set_seed(r)



def get_col_value(wsheet, col):
    rows = wsheet.max_row
    col_data = []
    for i in range(2, rows + 1):
        cell_value = wsheet.cell(i, col).value
        col_data.append(cell_value)
    return col_data


excel40396 = openpyxl.load_workbook('label40396.xlsx')
sheets1 = excel40396.get_sheet_names()
ws1 = excel40396.get_sheet_by_name(sheets1[0])
label40396 = get_col_value(ws1, 3)

all_train_genes = pd.read_excel('genes.xlsx', header=0, usecols=[0, 1])
all_train_genes = all_train_genes.iloc[:50, :]
all_train_genes = all_train_genes.values
print(all_train_genes)

all_genes = pd.read_excel('all_data1.xlsx', header=0)
print(all_genes.columns)

all_test_genes1 = pd.read_excel('data21802.xlsx', index_col=0)
all_test_genes2 = pd.read_excel('data13015.xlsx', index_col=0)
all_test_genes3 = pd.read_excel('data40586.xlsx', index_col=0)
all_test_genes4 = pd.read_excel('data103842.xlsx', index_col=0)
all_test_genes5 = pd.read_excel('data61821.xlsx', index_col=0)
all_test_genes6 = pd.read_excel('data9692.xlsx', index_col=0)
all_test_genes = pd.concat(
    [all_test_genes1, all_test_genes2, all_test_genes3, all_test_genes4, all_test_genes5,
     all_test_genes6], join='inner', axis=1)
all_test_genes = all_test_genes.T

i = 0
indexname = []
for ind in all_test_genes.index:
    indexname.append(i)
    i = i + 1
all_test_genes.index = indexname
print(all_test_genes)

label6269_1 = list(chain.from_iterable(pd.read_excel('label6269-1.xlsx', usecols=[2]).values))
# print(label6269_1)
# print(len(label6269_1))
label6269_2 = list(chain.from_iterable(pd.read_excel('label6269-2.xlsx', usecols=[2]).values))
# print(len(label6269_2))
label6269_3 = list(chain.from_iterable(pd.read_excel('label6269-3.xlsx', usecols=[2]).values))
# print(len(label6269_3))
label11755 = list(chain.from_iterable(pd.read_excel('label11755.xlsx', usecols=[2]).values))
# print(len(label11755))
label13015 = list(chain.from_iterable(pd.read_excel('label13015.xlsx', usecols=[2]).values))
label13015 = list(filter(lambda x: x != 10, label13015))
# print(len(label13015))
label13015_2 = list(chain.from_iterable(pd.read_excel('label13015-2.xlsx', usecols=[2]).values))
label13015_2 = list(filter(lambda x: x != 10, label13015_2))
# print(len(label13015_2))
label16129 = list(chain.from_iterable(pd.read_excel('label16129.xlsx', usecols=[2]).values))
# print(len(label16129))
label16129_2 = list(chain.from_iterable(pd.read_excel('label16129-2.xlsx', usecols=[2]).values))
# print(len(label16129_2))
label16129_3 = list(chain.from_iterable(pd.read_excel('label16129-3.xlsx', usecols=[2]).values))
# print(len(label16129_3))
label17156 = list(chain.from_iterable(pd.read_excel('label17156.xlsx', usecols=[2]).values))
# print(len(label17156))
label22098 = list(chain.from_iterable(pd.read_excel('label22098.xlsx', usecols=[2]).values))
label22098 = list(filter(lambda x: x != 10, label22098))
# print(len(label22098))
label23140 = list(chain.from_iterable(pd.read_excel('label23140.xlsx', usecols=[2]).values))
# print(len(label23140))
label25504 = list(chain.from_iterable(pd.read_excel('label25504.xlsx', usecols=[2]).values))
label25504 = list(filter(lambda x: x != 14, label25504))
# print(len(label25504))
label25504_3 = list(chain.from_iterable(pd.read_excel('label25504-3.xlsx', usecols=[2]).values))
label25504_3 = list(filter(lambda x: x != 3, label25504_3))
# print(len(label25504_3))
label25504_4 = list(chain.from_iterable(pd.read_excel('label25504-4.xlsx', usecols=[2]).values))
label25504_4 = list(filter(lambda x: x != 14, label25504_4))
# print(len(label25504_4))
label29161 = list(chain.from_iterable(pd.read_excel('label29161.xlsx', usecols=[2]).values))
# print(len(label29161))
label33341_2 = list(chain.from_iterable(pd.read_excel('label33341-2.xlsx', usecols=[2]).values))
# print(len(label33341_2))
label34205 = list(chain.from_iterable(pd.read_excel('label34205.xlsx', usecols=[2]).values))
print(len(label34205))
label38246 = list(chain.from_iterable(pd.read_excel('label38246.xlsx', usecols=[2]).values))
print(len(label38246))
label38900 = list(chain.from_iterable(pd.read_excel('label38900.xlsx', usecols=[2]).values))
print(len(label38900))
label40586 = list(chain.from_iterable(pd.read_excel('label40586.xlsx', usecols=[2]).values))
print(len(label40586))
label51808 = list(chain.from_iterable(pd.read_excel('label51808.xlsx', usecols=[2]).values))
label51808 = list(filter(lambda x: x != 10, label51808))
print(len(label51808))
label69606 = list(chain.from_iterable(pd.read_excel('label69606.xlsx', usecols=[2]).values))
print(len(label69606))
label42834 = list(chain.from_iterable(pd.read_excel('label42834.xlsx', usecols=[2]).values))
label42834 = list(filter(lambda x: x != 10, label42834))
print(len(label42834))
label_excel = xlrd.open_workbook('all_labels.xls')
sheet0 = label_excel.sheets()[12]
label68310 = sheet0.col_values(2, 1, )
sheet1 = label_excel.sheets()[11]
label20346 = sheet1.col_values(2, 1, )
print(len(label20346))
sheet2 = label_excel.sheets()[10]
label21802 = sheet2.col_values(2, 1, )
print(len(label21802))
sheet3 = label_excel.sheets()[9]
label27131 = sheet3.col_values(2, 1, )
print(len(label27131))
sheet4 = label_excel.sheets()[8]
label28750 = sheet4.col_values(2, 1, )
print(len(label28750))
sheet5 = label_excel.sheets()[7]
label40012 = sheet5.col_values(2, 1, )
label40012 = list(filter(lambda x: x != 3, label40012))
print(len(label40012))
sheet6 = label_excel.sheets()[6]
label42026 = sheet6.col_values(2, 1, )
print(len(label42026))
sheet7 = label_excel.sheets()[5]
label57065 = sheet7.col_values(2, 1, )
print(len(label57065))
sheet8 = label_excel.sheets()[4]
label60244 = sheet8.col_values(2, 1, )
# label60244 = list(filter(lambda x: x != 3, label60244))
print(len(label60244))
sheet9 = label_excel.sheets()[3]
label63990 = sheet9.col_values(2, 1, )
print(len(label63990))
sheet10 = label_excel.sheets()[2]
label66099 = sheet10.col_values(2, 1, )
print(len(label66099))
sheet11 = label_excel.sheets()[1]
label69528 = sheet11.col_values(2, 1, )
print(len(label69528))
sheet12 = label_excel.sheets()[0]
label111368 = sheet12.col_values(2, 1, )
print(len(label111368))
label103842 = list(chain.from_iterable(pd.read_excel('label103842.xlsx', usecols=[2]).values))
label61821 = list(chain.from_iterable(pd.read_excel('label61821.xlsx', usecols=[2]).values))
label29385 = list(chain.from_iterable(pd.read_excel('label29385.xlsx', usecols=[2]).values))
label9692 = list(chain.from_iterable(pd.read_excel('label9692.xlsx', usecols=[2]).values))
label68004 = list(chain.from_iterable(pd.read_excel('label68004.xlsx', usecols=[2]).values))
label10527 = list(chain.from_iterable(pd.read_excel('label10527.xlsx', usecols=[2]).values))
labels = np.array(
    label6269_1 + label6269_2 + label6269_3 + label11755 + label13015_2 + label16129 + label16129_2 +
    label17156 + label20346 + label22098 + label23140 + label25504 + label25504_3 + label25504_4 + label27131 + label28750 + label29161 + label33341_2
    + label34205 + label38246 + label38900 + label40012 + label40396 + label42026 + label42834 + label51808 + label57065 +
    label60244 + label63990 +
    label66099 + label68310 + label69528 + label69606 + label111368)
print(len(labels))
test_label = label21802 + label13015 + label40586 + label103842 + label61821 + label9692

labells = []
gene_index = []
gene_num = 0
for i in labels:
    if i == 0 or i == 11 or i == 12 or i == 4 or i == 2:
        gene_index.append(gene_num)
    gene_num = gene_num + 1

for i in labels:
    if i == 0 or i == 4:
        j = 0
    elif i == 11:
        j = 1
    elif i == 12:
        j = 2
    elif i == 2:
        j = 3
    else:
        j = 4
    labells.append(j)
labells = list(filter(lambda x: x != 4, labells))
print(labells)
test_index = []
test_num = 0
for i in test_label:
    if i == 0 or i == 11 or i == 12 or i == 2 or i == 4:
        test_index.append(test_num)
    test_num = test_num + 1

train_data = []
test_data = []
for train_gene in all_train_genes:
    gene1 = train_gene[0]
    gene2 = train_gene[1]
    if gene1 in all_genes.columns and gene2 in all_genes.columns and gene1 in all_test_genes.columns and gene2 in all_test_genes.columns:
        pair = []
        t_pair = []
        each_pair = np.array(all_genes.loc[gene_index, [gene1]].values) > np.array(
            all_genes.loc[gene_index, [gene2]].values)
        each_pair = each_pair.flatten()
        # print(each_pair)
        test_pair = np.array(all_test_genes.loc[test_index, [gene1]].values) > np.array(
            all_test_genes.loc[test_index, [gene2]].values)
        for i in each_pair:
            if i == 1:
                j = 1
            else:
                j = -1
            pair.append(j)
        for m in test_pair:
            if m == 1:
                n = 1
            else:
                n = -1
            t_pair.append(n)
        train_data.append(pair)
        test_data.append(t_pair)

train_data = np.array(train_data)

train_data = train_data.T
trainData = []
trainLabel = []
for i in train_data:
    i = np.reshape(i, (1, 50))
    trainData.append(i)

trainData = np.array(trainData)
trainLabel = np.array(labells)
tl = []
for i in test_label:
    if i == 0 or i == 4:
        j = 0
    elif i == 11:
        j = 1
    elif i == 12:
        j = 2
    elif i == 2:
        j = 3
    else:
        j = 4
    tl.append(j)
tl = list(filter(lambda x: x != 4, tl))
print(tl)

print(trainLabel.shape)
trainLabel = to_categorical(trainLabel, 4)
train_dt, val_dt, train_l, val_l = train_test_split(trainData, trainLabel, test_size=0.2, random_state=1,
                                                    stratify=trainLabel)
train_dt = np.reshape(train_dt, (2727, 1, 50))
val_dt = np.reshape(val_dt, (682, 1, 50))
train_l = np.reshape(train_l, (2727, 1, 4))
val_l = np.reshape(val_l, (682, 1, 4))

train_ll = np.reshape(train_l, (2727, 4))
train_ll = np.argmax(train_ll, axis=1)
flag1 = train_ll == 1
flag2 = train_ll == 2
c1 = train_dt[flag1]
c2 = train_l[flag1]
c3 = train_dt[flag2]
c4 = train_l[flag2]
f1 = np.concatenate([c3, c1, c1], axis=0)
shuffle_ind = np.random.permutation(len(f1))
f2 = np.concatenate([c4, c2, c2], axis=0)
f1 = f1[shuffle_ind]
f2 = f2[shuffle_ind]
train_dt = np.concatenate([train_dt, f1], axis=0)
train_l = np.concatenate([train_l, f2], axis=0)
sh_in = np.random.permutation(train_dt.shape[0])
train_dt = train_dt[sh_in]
train_l = train_l[sh_in]
train_ll = train_ll.tolist()
train_dataset = tf.data.Dataset.from_tensor_slices((train_dt, train_l), )
val_dataset = tf.data.Dataset.from_tensor_slices((val_dt, val_l))
def build_model():
    inputs = Input(shape=(50,))

    attention_probs = Dense(50, activation=relu)(inputs)
    attention_mul = Multiply()([inputs, attention_probs])

    attention_probs_2 = Dense(50, activation=softmax)(attention_mul)
    attention_mul_2 = Multiply()([attention_mul, attention_probs_2])

    Dense_lay0 = Dense(16, activation='relu')(attention_mul_2)

    Dense_lay1 = Dense(8, activation='relu')(Dense_lay0)
    Dense_lay2 = Dense(8, activation='relu')(Dense_lay1)
    Dense_lay3 = Dense(8, activation='relu')(Dense_lay2)
    # # #
    Dense_lay4 = Dense(4, activation='relu')(Dense_lay3)
    output = Dense(4, activation=softmax)(Dense_lay4)
    model = Model(inputs=[inputs], outputs=output)
    return model
model = []
model = build_model()
model.compile(
    optimizer=Adam(lr=0.001, amsgrad=True),
    # optimizer=tf.keras.optimizers.Adam(lr=0.001),
    loss=categorical_crossentropy,
)
model.fit(train_dataset, epochs=10, validation_data=val_dataset, verbose=2,
          callbacks=[EarlyStopping(monitor='val_loss') ]
         )
