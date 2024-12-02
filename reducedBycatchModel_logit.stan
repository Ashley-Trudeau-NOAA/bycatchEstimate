// First pass starting 11/25/24
// second pass 11/26/24, taking one step back, only one nested level
// using logit beta to make estimation easier 

// for now, observer observations are drawn straight from vessel catch, not doing buckets
// Problem with first pass may have been including sample size as a count rather than as a parameter
// useful resource: https://mc-stan.org/users/documentation/case-studies/pool-binary-trials.html 
data {
// N is the total number of observer samples (of individual fish--is it RHS or not) across all trips
  int<lower=0> N;
// V is the number of observed vessel trips (reserving T for time steps later)
  int<lower=0> V;
  // totalCatch is total trip catch in tenths of pounds (another "count")
  array[N] int<lower=0> totalCatch;
// VV is index of vessel trips, could be changed to index of unique vessels for 
// effect on bycatch ("skipper effect," note that goal is to account for, not estimate, vessel differences)
  array[N] int<lower=0, upper=V> VV;
// y is a 'count' of the number of (tenths of) pounds RHS observed
  array[N] int<lower=0> y;

}

parameters {
  
  // each trip has some probability of RHS that is drawn from the total distribution
  // (trip probability could be affected by time, vessel)
  
  // mean log odds of RHS catch overall (separate by species and add species effect? or model separately?)
  real logit_rhs_total;
  // log odds RHS catch by trip. Could add nesting by observer sample (buckets), then trip to account for 
  // estimation error in catch composition
  vector[V] logit_rhs_trip;
  real<lower=0> sigma_total;
  
}


model {
  // reparameterized beta distribution to use mean probability and count in place
  // of alpha and beta (rstan handbook)
  
  
  logit_rhs_total ~ normal(0,1);
  sigma_total ~ normal(0,1);
  
  // model specification really needs zero inflation (probably), won't currently predict 
  // any zero-RHS trips
  
  // log odds RHS by trip could be predicted by permit, area, season, vessel, and/or
  // previous years' bycatch (options: trend, random walk, year effect, ARIMA)
  for(i in 1:N){
  logit_rhs_trip[VV[i]] ~ normal(logit_rhs_total, sigma_total);
  }

  for(i in 1:N){
    // observer draws nested within trips
  y[i] ~ binomial_logit(totalCatch[i], logit_rhs_trip[VV[i]]);
  }
  

}

generated quantities{
  real prob_rhs_total;
  prob_rhs_total = inv_logit(logit_rhs_total);
  // can estimate total RHS catch with error in this block as prob_rhs_total * yearsCatch
  
  // when there are covariates, I think it would need to instead predict prob_rhs by stratum
  // and season for that year
}
