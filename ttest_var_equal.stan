data{
  int<lower=1> N1;
  int<lower=1> N2;
  real X1[N1];
  real X2[N2];
}

parameters{
  real mu1;
  real mu2;
  real<lower=0> sig;
}

model{
  // likelihood
  X1 ~ normal(mu1,sig);
  X2 ~ normal(mu2,sig);
  // prior
  mu1 ~ normal(0,100);
  mu2 ~ normal(0,100);
  sig ~ cauchy(0,5);
}
