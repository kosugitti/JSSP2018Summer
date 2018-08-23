rm(list=ls())
library(tidyverse)
old = theme_set(theme_gray(base_family = "HiraKakuProN-W3"))
# 推測統計学 -------------------------------------------------------------------

## 乱数の発生
set.seed(2018)
rnorm(10,mean=50,sd=10)

rnorm(100,mean=50,sd=10)



# 世界がもし100人の村だったら ---------------------------------------------------------

village <- rnorm(100,mean=50,sd=10)
### 母平均
mean(village)

### ランダムに10個抜き出す

S1 <- sample(village,size=10)
S1
mean(S1)

S2 <- sample(village,size=10)
S2
mean(S2)

S3 <- sample(village,size=10)
S3
mean(S3)

(mean(S1)+mean(S2)+mean(S3))/3



# 推測統計学の原理 ----------------------------------------------------------------

N <- 200
Sz <- 10

Sset <- c()
estM <- c()
for(i in 1:N){
  Sset <- c(Sset,mean(sample(village,Sz)))
  estM <- c(estM,mean(Sset))
}

data.frame(estM) %>% mutate(id=1:N) %>% 
  ggplot(aes(x=id,y=estM)) + geom_point() + geom_line() +
  ylim(40,60) + geom_hline(yintercept = mean(village),color='red') +
  xlab("サンプル数") + ylab("平均値の平均値")


# 標準誤差 --------------------------------------------------------------------

ggplot() + geom_histogram(aes(x=village),binwidth=1,alpha=0.7)+
  geom_histogram(aes(x=Sset),binwidth=1,alpha=0.5,fill='blue') +
  xlim(20,80) + xlab("") + ylab("度数")



# 分散の推定 -------------------------------------------------------------------


VAR <- function(x){
  return(sum((x-mean(x))^2)/length(x))
}

#### 母分散
VAR(village)

#### 標本分散
VAR(S1)

#### 不偏分散
var(S1)

## 分散の推定値
N <- 500
Sz <- 10

Vset <- c()
vset <- c()
estV <- c()
estv <- c()
for(i in 1:N){
  tmp <- sample(village,Sz)
  Vset <- c(Vset,VAR(tmp))
  vset <- c(vset,var(tmp))
  estV <- c(estV,mean(Vset))
  estv <- c(estv,mean(vset))
}

data.frame(estV,estv) %>% mutate(id=1:N) %>% 
  tidyr::gather(key,value,-id,factor_key = T) %>% 
  ggplot(aes(x=id,y=value,group=key,color=key)) + geom_point() + geom_line() +
  geom_hline(yintercept = VAR(village),color='red') +
  xlab("サンプル数") + ylab("分散の平均値")

