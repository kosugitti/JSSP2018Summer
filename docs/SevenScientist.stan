data{
  int<lower=0> N;
  real X[N];
}

parameters{
  real mu;
  real<lower=0> sig[N];
}

model{
  for(n in 1:N){
    //likelihood
    X[n] ~ normal(mu,sig[n]);
    //prior
    sig[n] ~ inv_gamma(0.0001,0.0001);
  }
  // prior
  mu ~ normal(0,1000);
}
