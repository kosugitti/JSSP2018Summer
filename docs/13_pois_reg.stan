data{
  int<lower=0> L;
  real X[L];
  int<lower=0> Y[L];
}

parameters{
  real beta_0;
  real beta_1;
}

transformed parameters{
  real mu[L];
  for(l in 1:L){
    mu[l] = exp(beta_0 + beta_1 * X[l]);
  }
}

model{
  for(l in 1:L){
    Y[l] ~ poisson(mu[l]);
  }
}

generated quantities{
  real pred[L];
  for(l in 1:L){
    pred[l] = poisson_rng(mu[l]);
  }
}
