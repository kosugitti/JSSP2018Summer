data {
  int L;  // data length
  int Nv; // number of variables
  vector[Nv] X[L];  // data vetor
}

parameters{
  vector[Nv]  mu;             // mean vector
  vector<lower=0>[Nv] sig;  //SD vector
  corr_matrix[Nv]   rho;    //相関行列
}

transformed parameters{
    cov_matrix[Nv] V;           //共分散行列
    V = quad_form_diag(rho,sig);//相関行列とSDを共分散行列にする関数
}

model{
    X ~ multi_normal(mu,V);
    //prior
    mu ~ normal(0,100);
    sig ~ cauchy(0,5);
    rho ~ lkj_corr(1);  //Stanのもつ相関行列用の事前分布
}
