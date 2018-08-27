data{
  int<lower=1> N1;
  int<lower=1> N2;
  real X1[N1];
  real X2[N2];
}

parameters{
  real mu1;
  real mu2;
  real<lower=0> sig1;
  real<lower=0> sig2;
}

model{
  X1 ~ normal(mu1,sig1);
  X2 ~ normal(mu2,sig2);
}
