# Randomization Project
## Project objective
In this project I imagine a policy evaluation application and I compare two settings using Monte-Carlo simulations. The primary aim is to show that under randomization we can **accurately** assess the impact of a policy, specifically with no bias.

## Case study and Data
Suppose we want to evaluate the impact of a training program on the earnings of young individuals in a given country. 
We consider two possible settings:
1. auto-selection: young individuals choose whether they attend the training program or not
2. randomization: young individuals are randomly assigned to either join the program or not
   
For each scenario, we generate a dataset and we estimate the policy impact in three different ways (difference, simple regression model and multiple regression model). 
We perform this procedure multiple times and we compute the mean among all the estimated impacts as the ultimate result for the given scenario. 
Finally, we compare the final results obtained from the two scenarios and we draw our conclusions.

In this application, the variables are:
* treatment (trattati in Italian): a dummy variable that indicates if an individual attends the program or not. In the first scenario it is positively correlated with individual motivation ` gen trattati = (motivazione >= 0) ` , while in the second scenario it is random
 ` gen trattati = (motivazione >= 0) ` gen trattati = (uniform() <= 0.5) `
  
* controls: 
* wage: outcome variable, generated as a function of treatment, controls and motivation (unobservable)

## Results
