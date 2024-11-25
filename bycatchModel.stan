// Starting with a basic estimation model for proportion RHS based on one sample from a known population size
data {
// N is the number of draws (with replacement)
  int<lower=0> N;
// y is proportion/rate RHS
  vector[N] y;
}

// I'm reparameterizing the beta distribution to use mean and count

parameters {
  real<lower=0, upper=1> phi;
  real<lower=0.1> lambda;
}

transformed parameters {
  real<lower=0> alpha = lambda * phi;
  real<lower=0> beta = lambda * (1-phi);
}


model {
  phi ~ beta(1, 1);
  lambda ~ pareto(0.1, 1.5);
  
  for (n in 1:N){
    y[n] ~ beta(alpha, beta);
  }
}

