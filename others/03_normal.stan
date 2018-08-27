data{
  int<lower=0> N;
  real X[N];
}

parameters{
  real mu;
  real<lower=0> sig;
  real mu_pre;
  real<lower=0> sig_pre;
}

model{
  // likelihood
  X ~ normal(mu,sig);
  //prior
  mu ~ uniform(0,300);
  sig ~ cauchy(0,5);
  //
  mu_pre ~ uniform(0,300);
  sig_pre ~ cauchy(0,5);
}

generated quantities{
  real pred1;
  real pred2;
  pred1 = normal_rng(mu_pre,sig_pre);
  pred2 = normal_rng(mu,sig);
}
