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

