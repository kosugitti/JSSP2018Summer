data{
  int<lower=0> L;
  int<lower=2> G;
  int<lower=0> team[L];
  real X[L];
}

parameters{
  real mu[G];
  real<lower=0> sig[G];
}

model{
  for(l in 1:L){
    X[l] ~ lognormal(mu[team[l]],sig[team[l]]);
  }
}

generated quantities{
  real diff[G-1];
  for(g in 2:G){
    diff[(g-1)] = mu[1] - mu[g];
  }
}
