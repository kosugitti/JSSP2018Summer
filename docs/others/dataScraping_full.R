rm(list=ls())
library(tidyverse)
library(rvest)
library(summarytools)

# 年俸等のデータ
# 広島 https://baseball-data.com/ranking-salary/c/
# 阪神 https://baseball-data.com/ranking-salary/t/
# DeNA https://baseball-data.com/ranking-salary/yb/
# 巨人 https://baseball-data.com/ranking-salary/g/
# 中日 https://baseball-data.com/ranking-salary/d/
# ヤクルト https://baseball-data.com/ranking-salary/s/
# SB  https://baseball-data.com/ranking-salary/h/
# 西武 https://baseball-data.com/ranking-salary/l/
# 楽天 https://baseball-data.com/ranking-salary/e/
# オリックス https://baseball-data.com/ranking-salary/bs/
# 日ハム https://baseball-data.com/ranking-salary/f/
# ロッテ https://baseball-data.com/ranking-salary/m/

## 打者成績
# 広島 https://baseball-data.com/stats/hitter-c/

## 投手成績
# 広島 https://baseball-data.com/stats/pitcher-c/

# データ
## プレイヤーデータ
address1 <- 'https://baseball-data.com/player/'
## 打者/投手成績
address2 <- 'https://baseball-data.com/stats/'
## チームID
tID <- c('c','t','yb','g','d','s','h','l','e','bs','f','m')


# チームごとのデータを取っていく ---------------------------------------------------------

dat1 <- data.frame()
dat2 <- data.frame()
dat3 <- data.frame()

for(i in 1:NROW(tID)){
  # プレイヤーデータ
  url1 <- paste0(address1,tID[i],"/")
  tmp.dat <- read_html(url1) %>% html_table() %>% as.data.frame()
  tmp.dat$team <- tID[i]
  dat1 <- rbind(dat1,tmp.dat)
  # 打者成績
  url2 <- paste0(address2,"hitter-",tID[i],"/")
  tmp.dat <- read_html(url2) %>% html_table() %>% as.data.frame() %>% slice(1:(n()-1))
  tmp.dat$team <- tID[i]
  dat2 <- rbind(dat2,tmp.dat)
  # 投手成績
  url3 <- paste0(address2,"pitcher-",tID[i],"/")
  tmp.dat <- read_html(url3) %>% html_table() %>% as.data.frame() %>% slice(1:(n()-1))
  tmp.dat$team <- tID[i]
  dat3 <- rbind(dat3,tmp.dat)
}


# プレイヤーデータ整形 ----------------------------------------------------------------------

dat1 %>%  as_tibble() %>% 
  transmute(Name = .$選手名,
            team = as.factor(.$team),
            salary  = str_replace(.$年俸.推定.,"万円","") %>% str_replace(",","") %>% as.numeric(),
            position = .$守備,
            years = str_replace(.$年数,"年","") %>% as.numeric(),
            height = str_replace(.$身長,"cm","") %>% as.numeric(),
            weight =str_replace(.$体重,"kg","") %>% as.numeric(),
            bloodType = as.factor(.$血液型),
            throw.by = str_sub(.$投打, start=1, end=1) %>% as.factor() ,
            batting.by = str_sub(.$投打, start=2, end=2) %>% as.factor() ,
            birth.place = .$出身地,
            birth.day = as.Date(.$生年月日)) -> dat1

# 野手データ整形 ----------------------------------------------------------------------

dat2 %>% as_tibble() %>% mutate_at(c(3:20),funs(as.numeric(.))) %>% 
  mutate(team = as.factor(team)) -> dat2

# 投手データ整形 ----------------------------------------------------------------------

dat3 %>% as_tibble() %>% mutate_at(c(3:20),funs(as.numeric(.))) %>% 
  mutate(team = as.factor(team)) -> dat3



# 統合 ----------------------------------------------------------------------

Cleague <- c("Carp", "DeNA", "Dragons", "Giants", "Swallows", "Tigers")

dat1 %>% full_join(.,full_join(dat2,dat3,by=c("選手名","team","試合","背番号")),
                   by=c("Name"="選手名","team")) %>% 
  mutate('Name'= as.factor(Name),
         'team' = as.factor(team),
         'position' = as.factor(position),
         'birth.place' = as.factor(birth.place)) %>% 
  mutate(team =fct_recode(team,'Tigers'='t','Carp'='c','Giants'='g','DeNA'='yb',
             'Dragons'='d','Swallows'='s','Softbank'='h','Lions'='l',
             'Eagles'='e','Orix'='bs','Fighters'='f','Lotte'='m')) %>% 
  rename(セーブ=セlブ,ホールド=ホlルド) %>% 
  mutate(league = factor(ifelse(team %in% Cleague,1, 2), labels = c("C", "P"))) -> baseball


# write_csv(baseball,path = "baseball.csv")
# rm(list=ls())