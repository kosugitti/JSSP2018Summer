data{
  int<lower=0> L;
  int<lower=0> N[L];
  int<lower=0> X[L];
}

parameters{
  real<lower=0,upper=1> theta;
}

model{
  for(l in 1:L)
    X[l] ~ binomial(N[l],theta);
}

generated quantities{
  int pred[L];
  for(l in 1:L)
    pred[l] = binomial_rng(N[l],theta);
}
