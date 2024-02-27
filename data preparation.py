import pandas as pd

data6269_1 = pd.read_excel('data6269_1.xlsx', index_col=0, header=1)
data6269_2 = pd.read_excel('data6269_2.xlsx', index_col=0)
data6269_3 = pd.read_excel('data6269_3.xlsx', index_col=0)
data6377 = pd.read_excel('data6377.xlsx', index_col=0)
data9692 = pd.read_excel('data9692.xlsx', index_col=0)
data11755 = pd.read_excel('data11755.xlsx', index_col=0)
data13015 = pd.read_excel('data13015.xlsx', index_col=0)
data13015_2 = pd.read_excel('data13015_2.xlsx', index_col=0)
data16129 = pd.read_excel('data16129.xlsx', index_col=0)
data16129_2 = pd.read_excel('data16129_2.xlsx', index_col=0, )
data16129_3 = pd.read_excel('data16129_3.xlsx', index_col=0)
data17156 = pd.read_excel('data17156.xlsx', index_col=0)
data20346 = pd.read_excel('data20346.xlsx', index_col=0)
data21802 = pd.read_excel('data21802.xlsx', index_col=0)
data22098 = pd.read_excel('data22098.xlsx', index_col=0)
data23140 = pd.read_excel("data23140.xlsx", index_col=0)
data25504 = pd.read_excel('data25504.xlsx', index_col=0)
data25504_3 = pd.read_excel("data25504-3.xlsx", index_col=0)
data25504_4 = pd.read_excel('data25504-4.xlsx', index_col=0)
data27131 = pd.read_excel('data27131.xlsx', index_col=0)
data28750 = pd.read_excel('data28750.xlsx', index_col=0)
data29161 = pd.read_excel('data29161.xlsx', index_col=0)
data29385 = pd.read_excel('data29385.xlsx', index_col=0)
data33341 = pd.read_excel('data33341.xlsx', index_col=0)
data33341_2 = pd.read_excel('data33341-2.xlsx', index_col=0)
data34205 = pd.read_excel('data34205.xlsx', index_col=0)
data38246 = pd.read_excel('data38246.xlsx', index_col=0)
data38900 = pd.read_excel('data38900.xlsx', index_col=0)
data40012 = pd.read_excel('data40012.xlsx', index_col=0)
data40396 = pd.read_excel('data40396.xlsx', index_col=0)
data40586 = pd.read_excel('data40586.xlsx', index_col=0)
data42026 = pd.read_excel('data42026.xlsx', index_col=0)
data42834 = pd.read_excel('data42834.xlsx', index_col=0)
data51808 = pd.read_excel('data51808.xlsx', index_col=0)
data57065 = pd.read_excel('data57065.xlsx', index_col=0)
data60244 = pd.read_excel('data60244.xlsx', index_col=0)
data61821 = pd.read_excel('data61821.xlsx', index_col=0)
data63990 = pd.read_excel('data63990.xlsx', index_col=0)
data66099 = pd.read_excel('data66099.xlsx', index_col=0)
data68004 = pd.read_excel('data68004.xlsx', index_col=0)
data68310 = pd.read_excel('data68310.xlsx', index_col=0)
data69528 = pd.read_excel('data69528.xlsx', index_col=0)
data69606 = pd.read_excel('data69606.xlsx', index_col=0)
data103842 = pd.read_excel('data103842.xlsx', index_col=0)
data111368 = pd.read_excel('data111368.xlsx', index_col=0)

all_train_genes0 = pd.concat(
    [data6269_1, data6269_2, data6269_3, data9692, data11755, data13015, data13015_2, data16129, data16129_2, data16129_3,
     data17156, data20346
        , data21802, data22098, data23140, data25504, data25504_3, data25504_4, data27131, data28750, data29161,
     data33341_2,
     data34205, data38246, data38900, data40012, data40396, data40586, data42026, data42834, data51808,
     data60244, data61821, data63990,
    data68310, data69606, data103842, data111368], join='inner', axis=1)
all_train_genes0 = all_train_genes0.T
all_train_genes0.to_excel('transfer_data.xlsx')

all_train_genes1 = pd.concat(
    [data6269_1, data6269_2, data6269_3, data11755, data13015_2, data16129, data16129_2,
     data17156, data20346
        , data22098, data23140, data25504, data25504_3, data25504_4, data27131, data28750, data29161,
     data33341_2
        , data34205, data38246, data38900, data40012, data40396, data42026, data42834, data51808, data57065,
     data60244, data63990,
     data66099, data68310, data69528, data69606, data111368],
    join='inner', axis=1)
print(all_train_genes1)
all_train_genes1 = all_train_genes1.T
all_train_genes1.to_excel('all_data1.xlsx')

