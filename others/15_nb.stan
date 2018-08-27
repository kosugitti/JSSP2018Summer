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

transformed parameters{
  real mu[L];
  for(l in 1:L){
    mu[l] = exp(beta_0 + beta_1 * X[l]);
  }
}

model{
  for(l in 1:L){
    Y[l] ~ neg_binomial_2(mu[l],phi);
  }
}

generated quantities{
  int pred[L];
  for(l in 1:L){
    pred[l] = neg_binomial_2_rng(mu[l],phi);
  }
}
