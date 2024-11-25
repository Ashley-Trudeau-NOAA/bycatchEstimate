//
// Starting with a basic estimation model for proportion RHS based on one sample from a known population size
data {
  # N is the number of draws (with replacement)
  int<lower=0> N;
  # y is proportion/rate RHS
  vector[N] y;
}

// I'm reparameterizing the beta distribution to use mean and count
// https://mc-stan.org/docs/stan-users-guide/reparameterization.html#reparameterizations  

parameters {
  real<lower=0, upper=1> phi;
  real<lower=0.1> lambda;
}

transformed parameters {
  real<lower=0> alpha = lambda * phi;
  real<lower=0> beta = lambda * (1-phi);
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  phi ~ beta(1, 1);
  lambda ~ pareto(0.1, 1.5);
  
  for (n in 1:N){
    y[n] ~ beta(alpha, beta);
  }
}

