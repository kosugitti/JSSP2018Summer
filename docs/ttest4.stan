data{
  int<lower=0> N1;
  int<lower=1> N2;
  real X1[N1];
  real X2[N2];
}

parameters{
  real mu;
  real<lower=0> sig1;
  real<lower=0> sig2;
  real d;
}

model{
  // likelihood
  X1 ~ normal(mu,sig1);
  X2 ~ normal(mu+d,sig2);
  // prior
  mu ~ normal(0,100);
  sig1 ~ cauchy(0,5);
  sig2 ~ cauchy(0,5);
  d ~ uniform(-50,50);
}

generated quantities{
  real pred1;
  real pred2;
  real cohenD;
  pred1 = normal_rng(mu,sig1);
  pred2 = normal_rng(mu+d,sig2);
  cohenD = d /(((sig1*N1)+(sig2*N2))/(N1+N2));
}
