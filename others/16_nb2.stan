data{
  int<lower=0> L;
  real X[L];
  int<lower=0> Y[L];
}

parameters{
  real beta_0;
  real beta_1;
  real<lower=0> phi;
}

model{
  for(l in 1:L){
    Y[l] ~ neg_binomial_2_log(beta_0 + beta_1 * X[l],phi);
  }
}

generated quantities{
  int pred[L];
  for(l in 1:L){
    pred[l] = neg_binomial_2_log_rng(beta_0 + beta_1 * X[l],phi);
  }
}
