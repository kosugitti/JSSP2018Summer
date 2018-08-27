rm(list = ls())
library(tidyverse)
old = theme_set(theme_gray(base_family = "HiraKakuProN-W3"))
library(GGally)
library(summarytools)
library(rstan)
options(mc.cores = parallel::detectCores())
# library(shinystan)
library(plotly)
library(gridExtra)
library(loo)
library(bayesplot)

# 読み込みと下処理
# ----------------------------------------------------------------
bs <- read_csv("baseball.csv") %>% mutate(Name = as.factor(Name), 
  team = as.factor(team), position = as.factor(position), bloodType = as.factor(bloodType), 
  throw.by = as.factor(throw.by), batting.by = as.factor(batting.by))
pokemon <- read_csv("pokemon.csv") %>% mutate(ID = as.factor(ID), 
  Name = as.factor(Name), Type1 = as.factor(Type1), Type2 = as.factor(Type2), 
  Legendary = as.factor(Legendary))
# 基本的な分布の確認
# ---------------------------------------------------------------

view(dfSummary(bs))
view(dfSummary(pokemon))

bs %>% filter(position != "投手") %>% dplyr::select(salary, 
  years, height, weight) %>% ggpairs()

bs %>% filter(position == "投手") %>% dplyr::select(salary, 
  years, height, weight) %>% ggpairs()

pokemon %>% select(-ID, -Name, -Type1, -Type2) %>% ggpairs()

# 分析開始
# --------------------------------------------------------------------


# 一変量の推定 平均身長
height <- bs %>% select(height) %>% na.omit() %>% unlist()
model01 <- stan_model("01_normal.stan")
dataset <- list(N = NROW(height), X = height)
fit01 <- sampling(model01, data = dataset, warmup = 1000, iter = 2000, 
  chains = 4)
# 結果の確認
fit01

# MCMCサンプルの取り出し
fit01.mcmc <- rstan::extract(fit01, pars = c("mu", "sig")) %>% 
  as.data.frame()
# サンプルの長さを確認
NROW(fit01.mcmc)
# 事後分布
fit01.mcmc %>% ggplot(aes(x = mu)) + geom_histogram(binwidth = 0.01)
fit01.mcmc %>% ggplot(aes(x = sig)) + geom_histogram(binwidth = 0.01)
# 同時分布
gg <- fit01.mcmc %>% ggplot(aes(x = mu, y = sig)) + geom_point()
ggplotly(gg)
x_c <- fit01.mcmc$mu %>% cut(., 50)
y_c <- fit01.mcmc$sig %>% cut(., 50)
z <- table(x_c, y_c)
# 一括実行の時にバグる plot_ly(z=z,type='surface')

# 本当は事前分布を入れたほうがいい
model02 <- stan_model("02_normal.stan")
fit02 <- sampling(model02, data = dataset, warmup = 1000, iter = 2000, 
  chains = 4)
# 結果の確認
fit02
# MCMCサンプルの取り出し
fit02.mcmc <- rstan::extract(fit02, pars = c("mu", "sig")) %>% 
  as.data.frame()
# サンプルの長さを確認
NROW(fit02.mcmc)
# 事後分布
fit02.mcmc %>% ggplot(aes(x = mu)) + geom_histogram(binwidth = 0.01)
fit02.mcmc %>% ggplot(aes(x = sig)) + geom_histogram(binwidth = 0.01)
# 同時分布
gg <- fit02.mcmc %>% ggplot(aes(x = mu, y = sig)) + geom_point()
ggplotly(gg)
x_c <- fit02.mcmc$mu %>% cut(., 50)
y_c <- fit02.mcmc$sig %>% cut(., 50)
z <- table(x_c, y_c)
# plot_ly(z=z,type='surface')


## 平均体重(事前予測分布，事後予測分布)
weight <- bs %>% select(weight) %>% na.omit() %>% unlist()
dataset <- list(N = NROW(weight), X = weight)
fit01a <- sampling(model01, data = dataset, warmup = 2000, iter = 5000, 
  chains = 4)
# 結果の確認
fit01a

model03 <- stan_model("03_normal.stan")
fit03 <- sampling(model03, data = dataset, warmup = 2000, iter = 5000, 
  chains = 4)
# 結果の確認
fit03

## 描画して確認
fit03.mcmc <- rstan::extract(fit03, pars = c("mu", "sig", "mu_pre", 
  "sig_pre", "pred1", "pred2")) %>% as.data.frame()
### 事前分布
g1 <- fit03.mcmc %>% select(mu_pre, sig_pre) %>% gather(key, 
  val, factor_key = T) %>% ggplot(aes(x = val, color = key, 
  fill = key)) + geom_histogram(binwidth=5) + facet_wrap(~key, scales = "free")
### 事前予測分布
g2 <- fit03.mcmc %>% select(pred1) %>% ggplot(aes(x = pred1)) + 
  geom_histogram(binwidth=5)
### 事後分布
g3 <- fit03.mcmc %>% select(mu, sig) %>% gather(key, val, factor_key = T) %>% 
  ggplot(aes(x = val, color = key, fill = key)) + geom_histogram(binwidth=5) + 
  facet_wrap(~key, scales = "free")
### 事後予測分布
g4 <- fit03.mcmc %>% select(pred2) %>% ggplot(aes(x = pred2)) + 
  geom_histogram(binwidth=5)


# 個別表示
g1
g2
g3
g4
# まとめて表示
grid.arrange(g1, g2, g3, g4, ncol = 2)

## 平均年俸ーおや，分布が違うぞ
bs %>% select(salary) %>% ggplot(aes(x = salary)) + geom_histogram(binwidth = 1000)
sal <- bs %>% select(salary) %>% na.omit() %>% unlist()
dataset <- list(N = NROW(sal), X = sal, Lower = 0, Upper = 1e+06)
model04 <- stan_model("04_normal.stan")
fit04 <- sampling(model04, dataset)
fit04
mean(bs$salary, na.rm = T)
## 描画して確認
fit04.mcmc <- rstan::extract(fit04, pars = c("mu", "sig", "mu_pre", 
  "sig_pre", "pred1", "pred2")) %>% as.data.frame()
### 事前分布
g1 <- fit04.mcmc %>% select(mu_pre, sig_pre) %>% gather(key, 
  val, factor_key = T) %>% ggplot(aes(x = val, color = key, 
  fill = key)) + geom_histogram() + facet_wrap(~key, scales = "free")
### 事前予測分布
g2 <- fit04.mcmc %>% select(pred1) %>% ggplot(aes(x = pred1)) + 
  geom_histogram()
### 事後分布
g3 <- fit04.mcmc %>% select(mu, sig) %>% gather(key, val, factor_key = T) %>% 
  ggplot(aes(x = val, color = key, fill = key)) + geom_histogram() + 
  facet_wrap(~key, scales = "free")
### 事後予測分布
g4 <- fit04.mcmc %>% select(pred2) %>% ggplot(aes(x = pred2)) + 
  geom_histogram()
# 個別表示
g1
g2
g3
g4
# まとめて表示
grid.arrange(g1, g2, g3, g4, ncol = 2)

data.frame(val = c(bs$salary, fit04.mcmc$pred2), key = factor(c(rep(1, 
  NROW(bs)), rep(2, NROW(fit3.mcmc))), labels = c("data", "post pred. dist."))) %>% 
  ggplot(aes(x = val, fill = key)) + geom_histogram(binwidth = 1000, 
  alpha = 0.5)
# geom_density(alpha=0.5)+ theme(legend.position = 'none')
# facet_wrap(~key,scales='free')

# 対数正規分布モデルに変える
model05 <- stan_model("05_lognormal.stan")
fit05 <- sampling(model05, dataset)
fit05.mcmc <- rstan::extract(fit05, pars = c("mu", "sig", "pred1")) %>% 
  data.frame()
g1 <- fit05.mcmc %>% ggplot(aes(x = pred1)) + geom_histogram(binwidth = 1000) + 
  xlim(0, 50000) + xlab("事後予測分布")
g2 <- bs %>% select(salary) %>% ggplot(aes(x = salary)) + geom_histogram(binwidth = 1000) + 
  xlim(0, 50000) + xlab("データ分布")
grid.arrange(g2, g1, ncol = 2)

summary(bs$salary)
summary(fit3k.mcmc$pred1)
# 対数正規分布の平均値
fit05
fit05.mcmc$mu %>% exp %>% mean

#### 適当な確率分布でなければならないことがわかったところで
#### 打率の推定
df <- bs %>% filter(position != "投手") %>% select("打数", 
  "安打", "打率") %>% na.omit()
df %>% ggplot(aes(x = 打率)) + geom_histogram(binwidth = 0.01)
dataset <- list(L = NROW(df), N = df$打数, X = df$安打)
model06 <- stan_model("06_binomial.stan")
fit06 <- sampling(model06, dataset)
fit06
summary(df$打率)



# 二つの変数と平均の差の検定
# -----------------------------------------------------------


## 身長と体重の相関
df <- bs %>% select("height", "weight") %>% na.omit()
df %>% ggplot(aes(x = height, y = weight)) + geom_point()
cor(df)
dataset <- list(L = NROW(df), X = df)
model07 <- stan_model("07_corr.stan")
fit07 <- sampling(model07, dataset)
fit07

# 二変数の推定 セリーグとパリーグの体格差
Cleague <- c("Carp", "DeNA", "Dragons", "Giants", "Swallows", 
  "Tigers")
df <- bs %>% mutate(league = factor(ifelse(team %in% Cleague, 
  1, 2), labels = c("C", "P"))) %>% select("weight", "league") %>% 
  na.omit()
df %>% ggplot(aes(x = weight, group = league, fill = league)) + 
  geom_histogram(binwidth = 2, alpha = 0.5)

var.test(weight ~ league, data = df)
t.test(weight ~ league, data = df)

model08 <- stan_model("08_ttest.stan")
dataset <- list(N1 = NROW(df[df$league == "C", ]), N2 = NROW(df[df$league == 
  "P", ]), X1 = unlist(df[df$league == "C", "weight"]), X2 = unlist(df[df$league == 
  "P", "weight"]))
fit08 <- sampling(model08, dataset)
fit08
plot(fit08, pars = c("mu1", "mu2"), show_density = TRUE)

rstan::extract(fit08, pars = c("mu1", "mu2")) %>% data.frame %>% 
  gather(key, val, factor_key = TRUE) %>% ggplot(aes(x = val, 
  group = key, fill = key)) + geom_histogram(binwidth = 0.01, 
  alpha = 0.5)

# 差の分布
model09 <- stan_model("09_ttest.stan")
fit09 <- sampling(model09, dataset)
fit09

rstan::extract(fit09, pars = "d") %>% data.frame() %>% ggplot(aes(x = d)) + 
  geom_density()

# 差があるかないかだけが大事か？1kgの違いって意味あるか？

## 様々な仮説を検討することができる
df <- rstan::extract(fit09, pars = "d") %>% data.frame

NROW(df[df$d > 0, ])/NROW(df)
NROW(df[(df$d > -2) & (df$d < (-1)), ])/NROW(df)

## セリーグとパリーグの年俸差
df <- bs %>% mutate(league = factor(ifelse(team %in% Cleague, 
  1, 2), labels = c("C", "P"))) %>% select("salary", "league") %>% 
  na.omit()
model10 <- stan_model("10_log_ttest.stan")
dataset <- list(N1 = NROW(df[df$league == "C", ]), N2 = NROW(df[df$league == 
  "P", ]), X1 = unlist(df[df$league == "C", "salary"]), X2 = unlist(df[df$league == 
  "P", "salary"]))
fit10 <- sampling(model10, dataset)
fit10


## 多群の比較
df <- bs %>% select("team", "salary") %>% na.omit()
df %>% ggplot(aes(x = team, y = salary, group = team, fill = team)) + 
  stat_summary(fun.y = mean, geom = "bar") + coord_flip()
dataset <- list(L = NROW(df), G = max(as.numeric(df$team)), team = as.integer(df$team), 
  X = df$salary)
model11 <- stan_model("11_log_mean.stan")
fit11 <- sampling(model11, dataset)
print(fit11)

# 回帰分析
# --------------------------------------------------------------------

bs %>% dplyr::select("weight", "height") %>% ggplot(aes(x = weight, 
  y = height)) + geom_point()
df <- bs %>% dplyr::select("weight", "height") %>% na.omit
summary(lm(height ~ weight, data = df))
dataset <- list(L = NROW(df), X = df$weight, Y = df$height)
model12 <- stan_model("12_regression.stan")
fit12 <- sampling(model12, dataset)
print(fit12, pars = c("beta_0", "beta_1", "sigma"))
plot(fit12,pars=c("sigma"),show_density=T)
bayesplot::mcmc_dens(as.array(fit12), pars = c("beta_0", "beta_1", "sigma"))

# 事後予測分布
pred <- rstan::extract(fit12, pars = "pred") %>% data.frame() %>% 
  tidyr::gather(key, val, factor_key = T) %>% dplyr::group_by(key) %>% 
  dplyr::summarize(EAP = mean(val))
data.frame(weight = df$weight, height = df$height, pred = pred$EAP) %>% 
  tidyr::gather(key, val, -weight, factor_key = T) %>% ggplot(aes(x = weight, 
  y = val, color = key)) + geom_point()
# R2
(cor(df$height, pred$EAP))^2
rstan::extract(fit12, pars = "log_lik")$log_lik %>% loo()



# 一般化線形モデル
# ----------------------------------------------------------------

## ピッチャーの勝利！ 1勝はしてる人で
df <- bs %>% filter(position == "投手" & 勝利 > 0) %>% dplyr::select("勝利", 
  "salary") %>% na.omit() %>% mutate(salary.z = as.numeric(scale(salary)))
df %>% ggplot(aes(x = 勝利)) + geom_histogram(binwidth = 1)
table(df$勝利)


df %>% ggplot(aes(y = 勝利, x = salary.z)) + geom_point() + 
  geom_smooth(method = "lm", se = F)
# 普通の回帰分析だとダメ
result.lm <- lm(勝利 ~ salary.z, data = df)
hist(result.lm$residuals)
plot(result.lm)


# 事後予測分布
dataset <- list(L = NROW(df), X = df$salary.z, Y = df$勝利)
fit12 <- sampling(model12, dataset)
pred <- rstan::extract(fit12, pars = "pred") %>% data.frame() %>% 
  tidyr::gather(key, val, factor_key = T) %>% dplyr::group_by(key) %>% 
  dplyr::summarize(EAP = mean(val))
data.frame(win = df$勝利, pred = pred$EAP) %>% tidyr::gather(key, 
  val, factor_key = T) %>% ggplot(aes(x = val, fill = key)) + 
  geom_histogram(binwidth = 0.1)

## ポアソン回帰
dataset <- list(L = NROW(df), X = df$salary.z, Y = df$勝利)
model13 <- stan_model("13_pois_reg.stan")
fit13 <- sampling(model13, dataset)
print(fit13, pars = c("beta_0", "beta_1"))

# 専用の関数も
model14 <- stan_model("14_poislog_reg.stan")
fit14 <- sampling(model14, dataset)
print(fit14, pars = c("beta_0", "beta_1"))

rstan::extract(fit14, pars = "pred") %>% data.frame() %>% tidyr::gather(key, 
  val, factor_key = T) %>% group_by(key) %>% summarize(median = median(val)) %>% 
  cbind(., df$勝利) %>% gather(key2, val, -key, factor_key = T) %>% 
  ggplot(aes(x = val, fill = key2)) + geom_histogram(binwidth = 0.1, 
  alpha = 0.6) + facet_wrap(~key2)

## 負の二項分布
model15 <- stan_model("15_nb.stan")
fit15 <- sampling(model15, dataset)
print(fit15, pars = c("beta_0", "beta_1", "phi"))


## 専用の関数も
model16 <- stan_model("16_nb2.stan")
fit16 <- sampling(model16, dataset)
print(fit16, pars = c("beta_0", "beta_1", "phi"))


rstan::extract(fit16, pars = "pred") %>% data.frame() %>% tidyr::gather(key, 
  val, factor_key = T) %>% group_by(key) %>% summarize(median = median(val)) %>% 
  cbind(., df$勝利) %>% gather(key2, val, -key, factor_key = T) %>% 
  ggplot(aes(x = val, fill = key2)) + geom_histogram(binwidth = 0.1, 
  alpha = 0.6) + facet_wrap(~key2)

# 階層線形モデル
# -----------------------------------------------------------------

## グラウンドに銭は埋まっているか（チームごとの階層
bs %>% filter(position != "投手") %>% select("salary", "本塁打", 
  "team") %>% na.omit() %>% ggplot(aes(x = 本塁打, y = salary, 
  color = team)) + geom_point() + geom_smooth(method = "lm", 
  se = F)

df <- bs %>% filter(position != "投手") %>%
  select("salary","本塁打", "team") %>% na.omit() %>%
  mutate(salary.z = as.numeric(scale(salary)))

# 普通の回帰分析
dataset <- list(L = NROW(df), X = df$本塁打, Y = df$salary)
model12 <- stan_model("12_regression.stan")
fit12 <- sampling(model12, dataset)
print(fit12, pars = c("beta_0", "beta_1", "sigma"))
## チームによって傾きは違う
dataset <- list(L=NROW(df),X=df$本塁打, Y=df$salary,
                G=12, Idx=as.numeric(df$team))
model17 <- stan_model('17_HLM.stan')
fit17 <- sampling(model17,dataset)
print(fit17,pars=c("beta_0","beta_1"))
rstan::extract(fit17,pars='pred') %>% data.frame() %>% 
  tidyr::gather(key,val,factor_key=T) %>% 
  group_by(key) %>% 
  summarize(EAP=mean(val)) %>% 
  cbind(.,df) %>% select('EAP','salary','team') %>% 
  ggplot(aes(x=salary,y=EAP,color=team))+geom_point()+
  facet_wrap(~team)

## 階層化
model18 <- stan_model('18_HLM.stan')
fit18 <- sampling(model18,dataset)
print(fit18,pars=c("beta_0","mu_beta1","tau"))
rstan::extract(fit18,pars='pred') %>% data.frame() %>% 
  tidyr::gather(key,val,factor_key=T) %>% 
  group_by(key) %>% 
  summarize(EAP=mean(val)) %>% 
  cbind(.,df) %>% select('EAP','salary','team') %>% 
  ggplot(aes(x=salary,y=EAP,color=team))+geom_point()+
  facet_wrap(~team)



# 探索的データ解析 ----------------------------------------------------------------
# クラスター分析 ポケモンのグループ化 ポケモンの因子分析
pokemon %>% dplyr::select('HP','Attack','Defense','Sp.Atk','Sp.Def','Speed') %>% 
  dist() %>% hclust(.,method='ward.D2') %>% plot()



# ポケモンの潜在クラス分析
