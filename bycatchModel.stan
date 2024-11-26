// Starting with a basic estimation model for proportion RHS based on one sample from a known population size
data {
// V is the number of vessel trips
  int<lower=0> V;
// D is the number of observer draws (with replacement)
  int<lower=0> D;
// y is a bernoulli draw, RHS or not (1,0)
  array[D] int<lower=0, upper=1> y;
}


parameters {
  real<lower=0, upper=1> p_rhs_trip;
  real<lower=0, upper=1> p_rhs_total;
  
  //real<lower=0.1> lambda;

}

transformed parameters {
  //real<lower=0> alpha = lambda * p_rhs_total;
  //real<lower=0> beta = lambda * (1-p_rhs_total);
}


model {
  // reparameterized beta distribution to use mean probability and count in place
  // of alpha and beta (rstan handbook)
  
  // vague prior for p_rhs_total (to be estimated) can be more informative later
  p_rhs_total ~ beta(1,1);
  //lambda ~ pareto(0.1, 1.5);
  
  p_rhs_trip ~ beta(V * p_rhs_total, V * (1-p_rhs_total));
  
  y ~ bernoulli(p_rhs_trip);
  

}

