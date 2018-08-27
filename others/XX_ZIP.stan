data{
  int<lower=0> L;
  int<lower=0> Y[L];
}

parameters{
  real<lower=0,upper=1> theta;
  real<lower=0> mu;
}

model{
  for(l in 1:L){
    if(Y[l]==0){
      target += log_sum_exp(
        bernoulli_lpmf(0|theta),
        bernoulli_lpmf(1|theta)+poisson_lpmf(0|mu)
      );
    }else{
        target += bernoulli_lpmf(1|theta)+poisson_lpmf(Y[l]|mu);
    }
  }
}

generated quantities{
  int pred[L];
  for(l in 1:L){
    int tmp;
    tmp = bernoulli_rng(theta);
    if(tmp==0){
      pred[l] = 0;
    }else{
      pred[l] = poisson_rng(mu);
    }
  }
}
