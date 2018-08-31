data{
  int<lower=0> L;   // sample size
  real X[L];       // predictor
  int<lower=0> Y[L];      // predicted
}
parameters{
  real beta0;
  real beta1;
  real lambda[L];
  real<lower=0> sig;  // SD for random effect
}
model{
  for(l in 1:L){
    lambda[l] ~ normal(beta0 + beta1*X[l],sig);
    Y[l] ~ poisson_log(lambda[l]);
  }
  //prior
  beta0 ~ normal(0,100);
  beta1 ~ normal(0,100);
  sig ~ cauchy(0,5);
}
generated quantities{
  int pred[L];
  for(l in 1:L)
    pred[l] = poisson_log_rng(lambda[l]);
}
