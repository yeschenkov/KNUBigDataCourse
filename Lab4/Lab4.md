Lab4.R
================
v.yeshchenkov
2020-04-27

``` r
library("RSQLite")
```

    ## Warning: package 'RSQLite' was built under R version 3.6.3

``` r
conn <- dbConnect(SQLite(), "database.sqlite")

## 1. Назва статті (Title), тип виступу (EventType). Необхідно вибрати тільки статті
## с типом виступу Spotlight. Сортування по назві статті.

firstRes <- dbSendQuery(conn, "SELECT Title, EventType FROM Papers WHERE EventType='Spotlight' Order By Title")
firstResFetched <- dbFetch(firstRes, 10)
dbClearResult(firstRes)
firstResFetched
```

    ##                                                                                           Title
    ## 1  A Tractable Approximation to Optimal Point Process Filtering: Application to Neural Encoding
    ## 2                                    Accelerated Mirror Descent in Continuous and Discrete Time
    ## 3                        Action-Conditional Video Prediction using Deep Networks in Atari Games
    ## 4                                                                      Adaptive Online Learning
    ## 5                          Asynchronous Parallel Stochastic Gradient for Nonconvex Optimization
    ## 6                                                 Attention-Based Models for Speech Recognition
    ## 7                                                       Automatic Variational Inference in Stan
    ## 8                                   Backpropagation for Energy-Efficient Neuromorphic Computing
    ## 9                       Bandit Smooth Convex Optimization: Improving the Bias-Variance Tradeoff
    ## 10                         Biologically Inspired Dynamic Textures for Probing Motion Perception
    ##    EventType
    ## 1  Spotlight
    ## 2  Spotlight
    ## 3  Spotlight
    ## 4  Spotlight
    ## 5  Spotlight
    ## 6  Spotlight
    ## 7  Spotlight
    ## 8  Spotlight
    ## 9  Spotlight
    ## 10 Spotlight

``` r
## 2. Ім’я автора (Name), Назва статті (Title). Необхідно вивести всі назви статей
## для автора «Josh Tenenbaum». Сортування по назві статті.

secondRes <- dbSendQuery(conn, "SELECT Title, Name FROM Papers JOIN PaperAuthors ON Papers.Id = PaperId JOIN Authors On AuthorId = Authors.Id WHERE Name='Josh Tenenbaum' Order By Title")
secondResFetched <- dbFetch(secondRes, 10)
dbClearResult(secondRes)
secondResFetched
```

    ##                                                                                               Title
    ## 1                                                       Deep Convolutional Inverse Graphics Network
    ## 2 Galileo: Perceiving Physical Object Properties by Integrating a Physics Engine with Deep Learning
    ## 3                                                Softstar: Heuristic-Guided Probabilistic Inference
    ## 4                                                        Unsupervised Learning by Program Synthesis
    ##             Name
    ## 1 Josh Tenenbaum
    ## 2 Josh Tenenbaum
    ## 3 Josh Tenenbaum
    ## 4 Josh Tenenbaum

``` r
## 3. Вибрати всі назви статей (Title), в яких є слово «statistical». Сортування по
## назві статті.

thirdRes <- dbSendQuery(conn, "SELECT Title FROM Papers WHERE Title LIKE '%statistical%' Order By Title")
thirdResFetched <- dbFetch(thirdRes, 10)
dbClearResult(thirdRes)
thirdResFetched
```

    ##                                                                                  Title
    ## 1 Adaptive Primal-Dual Splitting Methods for Statistical Learning and Image Processing
    ## 2                                Evaluating the statistical significance of biclusters
    ## 3                  Fast Randomized Kernel Ridge Regression with Statistical Guarantees
    ## 4     High Dimensional EM Algorithm: Statistical Optimization and Asymptotic Normality
    ## 5                Non-convex Statistical Optimization for Sparse Tensor Graphical Model
    ## 6            Regularized EM Algorithms: A Unified Framework and Statistical Guarantees
    ## 7                            Statistical Model Criticism using Kernel Two Sample Tests
    ## 8                         Statistical Topological Data Analysis - A Kernel Perspective

``` r
## 4. Ім’я автору (Name), кількість статей по кожному автору (NumPapers).
## Сортування по кількості статей від більшої кількості до меньшої

fourthRes <- dbSendQuery(conn, "SELECT Name, count(*) as NumPapers FROM Authors JOIN PaperAuthors ON Authors.id = AuthorId GROUP BY Name Order By NumPapers DESC")
fourthResFetched <- dbFetch(fourthRes, 10)
dbClearResult(fourthRes)
fourthResFetched
```

    ##                    Name NumPapers
    ## 1  Pradeep K. Ravikumar         7
    ## 2        Lawrence Carin         6
    ## 3               Han Liu         6
    ## 4     Zoubin Ghahramani         5
    ## 5               Le Song         5
    ## 6   Inderjit S. Dhillon         5
    ## 7          Zhaoran Wang         4
    ## 8         Yoshua Bengio         4
    ## 9  Simon Lacoste-Julien         4
    ## 10          Shie Mannor         4
