data{
  int<lower=1> N;
  real X[N];
  real pre_mu;
  real pre_sig;
}

parameters{
  real mu;
}

model{
  X ~ normal(mu,9);
  mu ~ normal(pre_mu,pre_sig);
}
