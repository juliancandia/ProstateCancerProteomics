require(gplots)
require(RColorBrewer)

rm(list=ls())

PROJECT_DIR = "~/git/ProstateCancerProteomics" # replace this line with your local path

race_label_header = c("Af","AA","EA")
race_label = c("Afr","AfrAm","EurAm")
race_col = c(colorRampPalette(brewer.pal(5,"Blues"))(5)[c(1,5)],"darkolivegreen1")
n_race = length(race_label)
model_pval = vector("list",n_race)
coef = vector("list",n_race)
pval = vector("list",n_race)
for (i_race in 1:n_race) {
    infile = file.path(PROJECT_DIR,"RESULTS",paste0(race_label[i_race],"_Fstat_controls.txt"))
    model_pval[[i_race]] = as.matrix(read.table(infile,header=T,stringsAsFactors=F,sep="\t"))
    model_pval[[i_race]] = model_pval[[i_race]][,c(1,3)] # to use adjusted F-stat p-values
    infile = file.path(PROJECT_DIR,"RESULTS",paste0(race_label[i_race],"_coef_controls.txt"))
    coef[[i_race]] = as.matrix(read.table(infile,header=T,stringsAsFactors=F,sep="\t"))
    coef[[i_race]] = coef[[i_race]][,c(1,3,6,9,12,15,18,21)]
    infile = file.path(PROJECT_DIR,"RESULTS",paste0(race_label[i_race],"_pval_controls.txt"))
    pval[[i_race]] = as.matrix(read.table(infile,header=T,stringsAsFactors=F,sep="\t"))
    pval[[i_race]] = pval[[i_race]][,c(1,3,5,7,9,11,13,15)]
}

analyte = model_pval[[1]][,1]
model_pval_all = NULL
pval_all = NULL
for (i_race in 1:n_race) {
    model_pval_all = cbind(model_pval_all,as.numeric(model_pval[[i_race]][,2]))
    pval_all = cbind(pval_all,matrix(as.numeric(pval[[i_race]][,-1]),ncol=ncol(pval[[i_race]])-1))
}
analyte_sel = (apply(model_pval_all<0.05,1,sum)>0)&(apply(pval_all<0.05,1,sum)>0)
analyte = analyte[analyte_sel]
for (i_race in 1:n_race) {
    model_pval[[i_race]] = model_pval[[i_race]][analyte_sel,]
    coef[[i_race]] = coef[[i_race]][analyte_sel,]
    pval[[i_race]] = pval[[i_race]][analyte_sel,]
}

# analyte annotations by biological process
library(readxl)
infile = file.path(PROJECT_DIR,"DATA","Olink markers grouped by biological processes.xlsx")
process = c("Apoptosis or cell killing","Chemotaxis","Metabolism or autophagy","Suppress tumor immunity","Promote tumor immunity","Vascular and tissue remodeling")
n_proc = length(process)
proc_analyte = vector("list",n_proc)
for (i_proc in 1:n_proc) {
    proc_analyte[[i_proc]] = as.matrix(read_excel(infile,sheet=i_proc))[,1]
}
proc_col = grDevices::rainbow(n_proc)
proc_col[1] = "brown"
proc_col[5] = "orange"

var = c("Age","BMI","Education","Aspirin","Smoking","Diabetes","PSA")
n_analyte = length(analyte)
n_var = length(var)
myCol = rev(redblue(11)[c(1,3,5,6,7,9,11)])
myBreaks = c(-3.9,-2.9,-1.9,-0.9,0.9,1.9,2.9,3.9)

res_merged = matrix(rep(0,n_analyte*n_race*n_var),ncol=n_race*n_var)
for (i_race in 1:n_race) {
    res = matrix(rep(0,n_analyte*n_var),ncol=n_var)
    signif_mat = matrix(as.numeric(pval[[i_race]][,-1]),ncol=ncol(pval[[i_race]])-1)
    res[which(signif_mat<0.05,arr.ind=T)] = 1
    res[which(signif_mat<0.01,arr.ind=T)] = 2
    res[which(signif_mat<0.001,arr.ind=T)] = 3
    model_mat = matrix(rep(0,n_analyte*n_var),ncol=n_var)
    model_mat[as.numeric(model_pval[[i_race]][,-1])<0.05,] = rep(1,n_var)
    coef_mat = matrix(as.numeric(coef[[i_race]][,-1]),ncol=ncol(coef[[i_race]])-1)
    sign_mat = matrix(rep(1,n_analyte*n_var),ncol=n_var)
    sign_mat[which(coef_mat<0,arr.ind=T)] = -1
    res = res*sign_mat*model_mat
    for (i_var in 1:n_var) {
        res_merged[,(i_var-1)*n_race+i_race] = res[,i_var]
    }
}
var_labels = rep("",n_race*n_var)
var_labels[seq(2,n_race*n_var,by=3)] = var
rownames(res_merged) = analyte
colnames(res_merged) = var_labels
col_ref = NULL
for (i_var in 1:n_var) {
    col_ref = c(col_ref,race_col)
}
outfile = file.path(PROJECT_DIR,"RESULTS",paste0(paste0(race_label,collapse="_"),".pdf"))
pdf(outfile,width=7,height=5)
for (i_proc in 1:n_proc) {
    row_ref = rep(NA,n_analyte)
    row_ref[analyte%in%proc_analyte[[i_proc]]] = proc_col[i_proc]
    hm <- heatmap.2(res_merged, scale="none", Rowv=F, Colv=F, na.rm=T, na.color="black",
    col = myCol, breaks = myBreaks, dendrogram = "none", key=T, density.info="none", trace="none",
    cexRow=0.35,ColSideColors=col_ref, RowSideColors=row_ref)
}
dev.off()

# characterizing differences
res = vector("list",n_race)
for (i_race in 1:n_race) {
    infile = file.path(PROJECT_DIR,"RESULTS",paste0(race_label[i_race],"_res_controls.txt"))
    res[[i_race]] = as.matrix(read.table(infile,header=T,stringsAsFactors=F,sep="\t"))
    sel = res[[i_race]][,"Analyte"]%in%rownames(res_merged)
    res[[i_race]] = res[[i_race]][sel,]
}
analyte = res[[1]][,"Analyte"]
n_analyte = length(analyte)
n_race_pairs = n_race*(n_race-1)/2
diff = matrix(rep(0,n_analyte*n_var*n_race_pairs),nrow=n_analyte)
for (i_analyte in 1:n_analyte) {
    for (i_var in 1:n_var) {
        race_index = 0
        for (i_race in 1:(n_race-1)) {
            est1 = as.numeric(res[[i_race]][i_analyte,4*(i_var-1)+5])
            se1 = as.numeric(res[[i_race]][i_analyte,4*(i_var-1)+6])
            for (j_race in (i_race+1):n_race) {
                est2 = as.numeric(res[[j_race]][i_analyte,4*(i_var-1)+5])
                se2 = as.numeric(res[[j_race]][i_analyte,4*(i_var-1)+6])
                race_index = race_index + 1
                if (sign(est1-est2+1.96*sqrt(se1**2+se2**2))*sign(est1-est2-1.96*sqrt(se1**2+se2**2))==1) {
                    diff[i_analyte,(i_var-1)*n_race_pairs+race_index] = 1
                }
            }
        }
    }
}

header1 = NULL
for (i_var in 1:n_var) {
    header1 = c(header1,c(var[i_var],rep("",n_race_pairs-1)))
}
header2 = NULL
for (i_race in 1:(n_race-1)) {
    for (j_race in (i_race+1):n_race) {
        header2 = c(header2,paste0(race_label_header[i_race],"-",race_label_header[j_race]))
    }
}
header2 = rep(header2,n_var)

outfile = file.path(PROJECT_DIR,"RESULTS","diff_controls.txt")
output = rbind(c("",header1),c("Analyte",header2),cbind(analyte,diff))
write(t(output),ncol=ncol(output),file=outfile,sep="\t")
