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
  array[N] int<lower=0> nFish;

}

parameters {
  
  // there is some final estimated probability of RHS catch for the year/stratum
  real logit_rhs_total;
  real<lower=0> sigma_total;
  // each trip has some probability of RHS that is drawn from the total distribution. 
  // this mean probability could vary over time and/or by vessel with additional parameters
  // gear/area covariates could be added so that data can be shared across strata
  vector[V] logit_rhs_trip;
  vector<lower=0>[V] sigma_trip;
  // each bucket has some probability of RHS that is drawn from the trip distribution
  vector[B] logit_rhs_bucket;
  vector<lower=0>[V] sigma_bucket;

}


model {

  
  // vague prior for p_rhs_total (to be estimated) can be more informative later
  // In actual use, priors could be estimates from the previous year/stratum
  p_rhs_total ~ beta(1,1);
  
  logit_rhs_total ~ normal(0,1);
  sigma_total ~ normal(0,1);
  
  // some help for nesting syntax https://stackoverflow.com/questions/29379001/nested-model-in-stan 
  // this is where I left off 11/26
  for(i in 1:N){
  logit_rhs_trip[VV[i]] ~ normal(logit_rhs_total, sigma_total);
  }
  
  for(i in 1:N){
    logit_rhs_bucket[BB[i]]
  }

  for(i in 1:N){
    // observer draws nested within trips
  y[i] ~ binomial_logit(nFish, logit_rhs_trip[VV[i]]);
  }

  
  
  
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

