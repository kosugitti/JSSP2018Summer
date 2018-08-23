data{
  int<lower=0> N;
  int<lower=0> Time[N];
  real C[N];
}

parameters{
  vector<lower=0>[2] mu;
  real<lower=0> sigma;
  real<lower=0,upper=N> tau;
}


model{
  //prior
  mu[1] ~ normal(0,1000);
  mu[2] ~ normal(0,1000);
  sigma ~ cauchy(0,5);

  //likelihood
  for(n in 1:N){
    if(Time[n]> tau){
      C[n] ~ normal(mu[2],sigma);
    } else {
      C[n] ~ normal(mu[1],sigma);
    }
  }

  tau ~ uniform(0,N);
}
