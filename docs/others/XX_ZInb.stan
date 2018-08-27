data{
  int<lower=0> L;
  real X[L];
  int<lower=0> Y[L];
}

parameters{
  real<lower=0,upper=1> theta;
  real beta_0;
  real beta_1;
  real<lower=0> phi;
}


transformed parameters{
  real mu[L];
  for(l in 1:L){
    mu[l] = exp(beta_0 + beta_1 * X[l]);
  }
}


model{
  for(l in 1:L){
    if(Y[l]==0){
      target += log_sum_exp(
        bernoulli_lpmf(0|theta),
        bernoulli_lpmf(1|theta)+neg_binomial_2_lpmf(0|mu[l],phi)
      );  
    }else{
        target += bernoulli_lpmf(1|theta)+neg_binomial_2_lpmf(Y[l]|mu[l],phi);
    }
  }
}


generated quantities{
  int pred[L];
  for(l in 1:L){
    pred[l] = bernoulli_rng(theta) * neg_binomial_2_rng(mu[l],phi);
  }
}
