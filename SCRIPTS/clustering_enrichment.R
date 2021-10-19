library(readxl)
library(gplots)
library(RColorBrewer)

rm(list=ls())

PROJECT_DIR = "~/git/ProstateCancerProteomics" # replace this line with your local path

infile = file.path(PROJECT_DIR,"DATA","original_data.xlsx")
data = as.matrix(read_excel(infile,sheet=1))
data = data[data[,"case"]==0,] # we select only controls
race = data[,"race"]
expr = data[,21:102]
feat = colnames(expr)
n_feat = length(feat)
expr = matrix(as.numeric(unlist(expr)),ncol=n_feat)
tail = 0.01
for (i_feat in 1:n_feat) {
    intensity = expr[,i_feat]
    lower_bound = quantile(intensity,probs=tail)
    intensity[intensity<lower_bound] = lower_bound
    upper_bound = quantile(intensity,probs=1-tail)
    intensity[intensity>upper_bound] = upper_bound
    expr[,i_feat] = intensity
}

n_subj = nrow(expr)
dist.mat = matrix(rep(0,n_subj*n_subj),ncol=n_subj)
# we z-score transform gene expression
x = expr
x_col_mean = apply(x,2,mean)
x_col_sd = apply(x,2,sd)
for (i in 1:ncol(x)) {
    x[,i] = (x[,i]-x_col_mean[i])/x_col_sd[i] # data are z-score transformed by col (features)
}

for (i_subj in 1:(n_subj-1)) {
    for (j_subj in (i_subj+1):n_subj) {
        dist.mat[i_subj,j_subj] = 1-cor(x[i_subj,],x[j_subj,])
        dist.mat[j_subj,i_subj] = dist.mat[i_subj,j_subj]
    }
}

hc = hclust(as.dist(dist.mat),method="average")

for (K in 2:3) {
    dt = table(race,cutree(hc, k=K))
    colnames(dt) = paste("cluster",1:K)
    #fisher.pval = fisher.test(dt)$p.value
    #chisq.pval = chisq.test(dt)$p.value
    outfile = file.path(PROJECT_DIR,"RESULTS",paste0("clustering_enrichment_K",K,".pdf"))
    pdf(outfile,width=7,height=5)
    balloonplot(t(dt),main="",xlab="",ylab="",label=T,show.margins=F,dotcolor=brewer.pal(9,"Oranges")[3])
    dev.off()
}
