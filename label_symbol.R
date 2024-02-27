setwd("C:/Users/xieji/Desktop/bvn/224615")
fil=dir()

library(readxl)
data=NULL
for (i in 1:length(fil)) {
  print(fil[i])
  dat <- as.matrix(read_excel("C:/Users/xieji/Desktop/bvn/224615/GSE224615_DEGs.xlsx"))
  print(dat)
  rownames(dat)=dat[,1]
  print(dat)
  dat=as.matrix(dat[,-1])
  data=cbind(data,dat)
}
print(rownames(dat))
library(clusterProfiler)
symb = bitr(rownames(dat), fromType = "ENSEMBL", toType = "SYMBOL", OrgDb = "org.Hs.eg.db")
print(symb)

index=which(duplicated(symb[,1]))
symb1=symb[-index,]
length(unique(symb[,2]))
index=match(symb1[,1],rownames(data))
data1=data[index,]

colnames(data1)=substr(fil,1,3)
data1=cbind(symb1[,2],data1)
write.table(data1,"GSE224615.txt",sep="\t",quote = F)
