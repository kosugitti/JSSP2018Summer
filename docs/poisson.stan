data{
  int<lower=0> L;   // sample size
  real X[L];       // predictor
  int<lower=0> Y[L];      // predicted
}

parameters{
  real beta0;
  real beta1;
}

transformed parameters{
  real<lower=0> theta[L];
  for(l in 1:L)
    theta[l] = exp(beta0 + beta1*X[l]);
}

model{
  for(l in 1:L)
    Y[l] ~ poisson(theta[l]);
    
  //prior
  beta0 ~ normal(0,100);
  beta1 ~ normal(0,100);
}
