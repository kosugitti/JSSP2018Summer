data{
  int<lower=0> N1;
  int<lower=1> N2;
  real X1[N1];
  real X2[N2];
}

parameters{
  real mu;
  real<lower=0> sig;
  real d;
}

model{
  // likelihood
  X1 ~ normal(mu,sig);
  X2 ~ normal(mu+d,sig);
  // prior
  mu ~ normal(0,100);
  sig ~ cauchy(0,5);
  d ~ uniform(-50,50);
}

generated quantities{
  real log_lik[N1+N2];
  for(n in 1:N1){
    log_lik[n] = normal_lpdf(X1|mu,sig);
  }
  for(n in (N1+1):(N1+N2)){
    log_lik[n] = normal_lpdf(X2|mu+d,sig);
  }
}
