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
  X ~ lognormal(mu,sig);
  //prior
  mu ~ uniform(0,10000);
  sig ~ cauchy(0,5);
}

generated quantities{
  real pred1;
  pred1 = lognormal_rng(mu,sig);
}
