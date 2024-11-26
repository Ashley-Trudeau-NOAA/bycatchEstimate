# bycatchEstimate
Model-based estimates of RHS bycatch

Observer samples (classifying each fish as RHS or not) are modeled as a Bernoulli draw based on the number of buckets/samples taken that trip and the (estimated) trip RHS probability.
- NB buckets are drawn from the catch during a trip. Each bucket has an RHS probability that is drawn from the trip RHS probability. This probability is drawn from a beta distribution parameterized by the number of buckets sampled and the (estimated) trip RHS probability. 

- At some point, the trip RHS probability could be influenced by time and/or vessel. For now it's a straight draw. 

The trip's RHS probability is drawn from a beta distribution parameterized by that season's/year's/stratum's RHS probability and the number of trips observed. 
- p_rhs_total is the parameter of interest

As a generated quantity, p_rhs_total can be multiplied by the total landings to give a posterior distribution of estimated RHS catch. 