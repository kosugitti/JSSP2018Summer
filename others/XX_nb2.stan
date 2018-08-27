data{
  int<lower=0> L;
  real X[L];
  int<lower=0> maxG;      // 最大グループ数
  int<lower=0> Idx[L];    // 識別子
  int<lower=0> Y[L];
}

parameters{
  real beta_0;
  real beta_1[maxG];
  real<lower=0> phi;
  
  real mean_beta1;
  real<lower=0> sig1;
  
  real gamma[L];
  real<lower=0> sig2;
}

transformed parameters{
  real mu[L];
  for(l in 1:L){
    mu[l] = beta_0 + (beta_1[Idx[l]] * X[l]);
  }
}

model{
  for(l in 1:L){
    gamma[l] ~ normal(mu[l],sig2);
    Y[l] ~ neg_binomial_2_log(gamma[l],phi);
  }
  beta_1 ~ normal(mean_beta1,sig1);
}

generated quantities{
  int pred[L];
  for(l in 1:L){
    pred[l] = neg_binomial_2_log_rng(gamma[l],phi);
  }
}
