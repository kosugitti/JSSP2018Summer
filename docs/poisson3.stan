data{
  int<lower=0> L;   // sample size
  real X[L];       // predictor
  int<lower=0> Y[L];      // predicted
}

parameters{
  real beta0;
  real beta1;
}


model{
  for(l in 1:L)
    Y[l] ~ poisson_log(beta0 + beta1*X[l]);
    
  //prior
  beta0 ~ normal(0,100);
  beta1 ~ normal(0,100);
}

generated quantities{
  int pred[L];
  for(l in 1:L)
    pred[l] = poisson_log_rng(beta0 + beta1*X[l]);
}
