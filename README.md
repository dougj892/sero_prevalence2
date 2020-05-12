# Estimating seroprevalence using data from an imperfect test administered to a convenience sample

This repo contains code to estimate seroprevalance using data from an imperfect test administered to a convenience sample.  Full details of the approaches used can be found on my [blog](www.dougjohnson.in). (The blog post should have a similar sounding title.)

## Adapting the code for person use

To copy / adapt code, start with the R notebook "Estimate seroprevalence." As I mention on my blog, if you are just estimating overall seroprevalance, you are probably Ok just using the really simple approach.  The code for this approach can be found at the top of the notebook.

If you would like to generate subgroup estimates, you may want to consider the more complicated approach. If so, I strongly recommend using the BRMS package. The code which uses this package can be found at the end of the notebook. 

If you are a glutton for punishment, you may want to fit a full model in Stan.  The R code for that model is in the middle of the notebook and the stan code is in the folder "stan_code."