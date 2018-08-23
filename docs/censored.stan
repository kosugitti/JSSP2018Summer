data{
  int<lower=0> nF; // number of failes
  int<lower=0> N;  // number of questions
}

parameters{
  real<lower=0.25,upper=1> theta;
}

model{
  30 ~ binomial(N,theta);
  target += nF * (log(binomial_cdf(25,N,theta) - binomial_cdf(14,N,theta)));
}
