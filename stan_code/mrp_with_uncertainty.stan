// 

data {
  int<lower = 0> N;
  
  int<lower = 0> ng_age;
  int<lower = 0> ng_income;
  int<lower = 0> ng_state;
  int<lower = 0> ng_eth;
  
  int<lower = 1, upper = 2> sex[N];
  int<lower = 1, upper = ng_age> age[N];
  int<lower = 1, upper = ng_income> income[N];
  int<lower = 1, upper = ng_state> state[N];
  int<lower = 1, upper = ng_eth> eth[N];
  int<lower = 0> y[N];

  int<lower = 0> P[2, ng_age, ng_income, ng_state, ng_eth];
  
  int<lower=0> tp;  
  int<lower=0> fn;  
  int<lower=0> tn;  
  int<lower=0> fp; 
}

parameters {
  real alpha;
  real<lower = 0> sigma_age;
  vector<multiplier = sigma_age>[ng_age] beta_age;
  real<lower = 0> sigma_income;
  vector<multiplier = sigma_income>[ng_income] beta_income;
  real<lower = 0> sigma_state;
  vector<multiplier = sigma_state>[ng_state] beta_state;
  real<lower = 0> sigma_eth;
  vector<multiplier = sigma_eth>[ng_eth] beta_eth;
  real epsilon;
  
  real <lower=0,upper=1> se;
  real <lower=0,upper=1> sp;
}

transformed parameters {
  vector[N] eps;
  vector <lower=0,upper=1>[N] pt;
  vector <lower=0,upper=1>[N] pa;
  
  for (i in 1:N) {
    eps[i] = {epsilon, -epsilon}[sex[i]];
  }

  pt = inv_logit(alpha + beta_age[age] + beta_income[income] + beta_state[state] + beta_eth[eth]+eps);  
  pa = se*pt+(1-sp)*(1-pt);
}

model {
  // priors
  alpha ~ normal(0, 2);
  beta_age ~ normal(0, sigma_age);
  beta_income ~ normal(0, sigma_income);
  beta_state ~ normal(0, sigma_state);
  beta_eth ~ normal(0, sigma_eth);
  
  sigma_age ~ normal(0, 3);
  sigma_income ~ normal(0, 3);
  sigma_state  ~ normal(0, 3);
  sigma_eth  ~ normal(0, 3);
  epsilon ~ normal(0, 3);
  
  // likelihood
  // tp ~ binomial(tp+fn, se);
  // tn ~ binomial(tn+fp, sp);
  // y ~ bernoulli(pa);
  
  target += binomial_lpmf(tp | tp+fn, se);
  target += binomial_lpmf(tn | tn+fp, sp);
  target += bernoulli_lpmf(y | pa);
}
generated quantities {
  real<lower = 0, upper = 1> phi;
  real eps_i;
  real expect_pos = 0;
  int total = 0;
  for (sex_i in 1:2)
    for (age_i in 1:ng_age)
      for (inc_i in 1:ng_income) {
        for (state_i in 1:ng_state) {
          for (eth_i in 1:ng_eth) {
            total += P[sex_i, age_i, inc_i, state_i, eth_i];
            eps_i= {epsilon, -epsilon}[sex[sex_i]];
            expect_pos += P[sex_i, age_i, inc_i, state_i, eth_i]* inv_logit(alpha + eps_i+ beta_age[age_i] + beta_income[inc_i] + beta_state[state_i] + beta_eth[eth_i]);
            //expect_pos += binomial_rng(P[sex_i, age_i, inc_i, state_i, eth_i], inv_logit(alpha + eps_i+ beta_age[age_i] + beta_income[inc_i] + beta_state[state_i] + beta_eth[eth_i]));
          }
        }
      }
  phi = expect_pos / total;
}


