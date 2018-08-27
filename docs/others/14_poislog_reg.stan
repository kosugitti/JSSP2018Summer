data{
  int<lower=0> L;
  real X[L];
  int<lower=0> Y[L];
}

parameters{
  real beta_0;
  real beta_1;
}

model{
  for(l in 1:L){
    Y[l] ~ poisson_log(beta_0 + beta_1 * X[l]);
  }
}

generated quantities{
  int pred[L];
  for(l in 1:L){
    pred[l] = poisson_log_rng(beta_0 + beta_1 * X[l]);
  }
}
