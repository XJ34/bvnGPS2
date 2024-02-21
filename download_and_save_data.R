workspace_path = "D:/Bio/data/20210510_data_reload/"
setwd(workspace_path)
# dataset_name = "coconut"
# dataset_name = "nc2020"
# dataset_name = "host2016"
dataset_name = "non_infected_as_4"

if (dataset_name == "coconut")
{
  save_path = "./coconut/"
  GSE_IDs = c("20346", "40012", "40396", "42026", "60244", "66099", "63990")  # coconut
  GSE_IDs = c("63990")
} else if (dataset_name == "nc2020")
{
  save_path = "./nc2020/"
  GSE_IDs = c("21802", "27131", "28750", "42834", "57065", "68310", "69528", "111368")  # nc 2020
  GSE_IDs = c("28750")
} else if (dataset_name == "host2016")
{
  save_path = "./host2016/"
  GSE_IDs = c("6269")  # host 6269
}  else if (dataset_name == "non_infected_as_4")
{
  save_path = "./non_infected_as_4/"
  GSE_IDs = c("63990")  # host 6269
} 

options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
options("repos"=c(CRAN="http://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

if(FALSE)
{
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  BiocManager::install("GEOquery")
  
  install.packages('devtools')
  library(devtools)
  install_github('jmzeng1314/AnnoProbe')
}

##加载R包
library(GEOquery)
library(AnnoProbe)

description_to_label <- function(des){
  output_list = list()
  for (i in 1:dim(des)[1]){
    des_each = des[i, 1]
    # 20346
    if (substring(des_each, 1, 19) == "bacterial pneumonia"){key = 1}
    else if (substring(des_each, 1, 16) == "Severe Influenza"){key = 2}
    else if (substring(des_each, 1, 3) == "Vac"){key = 0}
    # 40012
    else if (substring(des_each, 1, 42) == "PAXgene whole blood, influenza A pneumonia"){key = 2}
    else if (substring(des_each, 1, 40) == "PAXgene whole blood, bacterial pneumonia"){key = 1}
    # else if (substring(des_each, 1, 25) == "PAXgene whole blood, SIRS"){key = 0}
    else if (substring(des_each, 1, 25) == "PAXgene whole blood, SIRS"){key = 4}  # 0513_noninfected
    else if (substring(des_each, 1, 36) == "PAXgene whole blood, healthy control"){key = 0}
    else if (substring(des_each, 1, 62) == "PAXgene whole blood, mixed bacterial and influenza A pneumonia"){key = 3}
    # 40396
    else if (substring(des_each, 1, 20) == "pathogen: Adenovirus") {key=2}
    else if (substring(des_each, 1, 14) == "pathogen: HHV6") {key=2}
    else if (substring(des_each, 1, 21) == "pathogen: Enterovirus") {key=2}
    else if (substring(des_each, 1, 20) == "pathogen: Rhinovirus") {key=2}
    else if (substring(des_each, 1, 16) == "pathogen: E.coli") {key=1}
    else if (substring(des_each, 1, 18) == "pathogen: Bacteria") {key=1}
    else if (substring(des_each, 1, 14) == "pathogen: MRSA") {key=1}
    else if (substring(des_each, 1, 20) == "pathogen: Salmonella") {key=1}
    else if (substring(des_each, 1, 14) == "pathogen: MSSA") {key=1}
    else if (substring(des_each, 1, 14) == "pathogen: None") {key=0}
    # 42026
    else if (substring(des_each, 1, 7) == "WB-H1N1") {key=2}
    else if (substring(des_each, 1, 6) == "WB-RSV") {key=2}
    else if (substring(des_each, 1, 7) == "WB-bact") {key=1}
    else if (substring(des_each, 1, 10) == "WB-control") {key=0}
    # 不一定可以使用 
    # 66099
    else if (substring(des_each, 1, 16) == "disease: Control") {key=0}
    else if (substring(des_each, 1, 20) == "disease: SepticShock") {key=1}
    else if (substring(des_each, 1, 13) == "disease: SIRS") {key=2}
    else if (substring(des_each, 1, 15) == "disease: Sepsis") {key=1}
    # 60244
    else if (substring(des_each, 1, 20) == "whole blood-BACTERIA"){key = 1}
    else if (substring(des_each, 1, 23) == "whole blood-COINFECTION"){key = 3}
    else if (substring(des_each, 1, 17) == "whole blood-VIRUS"){key = 2}
    else if (substring(des_each, 1, 27) == "whole blood-Healthy Control"){key = 0}
    # 27131
    else if (substring(des_each, 1, 9) == "blood_day"){key = 2}
    else if (substring(des_each, 1, 13) == "Blood_Control"){key = 0}
    # 111368
    else if (des_each == "HC"){key = 0}
    else if (des_each == "H1N1"){key = 2}
    else if (des_each == "A"){key = 2}
    else if (des_each == "B"){key = 2}
    else if (des_each == "H3N2"){key = 2}
    # 28750
    # else if (substring(des_each, 1, 24) == "Experiment_Post_Surgical") {key = 0}  # 0513 noninfected
    else if (substring(des_each, 1, 24) == "Experiment_Post_Surgical") {key = 4}
    else if (substring(des_each, 1, 17) == "Experiment_Sepsis") {key = 1}
    else if (substring(des_each, 1, 15) == "Control_Healthy") {key = 0}
    # 42834
    else if (substring(des_each, 1, 9) == "TB Sample") {key=1}  # 结核病
    else if (substring(des_each, 1, 14) == "TB_PBMC Sample") {key=1}  # 结核病
    else if (substring(des_each, 1, 5) == "TB_CD") {key=1}  # 结核病
    else if (substring(des_each, 1, 14) == "TB_Whole blood") {key=1}  # 结核病
    else if (substring(des_each, 1, 14) == "Sarcoid Sample") {key=10}  # 肉结 删去
    else if (substring(des_each, 1, 26) == "Sarcoid_Whole blood Sample") {key=10}  # 肉结 删去
    else if (substring(des_each, 1, 10) == "Sarcoid_CD") {key=10}  # 肉结 删去
    else if (substring(des_each, 1, 12) == "Sarcoid_PBMC") {key=10}  # 肉结 删去
    else if (substring(des_each, 1, 16) == "Pneumonia Sample") {key=10}  # 肺炎 删去
    else if (substring(des_each, 1, 13) == "Cancer Sample") {key=10}  # 癌症 删去
    else if (substring(des_each, 1, 14) == "Control Sample") {key = 0}
    else if (substring(des_each, 1, 17) == "Pneumonia_Treated") {key = 10}
    else if (substring(des_each, 1, 23) == "Pneumonia_Pre-treatment") {key = 10}
    # 69528
    else if (des_each == "pathogens: Acinetobacter baumannii") {key = 1}  # 鮑氏不動桿菌
    else if (des_each == "pathogens: Acinetobacter lwoffii") {key = 1}  # 魯氏不動桿菌
    else if (des_each == "pathogens: Acinetobacter Iwoffii") {key = 1}
    else if (des_each == "pathogens: Aeromonas spp.") {key = 1}  # 親水性產氣單胞菌
    else if (des_each == "pathogens: Bacillus spp., Micrococcus spp.") {key = 1}  # 枯草桿菌 藤黃微球菌 
    else if (des_each == "pathogens: Burkholderia pseudomallei") {key = 1}  # 类鼻疽伯克霍尔德菌
    else if (des_each == "pathogens: Citrobacter freundii") {key = 1}  # 弗氏檸檬酸桿菌
    else if (des_each == "pathogens: Control") {key = 0}
    else if (des_each == "pathogens: Corynebacterium spp.") {key = 1}  # 棒狀桿菌屬
    else if (des_each == "pathogens: Cryptococcus neoformans") {key = 1}  # 新型隱球菌
    else if (des_each == "pathogens: Enterococcus spp.") {key = 1}  # 腸球菌
    else if (des_each == "pathogens: Eschericia coli") {key = 1}  # 大腸桿菌 
    else if (des_each == "pathogens: Eschericia coli, Viridans Streptococcus") {key = 1}  # 大腸桿菌 草綠色鏈球菌
    else if (des_each == "pathogens: Klebseilla pneumoniae,  Viridans Streptococci") {key = 1}  # 克雷伯氏肺炎菌 草綠色鏈球菌
    else if (des_each == "pathogens: Klebseilla spp., Pseudomonas aeruginosa") {key = 1}  # 肺炎克雷伯杆菌 绿脓杆菌
    else if (des_each == "pathogens: Klebsiella pneumoniae") {key = 1}  # 克雷伯氏肺炎菌
    else if (des_each == "pathogens: Klebslella pneumoniae") {key = 1}
    else if (des_each == "pathogens: Micrococcus spp.") {key = 1}  # 藤黃微球菌
    else if (des_each == "pathogens: Salmonella") {key = 1}  # 沙门氏菌
    else if (des_each == "pathogens: Salmonella gr.C") {key = 1}
    else if (des_each == "pathogens: Sphingobacterium spp.") {key = 1}  # 鞘氨醇杆菌属
    else if (des_each == "pathogens: Sphingomanas spp.") {key = 1}  # 鞘脂單胞菌屬
    else if (des_each == "pathogens: Staphylococcus aureus") {key = 1}  # 金黃色葡萄球菌
    else if (des_each == "pathogens: Streptoccus suis") {key = 1}  # 豬鏈球菌
    else if (des_each == "pathogens: Streptococcus pyogenes") {key = 1}  # 化膿性鏈球菌
    else if (des_each == "pathogens: Viridans Streptococci") {key = 1}  # 草綠色鏈球菌 
    # else if (substring(des_each, 1, 18) == "Uninfected healthy") {key = 0}
    # else if (substring(des_each, 1, 35) == "Uninfected type 2 diabetes mellitus") {key = 0}
    # else if (substring(des_each, 1, 22) == "Septicemic melioidosis") {key = 1}
    # else if (substring(des_each, 1, 12) == "Other sepsis") {key = 1}
    # 63990
    # else if (des_each == "non-infectious illness") {key=0}
    else if (des_each == "non-infectious illness") {key = 4}  # 0513 noninfected 
    else if (des_each == "bacterial") {key=1}
    else if (des_each == "viral") {key=2}
    # 68310
    else if (des_each == "infection: enterovirus") {key=2}  
    else if (des_each == "infection: human coronavirus HKU1") {key=2}  
    else if (des_each == "infection: human coronavirus NL63") {key=2}  
    else if (des_each == "infection: human rhinovirus") {key=2}  
    else if (des_each == "infection: human rhinovirus and enterovirus") {key=2} 
    else if (des_each == "infection: human rhinovirus and human coronavirus HKU1") {key=2} 
    else if (des_each == "infection: human rhinovirus and human coronavirus NL63") {key=2} 
    else if (des_each == "infection: human rhinovirus and respiratory syncytial virus A") {key=2} 
    else if (des_each == "infection: human rhinovirus and respiratory syncytial virus B") {key=2} 
    else if (des_each == "infection: influenza A virus") {key=2} 
    else if (des_each == "infection: influenza A virus and human coronavirus 229E") {key=2} 
    else if (des_each == "infection: influenza A virus and human coronavirus OC43") {key=2}  
    else if (des_each == "infection: influenza A virus and human rhinovirus") {key=2}  
    else if (des_each == "infection: influenza A virus and respiratory syncytial virus B") {key=2} 
    else if (des_each == "infection: influenza B virus") {key=2}  
    else if (des_each == "infection: influenza B virus and human rhinovirus") {key=2} 
    else if (des_each == "infection: our tests did not detect one of the viruses sought") {key=10} 
    else if (des_each == "infection: respiratory syncytial virus A") {key=2} 
    # 57065
    else if (substring(des_each, 1, 7) == "Blood_P"){key = 1}
    else if (substring(des_each, 1, 8) == "Blood_HV"){key = 0}
    # 21802
    else if (substring(des_each, 1, 39) == "Pandemic H1N1 positive critical patient"){key = 2}
    else if (substring(des_each, 1, 15) == "Healthy Control"){key = 0}
    # 6269_2
    else if (substring(des_each, 1, 19) == "PBMC_InfluenzaA_INF") {key=2}
    else if (substring(des_each, 1, 19) == "PBMC_InfluenzaB_INF") {key=2}
    else if (substring(des_each, 1, 21) == "PBMC_S.pneumoniae_INF") {key=1}  # 肺炎链球菌
    else if (substring(des_each, 1, 22) == "PBMC_S.aureus_MRSA_INF") {key=1}  # 耐甲氧西林金黃色葡萄球菌 (MRSA Super bug)
    else if (substring(des_each, 1, 22) == "PBMC_S.aureus_MSSA_INF") {key=1}  # 耐甲氧西林金黃色葡萄球菌 (MRSA Super bug)
    # 6269_3
    else if (substring(des_each, 1, 15) == "PBMC_E.coli_INF") {key=1}  # 大肠杆菌
    else if (substring(des_each, 1, 12) == "PBMC_Healthy") {key=0}  # 健康
    # else if (substring(des_each, 1, 21) == "PBMC_InfluenzaA_INF") {key=1}  
    # else if (substring(des_each, 1, 22) == "PBMC_S.aureus_MRSA_INF") {key=1}  # 金黄色葡萄球菌
    # else if (substring(des_each, 1, 22) == "PBMC_S.aureus_MSSA_INF") {key=1}  # 金黄色葡萄球菌
    # else if (substring(des_each, 1, 22) == "PBMC_S.pneumoniae_INF") {key=1}

    # # 
    # else if (substring(des_each, 1, 15) == "healthy subject"){key = 0}
    # else if (substring(des_each, 1, 27) == "intensive-care unit patient"){key = 1}
    # # 
    # else if (substring(des_each, 1, 23) == "bacterial pneumonia_day") {key=1}
    # else if (substring(des_each, 1, 20) == "Severe Influenza_day") {key=2}
    # else if (substring(des_each, 1, 3) == "Vac") {key=0} 
    # # 25504
    # else if (substring(des_each, 1, 3) == "Con") {key = 0}
    # else if (substring(des_each, 1, 3) == "Inf") {key = 1}
    # else if (substring(des_each, 1, 3) == "NEC") {key = 1}
    # else if (substring(des_each, 1, 3) == "Vir") {key = 2}
    else {
      print("出现了没见过的字符"); 
      print(des_each);
      readline()
    }
    output_list[i] <- key
  }
  return (unlist(output_list))
}


get_detail_func <- function(GSE_ID_each, eset_id=1){
  print(GSE_ID_each)
  GSE_ID_each_cated = paste("GSE", GSE_ID_each, sep="")
  if (eset_id == 1)
  {
    save_sig = GSE_ID_each_cated
  }
  else
  {
    print(eset_id)
    save_sig = paste(GSE_ID_each_cated, eset_id, sep="_")
  }
  print(GSE_ID_each_cated)
  print(save_sig)
  
  #step1 获取数据的探针表达矩阵
  # gset=AnnoProbe::geoChina(GSE_ID_each_cated) #举个例子要GSE63514的数据 好像只能下载到当前路径，有点乱
  suppressWarnings(load(paste("./", GSE_ID_each_cated,"_eSet.Rdata", sep="")))  # 应用当前路径下的输出
  eSet=gset[[eset_id]]
  probes_expr_without_log2 <- exprs(eSet);dim(probes_expr_without_log2)
  phenoDat <- pData(eSet)  # TODO
    write.table(phenoDat, file=paste(save_path, "all_lc_", save_sig, ".csv",sep=""), sep=",", row.names=T, quote=FALSE)
  #step2 获取数据的平台文件对探针加以注释 这些很简单，这个包有直接注释的函数，你要是想自己处理也可以
  gpl=eSet@annotation
  checkGPL(gpl)
  printGPLInfo(gpl)
  probe2gene=idmap(gpl)  # GPL570_bioc.rda
  head(probe2gene)
  genes_expr_without_log2 <-filterEM(probes_expr_without_log2,probe2gene)  ##将序号转化为基因 得到了注释后的表达谱
  
  if (GSE_ID_each == "69528"){
    # phenoDat_col1 = phenoDat["study group:ch1"]
    phenoDat_col1 = phenoDat["characteristics_ch1"]
    print("phenoDat_col1   69528")
    print(phenoDat_col1)
    phenoLabel<-within(phenoDat_col1,{
      Label<-description_to_label(phenoDat_col1["characteristics_ch1"])
    })
  }
  else if (GSE_ID_each == "111368"){
    phenoDat_col1 = phenoDat["flu_type:ch1"]
    print("phenoDat_col1   111368")
    print(phenoDat_col1)
    phenoLabel<-within(phenoDat_col1,{
      Label<-description_to_label(phenoDat_col1["flu_type:ch1"])
    })
  }  
  else if (GSE_ID_each == "40396"){
    phenoDat_col1 = phenoDat["characteristics_ch1.4"]
    print("phenoDat_col1   40396")
    print(phenoDat_col1)
    phenoLabel<-within(phenoDat_col1,{
      Label<-description_to_label(phenoDat_col1["characteristics_ch1.4"])
    })
  }
  else if (GSE_ID_each == "66099"){
    phenoDat_col1 = phenoDat["characteristics_ch1.2"]
    print("phenoDat_col1   66099")
    print(phenoDat_col1)
    phenoLabel<-within(phenoDat_col1,{
      Label<-description_to_label(phenoDat_col1["characteristics_ch1.2"])
    })
  }
  else if (GSE_ID_each == "63990"){
    phenoDat_col1 = phenoDat["infection_status:ch1"]
    print("phenoDat_col1   63990")
    print(phenoDat_col1)
    phenoLabel<-within(phenoDat_col1,{
      Label<-description_to_label(phenoDat_col1["infection_status:ch1"])
    })
  }
  else if (GSE_ID_each == "68310"){
    phenoDat_col1 = phenoDat["characteristics_ch1.3"]
    print("phenoDat_col1   68310")
    print(phenoDat_col1)
    phenoLabel<-within(phenoDat_col1,{
      Label<-description_to_label(phenoDat_col1["characteristics_ch1.3"])
    })
  }
  else{
    print("usual")
    phenoDat_col1 = phenoDat[1]
    print("phenoDat_col1")
    print(phenoDat_col1)
    phenoLabel<-within(phenoDat_col1,{
      Label<-description_to_label(phenoDat_col1["title"])
    })
  }
  # print("GSE_ID", GSE_ID_each_cated)
  write.table(genes_expr_without_log2,file=paste(save_path, "exp_gene_", save_sig ,".txt", sep=""),sep="\t",row.name=T,quote=FALSE)
  write.table(phenoLabel, file=paste(save_path, "label_", save_sig, ".txt",sep=""), sep="\t", row.names=T, quote=FALSE)
}

for (GSE_ID_each in GSE_IDs){
  print(GSE_ID_each)
  if (GSE_ID_each == "6269"){
    get_detail_func(GSE_ID_each, 2)
    get_detail_func(GSE_ID_each, 3)
  }
  else{
    get_detail_func(GSE_ID_each)    
  }
  
}

