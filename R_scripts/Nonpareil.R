install.packages("Nonpareil")

library(Nonpareil)

setwd("path/to/data/file")

samples <- read.table('sampleid_name.txt', sep='\t', header=TRUE, as.is=TRUE);
samples$File = paste(samples$Sample, "_paired_1.npo", sep = "")

nps <- Nonpareil.set(samples$File, labels=samples$Name, plot.opts=list(plot.observed=FALSE))
summary(nps)

write.csv(print(nps), file="R-nonpareil-out.csv")
