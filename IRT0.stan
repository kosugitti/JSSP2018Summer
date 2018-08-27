data{
  int<lower=0> N; //number of persons
  int<lower=0> M; //number of questions
  int K[N,M]; 
}

parameters{
  real<lower=0,upper=1> p[N];
  real<lower=0,upper=1> q[M];
}

transformed parameters{
  real<lower=0,upper=1> theta[N,M];
  for(n in 1:N){
    for(m in 1:M){
      theta[n,m] = p[n] * q[m];
    }
  }
}

model{
  for(n in 1:N){
    for(m in 1:M){
      K[n,m] ~ bernoulli(theta[n,m]);
    }
  }
  p ~ beta(1,1);
  q ~ beta(1,1);
}
