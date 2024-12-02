// First pass starting 11/25/24
// second pass, taking one step back, only one nested level
// observer observations are drawn straight from vessel catch, not doing buckets
// Problem may have been including sample size as a count rather than as a parameter
// useful resource: https://mc-stan.org/users/documentation/case-studies/pool-binary-trials.html 
data {
// N is the total number of observer samples (of individual fish--is it RHS or not) across all trips
  int<lower=0> N;
// V is the number of observed vessel trips (reserving T for time steps later)
  int<lower=0> V;
  array[N] int<lower=0> nFish;
  array[N] int<lower=0, upper=V> VV;
// y is a bernoulli draw, RHS or not (1,0)
  array[N] int<lower=0> y;
  
}

parameters {
  
  // each trip has some probability of RHS that is drawn from the total distribution
  // (trip probability could be affected by time, vessel)
  vector<lower=0, upper=1>[V] p_rhs_trip;
  // there is some final estimated probability of RHS catch for the year/stratum
  real<lower=0, upper=1> p_rhs_total;
  real<lower=1> kappa; // "population concentration"
}

//transformed parameters {
  // alpha and beta are functions of p_rhs_total and sample size (number of trips sampled)
   // real<lower=0> alpha = kappa * p_rhs_total;
   // real<lower=0> beta = kappa * (1-p_rhs_total);

//}

model {
  // reparameterized beta distribution to use mean probability and count in place
  // of alpha and beta (rstan handbook)
  
  // vague prior for p_rhs_total (to be estimated) can be more informative later
  // trying very informative prior
  p_rhs_total ~ beta(1,1);
  kappa ~ pareto(1, 1.5);
  

  // trips within total catch
  for(i in 1:N){
  p_rhs_trip[VV[i]] ~ beta(kappa * p_rhs_total, kappa * (1-p_rhs_total));
  }
  
  for(i in 1:N){
    // observer draws nested within trips
  y[i] ~ binomial(nFish, p_rhs_trip[VV[i]]);
  }
  

}

