library(readxl)

rm(list=ls())

PROJECT_DIR = "~/git/ProstateCancerProteomics" # replace this line with your local path

infile = file.path(PROJECT_DIR,"DATA","original_data.xlsx")
data = as.matrix(read_excel(infile,sheet=1))

analyte_index = 21:ncol(data)
analyte_label = colnames(data[,analyte_index])
n_analyte = length(analyte_label)
analyte_all = matrix(as.numeric(data[,analyte_index]),ncol=n_analyte)
for (study in c("NCI-MD","Ghana")) {
    if (study=="NCI-MD") {
        var_index = c(6,8,9,16,14,17,18)
        race_label = c("AfrAm","EurAm")
        race = c("African American","European American")
    } else if (study=="Ghana") {
        var_index = c(6,8,11,16,14,17,18)
        race_label = "Afr"
        race = "African"
    }
    var = colnames(data[,var_index])
    n_var = length(var)
    var_label = c("Age","BMI","Education","Aspirin","Smoking","Diabetes","PSA")
    n_race = length(race)
    for (i_race in 1:n_race) {
        select = (data[,"race"]==race[i_race])&(data[,"case"]==0)
        tmp = data[select,var_index]
        analyte = analyte_all[select,]
        tmp = matrix(as.numeric(tmp),ncol=ncol(tmp))
        remove = unique(which(is.na(tmp),arr.ind=T)[,1])
        # "drastic/conservative" approach, we don't impute but remove all instances with missing data
        democlin = tmp[-remove,]
        analyte = analyte[-remove,]
        colnames(democlin) = var
        colnames(analyte) = analyte_label
        mydata = data.frame(cbind(democlin,analyte))
        coef = matrix(rep(NA,n_analyte*3*n_var),ncol=3*n_var)
        pval = matrix(rep(NA,n_analyte*2*n_var),ncol=2*n_var)
        Fstat = rep(NA,n_analyte)
        res = matrix(rep(NA,n_analyte*(4*n_var+3)),ncol=(4*n_var+3))
        for (i_analyte in 1:n_analyte) {
            myformula = as.formula(paste0(analyte_label[i_analyte],"~",paste0(var,collapse="+")))
            fit = lm(myformula,mydata)
            coef[i_analyte,] = as.numeric(t(cbind(confint(fit,level=0.95)[-1,1],coef(summary(fit))[-1,1],confint(fit,level=0.95)[-1,2])))
            p = coef(summary(fit))[-1,4]
            padj = p.adjust(p,method="fdr")
            pval[i_analyte,] = as.numeric(t(cbind(p,padj)))
            Fstat[i_analyte] = 1 - pf(summary(fit)$fstatistic[1], summary(fit)$fstatistic[2], summary(fit)$fstatistic[3])
            res[i_analyte,1] = summary(fit)$fstatistic[1]
            res[i_analyte,2] = Fstat[i_analyte]
            for (i_var in 1:n_var) {
                res[i_analyte,4*(i_var-1)+4] = coef(summary(fit))[i_var+1,1]
                res[i_analyte,4*(i_var-1)+5] = coef(summary(fit))[i_var+1,2]
                res[i_analyte,4*(i_var-1)+6:7] = pval[i_analyte,2*(i_var-1)+1:2]
            }
        }
        res[,3] = p.adjust(as.numeric(res[,2]),method="fdr")
        outfile = file.path(PROJECT_DIR,"RESULTS",paste0(race_label[i_race],"_res_controls.txt"))
        header = c("Fstat","Fstat.pval","Fstat.pval.adj")
        for (i_var in 1:n_var) {
            header = c(header,paste0(var_label[i_var],".",c("est","se","pval","pval.adj")))
        }
        output = rbind(c("Analyte",header),cbind(analyte_label,res))
        write(t(output),ncol=ncol(output),file=outfile,sep="\t")
        
        outfile = file.path(PROJECT_DIR,"RESULTS",paste0(race_label[i_race],"_Fstat_controls.txt"))
        output = rbind(c("analyte","Fstat.pval","Fstat.pval.adj"),cbind(analyte_label,Fstat,p.adjust(Fstat,method="fdr")))
        write(t(output),ncol=ncol(output),file=outfile,sep="\t")
        
        outfile = file.path(PROJECT_DIR,"RESULTS",paste0(race_label[i_race],"_coef_controls.txt"))
        header = NULL
        for (i_var in 1:n_var) {
            header = c(header,paste0(var[i_var],"_",c("l","m","u")))
        }
        output = rbind(c("analyte",header),cbind(analyte_label,coef))
        write(t(output),ncol=ncol(output),file=outfile,sep="\t")
        
        outfile = file.path(PROJECT_DIR,"RESULTS",paste0(race_label[i_race],"_pval_controls.txt"))
        header = NULL
        for (i_var in 1:n_var) {
            header = c(header,paste0(var[i_var],"_",c("pval","pval.adj")))
        }
        output = rbind(c("analyte",header),cbind(analyte_label,pval))
        write(t(output),ncol=ncol(output),file=outfile,sep="\t")
    }
}


