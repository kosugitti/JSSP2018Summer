
# 授業準備 ----------------------------------------------------------------------

install.packages('tidyverse')
install.packages('rstan')
install.packages('bayesplot')
install.packages('summarytools')
install.packages('gridExtra')
install.packages('GGally')
install.packages('loo')
source('http://riseki.php.xdomain.jp/index.php?plugin=attach&refer=ANOVA君&openfile=anovakun_482.txt',encoding = 'CP932')

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


# 乱数による近似 -----------------------------------------------------------------



# 数値例を発生
set.seed(12345)
# 標準正規分布から発生する100個の乱数をつくってみる
x100 <- rnorm(100,0,1)
mean(x100)        # 平均値
var(x100)         # 分散
sd(x100)          # 標準偏差
max(x100)         # 最大値
min(x100)         # 最小値
median(x100)      # 中央値

# パーセンタイル
# 0%, 25%, 50%, 75%, 100%
quantile(x100,probs=c(0,0.25,0.5,0.75,1))

################
# 毎回答えが違う
x100.1 <- rnorm(100,0,1)
x100.2 <- rnorm(100,0,1)
x100.3 <- rnorm(100,0,1)

mean(x100.1)
mean(x100.2)
mean(x100.3)

# サンプルサイズを増やすと理論値に近づく
x1000 <-  rnorm(1000,0,1)
mean(x1000)

x10000 <- rnorm(10000,0,1)
mean(x10000)

x100000 <-  rnorm(100000,0,1)
mean(x100000)

# 確率点
quantile(x100000,probs=c(0,0.25,0.33,0.75,1))
qnorm(0.25,0,1)
qnorm(0.33,0,1)
qnorm(0.75,0,1)

# 累積分布；ある数字よりも大きく(小さく)なる確率
length(x100000[x100000<1.96])/length(x100000)
pnorm(1.96,0,1)


################
# 図にするとわかりやすい

# データをデータフレームにまとめる
data.frame(class=c(rep(1,NROW(x100)),
                   rep(2,NROW(x1000)),
                   rep(3,NROW(x10000)),
                   rep(4,NROW(x100000))),
           value=c(x100,x1000,x10000,x100000)) %>%
  # グループ名を作る変数を作成
  mutate(class=as.factor(class)) %>% 
  # 作図。x軸は値。グループごとに分けたヒストグラム
  ggplot(aes(x=value))+geom_histogram(binwidth = 0.1)+xlim(-4,4)+
  facet_wrap(~class,scales = "free")

#### 積分も簡単
NROW(x100000[x100000>0 & x100000 <1])/NROW(x100000)

data.frame(val=x100000) %>% mutate(itg=ifelse(val>0&val<1,1,2)) %>% 
  mutate(itg=as.factor(itg)) %>% 
  ggplot(aes(x=val,fill=itg))+geom_histogram(binwidth = 0.01) + 
  xlim(-4,4) +theme(legend.position = 'none')


# Stan実演1:まずは一つのデータから -----------------------------------------------------
## 乱数のタネを設定
set.seed(201808)
## 仮想データを使います
X <- round(rnorm(49, 53, 9))
## 仮想データの中身
X
## 仮想データの平均値
mean(X)

## stanモデルコンパイル
model1 <- stan_model('yoshinaya.stan')
## stanに与えるデータセットを準備
dataset <- list(N=49, X=X)
## stanをつかってサンプリング
fit <- sampling(model1,dataset)
## 結果の出力
print(fit)
## 図示
plot(fit,pars='mu',show_density=T)
## パッケージを使って美しく
bayesplot::mcmc_dens(as.array(fit),pars='mu')
bayesplot::mcmc_trace(as.array(fit),pars='mu')
bayesplot::mcmc_areas(as.array(fit,pars='mu'))
## MCMCサンプルを取り出す
rstan::extract(fit,pars='mu')
## 取り出したデータセットを処理
rstan::extract(fit,pars='mu') %>% data.frame() %>% summary()
## 取り出したデータセットを使って
rstan::extract(fit,pars='mu') %>% data.frame() ->result.df
# データ数
NROW(result.df)
# 任意のパーセンタイル点
quantile(result.df$mu,probs = c(0.025,0.56,0.98))
# 任意の区間の密度
NROW(result.df[result.df$mu>55 & result.df$mu < 60,])/NROW(result.df)
# 別解
result.df %>% dplyr::filter(.$mu>55 & .$mu<60) %>% NROW(.)/4000


## MCMCのサンプルサイズ指定
fit <- sampling(model1,dataset,
                warmup=5000,
                iter=100000,
                chains=3,
                thin=2)
fit

# 面白ベイジアンモデリング ------------------------------------------------------------

# 7scientist --------------------------------------------------------------

## データの準備
X <- c(-27.020,3.570,8.191,9.808,9.603,9.945,10.056)
sc7 <- list(N=NROW(X),X=X)
## モデルコンパイル
model <- stan_model('SevenScientist.stan')
## 推定
fit <- sampling(model,sc7,iter=10000)
##  表示
fit
## 描画
plot(fit,pars=c('sig[1]','sig[2]','sig[3]','sig[4]',
                'sig[5]','sig[6]','sig[7]'),show_density=T)

# 打ち切りデータ -----------------------------------------------------------------

## データの準備
nfails     <- 10   
n          <- 50    # Number of questions
datasasoon <- list(nF=nfails,N=n) 
## モデルコンパイル
sasoon <- stan_model("censored.stan")
fit <- sampling(sasoon,datasasoon)
fit
fit %>% as.array %>% 
  bayesplot::mcmc_dens(pars="theta") + xlim(0,1)

### 確認
## 二項分布の例
theta <- 0.4
Ntrial <- 50
size <- 10000
data.frame(x=rbinom(size,Ntrial,theta)) %>% 
  ggplot(aes(x=x))+geom_histogram(binwidth = 0.5)

## 今回の例を乱数で作ってみる
### 仮にtheta=0.4とする
N <- 10000
data.frame(X=rbinom(N,50,0.4)) %>% 
  table() %>% data.frame() %>% 
  rename(tbl=1) %>% mutate(tbl=as.numeric(levels(tbl)[tbl])) %>% 
  right_join(.,data.frame(tbl=1:50)) %>% 
  mutate(Freq=replace_na(Freq,0)) %>% 
  mutate(Cum = cumsum(Freq)/N) %>% 
  mutate(COL = ifelse(tbl<15,1,ifelse(tbl<25,2,3))) %>% 
  ggplot(aes(x=tbl,y=Cum,fill=as.factor(COL))) + 
  geom_bar(stat='identity',alpha=0.5) +
  xlab("")+ylab("")+ theme(legend.position = 'none')


# 変化点の検出 ------------------------------------------------------------------

c <- scan("changepointdata.txt")
n <- length(c)
t <- 1:n
datapoints <- list(C=c,N=n,Time=t)
ChangeDetection <- stan_model("ChangeDetection.stan")
fit <- sampling(ChangeDetection,datapoints)
print(fit)

df <- transform(c)
Ms <- rstan::get_posterior_mean(fit,pars="mu")[,5]
point <- round(apply(as.matrix(rstan::extract(fit,pars="tau")$tau),2,median))
df$Mu <- c(rep(Ms[1],point),rep(Ms[2],n-point))
df %>% dplyr::mutate(num=row_number()) %>% ggplot(aes(x=num,y=X_data))+geom_line(alpha=0.5)+
  geom_point(aes(y=Mu),color="blue")

# 飛行機を再捕獲する ---------------------------------------------------------------

x <- 10 # number of captures
k <- 4  # number of recaptures from n
n <- 5  # size of second sample
tmax <- 50 # maximum population size
datastan <- list(X=x,N=n,K=k,TMax=tmax)
planeModel <- stan_model("plane.stan")
fit <- sampling(planeModeldatastan,algorithm="Fixed_param")
fit %>% as.array %>% bayesplot::mcmc_hist(pars="t",binwidth=1)



