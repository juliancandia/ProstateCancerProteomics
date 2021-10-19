library(readxl)

rm(list=ls())

PROJECT_DIR = "~/git/ProstateCancerProteomics" # replace this line with your local path

infile = file.path(PROJECT_DIR,"DATA","Table 1 statistics.xlsx")
AA = as.matrix(read_excel(infile,sheet=2))
EA = as.matrix(read_excel(infile,sheet=3))

n = 3
diff = rep(0,n)
for (i in 1:3) {
    est1 = as.numeric(AA[i+1,2])
    se1 = as.numeric(AA[i+1,3])
    est2 = as.numeric(EA[i+1,2])
    se2 = as.numeric(EA[i+1,3])
    if (sign(est1-est2+1.96*sqrt(se1**2+se2**2))*sign(est1-est2-1.96*sqrt(se1**2+se2**2))==1) {
        diff[i] = 1
    }
}
