data{
  int<lower=0> N; // sample size
  real X[N];      // predictor
  int<lower=0,upper=1> Y[N];      // predicted value(should be 0,1)
}

parameters{
  real beta0;     // baseline
  real beta1;     // coefficient
}

model{
  real prob[N];  // transformed parameter
  //likelihood
  for(n in 1:N){
    prob[n] = inv_logit(beta0 + beta1 * X[n]);
    Y[n] ~ bernoulli(prob[n]);
  }
  //prior
  beta0 ~ normal(0,100);
  beta1 ~ normal(0,100);
}

