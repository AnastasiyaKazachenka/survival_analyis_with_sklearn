TCG_UVM <- readRDS("./data/TCG_UVM.rds")
clinical <- readRDS("./data/clinical.rds")

expres <- TCGA_UVM[rowSums(TCGA_UVM[,c(3:82)]>5) > 20,]
expres <- as.data.frame(expres)
row.names(expres) <- expres$GeneID

expres <- expres %>%
  select(-GeneID,-GeneType) %>%
  t() %>%
  as.data.frame()

row.names(expres) <- gsub("-01A","",row.names(expres))
row.names(expres) <- gsub("-01B","",row.names(expres))

row.names(clinical) <- clinical$submitter_id
clinical$submitter_id <- NULL

uvm <- merge(clinical,expres,by=0)
uvm <- uvm %>%
  mutate(OS = case_when(vital_status==1 ~ "False",
                        vital_status==2 ~ "True"))

row.names(uvm) <- uvm$Row.names
uvm$Row.names <- NULL

write.csv(uvm,file="./data/TPMs_OS_TCGA_UVM.csv")
