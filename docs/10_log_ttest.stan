data{
  int<lower=0> N1;
  int<lower=1> N2;
  real X1[N1];
  real X2[N2];
}

parameters{
  real mu1;
  real<lower=0> sig1;
  real<lower=0> sig2;
  real d;
}

model{
  // likelihood
  X1 ~ lognormal(mu1,sig1);
  X2 ~ lognormal(mu1+d,sig2);
  // prior
  mu1 ~ uniform(0,200);
  sig1 ~ cauchy(0,5);
  sig2 ~ cauchy(0,5);
  d ~ uniform(-50,50);
}
