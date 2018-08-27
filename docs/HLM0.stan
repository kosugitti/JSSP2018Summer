data{
  int<lower=0> L; // data length
  int<lower=0> G; //number of maximim groups
  real X[L];
  real Y[L];
  int Idx[L]; // index of team
}

parameters{
  real beta_0;
  real beta_1[G];
  real<lower=0> sigma[G];
}

model{
  for(l in 1:L){
    Y[l] ~ normal(beta_0 + beta_1[Idx[l]] * X[l], sigma[Idx[l]]);
  }
  beta_0 ~ normal(0,100);
  beta_1 ~ normal(0,100);
  sigma ~ cauchy(0,5);
}

generated quantities{
  real pred[L];
  for(l in 1:L){
    pred[l] = normal_rng(beta_0 + beta_1[Idx[l]]* X[l], sigma[Idx[l]]);
  }
}
