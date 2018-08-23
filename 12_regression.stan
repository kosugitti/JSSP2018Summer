data{
  int<lower=0> L;
  real X[L];
  real Y[L];
}

parameters{
  real beta_0;
  real beta_1;
  real<lower=0> sigma;
}

model{
  for(l in 1:L){
    Y[l] ~ normal(beta_0 + beta_1 * X[l], sigma);
  }
}

generated quantities{
  real log_lik[L];
  real pred[L];
  for(l in 1:L){
    log_lik[l] = normal_lpdf(X[l]|beta_0 + beta_1 * X[l], sigma);
    pred[l] = normal_rng(beta_0 + beta_1 * X[l], sigma);
  }
}
