rm(list = ls())
library(tidyverse)
old = theme_set(theme_gray(base_family = "HiraKakuProN-W3"))
library(GGally)
library(summarytools)
library(rstan)
options(mc.cores = parallel::detectCores())
# library(shinystan) library(plotly)
library(gridExtra)
library(loo)
library(bayesplot)



# 事前予測分布と事後予測分布 -----------------------------------------------------------

N <- 1000
theta <- 5
X <- rpois(N,theta)

data.frame(X) %>% 
ggplot(aes(x=X))+geom_histogram(binwidth = 0.5)+
  xlim(0,10) +xlab('データ') +ylab("")


model <- stan_model('00_pre_post.stan')
dataset <- list(N=N,X=X)
fit <- sampling(model,dataset,iter=100000)

rstan::extract(fit,pars='theta_pre') %>% 
  data.frame %>% 
  ggplot(aes(x=theta_pre))+
  geom_histogram(fill='orange',alpha=0.4,binwidth = 0.1) +
  xlim(0,10) +xlab('パラメータの事前分布') +ylab("") -> g1

rstan::extract(fit,pars='pred1') %>% 
  data.frame %>% 
  ggplot(aes(x=pred1))+
  geom_histogram(fill='green',alpha=0.6,binwidth = 0.5) +
  xlim(0,20) +xlab('事前予測分布') +ylab("") -> g2

rstan::extract(fit,pars='theta_post') %>% 
  data.frame %>% 
  ggplot(aes(x=theta_post))+
  geom_histogram(fill='red',alpha=0.4,binwidth = 0.1) +
  xlim(0,10)+xlab('パラメータの事後分布') +ylab("")  -> g3

rstan::extract(fit,pars='pred2') %>% 
  data.frame %>% 
  ggplot(aes(x=pred2))+
  geom_histogram(fill='blue',alpha=0.4,binwidth = 0.5) +
  xlim(0,20) +xlab('事後予測分布') +ylab("") -> g4


# 個別表示
g1
g2
g3
g4
# まとめて表示
grid.arrange(g1, g3, g2, g4, ncol = 2)
