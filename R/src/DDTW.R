sc <- read.table("~/Documents/GitHub/Frequent-Patterns-in-Time-Series/R/data/synthetic_control.data", header = F, sep = "")
# show one sample from each class
#idx <- c(1, 101, 201, 301, 401, 501)
#sample1 <- t(sc[idx,])
#plot.ts(sample1, main="")
library(dtw)

#calculate derivative distance
#new length = old length -2
#no smoothing
rc <- dim(sc)
sc_new <- matrix(0, rc[1], (rc[2]-2) ) 
for (i in 1:rc[1]) {
  for (j in 2:(rc[2]-1) ) {
    sc_new[i,j-1] = ( (sc[i,j]-sc[i,j-1]) + ( (sc[i,j+1]-sc[i,j-1])/2 ) )/2
  }
}

distMatrix <- dist(sc_new, method = "DTW")
hc <- hclust(distMatrix, method = "average")
observedLabels <- rep(1:6, each=100)
plot(hc, labels=observedLabels, main = "")
# cut tree to get 6 clusters
rect.hclust(hc, k = 6)
memb <- cutree(hc, k = 6)
table(observedLabels, memb)
