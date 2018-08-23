data{
  int<lower=0> X; //第一標本サイズ
  int<lower=0> N; //第二標本サイズ
  int<lower=0,upper=N> K; //再捕獲した数
  int<lower=X> TMax; // ありえそうな最大数
}

transformed data{
  int<lower=X> tmin; //少なくともこれぐらいはいる
  tmin = X + N - K;
}

parameters{
}

transformed parameters{
  vector[TMax] lp;  //最大数までの尤度
  for(t in 1:TMax){
    if(t < tmin){
      // 最低限以下はあり得ないので尤度を負の無限大にする
      lp[t] = log(1.0/TMax) + negative_infinity();
    }else{
      // 最大値まで均等にありそうな超幾何分布 HM(K|N,X,台数)
      lp[t] = log(1.0/TMax) + hypergeometric_lpmf(K|N,X,t-X);
    }
  }
}

model{
  target += log_sum_exp(lp);
}

generated quantities{
  int<lower=tmin,upper=TMax> t;
  simplex[TMax] tp;
  tp = softmax(lp);
  t = categorical_rng(tp);
}
