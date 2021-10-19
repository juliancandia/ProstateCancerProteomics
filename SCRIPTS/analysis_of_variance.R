rm(list=ls())

PROJECT_DIR = "~/git/ProstateCancerProteomics" # replace this line with your local path

infile = file.path(PROJECT_DIR,"DATA","WestAfrAncestry_NCIMDcontrols.txt")
data = as.matrix(read.table(infile,header=T,check.names=F,stringsAsFactors=F,sep="\t"))

# analysis_of_variance
explanatory_vars = c("WestAfr")
param = colnames(data)[3:84]
n_param = length(param)
myFormula = as.formula(paste0("obs ~ ",paste(explanatory_vars,collapse="+")))
anova_res = NULL
for (i_param in 1:n_param) {
  myDataFrame = data.frame(as.numeric(data[,param[i_param]]),data[,explanatory_vars])
  colnames(myDataFrame) = c("obs",explanatory_vars)
  aov.fit = aov(myFormula,data=myDataFrame)
  ss = summary(aov.fit)[[1]]["Sum Sq"][[1]] # Sum-of-Squares
  anova_res = rbind(anova_res,ss/sum(ss))
}

outfile = file.path(PROJECT_DIR,"RESULTS","analysis_of_variance.pdf")
pdf(file=outfile,width=7,height=5)

# Plot: analysis_of_variance
x = 1:n_param
xrange = range(x)
yrange = c(0,1)
plot(xrange,yrange,type="n",xlab="",ylab="variance fraction",xaxt="n",cex.lab=1)
title(main="Variance explained by degree of West African ancestry",cex.main=1,line=1)
#title(main=paste0("[",measure_title[i_measure],"]"),cex.main=0.85,line=1)
axis(side=1,at=x,labels=param,las=2,cex.axis=0.35) # tck=-0.005
anova_txt = c(explanatory_vars,"residual")
anova_col = c("blue","grey")
anova_pch = c(16,1)
for (i in 1:length(anova_txt)) {
  points(x,anova_res[,i],cex=1,col=anova_col[i],lty=2,type="b",lwd=2,pch=anova_pch[i])
}
x_legend = xrange[1] + (xrange[2]-xrange[1])*0.7
y_legend = yrange[1] + (yrange[2]-yrange[1])*0.85
legend_txt = anova_txt
legend_pch = anova_pch
legend_lwd = 2
legend_lty = 2
legend_col = anova_col
legend_text_size = 0.85
legend_symbol_size = 0.85
legend(x_legend,y_legend,legend_txt,pch=legend_pch,lwd=legend_lwd,col=legend_col,lty=legend_lty,
       cex=legend_text_size,pt.cex=legend_symbol_size)

dev.off()
