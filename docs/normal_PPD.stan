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
  mu ~ normal(0,100);
  sig ~ cauchy(0,5);
}

generated quantities{
  real pred;
  pred = normal_rng(mu,sig);
}

