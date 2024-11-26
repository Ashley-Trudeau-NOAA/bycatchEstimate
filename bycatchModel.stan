// First pass starting 11/25/24
// Starting with a basic estimation model for proportion RHS based on one sample from a known population size
data {
// N is the total number of observer samples (of individual fish--is it RHS or not) across all trips
  int<lower=0> N;
// Need to nest B within V 
  // total number of buckets in dataset
  int<lower=0> B;
  // BB is an index of buckets
  array[N] int<lower=0> BB;
  // NB is the count of buckets within trips
  array[N] int<lower=0> NB;
// V is the number of observed vessel trips (reserving T for time steps later)
  int<lower=0> V;
  array[N] int<lower=0, upper=V> VV;
// y is a bernoulli draw, RHS or not (1,0)
  array[N] int<lower=0, upper=1> y;
  
}

parameters {
  // each bucket has some probability of RHS that is drawn from the trip distribution
  vector[B] p_rhs_bucket;
  // each trip has some probability of RHS that is drawn from the total distribution
  // (trip probability could be affected by time, vessel)
  vector[V] p_rhs_trip;
  // there is some final estimated probability of RHS catch for the year/stratum
  real p_rhs_total;
  
}


model {
  // reparameterized beta distribution to use mean probability and count in place
  // of alpha and beta (rstan handbook)
  
  // vague prior for p_rhs_total (to be estimated) can be more informative later
  p_rhs_total ~ beta(1,1);
  
  // trips within total catch
  for(i in 1:N){
  p_rhs_trip[VV[i]] ~ beta(V * p_rhs_total, V * (1-p_rhs_total));
  }
  // buckets nested within trips
  for(i in 1:N){
    p_rhs_bucket[BB[i]] ~ beta(NB[i] * p_rhs_trip, NB[i] * (1-p_rhs_trip));
  }
  
  for(i in 1:N){
    // observer draws nested within trips
  y[i] ~ bernoulli(p_rhs_trip[VV[i]]);
  }
  

}

