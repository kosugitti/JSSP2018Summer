data{
  int<lower=0> L;
  vector[2] X[L];
}

parameters{
  vector[2] mu;
  real<lower=0> sd1;
  real<lower=0> sd2;
  real<lower=-1,upper=1> rho;
}

transformed parameters{
  cov_matrix[2] V;
  V[1,1] = sd1^2;
  V[2,2] = sd2^2;
  V[1,2] = sd1 * sd2 * rho;
  V[2,1] = sd1 * sd2 * rho;
}

model{
  //likelihood
  X ~ multi_normal(mu,V);
  // prior
  mu[1] ~ normal(0,300);
  mu[2] ~ normal(0,200);
  sd1 ~ cauchy(0,5);
  sd2 ~ cauchy(0,5);
  rho ~ uniform(-1,1);
}
