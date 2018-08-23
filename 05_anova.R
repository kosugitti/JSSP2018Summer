rm(list=ls())
library(tidyverse)
old = theme_set(theme_gray(base_family = "HiraKakuProN-W3"))
source("http://riseki.php.xdomain.jp/index.php?plugin=attach&refer=ANOVA君&openfile=anovakun_482.txt")

# 分散分析 -------------------------------------------------------------------


## 一要因三水準Between Desgin
df <- data.frame(level=c(rep(1,4),rep(2,4),rep(3,4)),
                 val=c(4,4,3,3,9,8,7,6,7,6,5,4))
anovakun(df,"As",3)

## 一要因三水準Within Desgin
df <- data.frame(A=c(10,9,4,7),B=c(5,4,2,3),C=c(9,5,3,5))
anovakun(df,"sA",3)
