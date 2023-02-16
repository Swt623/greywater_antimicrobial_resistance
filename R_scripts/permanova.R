# R 3.3.3
library(vegan) #This is vegan 2.4-2

# read in metadata (treat/house information)
sample_info <- read.csv(file = '~/Google Drive/Research/NorthwesternUniversity/Greywater_Metagemonics/Greywater_Data/metadata/sample_info.csv')

# read in data (abundance matrix)
ARO_data <- read.csv(file='~/Google Drive/Research/NorthwesternUniversity/Greywater_Metagemonics/Greywater_Data/ARGs/RGI/ARO_rpkm_summary_strict.csv', row.names = 'ARO.Term')
ARO_data[is.na(ARO_data)] <- 0
ARO_data <- t(ARO_data)
#colnames(ARO_data) = ARO_data[1,]
#ARO_data <- ARO_data[-1,]
#ARO_data <- as.data.frame(ARO_data)
#ARO_data <- lapply(ARO_data, as.numeric)
ARO_data <- as.data.frame(ARO_data)



GeneFamily_data <- read.csv(file = '~/Google Drive/Research/NorthwesternUniversity/Greywater_Metagemonics/Greywater_Data/ARGs/RGI/GeneFamily_rpkm_transpose.csv')
GeneFamily_data <- GeneFamily_data[, -1]

GeneFamily_data <- read.delim('~/Google Drive/Research/NorthwesternUniversity/Greywater_Metagemonics/Greywater_Data/ARGs/RGI/mapq50_filtered/genefamily_summary_rpkm_mapq50.txt')
GeneFamily_data <- t(GeneFamily_data)
colnames(GeneFamily_data) = GeneFamily_data[1,]
GeneFamily_data <- GeneFamily_data[-1,]
GeneFamily_data <- as.data.frame(GeneFamily_data)
GeneFamily_data <- lapply(GeneFamily_data, as.numeric)
GeneFamily_data <- as.data.frame(GeneFamily_data)

GeneFamily_data <- read.csv(file='~/Google Drive/Research/NorthwesternUniversity/Greywater_Metagemonics/Greywater_Data/ARGs/RGI/GeneFamily_rpkm_summary_strict.csv', row.names = 'AMR.Gene.Family')
GeneFamily_data[is.na(GeneFamily_data)] <- 0
GeneFamily_data <- t(GeneFamily_data)
GeneFamily_data <- as.data.frame(GeneFamily_data)


DrugClass_data <- read.csv(file = 'Google Drive/Research/NorthwesternUniversity/Greywater_Metagemonics/Greywater_Data/ARGs/RGI/DrugClass_rpkm_transpose.csv')
DrugClass_data <- DrugClass_data[, -1]

genera_data <- read.csv(file = 'Google Drive/Research/NorthwesternUniversity/Greywater_Metagemonics/Greywater_Data/taxonomy/metaxa2_genera_relab_filtered01_transpose.csv')
genera_data <- genera_data[, -1]

phy_data <- read.csv(file = 'Google Drive/Research/NorthwesternUniversity/Greywater_Metagemonics/Greywater_Data/taxonomy/metaxa2_phylum_relab_filtered01_transpose.csv')
phy_data <- phy_data[, -1]

# overall tests
ARO.div <- adonis(ARO_data ~ Treatment+House, data = sample_info, permutations = 9999, method="euclidean")
# Print p-value for "Treatment" grouping
print(ARO.div$aov.tab["House", "Pr(>F)"])
# p = 0.0115

# distance matrix (class 'dist')
ARO.dist <- vegdist(ARO_data, method="euclidean")

coef <- coefficients(ARO.div)["Treatment1",]
top.coef <- coef[rev(order(abs(coef)))[1:15]]
par(mfrow=c(1,1))
par(mar = c(3, 15, 2, 1))
barplot(sort(top.coef), horiz = T, las = 1, main = "Top ARO")

# overall tests for gene family
GeneFamily.div <- adonis(GeneFamily_data ~ Treatment+House, data = sample_info, permutations = 9999, method="euclidean")
GeneFamily.div <- adonis(GeneFamily_data ~ Treatment, data = sample_info, permutations = 9999, method="euclidean")
# Print p-value for "Treatment" grouping
print(GeneFamily.div$aov.tab["House", "Pr(>F)"])
# p = 0.0238

# distance matrix (class 'dist')
GeneFamily.dist <- vegdist(GeneFamily_data, method="euclidean")

coef <- coefficients(GeneFamily.div)["Treatment1",]
top.coef <- coef[rev(order(abs(coef)))[1:10]]
par(mar = c(3, 20, 2, 1))
barplot(sort(top.coef), horiz = T, las = 1, main = "Top Gene Family")

# overall tests for drug class
DrugClass.div <- adonis(DrugClass_data ~ Treatment+House, data = sample_info, permutations = 9999, method="euclidean")
# Print p-value for "Treatment" grouping
print(DrugClass.div$aov.tab["Treatment", "Pr(>F)"])
# p = 0.1234
# distance matrix (class 'dist')
DrugClass.dist <- vegdist(DrugClass_data, method="euclidean")
# make plot
coef <- coefficients(DrugClass.div)["Treatment1",]
top.coef <- coef[rev(order(abs(coef)))[1:15]]
par(mar = c(3, 40, 2, 1))
barplot(sort(top.coef), horiz = T, las = 1, main = "Top Drug Class")

# overall tests for drug class
genera.div <- adonis(genera_data ~ Treatment+House, data = sample_info, permutations = 9999, method="euclidean")
# Print p-value for "Treatment" grouping
print(genera.div$aov.tab["Treatment", "Pr(>F)"])
# Treatment: p = 0.0798; House: p = 0.0022
# distance matrix (class 'dist')
genera.dist <- vegdist(genera_data, method="euclidean")
# make plot
coef <- coefficients(genera.div)["Treatment1",]
top.coef <- coef[rev(order(abs(coef)))[1:15]]
par(mar = c(3, 15, 2, 1))
barplot(sort(top.coef), horiz = T, las = 1, main = "Top Taxa")


# overall tests for phylum
phy.div <- adonis(phy_data ~ Treatment+House, data = sample_info, permutations = 9999, method="euclidean")
# Print p-value for "Treatment" grouping
print(phy.div$aov.tab["Treatment", "Pr(>F)"])
print(phy.div$aov.tab["House", "Pr(>F)"])
# Treatment: p = 0.1197; House: p = 0.7548
# distance matrix (class 'dist')
phy.dist <- vegdist(phy_data, method="euclidean")
# make plot
coef <- coefficients(phy.div)["Treatment1",]
top.coef <- coef[rev(order(abs(coef)))[1:15]]
par(mar = c(3, 15, 2, 1))
barplot(sort(top.coef), horiz = T, las = 1, main = "Top Phylum")
