### Neural Network

Okay, so who *isn't* building a neural network these days. Not us! We gave it a go.
Initially, the results were not spectacular. But this was due to not normalizing
all the data on a 0-1 scale. Next, the results were TOO GOOD. An almost .05% mean
square predicted error. However, visualing the predicted showed this was just because
the neural net was predicting nearly the mean for each episode in the testData, so the margin of error was misleading.

More "hyperparamter tuning" and research let us to some fairly respectable results.

```
layers = c(10)
cnet <- neuralnet(x, trainData,hidden=layers, linear.output=TRUE, learningrate=.01,
                  rep=10,
                  algorithm="backprop") 
pred <- neuralnet::compute(cnet,testData[,3:555])
```

<img src="nn/results.png"/>

A small representation of just a few Characters shows the network, and how the screen time builds an weighting and activation function towards the overall_rating of the episode.

<img src="nn/network.png"/>


### Neural Network Background

Perceptron and Neural Network Overview

#### Perceptrons

1. Perceptrons are an advanced decision-making tool, first developed in the 1960s.
2. They focus on choices, where a straight line drawn through data can separate patterns.
3. Perceptrons work well for some problems but not for others.
4. Consider two Lexus buyer variables: rich (or not rich) and young (or not young).
   a. This example uses an "And" condition: a buyer must be both rich and young.
   b. With the "And" condition, a straight line can divide the buyers from the nonbuyers.
   c. This example uses an "Or" condition: a buyer must be either rich or young.
   d. With the "Or" condition, a straight line can divide the buyers from the nonbuyers.
   e. This example uses an "Exclusive Or" condition: a buyer must be either rich or young, but not both rich and young.
   f. With the "Exclusive Or" condition, a straight line cannot divide the buyers from the nonbuyers.

#### Perceptrons to Neural Networks

1. Although innovative, perceptrons could not solve the "Exclusive Or" problem (A or B but not both).
2. It's failure was reliance on the straight line or linear function.
3. Breaking the linearity constraint (i.e., allowing curved lines) solved the problem.
4. Applying the logistic function curve led to the development of neural networks.

#### Neural Networks

1. Neural networks are a powerful technique to identify trends and patterns; they expand on the concept of perceptrons.
2. Neural networks work in a way that is similar to the human brain.


#### Neural Networks Characteristics

1. Neural networks use the logistic function to represent nonlinear behavior.
2. A "hidden" layer of variables allows modeling of any mathematical representation.
3. Neural networks are slow to learn but very effective in decision making.

#### Neural Network Variables

1. Inputs:
   -These are the X variables that would be included in a regression.

2. Hidden nodes:
   -These are calculated by the neural network.
   -The user specifies how many hidden nodes to use.
   -More hidden nodes increase the ability of the neural network to find a pattern.
   -More hidden nodes also increase the time required to find a solution.

3. Outputs:
   - These are the Y variables.
   - There can be more than one Y variable (e.g., "buy a TV" or "buy a cell phone").

#### Neural Networks: Hill Climbing

1. The neural network process is like climbing a hill.
2. From a given starting point: find the direction of maximum slope, take a step in that direction, then repeat.


#### Neural Networks: Gradient Search

1. Gradient search is the mathematical process of hill climbing.
2. First, the neural network examines where it is in the landscape
3. Second, it calculates the slope in all directions, by taking the derivative of the logistic function, f(x):
4. Third, it takes a step uphill, then repeats the process until it reaches the top of the hill.


#### Problems with Gradient Search

1. Local optima challenge:

   -The problem with gradient search, or hill climbing, is that you might be climbing a small hill, not the tallest hill in the area.
   -That means the process may find a solution that is suboptimal.

2. Solution:
   -Run the neural network multiple times with different starting points in the landscape.
   -The neural network package in R randomly selects a new starting point each time.

#### Neural Network Implementation

1. Step 1: Collect data.
2. Step 2: Identify input variables (i.e., the X variables).
3. Step 3: Identify output variables (i.e., the Y variables).
4. Step 4: Determine number of hidden nodes.
5. Step 5: Run neural network
