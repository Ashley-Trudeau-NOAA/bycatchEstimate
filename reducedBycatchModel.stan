// First pass starting 11/25/24
// second pass, taking one step back, only one nested level
// observer observations are drawn straight from vessel catch, not doing buckets
data {
// N is the total number of observer samples (of individual fish--is it RHS or not) across all trips
  int<lower=0> N;
// V is the number of observed vessel trips (reserving T for time steps later)
  int<lower=0> V;
  array[N] int<lower=0, upper=V> VV;
// y is a bernoulli draw, RHS or not (1,0)
  array[N] int<lower=0, upper=1> y;
  
}

parameters {
  
  // alpha and beta parameters 
  
  // each trip has some probability of RHS that is drawn from the total distribution
  // (trip probability could be affected by time, vessel)
  vector[V] p_rhs_trip;
  // there is some final estimated probability of RHS catch for the year/stratum
  real<lower=0> p_rhs_total;
  
}


model {
  // reparameterized beta distribution to use mean probability and count in place
  // of alpha and beta (rstan handbook)
  
  // vague prior for p_rhs_total (to be estimated) can be more informative later
  // trying very informative prior
  p_rhs_total ~ beta(1,1000);
  
  // trips within total catch
  for(i in 1:N){
  p_rhs_trip[VV[i]] ~ beta(V * p_rhs_total, V * (1-p_rhs_total));
  }
  
  for(i in 1:N){
    // observer draws nested within trips
  y[i] ~ bernoulli(p_rhs_trip[VV[i]]);
  }
  

}

