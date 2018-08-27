546.7500/93.5

80.0833/93.5


pre <- c(34,33,30,34,32,31,29,32,34,31)
post <- c(33,30,33,32,33,33,30,38,35,36)
t.test(pre,post,paired = TRUE)

library(tidyverse)
g1 <- c(7,7,11,10,12)
g2 <- c(8,15,14,17,15)
g3 <- c(11,11,11,12,13)
BD1 <- data.frame(g1,g2,g3) %>%
  tidyr::gather(key,dat)
anovakun(BD1,'As',3,peta=T)

id1 <- c(76,66,85)
id2 <- c(58,60,83)
id3 <- c(70,69,82)
id4 <- c(63,80,75)
id5 <- c(48,76,75)
id6 <- c(56,71,77)
id7 <- c(65,80,85)
id8 <- c(60,78,82)
id9 <- c(60,61,82)
id0 <- c(66,60,74)
WD1 <- data.frame(rbind(id1,id2,id3,id4,id5,
                        id6,id7,id8,id9,id0)) 
anovakun(WD1,'sA',3,peta=TRUE)


dat <-  data.frame(ID = 1:10,
     A  =rep(1:2,each=5),
     B  =c(rep(1,10),rep(2,10)),
     val=c(56,43,75,69,63,31,60,43,27,28,
           37,24,27,25,30,75,85,64,51,56))


anovakun(dat,'AsB',2,2,long=T,peta=T)










