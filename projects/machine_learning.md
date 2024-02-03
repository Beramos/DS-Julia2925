# Machine learning: data-driven predictive modelling

**tags:** *machine learning*

![project image](https://images.unsplash.com/photo-1580711508260-a9ea2b5377bb?q=80&w=2624&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)

## 1. Abstract

Machine learning and data science: where computers learn from data like students cramming for exams, but without the coffee jitters. Picture a digital detective, tirelessly connecting the dots in a sea of numbers to reveal hidden patterns and insights. It's like teaching a robot to predict the future, but instead of a crystal ball, it uses algorithms and statistics. In this realm, data is the king, algorithms are its loyal subjects, and the quest is to turn chaos into clarity.

## 2. Background

In this project, you will use Julia to go through the different steps of a data science or machine learning project. To quote Wikipedia:

> "*Machine learning (ML) is a field of study in artificial intelligence concerned with the development and study of statistical algorithms that can learn from data and generalize to unseen data, and thus perform tasks without explicit instructions.*"

To be more specific, you are going to implement a supervised learning task to learn a general rule that maps inputs to outputs. For this, you will need to follow these steps:

- get and process the data;
- assess the data;
- pose the modelling question;
- train the model;
- verify the model

## 3. Assignments

Here below there will be a list of assignments, check the next sections on resources for helpful links

1. **Get or generate your data.**
Because time is rather on the short side to set up a complete experimental campaign, you can resort to either a data set that already exists or generate a synthetic data set. You are heavily encouraged to use data that you are familiar with, e.g. the data from your PhD or postdoc research. If you are not very familiar with machine learning, you might want to start with a benchmark data set to speed up your progress. Process the data and write some functions to read it.
2. **Assess data**
The next step before any modelling is done is assessing the data. Make some simple (box)plots and generate some summary statistics so that you can get familiar with the model. Can you see any trends? Is the input data correlated? How is the data distributed? Are there any outliers? How will you deal with missing data?
3. **Pose the modelling question**
Based on your understanding from question 2, you are now ready to start the modelling process. Try to formulate the problem: is it regression or classification? How are we going to assess the quality of the model? What type of mathematical frameworks are fit to answer the modelling question?
4. **Train and validate the model**
Split the data into a train and test set. Split the train set again if you need to optimise the hyper-parameters. Make sure to make a good choice for the splits, some types of data require specialised splits (e.g. time series). Train the model and assess its predictive power on the test data set. Is the training successful? If the training procedure is iterative: how did you determine the endpoint?
5. **Interpret the model**
The concept of model interpretability has now [reached the European parliament](https://www.europarl.europa.eu/news/en/headlines/society/20230601STO93804/eu-ai-act-first-regulation-on-artificial-intelligence). Try to understand your model: how does it behave? What are the most important input features? Is the full input space captured well? Do you see any trends in residuals?

Suggested extensions:

- Some data can benefit from feature engineering: applying transformations on your data to incorporate some expert knowledge. As an example: it might be that only the magnitude of a feature is important, so one might use the absolute value of the feature.

## 4. Resources

For this project, we heavily encourage you to use the [MLJ](https://alan-turing-institute.github.io/MLJ.jl/stable/#Data) package. Second, we also encourage the use of DrWatson.jl to forge some good habits regarding code structure and reproducibility of data science projects.

1. In case that you do not want to use your own data set, we recommend one of the following Julia packages:
- [MLDatasets.jl](https://juliaml.github.io/MLDatasets.jl/stable/)
- [ForecastData.jl](https://github.com/viraltux/ForecastData.jl)
- [MarketData.jl](https://juliaquant.github.io/MarketData.jl/stable/company_financial_series/#Large-historical-data-sets-1)
- [RDatasets.jl](https://github.com/JuliaStats/RDatasets.jl)
- [CDSAPI.jl](https://github.com/JuliaClimate/CDSAPI.jl)
- [HuggingFaceDatasets.jl](https://github.com/CarloLucibello/HuggingFaceDatasets.jl)
    
    Another option is to go the synthetic route. This might be interesting if you already have a specific model in mind that you want to use and you want to assess the effect of the dimensionality and noise on your performance. 
    
- [Synthetic data from MLJ](https://alan-turing-institute.github.io/MLJ.jl/stable/generating_synthetic_data/)
2. For visualisation you can use the Plots.jl package (make your own Plotrecipe if you are feeling fancy), consider if some dimensionality reduction or manifold learning would be interesting for your chosen data set
3. Hint:

```julia
X = ...
y = ...
using MLJ
models(matching(X, y))
```

4. If you are keen to try out neural networks: we recommend using the [Flux](https://fluxml.ai/) ecosystem of packages. 
5. Consider using the MLJ pipelines and target transformers for reproducible results!
6. Model interpretation will depend on the chosen model, for an all-round solution you can look into [Shapley values](https://christophm.github.io/interpretable-ml-book/shapley.html).