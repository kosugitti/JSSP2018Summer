data{
  int<lower=0> N;
  real X[N];
}

parameters{
  real mu;
  real<lower=0> sig;
}

model{
  // likelihood
  X ~ normal(mu,sig);
  //prior
  mu ~ uniform(0,300);
  sig ~ cauchy(0,5);
}

