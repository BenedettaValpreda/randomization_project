# Randomization Project
## Project objective
In this project I imagine a policy evaluation application and I compare two settings using Monte-Carlo simulations.  
The primary aim is to show that under randomization we can **accurately** assess the impact of a policy, namely with no bias.

## Case study and Data
Suppose we want to evaluate the impact of a training program on the earnings of young individuals in a given country. 
We consider two possible settings:
1. auto-selection: young individuals choose whether they attend the training program or not (depending on their personal motivation)
2. randomization: young individuals are randomly assigned to either join the program or not
   
For each scenario, we generate a dataset and we estimate the policy impact in three different ways (difference, simple regression model and multiple regression model). 
We perform this procedure multiple times (MC simulations) and we compute the mean among all the estimated impacts as the ultimate result for the given scenario. 
Finally, we compare the final results obtained from the two scenarios and we draw our conclusions.

In this project, the key variables are the following ones:
* treatment (*trattati* in Italian): a binary variable that indicates if an individual attends the program or not. In the first scenario it is positively correlated with an individual's motivation ` gen trattati = (motivazione >= 0) ` , while in the second scenario it is random
 ` gen trattati = (uniform() <= 0.5) `
* control variables: gender (*femmina* in Italian), nationality (*straniero* in Italian), age (*età* in Italian), years of education (*anni di istruzione* in Italian)
* wage (*reddito* in Italian): outcome variable, generated as a function of treatment, control variables, motivation (unobservable) and a random error term
` gen reddito = ceil(1500 + 100*trattati - 200*femmina - 300*straniero + 20*eta + 10*anni_istruzione + 50*motivazione + epsilon) `

Note from the equation above that the true impact of the program (namely the effect of the treatment on wages) is equal to 100.

## Results and Conclusions
In this section, we compare the results obtained with the three methods mentioned above running MC simulations. Table 1 displays the results for the first scenario (auto-selection), whereas Table 2 shows the results for the second one (randomization).

![image1](https://github.com/BenedettaValpreda/randomization_project/assets/147848856/1949f40f-6ad5-4cab-8fce-8efec91c728a)

![image2](https://github.com/BenedettaValpreda/randomization_project/assets/147848856/5661e224-9977-478a-af18-4519ab3663f3)


As expected, the results under random assignment in Table 2 are very close to the true impact (equal to 100), while the results under self-selection in Table 1 are biased. 
From a theoretical point of view, this is due to the fact that under randomization the group of individuals who join the program and the group of those who do not are balanced in every single feature (even the unobservable ones), hence in this scenario there is no selection bias that can compromise the estimation of the impact. 
