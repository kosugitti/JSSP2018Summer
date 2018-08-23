data{
  int<lower=1> N;
  real X[N];
}

parameters{
  real mu;
}

model{
  X ~ normal(mu,9);
  mu ~ uniform(0,100);
}
