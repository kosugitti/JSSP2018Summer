rm(list=ls())
library(tidyverse)
old = theme_set(theme_gray(base_family = "HiraKakuProN-W3"))

data(mtcars)

# initial graph --------------------------------------
ggplot(data = mtcars, aes(x = wt, y = disp))+
  geom_point(size = 3)+
  geom_smooth(method = "lm", se = FALSE, lty=3, size=1)

# extracting parameters from lm model ----------------------
tmp <- lm(disp ~ wt, data = mtcars)
intercept <- tmp$coefficients[1]
slope <- tmp$coefficients[2]
residual <- lsfit(y = mtcars$disp, x = mtcars$wt)$residuals

m <- mtcars %>%
  dplyr::mutate(residual = residual)

# done ---------------------------------------
ggplot(data = m, mapping = aes(x = wt, y = disp))+
  geom_point(size = 3)+
  geom_smooth(method = "lm", se = FALSE)+
  geom_pointrange(data = dplyr::filter(m, residual > 0), aes(ymax = disp, ymin = disp - residual)) +
  geom_pointrange(data = dplyr::filter(m, residual < 0), aes(ymax = disp - residual, ymin = disp))

# 回帰分析を実行する ---------------------------------------------------------------

lm(disp~wt,data=mtcars)

summary(lm(disp~wt,data=mtcars))
