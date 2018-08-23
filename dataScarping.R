rm(list=ls())
library(tidyverse)
library(rvest)

# 投手 ----------------------------------------------------------------------

read_html("http://baseball-data.com/ranking-salary/all/p.html") %>% 
  html_table() %>% as.data.frame() %>% as_tibble() %>% 
  transmute(Name = as.character(.$選手名),
         team = as.factor(.$チーム),
         pay  = str_replace(.$年俸.推定.,"万円","") %>% str_replace(",","") %>% as.numeric(),
         position = .$守備,
         years = str_replace(.$年数,"年","") %>% as.numeric(),
         hight = str_replace(.$身長,"cm","") %>% as.numeric(),
         weight =str_replace(.$体重,"kg","") %>% as.numeric(),
         bloodType = as.factor(.$血液型),
         arm.nage = str_sub(.$投打, start=1, end=1) %>% as.factor() ,
         arm.utsu = str_sub(.$投打, start=2, end=2) %>% as.factor() ,
         birth.place = .$出身地,
         birth.day = as.Date(.$生年月日)) -> p.df


# 野手 ----------------------------------------------------------------------

read_html("http://baseball-data.com/ranking-salary/all/h.html") %>% 
  html_table() %>% as.data.frame() %>% as_tibble() %>% 
  transmute(Name = as.character(.$選手名),
            team = as.factor(.$チーム),
            pay  = str_replace(.$年俸.推定.,"万円","") %>% str_replace(",","") %>% as.numeric(),
            position = .$守備,
         years = str_replace(.$年数,"年","") %>% as.numeric(),
         hight = str_replace(.$身長,"cm","") %>% as.numeric(),
         weight =str_replace(.$体重,"kg","") %>% as.numeric(),
         bloodType = as.factor(.$血液型),
         arm.nage = str_sub(.$投打, start=1, end=1) %>% as.factor() ,
         arm.utsu = str_sub(.$投打, start=2, end=2) %>% as.factor() ,
         birth.place = .$出身地,
         birth.day = as.Date(.$生年月日)) -> h.df


read_html("http://baseball-data.com/stats/hitter2-all/avg-5.html") %>% 
  html_table() %>% as.data.frame() %>% as_tibble() %>% 
  slice(1:(n()-1)) %>% 
  mutate(Name = as.character(.$選手名)) %>%
  mutate_at(c(4:25),funs(as.numeric(.))) %>% 
  select(-順位,-チーム,-選手名) -> avg5.df

read_html("http://baseball-data.com/stats/pitcher2-all/era-5.html") %>% 
  html_table() %>% as.data.frame() %>% as_tibble() %>% 
  slice(1:(n()-1)) %>% 
  mutate(Name = as.character(.$選手名)) %>%
  mutate_at(c(4:25),funs(as.numeric(.))) %>% 
  select(-順位,-チーム,-選手名) ->era5.df

rbind(p.df,h.df) %>% 
  full_join(.,avg5.df,by=c('Name'="Name")) %>% 
  full_join(.,era5.df,by=c('Name'="Name","試合"="試合","敬遠"="敬遠")) %>% 
  mutate('Name'= as.factor(Name),
         'team' = as.factor(team),
         'position' = as.factor(position),
         'birth.place' = as.factor(birth.place)) %>% 
  rename(セーブ=セlブ,
         ボーク=ボlク,
         ホールド=ホlルド)-> t.df
DT::datatable(t.df)
  