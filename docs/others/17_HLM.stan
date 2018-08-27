data{
  int<lower=0> L;
  int<lower=0> G; //グループ数
  real X[L];
  real Y[L];
  int Idx[L];
}

parameters{
  real beta_0;
  real beta_1[G];
  real<lower=0> sigma;
}

model{
  for(l in 1:L){
    Y[l] ~ normal(beta_0 + beta_1[Idx[l]] * X[l], sigma);
  }
}

generated quantities{
  real pred[L];
  for(l in 1:L){
    pred[l] = normal_rng(beta_0 + beta_1[Idx[l]]* X[l], sigma);
  }
}
