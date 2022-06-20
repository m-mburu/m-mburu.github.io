Supervised Learning in R: Classification
================

## k-Nearest Neighbors (kNN)

### Recognizing a road sign with kNN

After several trips with a human behind the wheel, it is time for the
self-driving car to attempt the test course alone.

As it begins to drive away, its camera captures the following image:

Stop Sign

Can you apply a kNN classifier to help the car recognize this sign?

The dataset signs is loaded in your workspace along with the dataframe
next_sign, which holds the observation you want to classify.

``` r
library(tidyverse)
library(data.table)
library(here)
# Load the 'class' package
library(class)

signs_data <- fread(here("supervised_learning_R/data/knn_traffic_signs.csv"))

id_nms <- c("id", "sample", "sign_type")

train_set <- signs_data[sample == "train"]
test_set <- signs_data[sample == "test"]
# Create a vector of labels
sign_types <- train_set$sign_type

# Classify the next sign observed
knn(train = train_set[, .SD, .SDcols = !id_nms],
    test = test_set[1, .SD, .SDcols = !id_nms],
    cl = sign_types)
```

    ## [1] pedestrian
    ## Levels: pedestrian speed stop

#### Thinking like kNN

With your help, the test car successfully identified the sign and
stopped safely at the intersection.

How did the knn() function correctly classify the stop sign?

-   kNN isn’t really learning anything; it simply looks for the most
    similar example.

### Exploring the traffic sign dataset

To better understand how the knn() function was able to classify the
stop sign, it may help to examine the training dataset it used.

Each previously observed street sign was divided into a 4x4 grid, and
the red, green, and blue level for each of the 16 center pixels is
recorded as illustrated here.

Stop Sign Data Encoding

The result is a dataset that records the sign_type as well as 16 x 3 =
48 color properties of each sign.

``` r
# Examine the structure of the signs dataset
signs <- copy(train_set)
str(signs)
```

    ## Classes 'data.table' and 'data.frame':   146 obs. of  51 variables:
    ##  $ id       : int  1 2 3 4 5 6 7 9 10 11 ...
    ##  $ sample   : chr  "train" "train" "train" "train" ...
    ##  $ sign_type: chr  "pedestrian" "pedestrian" "pedestrian" "pedestrian" ...
    ##  $ r1       : int  155 142 57 22 169 75 136 149 13 123 ...
    ##  $ g1       : int  228 217 54 35 179 67 149 225 34 124 ...
    ##  $ b1       : int  251 242 50 41 170 60 157 241 28 107 ...
    ##  $ r2       : int  135 166 187 171 231 131 200 34 5 83 ...
    ##  $ g2       : int  188 204 201 178 254 89 203 45 21 61 ...
    ##  $ b2       : int  101 44 68 26 27 53 107 1 11 26 ...
    ##  $ r3       : int  156 142 51 19 97 214 150 155 123 116 ...
    ##  $ g3       : int  227 217 51 27 107 144 167 226 154 124 ...
    ##  $ b3       : int  245 242 45 29 99 75 134 238 140 115 ...
    ##  $ r4       : int  145 147 59 19 123 156 171 147 21 67 ...
    ##  $ g4       : int  211 219 62 27 147 169 218 222 46 67 ...
    ##  $ b4       : int  228 242 65 29 152 190 252 242 41 52 ...
    ##  $ r5       : int  166 164 156 42 221 67 171 170 36 70 ...
    ##  $ g5       : int  233 228 171 37 236 50 158 191 60 53 ...
    ##  $ b5       : int  245 229 50 3 117 36 108 113 26 26 ...
    ##  $ r6       : int  212 84 254 217 205 37 157 26 75 26 ...
    ##  $ g6       : int  254 116 255 228 225 36 186 37 108 26 ...
    ##  $ b6       : int  52 17 36 19 80 42 11 12 44 21 ...
    ##  $ r7       : int  212 217 211 221 235 44 26 34 13 52 ...
    ##  $ g7       : int  254 254 226 235 254 42 35 45 27 45 ...
    ##  $ b7       : int  11 26 70 20 60 44 10 19 25 27 ...
    ##  $ r8       : int  188 155 78 181 90 192 180 221 133 117 ...
    ##  $ g8       : int  229 203 73 183 110 131 211 249 163 109 ...
    ##  $ b8       : int  117 128 64 73 9 73 236 184 126 83 ...
    ##  $ r9       : int  170 213 220 237 216 123 129 226 83 110 ...
    ##  $ g9       : int  216 253 234 234 236 74 109 246 125 74 ...
    ##  $ b9       : int  120 51 59 44 66 22 73 59 19 12 ...
    ##  $ r10      : int  211 217 254 251 229 36 161 30 13 98 ...
    ##  $ g10      : int  254 255 255 254 255 34 190 40 27 70 ...
    ##  $ b10      : int  3 21 51 2 12 37 10 34 25 26 ...
    ##  $ r11      : int  212 217 253 235 235 44 161 34 9 20 ...
    ##  $ g11      : int  254 255 255 243 254 42 190 44 23 21 ...
    ##  $ b11      : int  19 21 44 12 60 44 6 35 18 20 ...
    ##  $ r12      : int  172 158 66 19 163 197 187 241 85 113 ...
    ##  $ g12      : int  235 225 68 27 168 114 215 255 128 76 ...
    ##  $ b12      : int  244 237 68 29 152 21 236 54 21 14 ...
    ##  $ r13      : int  172 164 69 20 124 171 141 205 83 106 ...
    ##  $ g13      : int  235 227 65 29 117 102 142 229 125 69 ...
    ##  $ b13      : int  244 237 59 34 91 26 140 46 19 9 ...
    ##  $ r14      : int  172 182 76 64 188 197 189 226 85 102 ...
    ##  $ g14      : int  228 228 84 61 205 114 171 246 128 67 ...
    ##  $ b14      : int  235 143 22 4 78 21 140 59 21 6 ...
    ##  $ r15      : int  177 171 82 211 125 123 214 235 85 106 ...
    ##  $ g15      : int  235 228 93 222 147 74 221 252 128 69 ...
    ##  $ b15      : int  244 196 17 78 20 22 201 67 21 9 ...
    ##  $ r16      : int  22 164 58 19 160 180 188 237 83 43 ...
    ##  $ g16      : int  52 227 60 27 183 107 211 254 125 29 ...
    ##  $ b16      : int  53 237 60 29 187 26 227 53 19 11 ...
    ##  - attr(*, ".internal.selfref")=<externalptr>

``` r
# Count the number of signs of each type
table(signs$sign_type)
```

    ## 
    ## pedestrian      speed       stop 
    ##         46         49         51

``` r
# Check r10's average red level by sign type
aggregate(r10 ~ sign_type, data = signs, mean)
```

    ##    sign_type       r10
    ## 1 pedestrian 113.71739
    ## 2      speed  80.63265
    ## 3       stop 132.39216

### Classifying a collection of road signs

Now that the autonomous vehicle has successfully stopped on its own,
your team feels confident allowing the car to continue the test course.

The test course includes 59 additional road signs divided into three
types:

Stop Sign Speed Limit Sign Pedestrian Sign

At the conclusion of the trial, you are asked to measure the car’s
overall performance at recognizing these signs.

The class package and the dataset signs are already loaded in your
workspace. So is the dataframe test_signs, which holds a set of
observations you’ll test your model on.

``` r
# Use kNN to identify the test road signs
sign_types <- signs$sign_type
signs_pred <- knn(train = train_set[, .SD, .SDcols = !id_nms],
    test = test_set[, .SD, .SDcols = !id_nms],
    cl = sign_types)

# Create a confusion matrix of the predicted versus actual values
signs_actual <- test_set$sign_type
table(signs_actual,signs_pred)
```

    ##             signs_pred
    ## signs_actual pedestrian speed stop
    ##   pedestrian         19     0    0
    ##   speed               2    17    2
    ##   stop                0     0   19

``` r
# Compute the accuracy
mean(signs_actual == signs_pred)
```

    ## [1] 0.9322034

#### Understanding the impact of ‘k’

There is a complex relationship between k and classification accuracy.
Bigger is not always better.

Which of these is a valid reason for keeping k as small as possible (but
no smaller)?

-   A smaller k may utilize more subtle patterns

### Testing other ‘k’ values

By default, the knn() function in the class package uses only the single
nearest neighbor.

Setting a k parameter allows the algorithm to consider additional nearby
neighbors. This enlarges the collection of neighbors which will vote on
the predicted class.

Compare k values of 1, 7, and 15 to examine the impact on traffic sign
classification accuracy.

The class package is already loaded in your workspace along with the
datasets signs, signs_test, and sign_types. The object signs_actual
holds the true values of the signs.

``` r
# Compute the accuracy of the baseline model (default k = 1)
k_1 <- knn(train = train_set[, .SD, .SDcols = !id_nms],
    test = test_set[, .SD, .SDcols = !id_nms],
    cl = sign_types)

mean(signs_actual == k_1)
```

    ## [1] 0.9322034

``` r
# Modify the above to set k = 7
k_7 <-  knn(train = train_set[, .SD, .SDcols = !id_nms],
    test = test_set[, .SD, .SDcols = !id_nms],
    cl = sign_types, k = 7)
mean(signs_actual == k_7)
```

    ## [1] 0.9491525

``` r
# Set k = 15 and compare to the above
k_15 <- knn(train = train_set[, .SD, .SDcols = !id_nms],
    test = test_set[, .SD, .SDcols = !id_nms],
    cl = sign_types, k = 15)
mean(signs_actual == k_15)
```

    ## [1] 0.8644068

### Seeing how the neighbors voted

When multiple nearest neighbors hold a vote, it can sometimes be useful
to examine whether the voters were unanimous or widely separated.

For example, knowing more about the voters’ confidence in the
classification could allow an autonomous vehicle to use caution in the
case there is any chance at all that a stop sign is ahead.

In this exercise, you will learn how to obtain the voting results from
the knn() function.

The class package has already been loaded in your workspace along with
the datasets signs, sign_types, and signs_test.

``` r
# Use the prob parameter to get the proportion of votes for the winning class
sign_pred <-  knn(train = train_set[, .SD, .SDcols = !id_nms],
    test = test_set[, .SD, .SDcols = !id_nms],
    cl = sign_types, k = 7, prob = T)

# Get the "prob" attribute from the predicted classes
sign_prob <- attr(sign_pred, "prob")

# Examine the first several predictions
head(sign_pred )
```

    ## [1] pedestrian pedestrian pedestrian stop       pedestrian pedestrian
    ## Levels: pedestrian speed stop

``` r
# Examine the proportion of votes for the winning class
head(sign_prob)
```

    ## [1] 0.5714286 0.5714286 0.8571429 0.5714286 0.8571429 0.5714286

#### Why normalize data?

Before applying kNN to a classification task, it is common practice to
rescale the data using a technique like min-max normalization. What is
the purpose of this step? - Rescaling reduces the influence of extreme
values on kNN’s distance function.

## Naive Bayes

### Computing probabilities

The where9am data frame contains 91 days (thirteen weeks) worth of data
in which Brett recorded his location at 9am each day as well as whether
the daytype was a weekend or weekday.

Using the conditional probability formula below, you can compute the
probability that Brett is working in the office, given that it is a
weekday.

Calculations like these are the basis of the Naive Bayes destination
prediction model you’ll develop in later exercises.

``` r
locations <- fread(here("supervised_learning_R/data/locations.csv"))
where9am <- locations[hour==9]
p_A <- nrow(subset(where9am, location == "office"))/nrow(where9am)

# Compute P(B)
p_B <- nrow(subset(where9am, daytype == "weekday"))/nrow(where9am)

# Compute the observed P(A and B)
p_AB <- nrow(subset(where9am, location == "office" & daytype == "weekday" ))/nrow(where9am)

# Compute P(A | B) and print its value
p_A_given_B <- p_AB /p_B
p_A_given_B
```

    ## [1] 0.6

#### Understanding dependent events

In the previous exercise, you found that there is a 60% chance Brett is
in the office at 9am given that it is a weekday. On the other hand, if
Brett is never in the office on a weekend, which of the following is/are
true?

### A simple Naive Bayes location model

The previous exercises showed that the probability that Brett is at work
or at home at 9am is highly dependent on whether it is the weekend or a
weekday.

To see this finding in action, use the where9am data frame to build a
Naive Bayes model on the same data.

You can then use this model to predict the future: where does the model
think that Brett will be at 9am on Thursday and at 9am on Saturday?

The data frame where9am is available in your workspace. This dataset
contains information about Brett’s location at 9am on different days.

``` r
# Load the naivebayes package
library(naivebayes)

# Build the location prediction model
locmodel <- naive_bayes(location~daytype, data = where9am)
thursday9am <- locations[weekday=="thursday" & hour==9]
# Predict Thursday's 9am location
predict(locmodel, newdata = thursday9am)
```

    ##  [1] office office office office office office office office office office
    ## [11] office office office
    ## Levels: appointment campus home office

``` r
saturday9am <- locations[weekday=="saturday" & hour==9]
# Predict Saturdays's 9am location
predict(locmodel, newdata = saturday9am)
```

    ##  [1] home home home home home home home home home home home home home
    ## Levels: appointment campus home office

### Examining “raw” probabilities

The naivebayes package offers several ways to peek inside a Naive Bayes
model.

Typing the name of the model object provides the a priori (overall) and
conditional probabilities of each of the model’s predictors. If one were
so inclined, you might use these for calculating posterior (predicted)
probabilities by hand.

Alternatively, R will compute the posterior probabilities for you if the
type = “prob” parameter is supplied to the predict() function.

Using these methods, examine how the model’s predicted 9am location
probability varies from day-to-day. The model locmodel that you fit in
the previous exercise is in your workspace.

``` r
# The 'naivebayes' package is loaded into the workspace
# and the Naive Bayes 'locmodel' has been built

# Examine the location prediction model

locmodel
```

    ## 
    ## ================================== Naive Bayes ================================== 
    ##  
    ##  Call: 
    ## naive_bayes.formula(formula = location ~ daytype, data = where9am)
    ## 
    ## --------------------------------------------------------------------------------- 
    ##  
    ## Laplace smoothing: 0
    ## 
    ## --------------------------------------------------------------------------------- 
    ##  
    ##  A priori probabilities: 
    ## 
    ## appointment      campus        home      office 
    ##  0.01098901  0.10989011  0.45054945  0.42857143 
    ## 
    ## --------------------------------------------------------------------------------- 
    ##  
    ##  Tables: 
    ## 
    ## --------------------------------------------------------------------------------- 
    ##  ::: daytype (Bernoulli) 
    ## --------------------------------------------------------------------------------- 
    ##          
    ## daytype   appointment    campus      home    office
    ##   weekday   1.0000000 1.0000000 0.3658537 1.0000000
    ##   weekend   0.0000000 0.0000000 0.6341463 0.0000000
    ## 
    ## ---------------------------------------------------------------------------------

``` r
# Obtain the predicted probabilities for Thursday at 9am
predict(locmodel,newdata = thursday9am , type = "prob")
```

    ##       appointment    campus      home office
    ##  [1,]  0.01538462 0.1538462 0.2307692    0.6
    ##  [2,]  0.01538462 0.1538462 0.2307692    0.6
    ##  [3,]  0.01538462 0.1538462 0.2307692    0.6
    ##  [4,]  0.01538462 0.1538462 0.2307692    0.6
    ##  [5,]  0.01538462 0.1538462 0.2307692    0.6
    ##  [6,]  0.01538462 0.1538462 0.2307692    0.6
    ##  [7,]  0.01538462 0.1538462 0.2307692    0.6
    ##  [8,]  0.01538462 0.1538462 0.2307692    0.6
    ##  [9,]  0.01538462 0.1538462 0.2307692    0.6
    ## [10,]  0.01538462 0.1538462 0.2307692    0.6
    ## [11,]  0.01538462 0.1538462 0.2307692    0.6
    ## [12,]  0.01538462 0.1538462 0.2307692    0.6
    ## [13,]  0.01538462 0.1538462 0.2307692    0.6

``` r
# Obtain the predicted probabilities for Saturday at 9am
predict(locmodel,newdata = saturday9am , type = "prob")
```

    ##        appointment       campus      home      office
    ##  [1,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ##  [2,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ##  [3,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ##  [4,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ##  [5,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ##  [6,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ##  [7,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ##  [8,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ##  [9,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ## [10,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ## [11,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ## [12,] 3.838772e-05 0.0003838772 0.9980806 0.001497121
    ## [13,] 3.838772e-05 0.0003838772 0.9980806 0.001497121

#### Understanding independence

Understanding the idea of event independence will become important as
you learn more about how “naive” Bayes got its name. Which of the
following is true about independent events?

-   *Yes! One event is independent of another if knowing one doesn’t
    give you information about how likely the other is. For example,
    knowing if it’s raining in New York doesn’t help you predict the
    weather in San Francisco. The weather events in the two cities are
    independent of each other*.

#### Who are you calling naive?

The Naive Bayes algorithm got its name because it makes a “naive”
assumption about event independence.

What is the purpose of making this assumption?

-   *Yes! The joint probability of independent events can be computed
    much more simply by multiplying their individual probabilities.*

### A more sophisticated location model

The locations dataset records Brett’s location every hour for 13 weeks.
Each hour, the tracking information includes the daytype (weekend or
weekday) as well as the hourtype (morning, afternoon, evening, or
night).

Using this data, build a more sophisticated model to see how Brett’s
predicted location not only varies by the day of week but also by the
time of day. The dataset locations is already loaded in your workspace.

You can specify additional independent variables in your formula using
the + sign (e.g. y \~ x + b).

``` r
# The 'naivebayes' package is loaded into the workspace already

# Build a NB model of location
locmodel <- naive_bayes(location~ daytype + hourtype,data = locations)

weekday_afternoon <- locations[daytype =="weekday" &  hourtype == "afternoon"]
# Predict Brett's location on a weekday afternoon
predict(locmodel, weekday_afternoon)
```

    ##   [1] office office office office office office office office office office
    ##  [11] office office office office office office office office office office
    ##  [21] office office office office office office office office office office
    ##  [31] office office office office office office office office office office
    ##  [41] office office office office office office office office office office
    ##  [51] office office office office office office office office office office
    ##  [61] office office office office office office office office office office
    ##  [71] office office office office office office office office office office
    ##  [81] office office office office office office office office office office
    ##  [91] office office office office office office office office office office
    ## [101] office office office office office office office office office office
    ## [111] office office office office office office office office office office
    ## [121] office office office office office office office office office office
    ## [131] office office office office office office office office office office
    ## [141] office office office office office office office office office office
    ## [151] office office office office office office office office office office
    ## [161] office office office office office office office office office office
    ## [171] office office office office office office office office office office
    ## [181] office office office office office office office office office office
    ## [191] office office office office office office office office office office
    ## [201] office office office office office office office office office office
    ## [211] office office office office office office office office office office
    ## [221] office office office office office office office office office office
    ## [231] office office office office office office office office office office
    ## [241] office office office office office office office office office office
    ## [251] office office office office office office office office office office
    ## [261] office office office office office office office office office office
    ## [271] office office office office office office office office office office
    ## [281] office office office office office office office office office office
    ## [291] office office office office office office office office office office
    ## [301] office office office office office office office office office office
    ## [311] office office office office office office office office office office
    ## [321] office office office office office office office office office office
    ## [331] office office office office office office office office office office
    ## [341] office office office office office office office office office office
    ## [351] office office office office office office office office office office
    ## [361] office office office office office office office office office office
    ## [371] office office office office office office office office office office
    ## [381] office office office office office office office office office office
    ## Levels: appointment campus home office restaurant store theater

``` r
weekday_evening <- locations[daytype =="weekday" &  hourtype == "evening"]
# Predict Brett's location on a weekday evening
predict(locmodel, weekday_evening)
```

    ##   [1] home home home home home home home home home home home home home home home
    ##  [16] home home home home home home home home home home home home home home home
    ##  [31] home home home home home home home home home home home home home home home
    ##  [46] home home home home home home home home home home home home home home home
    ##  [61] home home home home home home home home home home home home home home home
    ##  [76] home home home home home home home home home home home home home home home
    ##  [91] home home home home home home home home home home home home home home home
    ## [106] home home home home home home home home home home home home home home home
    ## [121] home home home home home home home home home home home home home home home
    ## [136] home home home home home home home home home home home home home home home
    ## [151] home home home home home home home home home home home home home home home
    ## [166] home home home home home home home home home home home home home home home
    ## [181] home home home home home home home home home home home home home home home
    ## [196] home home home home home home home home home home home home home home home
    ## [211] home home home home home home home home home home home home home home home
    ## [226] home home home home home home home home home home home home home home home
    ## [241] home home home home home home home home home home home home home home home
    ## [256] home home home home home
    ## Levels: appointment campus home office restaurant store theater

### Preparing for unforeseen circumstances

While Brett was tracking his location over 13 weeks, he never went into
the office during the weekend. Consequently, the joint probability of
P(office and weekend) = 0.

Explore how this impacts the predicted probability that Brett may go to
work on the weekend in the future. Additionally, you can see how using
the Laplace correction will allow a small chance for these types of
unforeseen circumstances.

The model locmodel is already in your workspace, along with the
dataframe weekend_afternoon.

``` r
# The 'naivebayes' package is loaded into the workspace already
# The Naive Bayes location model (locmodel) has already been built

# Observe the predicted probabilities for a weekend afternoon
weekend_afternoon <- locations[daytype =="weekday" &  hourtype == "afternoon"]
predict(locmodel,newdat = weekend_afternoon ,type = "prob")
```

    ##        appointment     campus      home    office restaurant       store
    ##   [1,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##   [2,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##   [3,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##   [4,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##   [5,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##   [6,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##   [7,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##   [8,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##   [9,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [10,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [11,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [12,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [13,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [14,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [15,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [16,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [17,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [18,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [19,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [20,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [21,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [22,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [23,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [24,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [25,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [26,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [27,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [28,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [29,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [30,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [31,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [32,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [33,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [34,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [35,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [36,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [37,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [38,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [39,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [40,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [41,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [42,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [43,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [44,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [45,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [46,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [47,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [48,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [49,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [50,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [51,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [52,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [53,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [54,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [55,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [56,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [57,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [58,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [59,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [60,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [61,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [62,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [63,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [64,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [65,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [66,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [67,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [68,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [69,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [70,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [71,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [72,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [73,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [74,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [75,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [76,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [77,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [78,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [79,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [80,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [81,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [82,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [83,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [84,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [85,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [86,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [87,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [88,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [89,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [90,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [91,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [92,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [93,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [94,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [95,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [96,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [97,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [98,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##  [99,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [100,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [101,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [102,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [103,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [104,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [105,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [106,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [107,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [108,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [109,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [110,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [111,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [112,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [113,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [114,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [115,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [116,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [117,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [118,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [119,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [120,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [121,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [122,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [123,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [124,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [125,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [126,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [127,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [128,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [129,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [130,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [131,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [132,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [133,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [134,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [135,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [136,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [137,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [138,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [139,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [140,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [141,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [142,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [143,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [144,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [145,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [146,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [147,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [148,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [149,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [150,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [151,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [152,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [153,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [154,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [155,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [156,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [157,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [158,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [159,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [160,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [161,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [162,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [163,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [164,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [165,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [166,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [167,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [168,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [169,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [170,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [171,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [172,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [173,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [174,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [175,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [176,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [177,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [178,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [179,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [180,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [181,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [182,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [183,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [184,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [185,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [186,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [187,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [188,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [189,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [190,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [191,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [192,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [193,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [194,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [195,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [196,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [197,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [198,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [199,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [200,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [201,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [202,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [203,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [204,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [205,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [206,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [207,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [208,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [209,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [210,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [211,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [212,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [213,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [214,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [215,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [216,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [217,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [218,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [219,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [220,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [221,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [222,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [223,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [224,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [225,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [226,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [227,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [228,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [229,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [230,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [231,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [232,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [233,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [234,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [235,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [236,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [237,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [238,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [239,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [240,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [241,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [242,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [243,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [244,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [245,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [246,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [247,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [248,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [249,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [250,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [251,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [252,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [253,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [254,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [255,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [256,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [257,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [258,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [259,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [260,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [261,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [262,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [263,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [264,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [265,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [266,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [267,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [268,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [269,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [270,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [271,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [272,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [273,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [274,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [275,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [276,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [277,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [278,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [279,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [280,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [281,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [282,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [283,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [284,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [285,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [286,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [287,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [288,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [289,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [290,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [291,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [292,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [293,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [294,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [295,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [296,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [297,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [298,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [299,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [300,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [301,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [302,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [303,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [304,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [305,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [306,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [307,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [308,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [309,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [310,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [311,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [312,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [313,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [314,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [315,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [316,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [317,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [318,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [319,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [320,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [321,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [322,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [323,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [324,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [325,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [326,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [327,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [328,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [329,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [330,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [331,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [332,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [333,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [334,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [335,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [336,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [337,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [338,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [339,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [340,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [341,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [342,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [343,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [344,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [345,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [346,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [347,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [348,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [349,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [350,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [351,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [352,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [353,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [354,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [355,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [356,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [357,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [358,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [359,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [360,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [361,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [362,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [363,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [364,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [365,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [366,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [367,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [368,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [369,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [370,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [371,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [372,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [373,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [374,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [375,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [376,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [377,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [378,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [379,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [380,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [381,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [382,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [383,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [384,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [385,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [386,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [387,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [388,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [389,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ## [390,] 0.004300045 0.08385089 0.2482618 0.5848062 0.07304768 0.005733394
    ##             theater
    ##   [1,] 1.290014e-08
    ##   [2,] 1.290014e-08
    ##   [3,] 1.290014e-08
    ##   [4,] 1.290014e-08
    ##   [5,] 1.290014e-08
    ##   [6,] 1.290014e-08
    ##   [7,] 1.290014e-08
    ##   [8,] 1.290014e-08
    ##   [9,] 1.290014e-08
    ##  [10,] 1.290014e-08
    ##  [11,] 1.290014e-08
    ##  [12,] 1.290014e-08
    ##  [13,] 1.290014e-08
    ##  [14,] 1.290014e-08
    ##  [15,] 1.290014e-08
    ##  [16,] 1.290014e-08
    ##  [17,] 1.290014e-08
    ##  [18,] 1.290014e-08
    ##  [19,] 1.290014e-08
    ##  [20,] 1.290014e-08
    ##  [21,] 1.290014e-08
    ##  [22,] 1.290014e-08
    ##  [23,] 1.290014e-08
    ##  [24,] 1.290014e-08
    ##  [25,] 1.290014e-08
    ##  [26,] 1.290014e-08
    ##  [27,] 1.290014e-08
    ##  [28,] 1.290014e-08
    ##  [29,] 1.290014e-08
    ##  [30,] 1.290014e-08
    ##  [31,] 1.290014e-08
    ##  [32,] 1.290014e-08
    ##  [33,] 1.290014e-08
    ##  [34,] 1.290014e-08
    ##  [35,] 1.290014e-08
    ##  [36,] 1.290014e-08
    ##  [37,] 1.290014e-08
    ##  [38,] 1.290014e-08
    ##  [39,] 1.290014e-08
    ##  [40,] 1.290014e-08
    ##  [41,] 1.290014e-08
    ##  [42,] 1.290014e-08
    ##  [43,] 1.290014e-08
    ##  [44,] 1.290014e-08
    ##  [45,] 1.290014e-08
    ##  [46,] 1.290014e-08
    ##  [47,] 1.290014e-08
    ##  [48,] 1.290014e-08
    ##  [49,] 1.290014e-08
    ##  [50,] 1.290014e-08
    ##  [51,] 1.290014e-08
    ##  [52,] 1.290014e-08
    ##  [53,] 1.290014e-08
    ##  [54,] 1.290014e-08
    ##  [55,] 1.290014e-08
    ##  [56,] 1.290014e-08
    ##  [57,] 1.290014e-08
    ##  [58,] 1.290014e-08
    ##  [59,] 1.290014e-08
    ##  [60,] 1.290014e-08
    ##  [61,] 1.290014e-08
    ##  [62,] 1.290014e-08
    ##  [63,] 1.290014e-08
    ##  [64,] 1.290014e-08
    ##  [65,] 1.290014e-08
    ##  [66,] 1.290014e-08
    ##  [67,] 1.290014e-08
    ##  [68,] 1.290014e-08
    ##  [69,] 1.290014e-08
    ##  [70,] 1.290014e-08
    ##  [71,] 1.290014e-08
    ##  [72,] 1.290014e-08
    ##  [73,] 1.290014e-08
    ##  [74,] 1.290014e-08
    ##  [75,] 1.290014e-08
    ##  [76,] 1.290014e-08
    ##  [77,] 1.290014e-08
    ##  [78,] 1.290014e-08
    ##  [79,] 1.290014e-08
    ##  [80,] 1.290014e-08
    ##  [81,] 1.290014e-08
    ##  [82,] 1.290014e-08
    ##  [83,] 1.290014e-08
    ##  [84,] 1.290014e-08
    ##  [85,] 1.290014e-08
    ##  [86,] 1.290014e-08
    ##  [87,] 1.290014e-08
    ##  [88,] 1.290014e-08
    ##  [89,] 1.290014e-08
    ##  [90,] 1.290014e-08
    ##  [91,] 1.290014e-08
    ##  [92,] 1.290014e-08
    ##  [93,] 1.290014e-08
    ##  [94,] 1.290014e-08
    ##  [95,] 1.290014e-08
    ##  [96,] 1.290014e-08
    ##  [97,] 1.290014e-08
    ##  [98,] 1.290014e-08
    ##  [99,] 1.290014e-08
    ## [100,] 1.290014e-08
    ## [101,] 1.290014e-08
    ## [102,] 1.290014e-08
    ## [103,] 1.290014e-08
    ## [104,] 1.290014e-08
    ## [105,] 1.290014e-08
    ## [106,] 1.290014e-08
    ## [107,] 1.290014e-08
    ## [108,] 1.290014e-08
    ## [109,] 1.290014e-08
    ## [110,] 1.290014e-08
    ## [111,] 1.290014e-08
    ## [112,] 1.290014e-08
    ## [113,] 1.290014e-08
    ## [114,] 1.290014e-08
    ## [115,] 1.290014e-08
    ## [116,] 1.290014e-08
    ## [117,] 1.290014e-08
    ## [118,] 1.290014e-08
    ## [119,] 1.290014e-08
    ## [120,] 1.290014e-08
    ## [121,] 1.290014e-08
    ## [122,] 1.290014e-08
    ## [123,] 1.290014e-08
    ## [124,] 1.290014e-08
    ## [125,] 1.290014e-08
    ## [126,] 1.290014e-08
    ## [127,] 1.290014e-08
    ## [128,] 1.290014e-08
    ## [129,] 1.290014e-08
    ## [130,] 1.290014e-08
    ## [131,] 1.290014e-08
    ## [132,] 1.290014e-08
    ## [133,] 1.290014e-08
    ## [134,] 1.290014e-08
    ## [135,] 1.290014e-08
    ## [136,] 1.290014e-08
    ## [137,] 1.290014e-08
    ## [138,] 1.290014e-08
    ## [139,] 1.290014e-08
    ## [140,] 1.290014e-08
    ## [141,] 1.290014e-08
    ## [142,] 1.290014e-08
    ## [143,] 1.290014e-08
    ## [144,] 1.290014e-08
    ## [145,] 1.290014e-08
    ## [146,] 1.290014e-08
    ## [147,] 1.290014e-08
    ## [148,] 1.290014e-08
    ## [149,] 1.290014e-08
    ## [150,] 1.290014e-08
    ## [151,] 1.290014e-08
    ## [152,] 1.290014e-08
    ## [153,] 1.290014e-08
    ## [154,] 1.290014e-08
    ## [155,] 1.290014e-08
    ## [156,] 1.290014e-08
    ## [157,] 1.290014e-08
    ## [158,] 1.290014e-08
    ## [159,] 1.290014e-08
    ## [160,] 1.290014e-08
    ## [161,] 1.290014e-08
    ## [162,] 1.290014e-08
    ## [163,] 1.290014e-08
    ## [164,] 1.290014e-08
    ## [165,] 1.290014e-08
    ## [166,] 1.290014e-08
    ## [167,] 1.290014e-08
    ## [168,] 1.290014e-08
    ## [169,] 1.290014e-08
    ## [170,] 1.290014e-08
    ## [171,] 1.290014e-08
    ## [172,] 1.290014e-08
    ## [173,] 1.290014e-08
    ## [174,] 1.290014e-08
    ## [175,] 1.290014e-08
    ## [176,] 1.290014e-08
    ## [177,] 1.290014e-08
    ## [178,] 1.290014e-08
    ## [179,] 1.290014e-08
    ## [180,] 1.290014e-08
    ## [181,] 1.290014e-08
    ## [182,] 1.290014e-08
    ## [183,] 1.290014e-08
    ## [184,] 1.290014e-08
    ## [185,] 1.290014e-08
    ## [186,] 1.290014e-08
    ## [187,] 1.290014e-08
    ## [188,] 1.290014e-08
    ## [189,] 1.290014e-08
    ## [190,] 1.290014e-08
    ## [191,] 1.290014e-08
    ## [192,] 1.290014e-08
    ## [193,] 1.290014e-08
    ## [194,] 1.290014e-08
    ## [195,] 1.290014e-08
    ## [196,] 1.290014e-08
    ## [197,] 1.290014e-08
    ## [198,] 1.290014e-08
    ## [199,] 1.290014e-08
    ## [200,] 1.290014e-08
    ## [201,] 1.290014e-08
    ## [202,] 1.290014e-08
    ## [203,] 1.290014e-08
    ## [204,] 1.290014e-08
    ## [205,] 1.290014e-08
    ## [206,] 1.290014e-08
    ## [207,] 1.290014e-08
    ## [208,] 1.290014e-08
    ## [209,] 1.290014e-08
    ## [210,] 1.290014e-08
    ## [211,] 1.290014e-08
    ## [212,] 1.290014e-08
    ## [213,] 1.290014e-08
    ## [214,] 1.290014e-08
    ## [215,] 1.290014e-08
    ## [216,] 1.290014e-08
    ## [217,] 1.290014e-08
    ## [218,] 1.290014e-08
    ## [219,] 1.290014e-08
    ## [220,] 1.290014e-08
    ## [221,] 1.290014e-08
    ## [222,] 1.290014e-08
    ## [223,] 1.290014e-08
    ## [224,] 1.290014e-08
    ## [225,] 1.290014e-08
    ## [226,] 1.290014e-08
    ## [227,] 1.290014e-08
    ## [228,] 1.290014e-08
    ## [229,] 1.290014e-08
    ## [230,] 1.290014e-08
    ## [231,] 1.290014e-08
    ## [232,] 1.290014e-08
    ## [233,] 1.290014e-08
    ## [234,] 1.290014e-08
    ## [235,] 1.290014e-08
    ## [236,] 1.290014e-08
    ## [237,] 1.290014e-08
    ## [238,] 1.290014e-08
    ## [239,] 1.290014e-08
    ## [240,] 1.290014e-08
    ## [241,] 1.290014e-08
    ## [242,] 1.290014e-08
    ## [243,] 1.290014e-08
    ## [244,] 1.290014e-08
    ## [245,] 1.290014e-08
    ## [246,] 1.290014e-08
    ## [247,] 1.290014e-08
    ## [248,] 1.290014e-08
    ## [249,] 1.290014e-08
    ## [250,] 1.290014e-08
    ## [251,] 1.290014e-08
    ## [252,] 1.290014e-08
    ## [253,] 1.290014e-08
    ## [254,] 1.290014e-08
    ## [255,] 1.290014e-08
    ## [256,] 1.290014e-08
    ## [257,] 1.290014e-08
    ## [258,] 1.290014e-08
    ## [259,] 1.290014e-08
    ## [260,] 1.290014e-08
    ## [261,] 1.290014e-08
    ## [262,] 1.290014e-08
    ## [263,] 1.290014e-08
    ## [264,] 1.290014e-08
    ## [265,] 1.290014e-08
    ## [266,] 1.290014e-08
    ## [267,] 1.290014e-08
    ## [268,] 1.290014e-08
    ## [269,] 1.290014e-08
    ## [270,] 1.290014e-08
    ## [271,] 1.290014e-08
    ## [272,] 1.290014e-08
    ## [273,] 1.290014e-08
    ## [274,] 1.290014e-08
    ## [275,] 1.290014e-08
    ## [276,] 1.290014e-08
    ## [277,] 1.290014e-08
    ## [278,] 1.290014e-08
    ## [279,] 1.290014e-08
    ## [280,] 1.290014e-08
    ## [281,] 1.290014e-08
    ## [282,] 1.290014e-08
    ## [283,] 1.290014e-08
    ## [284,] 1.290014e-08
    ## [285,] 1.290014e-08
    ## [286,] 1.290014e-08
    ## [287,] 1.290014e-08
    ## [288,] 1.290014e-08
    ## [289,] 1.290014e-08
    ## [290,] 1.290014e-08
    ## [291,] 1.290014e-08
    ## [292,] 1.290014e-08
    ## [293,] 1.290014e-08
    ## [294,] 1.290014e-08
    ## [295,] 1.290014e-08
    ## [296,] 1.290014e-08
    ## [297,] 1.290014e-08
    ## [298,] 1.290014e-08
    ## [299,] 1.290014e-08
    ## [300,] 1.290014e-08
    ## [301,] 1.290014e-08
    ## [302,] 1.290014e-08
    ## [303,] 1.290014e-08
    ## [304,] 1.290014e-08
    ## [305,] 1.290014e-08
    ## [306,] 1.290014e-08
    ## [307,] 1.290014e-08
    ## [308,] 1.290014e-08
    ## [309,] 1.290014e-08
    ## [310,] 1.290014e-08
    ## [311,] 1.290014e-08
    ## [312,] 1.290014e-08
    ## [313,] 1.290014e-08
    ## [314,] 1.290014e-08
    ## [315,] 1.290014e-08
    ## [316,] 1.290014e-08
    ## [317,] 1.290014e-08
    ## [318,] 1.290014e-08
    ## [319,] 1.290014e-08
    ## [320,] 1.290014e-08
    ## [321,] 1.290014e-08
    ## [322,] 1.290014e-08
    ## [323,] 1.290014e-08
    ## [324,] 1.290014e-08
    ## [325,] 1.290014e-08
    ## [326,] 1.290014e-08
    ## [327,] 1.290014e-08
    ## [328,] 1.290014e-08
    ## [329,] 1.290014e-08
    ## [330,] 1.290014e-08
    ## [331,] 1.290014e-08
    ## [332,] 1.290014e-08
    ## [333,] 1.290014e-08
    ## [334,] 1.290014e-08
    ## [335,] 1.290014e-08
    ## [336,] 1.290014e-08
    ## [337,] 1.290014e-08
    ## [338,] 1.290014e-08
    ## [339,] 1.290014e-08
    ## [340,] 1.290014e-08
    ## [341,] 1.290014e-08
    ## [342,] 1.290014e-08
    ## [343,] 1.290014e-08
    ## [344,] 1.290014e-08
    ## [345,] 1.290014e-08
    ## [346,] 1.290014e-08
    ## [347,] 1.290014e-08
    ## [348,] 1.290014e-08
    ## [349,] 1.290014e-08
    ## [350,] 1.290014e-08
    ## [351,] 1.290014e-08
    ## [352,] 1.290014e-08
    ## [353,] 1.290014e-08
    ## [354,] 1.290014e-08
    ## [355,] 1.290014e-08
    ## [356,] 1.290014e-08
    ## [357,] 1.290014e-08
    ## [358,] 1.290014e-08
    ## [359,] 1.290014e-08
    ## [360,] 1.290014e-08
    ## [361,] 1.290014e-08
    ## [362,] 1.290014e-08
    ## [363,] 1.290014e-08
    ## [364,] 1.290014e-08
    ## [365,] 1.290014e-08
    ## [366,] 1.290014e-08
    ## [367,] 1.290014e-08
    ## [368,] 1.290014e-08
    ## [369,] 1.290014e-08
    ## [370,] 1.290014e-08
    ## [371,] 1.290014e-08
    ## [372,] 1.290014e-08
    ## [373,] 1.290014e-08
    ## [374,] 1.290014e-08
    ## [375,] 1.290014e-08
    ## [376,] 1.290014e-08
    ## [377,] 1.290014e-08
    ## [378,] 1.290014e-08
    ## [379,] 1.290014e-08
    ## [380,] 1.290014e-08
    ## [381,] 1.290014e-08
    ## [382,] 1.290014e-08
    ## [383,] 1.290014e-08
    ## [384,] 1.290014e-08
    ## [385,] 1.290014e-08
    ## [386,] 1.290014e-08
    ## [387,] 1.290014e-08
    ## [388,] 1.290014e-08
    ## [389,] 1.290014e-08
    ## [390,] 1.290014e-08

``` r
# Build a new model using the Laplace correction
locmodel2 <- naive_bayes(location~ daytype + hourtype,data = locations, laplace = 1)

# Observe the new predicted probabilities for a weekend afternoon
predict(locmodel2,newdat = weekend_afternoon ,type = "prob")
```

    ##        appointment     campus      home    office restaurant       store
    ##   [1,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##   [2,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##   [3,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##   [4,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##   [5,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##   [6,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##   [7,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##   [8,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##   [9,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [10,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [11,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [12,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [13,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [14,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [15,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [16,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [17,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [18,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [19,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [20,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [21,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [22,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [23,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [24,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [25,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [26,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [27,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [28,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [29,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [30,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [31,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [32,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [33,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [34,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [35,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [36,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [37,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [38,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [39,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [40,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [41,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [42,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [43,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [44,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [45,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [46,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [47,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [48,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [49,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [50,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [51,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [52,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [53,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [54,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [55,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [56,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [57,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [58,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [59,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [60,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [61,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [62,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [63,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [64,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [65,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [66,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [67,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [68,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [69,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [70,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [71,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [72,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [73,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [74,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [75,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [76,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [77,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [78,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [79,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [80,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [81,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [82,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [83,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [84,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [85,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [86,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [87,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [88,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [89,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [90,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [91,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [92,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [93,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [94,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [95,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [96,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [97,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [98,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##  [99,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [100,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [101,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [102,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [103,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [104,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [105,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [106,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [107,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [108,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [109,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [110,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [111,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [112,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [113,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [114,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [115,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [116,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [117,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [118,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [119,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [120,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [121,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [122,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [123,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [124,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [125,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [126,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [127,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [128,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [129,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [130,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [131,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [132,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [133,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [134,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [135,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [136,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [137,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [138,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [139,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [140,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [141,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [142,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [143,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [144,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [145,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [146,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [147,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [148,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [149,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [150,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [151,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [152,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [153,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [154,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [155,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [156,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [157,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [158,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [159,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [160,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [161,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [162,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [163,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [164,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [165,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [166,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [167,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [168,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [169,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [170,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [171,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [172,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [173,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [174,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [175,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [176,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [177,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [178,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [179,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [180,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [181,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [182,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [183,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [184,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [185,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [186,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [187,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [188,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [189,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [190,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [191,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [192,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [193,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [194,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [195,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [196,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [197,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [198,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [199,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [200,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [201,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [202,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [203,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [204,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [205,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [206,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [207,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [208,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [209,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [210,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [211,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [212,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [213,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [214,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [215,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [216,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [217,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [218,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [219,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [220,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [221,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [222,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [223,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [224,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [225,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [226,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [227,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [228,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [229,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [230,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [231,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [232,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [233,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [234,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [235,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [236,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [237,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [238,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [239,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [240,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [241,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [242,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [243,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [244,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [245,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [246,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [247,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [248,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [249,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [250,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [251,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [252,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [253,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [254,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [255,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [256,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [257,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [258,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [259,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [260,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [261,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [262,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [263,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [264,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [265,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [266,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [267,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [268,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [269,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [270,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [271,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [272,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [273,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [274,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [275,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [276,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [277,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [278,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [279,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [280,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [281,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [282,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [283,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [284,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [285,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [286,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [287,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [288,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [289,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [290,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [291,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [292,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [293,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [294,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [295,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [296,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [297,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [298,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [299,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [300,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [301,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [302,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [303,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [304,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [305,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [306,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [307,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [308,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [309,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [310,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [311,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [312,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [313,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [314,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [315,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [316,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [317,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [318,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [319,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [320,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [321,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [322,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [323,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [324,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [325,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [326,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [327,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [328,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [329,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [330,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [331,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [332,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [333,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [334,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [335,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [336,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [337,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [338,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [339,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [340,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [341,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [342,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [343,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [344,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [345,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [346,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [347,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [348,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [349,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [350,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [351,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [352,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [353,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [354,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [355,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [356,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [357,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [358,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [359,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [360,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [361,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [362,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [363,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [364,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [365,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [366,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [367,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [368,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [369,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [370,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [371,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [372,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [373,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [374,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [375,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [376,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [377,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [378,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [379,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [380,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [381,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [382,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [383,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [384,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [385,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [386,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [387,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [388,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [389,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ## [390,] 0.003619847 0.08119167 0.2514452 0.5857769  0.0713174 0.006486158
    ##             theater
    ##   [1,] 0.0001628931
    ##   [2,] 0.0001628931
    ##   [3,] 0.0001628931
    ##   [4,] 0.0001628931
    ##   [5,] 0.0001628931
    ##   [6,] 0.0001628931
    ##   [7,] 0.0001628931
    ##   [8,] 0.0001628931
    ##   [9,] 0.0001628931
    ##  [10,] 0.0001628931
    ##  [11,] 0.0001628931
    ##  [12,] 0.0001628931
    ##  [13,] 0.0001628931
    ##  [14,] 0.0001628931
    ##  [15,] 0.0001628931
    ##  [16,] 0.0001628931
    ##  [17,] 0.0001628931
    ##  [18,] 0.0001628931
    ##  [19,] 0.0001628931
    ##  [20,] 0.0001628931
    ##  [21,] 0.0001628931
    ##  [22,] 0.0001628931
    ##  [23,] 0.0001628931
    ##  [24,] 0.0001628931
    ##  [25,] 0.0001628931
    ##  [26,] 0.0001628931
    ##  [27,] 0.0001628931
    ##  [28,] 0.0001628931
    ##  [29,] 0.0001628931
    ##  [30,] 0.0001628931
    ##  [31,] 0.0001628931
    ##  [32,] 0.0001628931
    ##  [33,] 0.0001628931
    ##  [34,] 0.0001628931
    ##  [35,] 0.0001628931
    ##  [36,] 0.0001628931
    ##  [37,] 0.0001628931
    ##  [38,] 0.0001628931
    ##  [39,] 0.0001628931
    ##  [40,] 0.0001628931
    ##  [41,] 0.0001628931
    ##  [42,] 0.0001628931
    ##  [43,] 0.0001628931
    ##  [44,] 0.0001628931
    ##  [45,] 0.0001628931
    ##  [46,] 0.0001628931
    ##  [47,] 0.0001628931
    ##  [48,] 0.0001628931
    ##  [49,] 0.0001628931
    ##  [50,] 0.0001628931
    ##  [51,] 0.0001628931
    ##  [52,] 0.0001628931
    ##  [53,] 0.0001628931
    ##  [54,] 0.0001628931
    ##  [55,] 0.0001628931
    ##  [56,] 0.0001628931
    ##  [57,] 0.0001628931
    ##  [58,] 0.0001628931
    ##  [59,] 0.0001628931
    ##  [60,] 0.0001628931
    ##  [61,] 0.0001628931
    ##  [62,] 0.0001628931
    ##  [63,] 0.0001628931
    ##  [64,] 0.0001628931
    ##  [65,] 0.0001628931
    ##  [66,] 0.0001628931
    ##  [67,] 0.0001628931
    ##  [68,] 0.0001628931
    ##  [69,] 0.0001628931
    ##  [70,] 0.0001628931
    ##  [71,] 0.0001628931
    ##  [72,] 0.0001628931
    ##  [73,] 0.0001628931
    ##  [74,] 0.0001628931
    ##  [75,] 0.0001628931
    ##  [76,] 0.0001628931
    ##  [77,] 0.0001628931
    ##  [78,] 0.0001628931
    ##  [79,] 0.0001628931
    ##  [80,] 0.0001628931
    ##  [81,] 0.0001628931
    ##  [82,] 0.0001628931
    ##  [83,] 0.0001628931
    ##  [84,] 0.0001628931
    ##  [85,] 0.0001628931
    ##  [86,] 0.0001628931
    ##  [87,] 0.0001628931
    ##  [88,] 0.0001628931
    ##  [89,] 0.0001628931
    ##  [90,] 0.0001628931
    ##  [91,] 0.0001628931
    ##  [92,] 0.0001628931
    ##  [93,] 0.0001628931
    ##  [94,] 0.0001628931
    ##  [95,] 0.0001628931
    ##  [96,] 0.0001628931
    ##  [97,] 0.0001628931
    ##  [98,] 0.0001628931
    ##  [99,] 0.0001628931
    ## [100,] 0.0001628931
    ## [101,] 0.0001628931
    ## [102,] 0.0001628931
    ## [103,] 0.0001628931
    ## [104,] 0.0001628931
    ## [105,] 0.0001628931
    ## [106,] 0.0001628931
    ## [107,] 0.0001628931
    ## [108,] 0.0001628931
    ## [109,] 0.0001628931
    ## [110,] 0.0001628931
    ## [111,] 0.0001628931
    ## [112,] 0.0001628931
    ## [113,] 0.0001628931
    ## [114,] 0.0001628931
    ## [115,] 0.0001628931
    ## [116,] 0.0001628931
    ## [117,] 0.0001628931
    ## [118,] 0.0001628931
    ## [119,] 0.0001628931
    ## [120,] 0.0001628931
    ## [121,] 0.0001628931
    ## [122,] 0.0001628931
    ## [123,] 0.0001628931
    ## [124,] 0.0001628931
    ## [125,] 0.0001628931
    ## [126,] 0.0001628931
    ## [127,] 0.0001628931
    ## [128,] 0.0001628931
    ## [129,] 0.0001628931
    ## [130,] 0.0001628931
    ## [131,] 0.0001628931
    ## [132,] 0.0001628931
    ## [133,] 0.0001628931
    ## [134,] 0.0001628931
    ## [135,] 0.0001628931
    ## [136,] 0.0001628931
    ## [137,] 0.0001628931
    ## [138,] 0.0001628931
    ## [139,] 0.0001628931
    ## [140,] 0.0001628931
    ## [141,] 0.0001628931
    ## [142,] 0.0001628931
    ## [143,] 0.0001628931
    ## [144,] 0.0001628931
    ## [145,] 0.0001628931
    ## [146,] 0.0001628931
    ## [147,] 0.0001628931
    ## [148,] 0.0001628931
    ## [149,] 0.0001628931
    ## [150,] 0.0001628931
    ## [151,] 0.0001628931
    ## [152,] 0.0001628931
    ## [153,] 0.0001628931
    ## [154,] 0.0001628931
    ## [155,] 0.0001628931
    ## [156,] 0.0001628931
    ## [157,] 0.0001628931
    ## [158,] 0.0001628931
    ## [159,] 0.0001628931
    ## [160,] 0.0001628931
    ## [161,] 0.0001628931
    ## [162,] 0.0001628931
    ## [163,] 0.0001628931
    ## [164,] 0.0001628931
    ## [165,] 0.0001628931
    ## [166,] 0.0001628931
    ## [167,] 0.0001628931
    ## [168,] 0.0001628931
    ## [169,] 0.0001628931
    ## [170,] 0.0001628931
    ## [171,] 0.0001628931
    ## [172,] 0.0001628931
    ## [173,] 0.0001628931
    ## [174,] 0.0001628931
    ## [175,] 0.0001628931
    ## [176,] 0.0001628931
    ## [177,] 0.0001628931
    ## [178,] 0.0001628931
    ## [179,] 0.0001628931
    ## [180,] 0.0001628931
    ## [181,] 0.0001628931
    ## [182,] 0.0001628931
    ## [183,] 0.0001628931
    ## [184,] 0.0001628931
    ## [185,] 0.0001628931
    ## [186,] 0.0001628931
    ## [187,] 0.0001628931
    ## [188,] 0.0001628931
    ## [189,] 0.0001628931
    ## [190,] 0.0001628931
    ## [191,] 0.0001628931
    ## [192,] 0.0001628931
    ## [193,] 0.0001628931
    ## [194,] 0.0001628931
    ## [195,] 0.0001628931
    ## [196,] 0.0001628931
    ## [197,] 0.0001628931
    ## [198,] 0.0001628931
    ## [199,] 0.0001628931
    ## [200,] 0.0001628931
    ## [201,] 0.0001628931
    ## [202,] 0.0001628931
    ## [203,] 0.0001628931
    ## [204,] 0.0001628931
    ## [205,] 0.0001628931
    ## [206,] 0.0001628931
    ## [207,] 0.0001628931
    ## [208,] 0.0001628931
    ## [209,] 0.0001628931
    ## [210,] 0.0001628931
    ## [211,] 0.0001628931
    ## [212,] 0.0001628931
    ## [213,] 0.0001628931
    ## [214,] 0.0001628931
    ## [215,] 0.0001628931
    ## [216,] 0.0001628931
    ## [217,] 0.0001628931
    ## [218,] 0.0001628931
    ## [219,] 0.0001628931
    ## [220,] 0.0001628931
    ## [221,] 0.0001628931
    ## [222,] 0.0001628931
    ## [223,] 0.0001628931
    ## [224,] 0.0001628931
    ## [225,] 0.0001628931
    ## [226,] 0.0001628931
    ## [227,] 0.0001628931
    ## [228,] 0.0001628931
    ## [229,] 0.0001628931
    ## [230,] 0.0001628931
    ## [231,] 0.0001628931
    ## [232,] 0.0001628931
    ## [233,] 0.0001628931
    ## [234,] 0.0001628931
    ## [235,] 0.0001628931
    ## [236,] 0.0001628931
    ## [237,] 0.0001628931
    ## [238,] 0.0001628931
    ## [239,] 0.0001628931
    ## [240,] 0.0001628931
    ## [241,] 0.0001628931
    ## [242,] 0.0001628931
    ## [243,] 0.0001628931
    ## [244,] 0.0001628931
    ## [245,] 0.0001628931
    ## [246,] 0.0001628931
    ## [247,] 0.0001628931
    ## [248,] 0.0001628931
    ## [249,] 0.0001628931
    ## [250,] 0.0001628931
    ## [251,] 0.0001628931
    ## [252,] 0.0001628931
    ## [253,] 0.0001628931
    ## [254,] 0.0001628931
    ## [255,] 0.0001628931
    ## [256,] 0.0001628931
    ## [257,] 0.0001628931
    ## [258,] 0.0001628931
    ## [259,] 0.0001628931
    ## [260,] 0.0001628931
    ## [261,] 0.0001628931
    ## [262,] 0.0001628931
    ## [263,] 0.0001628931
    ## [264,] 0.0001628931
    ## [265,] 0.0001628931
    ## [266,] 0.0001628931
    ## [267,] 0.0001628931
    ## [268,] 0.0001628931
    ## [269,] 0.0001628931
    ## [270,] 0.0001628931
    ## [271,] 0.0001628931
    ## [272,] 0.0001628931
    ## [273,] 0.0001628931
    ## [274,] 0.0001628931
    ## [275,] 0.0001628931
    ## [276,] 0.0001628931
    ## [277,] 0.0001628931
    ## [278,] 0.0001628931
    ## [279,] 0.0001628931
    ## [280,] 0.0001628931
    ## [281,] 0.0001628931
    ## [282,] 0.0001628931
    ## [283,] 0.0001628931
    ## [284,] 0.0001628931
    ## [285,] 0.0001628931
    ## [286,] 0.0001628931
    ## [287,] 0.0001628931
    ## [288,] 0.0001628931
    ## [289,] 0.0001628931
    ## [290,] 0.0001628931
    ## [291,] 0.0001628931
    ## [292,] 0.0001628931
    ## [293,] 0.0001628931
    ## [294,] 0.0001628931
    ## [295,] 0.0001628931
    ## [296,] 0.0001628931
    ## [297,] 0.0001628931
    ## [298,] 0.0001628931
    ## [299,] 0.0001628931
    ## [300,] 0.0001628931
    ## [301,] 0.0001628931
    ## [302,] 0.0001628931
    ## [303,] 0.0001628931
    ## [304,] 0.0001628931
    ## [305,] 0.0001628931
    ## [306,] 0.0001628931
    ## [307,] 0.0001628931
    ## [308,] 0.0001628931
    ## [309,] 0.0001628931
    ## [310,] 0.0001628931
    ## [311,] 0.0001628931
    ## [312,] 0.0001628931
    ## [313,] 0.0001628931
    ## [314,] 0.0001628931
    ## [315,] 0.0001628931
    ## [316,] 0.0001628931
    ## [317,] 0.0001628931
    ## [318,] 0.0001628931
    ## [319,] 0.0001628931
    ## [320,] 0.0001628931
    ## [321,] 0.0001628931
    ## [322,] 0.0001628931
    ## [323,] 0.0001628931
    ## [324,] 0.0001628931
    ## [325,] 0.0001628931
    ## [326,] 0.0001628931
    ## [327,] 0.0001628931
    ## [328,] 0.0001628931
    ## [329,] 0.0001628931
    ## [330,] 0.0001628931
    ## [331,] 0.0001628931
    ## [332,] 0.0001628931
    ## [333,] 0.0001628931
    ## [334,] 0.0001628931
    ## [335,] 0.0001628931
    ## [336,] 0.0001628931
    ## [337,] 0.0001628931
    ## [338,] 0.0001628931
    ## [339,] 0.0001628931
    ## [340,] 0.0001628931
    ## [341,] 0.0001628931
    ## [342,] 0.0001628931
    ## [343,] 0.0001628931
    ## [344,] 0.0001628931
    ## [345,] 0.0001628931
    ## [346,] 0.0001628931
    ## [347,] 0.0001628931
    ## [348,] 0.0001628931
    ## [349,] 0.0001628931
    ## [350,] 0.0001628931
    ## [351,] 0.0001628931
    ## [352,] 0.0001628931
    ## [353,] 0.0001628931
    ## [354,] 0.0001628931
    ## [355,] 0.0001628931
    ## [356,] 0.0001628931
    ## [357,] 0.0001628931
    ## [358,] 0.0001628931
    ## [359,] 0.0001628931
    ## [360,] 0.0001628931
    ## [361,] 0.0001628931
    ## [362,] 0.0001628931
    ## [363,] 0.0001628931
    ## [364,] 0.0001628931
    ## [365,] 0.0001628931
    ## [366,] 0.0001628931
    ## [367,] 0.0001628931
    ## [368,] 0.0001628931
    ## [369,] 0.0001628931
    ## [370,] 0.0001628931
    ## [371,] 0.0001628931
    ## [372,] 0.0001628931
    ## [373,] 0.0001628931
    ## [374,] 0.0001628931
    ## [375,] 0.0001628931
    ## [376,] 0.0001628931
    ## [377,] 0.0001628931
    ## [378,] 0.0001628931
    ## [379,] 0.0001628931
    ## [380,] 0.0001628931
    ## [381,] 0.0001628931
    ## [382,] 0.0001628931
    ## [383,] 0.0001628931
    ## [384,] 0.0001628931
    ## [385,] 0.0001628931
    ## [386,] 0.0001628931
    ## [387,] 0.0001628931
    ## [388,] 0.0001628931
    ## [389,] 0.0001628931
    ## [390,] 0.0001628931

-   *Adding the Laplace correction allows for the small chance that
    Brett might go to the office on the weekend in the future.*

#### Understanding the Laplace correction

By default, the naive_bayes() function in the naivebayes package does
not use the Laplace correction. What is the risk of leaving this
parameter unset? - *The small probability added to every outcome ensures
that they are all possible even if never previously observed.*
