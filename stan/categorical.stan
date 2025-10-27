data {
  int<lower=1> N;
  int<lower=1> TagsN;
  
  array[N] int<lower=1, upper=TagsN> Tag;
  array[N] int Day;
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
  matrix[TagsN - 1, PeriodsN] alpha;
  matrix[TagsN - 1, PeriodsN] beta;
}

model {
  for(i in 1:N){
    if (Period[i] != 0){
      vector[TagsN] period_score;
      period_score[1] = 0;
      period_score[2:TagsN] = alpha[:, Period[i]] + Day[i] * beta[:, Period[i]];
      Tag[i] ~ categorical_logit(period_score);
    }
  }
  
  to_vector(alpha) ~ normal(-2, 1);
  to_vector(beta) ~ normal(0, 1);
}
