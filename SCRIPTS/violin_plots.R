rm(list=ls())

PROJECT_DIR = "~/git/ProstateCancerProteomics" # replace this line with your local path

infile = file.path(PROJECT_DIR,"RESULTS","biological_processes_averagezscores_controls.txt")
my_data <- read.table(infile,header=T,check.names=F,stringsAsFactors=F,sep="\t")
library(ggplot2)

#autophagy
my_plot <- ggplot(my_data, aes(x=factor(race), y=autophagy_averagezscore, fill=race))+ geom_violin(trim = FALSE)+ geom_boxplot(width=0.1) + scale_fill_manual(values=c("cadetblue3", "deepskyblue4", "darkolivegreen2"))
outfile = file.path(PROJECT_DIR,"RESULTS","autophagy_averagezscores_controls.tiff")
ggsave (file=outfile)

#apoptosis
my_plot <- ggplot(my_data, aes(x=factor(race), y=apoptosis_averagezscore, fill=race))+ geom_violin(trim = FALSE)+ geom_boxplot(width=0.1) + scale_fill_manual(values=c("cadetblue3", "deepskyblue4", "darkolivegreen2"))
outfile = file.path(PROJECT_DIR,"RESULTS","apoptosis_averagezscores_controls.tiff")
ggsave (file=outfile)

#chemotaxis
my_plot <- ggplot(my_data, aes(x=factor(race), y=chemotaxis_averagezscore, fill=race))+ geom_violin(trim = FALSE)+ geom_boxplot(width=0.1) + scale_fill_manual(values=c("cadetblue3", "deepskyblue4", "darkolivegreen2"))
outfile = file.path(PROJECT_DIR,"RESULTS","chemotaxis_averagezscores_controls.tiff")
ggsave (file=outfile)

#promote TI
my_plot <- ggplot(my_data, aes(x=factor(race), y=promoteTI_averagezscore, fill=race))+ geom_violin(trim = FALSE)+ geom_boxplot(width=0.1) + scale_fill_manual(values=c("cadetblue3", "deepskyblue4", "darkolivegreen2"))
outfile = file.path(PROJECT_DIR,"RESULTS","promoteTI_averagezscores_controls.tiff")
ggsave (file=outfile)

#suppression of TI
my_plot <- ggplot(my_data, aes(x=factor(race), y=suppressTI_averagezscore, fill=race))+ geom_violin(trim = FALSE)+ geom_boxplot(width=0.1) + scale_fill_manual(values=c("cadetblue3", "deepskyblue4", "darkolivegreen2"))
outfile = file.path(PROJECT_DIR,"RESULTS","suppressTI_averagezscores_controls.tiff")
ggsave (file=outfile)

#vasculature
my_plot <- ggplot(my_data, aes(x=factor(race), y=vasculature_averagezscore, fill=race))+ geom_violin(trim = FALSE)+ geom_boxplot(width=0.1) + scale_fill_manual(values=c("cadetblue3", "deepskyblue4", "darkolivegreen2"))
outfile = file.path(PROJECT_DIR,"RESULTS","vasculature_averagezscores_controls.tiff")
ggsave (file=outfile)




