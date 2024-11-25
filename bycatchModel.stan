// Starting with a basic estimation model for proportion RHS based on one sample from a known population size
data {
// N is the number of draws (with replacement)
  int<lower=0> N;
// y is proportion/rate RHS
  vector[N] y;
}

// I'm reparameterizing the beta distribution to use mean and count

parameters {
  real<lower=0, upper=1> mu;
  real<lower=0.1> lambda;
  real<lower=0> alpha2;
  real<lower=0> beta2;
}

transformed parameters {
  real<lower=0> alpha = lambda * mu;
  real<lower=0> beta = lambda * (1-mu);
}


model {
  mu ~ beta(1, 1);
  lambda ~ pareto(0.1, 1.5);
  
  mu ~ beta(alpha2, beta2);
  y ~ beta(alpha, beta);
  
}

