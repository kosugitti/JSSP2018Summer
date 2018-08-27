rm(list=ls())
library(tidyverse)
old = theme_set(theme_gray(base_family = "HiraKakuProN-W3"))
library(MASS)

# 様々な検定 -------------------------------------------------------------------

## 適合度の検定
seikaku <- c(72,48,24,16)
chisq.test(seikaku)

## 独立性の検定
dt <- matrix(c(90,60,40,60),ncol=2)
chisq.test(dt,correct = F)

## 平均値の差の検定

group1 <- c(30,50,70,90,60,50,70,60)
group2 <- c(20,40,60,40,40,50,40,30)
t.test(group1,group2,var.equal = T)

## 対応のある二群

pre <- c(20,44,55,62,50,48,60,45)
post <- c(30,56,68,70,55,64,60,37)
t.test(pre,post,paired = T)

## 平均値の差の検定 w/z Welchの補正

group1 <- c(30,50,70,90,60,50,70,60)
group2 <- c(20,40,60,40,40,50,40,30)
t.test(group1,group2,var.equal = F)
