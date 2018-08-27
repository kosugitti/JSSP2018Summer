rm(list = ls())

# パッケージの装備 ----------------------------------------------------------------

# データ整形汎用パッケージ
library(tidyverse)
# MCMC乱数発生器stanをRからつかうパッケージ
library(rstan)
# rstanを並列で使うオプション
options(mc.cores = parallel::detectCores())
# データ要約・可視化パッケージ
library(summarytools)
# 複数のグラフを並べて表示するパッケージ
library(gridExtra)
library(GGally)
# ベイズモデル比較指標計算パッケージ
library(loo)
# ベイズモデルの結果を可視化するパッケージ
library(bayesplot)
# 描画の際に文字化けするMacユーザは次の行のコメントアウトをとって実行する
#old = theme_set(theme_gray(base_family = "HiraKakuProN-W3"))

# サンプルデータの準備 --------------------------------------------------------------

bs <- read_csv("baseball.csv") %>% mutate(Name = as.factor(Name), 
                                          team = as.factor(team), 
                                          position = as.factor(position), 
                                          bloodType = as.factor(bloodType), 
                                          throw.by = as.factor(throw.by), 
                                          batting.by = as.factor(batting.by))
view(dfSummary(bs))
dfSummary(bs)
bs %>% filter(position != "投手") %>% 
  dplyr::select(salary,years, height, weight) %>% ggpairs()

bs %>% filter(position == "投手") %>% 
  dplyr::select(salary,years, height, weight) %>% ggpairs()
