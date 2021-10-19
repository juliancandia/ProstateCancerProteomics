library(readxl)
library(missForest)
library(eNetXplorer)
if (packageVersion("eNetXplorer")!="1.1.2") {stop("Must run eNetXplorer v1.1.2")}

rm(list=ls())

PROJECT_DIR = "~/git/ProstateCancerProteomics" # replace this line with your local path

# we read in and preprocess the data
infile = file.path(PROJECT_DIR,"DATA","immune markers with survival data.xlsx")
data = as.matrix(read_excel(infile,sheet=1)) # 819 subjects
clin_demo = matrix(as.numeric(data[,3:10]),ncol=8)
analyte = matrix(as.numeric(data[,15:96]),ncol=82)
time = as.numeric(data[,14])
status = as.numeric(data[,11])
y = cbind(time,status)

feat = colnames(data)[c(3:10,15:96)]
x = cbind(clin_demo,analyte)
feat = feat[-c(1,3)] # we remove features with too many missing values
x = x[,-c(1,3)]
n_feat = length(feat)
set.seed(123) # to make imputation reproducible
x = missForest(x)$ximp # to impute missing values
rownames(x) = trimws(data[,"TemporaryID"])
colnames(x) = feat

#group = c("All")
group = c("AfrAm")
#group = c("EurAm")
n_group = length(group)

for (i_group in 1:n_group) {
    if (group[i_group]=="All") {
        sel = rep(T,nrow(data))
    } else if (group[i_group]=="EurAm") {
        sel = data[,"race"]=="European American"
    } else if (group[i_group]=="AfrAm") {
        sel = data[,"race"]=="African American"
    }
    y0 = y[sel,]
    x0 = x[sel,]
    # we z-score transform all variables
    x0_col_mean = apply(x0,2,mean)
    x0_col_sd = apply(x0,2,sd)
    for (i in 1:ncol(x0)) {
        x0[,i] = (x0[,i]-x0_col_mean[i])/x0_col_sd[i] # data are z-score transformed by column
    }
    dest_label = group[i_group]
    dest_dir = file.path(PROJECT_DIR,"RESULTS",dest_label)
    fit = eNetXplorer(x=x0,y=y0,family="cox",alpha=seq(0,1,by=0.2),n_run=500,n_perm_null=125,seed=123, save_obj=T,dest_dir=dest_dir,dest_obj=paste0("eNet_",dest_label,".Robj"))
    summaryPDF(fit,dest_dir=dest_dir,dest_file=paste0("eNet_",dest_label,".pdf"))
    export(fit,dest_dir=dest_dir)
}
