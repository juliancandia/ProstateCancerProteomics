library(readxl)

rm(list=ls())

PROJECT_DIR = "~/git/ProstateCancerProteomics" # replace this line with your local path

infile = file.path(PROJECT_DIR,"DATA","original_data.xlsx")
data = as.matrix(read_excel(infile,sheet=1))

tail = 0.01
group = "controls_only" #c("cases_only","controls_only","all")
analyte_cols = 21:ncol(data)
n_analyte = length(analyte_cols)

if (group=="cases_only") {
  select = data[,"case"]==1
} else if (group=="controls_only") {
  select = data[,"case"]==0
} else if (group=="all") {
  select = rep(T,nrow(data))
}
for (i_analyte in 1:n_analyte) {
  intensity = as.numeric(data[select,analyte_cols[i_analyte]])
  lower_bound = quantile(intensity,probs=tail)
  intensity[intensity<lower_bound] = lower_bound
  upper_bound = quantile(intensity,probs=1-tail)
  intensity[intensity>upper_bound] = upper_bound
  data[select,analyte_cols[i_analyte]] = intensity
}

outfile = file.path(PROJECT_DIR,"RESULTS","original_data_outliers_removed.txt")
output = rbind(colnames(data),data)
write(t(output),ncol=ncol(output),file=outfile,sep="\t")
