data{
  int<lower=1> N;
  real X[N];
}

parameters{
  real mu;
}

model{
  
  for(n in 1:N){
    X[n] ~ normal(mu,9);
  }
  
  mu ~ uniform(0,100);
}
