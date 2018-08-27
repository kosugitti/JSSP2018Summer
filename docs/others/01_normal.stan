data{
  int<lower=0> N;
  real X[N];
}

parameters{
  real mu;
  real<lower=0> sig;
}

model{
  X ~ normal(mu,sig);
}
