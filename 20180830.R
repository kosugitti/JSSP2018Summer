library(tidyverse)
library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)
library(summarytools)
library(gridExtra)
library(GGally)
library(loo)
old = theme_set(theme_gray(base_family = "HiraKakuProN-W3"))


x100 <-  rnorm(100,0,1)
x1000 <-  rnorm(1000,0,1)
x10000 <-  rnorm(10000,0,1)
x100000 <-  rnorm(100000,0,1)

# データをデータフレームにまとめる
data.frame(class=c(rep(1,NROW(x100)),
                   rep(2,NROW(x1000)),
                   rep(3,NROW(x10000)),
                   rep(4,NROW(x100000))),
           value=c(x100,x1000,x10000,x100000)) %>% print %>% 
  # グループ名を作る変数を作成
  mutate(class=as.factor(class)) %>% print %>% 
  # 作図。x軸は値。グループごとに分けたヒストグラム
  ggplot(aes(x=value,fill=class))+geom_histogram(binwidth = 0.1)+xlim(-4,4)+
  facet_wrap(~class,scales = "free")
