data {
  int<lower=1> DaysN;
  array[DaysN * 2] int<lower=0> Ntag;
  array[DaysN * 2] int<lower=1> Ntotal;
  array[DaysN * 2] int<lower=1, upper=2> Period;
  array[DaysN * 2] int AbsDay;
}

parameters {
  matrix<lower=0, upper=1>[DaysN, 2] p;
}

model {
  to_vector(p) ~ beta_proportion(0.1, 2);
  for(i in 1:DaysN * 2) Ntag[i] ~ binomial(Ntotal[i], p[AbsDay[i], Period[i]]);
}
