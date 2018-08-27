rm(list=ls())
library(tidyverse)
old = theme_set(theme_gray(base_family = "HiraKakuProN-W3"))
library(MASS)
# 推測統計学 -------------------------------------------------------------------

## 相関係数の乱数
rho <- 0.7
SIG <- matrix(c(1,rho,rho,1),nrow=2)
N <- 100

dt <- mvrnorm(N,mu=c(0,0),Sigma = SIG)
dt

dt %>% data.frame() %>% 
  ggplot(aes(x=X1,y=X2))+geom_point() + xlim(-4,4)+ylim(-4,4)


# 帰無仮説の世界 -----------------------------------------------------------------
rho <- 0.0
SIG <- matrix(c(1,rho,rho,1),nrow=2)
N <- 10000

dt <- mvrnorm(N,mu=c(0,0),Sigma = SIG,empirical = TRUE)
dt
cor(dt)

dt %>% data.frame() %>% 
  ggplot(aes(x=X1,y=X2))+geom_point() + xlim(-4,4)+ylim(-4,4)


# 仮説検定 --------------------------------------------------------------------

df <- data.frame(dt)
dplyr::sample_n(df,2)

S1 <- sample_n(df,20)
cor(S1)

S2 <- sample_n(df,20)
cor(S2)

S3 <- sample_n(df,20)
cor(S3)

N = 2000
sz = 20
Sr <- c()
for(i in 1:N){
  Sr <- c(Sr,cor(sample_n(df,sz))[1,2])
}

data.frame(Sr) %>% ggplot(aes(x=Sr))+geom_histogram(binwidth=0.05) + 
  xlab("ランダムにサンプリングした時に出てくる相関係数")+ylab("度数")
data.frame(Sr) %>% ggplot(aes(x=Sr))+geom_density()+ 
  xlab("ランダムにサンプリングした時に出てくる相関係数")+ylab("密度")
  