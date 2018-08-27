data{
  int<lower=0> N;
  int X[N];
}

parameters{
  real<lower=0> theta_pre;
  real<lower=0> theta_post;
}

model{
  X ~ poisson(theta_post);
  
  theta_pre ~ uniform(0,10);
  theta_post ~ uniform(0,10);
}

generated quantities{
  int pred1;
  int pred2;
  
  pred1 = poisson_rng(theta_pre);
  pred2 = poisson_rng(theta_post);
}
