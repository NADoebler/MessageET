data {
  int<lower=1> N;

  array[N] int<lower=0> Ntag;
  array[N] int<lower=1> Ntotal;
  array[N] int Day; // zero if the day of the event
}

transformed data {
  int PeriodsN = 2;
  array[N] int Period;
  for(i in 1:N) {
    if (Day[i] < 0) {
      Period[i] = 1;
    } else if  (Day[i] > 0) {
      Period[i] = 2;
    } else {
      Period[i] = 0;
    }
  }
}

parameters {
  vector[PeriodsN] alpha;
  vector[PeriodsN] beta;
}

transformed parameters {
  vector[N] p;
  for(i in 1:N) if (Period[i] != 0) p[i] = inv_logit(alpha[Period[i]] + beta[Period[i]] * Day[i]);
}

model {
  for(i in 1:N) if (Period[i] != 0) Ntag[i] ~ binomial(Ntotal[i], p[i]);
  alpha ~ normal(-2, 1);
  beta ~ normal(0, 1);
}
