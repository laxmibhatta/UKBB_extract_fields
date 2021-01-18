rm(list=ls())
ukb <- data.table::fread("ukb_project_coffee_lung.txt", header=T, sep=" ", stringsAsFactors=F, fill=T)
write.table(ukb, "ukb_project_coffee_lung.txt", row.names=F, col.names=T, sep="\t", quote=F)
