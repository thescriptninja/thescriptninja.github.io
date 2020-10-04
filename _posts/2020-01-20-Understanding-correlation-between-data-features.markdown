---
layout: post
title: Understanding correlation between data features
date: 2020-01-20 1:23:54 IST
description: The Pearson correlation coefficient
author: Parth Paradkar
fbcomments: yes
tags: [post]
---

# Understanding correlation 


One of the main questions I faced while exploring data was that how can I measure the strength of the relationship between two features of the data. 

For example, how is the price of a car related with its mileage? How do we quantify their interdependence? How strong is the relationship? 

I attempt to explore this mathematically in this notebook.


```python
# Importing the required libraries
import pandas as pd
import seaborn as sns
```

### We shall consider a dataset that gives the specifications of cars and their prices.
Dataset link: [https://archive.ics.uci.edu/ml/datasets/automobile](https://archive.ics.uci.edu/ml/datasets/automobile)


```python
df = pd.read_csv("Automobile_data.csv")

# We shall consider three variables: the logarithm of the price, city mileage, curb weight.
test_df = pd.read_csv('corr_data.csv')
```

## The Pearson Correlation Coefficient

To measure the linear correlation between variables, correlation coefficients are defined. One such coefficient that pandas uses by default is the Pearson correlation coefficient.

Suppose we have two features (columns in the data) of the data: `X` and `Y`. Each feature contains `n` data points. Pearson correlation $r_{XY}$ is defined as: 

$r_{XY} = \frac{\sum(X_i - \overline{X})(Y_i - \overline{Y})}{\sqrt{\sum(X_i - \overline{X})^2}\sqrt{\sum(Y_i - \overline{Y})^2}}$

Here, $\overline{X}$ represents the mean of all the values of $X$. 

A value of 1 represents positive linear dependence i.e. $Y_{i} = mX_{i} + C$ where $m > 0$. 

A value of -1 represents negative linear dependence i.e. $Y_{i} = mX_{i} + C$ where $m < 0$

As we rarely find data that has exact linear dependence, the values of $r_{XY}$ practically lie between 1 and -1. Values closer to 0 represent little or no linear correlation between the two variables.


Let us investigate the different components of the above mathematical expression.

1. $(X_{i} - \overline{X})$ 

This expresses the distance of the $i^{th}$ point from $\overline{X}$. If $X_{i}$ is greater than the mean $X$ value, the expression's value will be positive and vice versa.

2. Similarly, $(Y_{i} - \overline{Y})$ is calculated. 
 
 
3. $\sqrt{\sum(X_i - \overline{X})^2}$ and $\sqrt{\sum(Y_i - \overline{Y})^2}$ 

The value of the numerator in the expression or $r_{XY}$ will depend upon the actual values of X and Y. Assume that we are dealing with values of $X$ and $Y$ that are quite high. We will correspondingly obtain high values of $X_{i} - \overline{X}$ and $Y_{i} - \overline{Y}$ and the value of the coefficient will not be constrained between 1 and -1. 

The above expressions normalize the coefficient.

Let us head over to a practical example.


We'll consider three features of the data: `log_price`: which is the logarithm of the price of the car; `city-mpg`: the city mileage of cars; `curb-weight`: the total mass of the vehicle without any passengers or cargo. 

P.S: We consider the logarithms of the price to deal with the skewness in the price and bring its distribution closer to the normal distribution.


```python
test_df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>log_price</th>
      <th>city-mpg</th>
      <th>curb-weight</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>9.510075</td>
      <td>21.0</td>
      <td>2548</td>
    </tr>
    <tr>
      <th>1</th>
      <td>9.711116</td>
      <td>21.0</td>
      <td>2548</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9.711116</td>
      <td>19.0</td>
      <td>2823</td>
    </tr>
    <tr>
      <th>3</th>
      <td>9.543235</td>
      <td>24.0</td>
      <td>2337</td>
    </tr>
    <tr>
      <th>4</th>
      <td>9.767095</td>
      <td>18.0</td>
      <td>2824</td>
    </tr>
  </tbody>
</table>
</div>



The correlation coefficients between each of the 3 features can be obtained from the corr() function offered by pandas


```python
test_df.corr()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>log_price</th>
      <th>city-mpg</th>
      <th>curb-weight</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>log_price</th>
      <td>1.000000</td>
      <td>-0.774933</td>
      <td>0.891455</td>
    </tr>
    <tr>
      <th>city-mpg</th>
      <td>-0.774933</td>
      <td>1.000000</td>
      <td>-0.749543</td>
    </tr>
    <tr>
      <th>curb-weight</th>
      <td>0.891455</td>
      <td>-0.749543</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>



I will try and give you a mathematical intuition of what is actually happening behind the scenes.


```python
# Calculating the mean values of each column

avgs = test_df.mean()
avgs
```




    log_price         9.350115
    city-mpg         25.179104
    curb-weight    2555.666667
    dtype: float64












## Consider the relationship between the variables log_price and curb_weight


![png](/img/pearson_correlation_12_1.png)

Looking at the graph above, we find that the two variables have a strong positive linear interdependence. Higher the curb weight, higher is the price. This is also apparent from the correlation matrix above as the Pearson coefficient has a value of 0.891455.

The red point represents $(\overline{X}, \overline{Y})$. 

Consider the two points shown in green and blue lying on opposite sides of the red point.

Let the green point be the $m^{th}$ point. Looking at its position, we can infer that $X_{m} - \overline{X} > 0$ and $Y_{m} - \overline{Y} > 0$. 

Hence, $(X_{m} - \overline{X})(Y_{m} - \overline{Y}) > 0$

Let the blue point be the $k^{th}$ point. From its position, we can say that $X_{m} - \overline{X} < 0$ and $Y_{m} - \overline{Y} < 0$. 

Hence, $(X_{k} - \overline{X})(Y_{k} - \overline{Y}) > 0$

Thus, for points lying to the `top-right` and `bottom-left` of $(\overline{X}, \overline{Y})$ will give positive values of the above product. The numerator of $r_{XY}$ is the sum of all such products. Hence for these two features, a net positive sum will be obtained, which will be normalized to values between 0 and 1.











## A similar analysis can be done for city-mpg and log_price in the graph below

![png](/img/pearson_correlation_14_1.png)

For the green($m^{th}$) point, $X_{m} - \overline{X} > 0$ and $Y_{m} - \overline{Y} < 0$. 

Hence, $(X_{k} - \overline{X})(Y_{k} - \overline{Y}) < 0$

For the blue($k^{th}$) point, $X_{m} - \overline{X} < 0$ and $Y_{m} - \overline{Y} > 0$. 

Hence, $(X_{k} - \overline{X})(Y_{k} - \overline{Y}) < 0$

For all points lying to the `top-left` and `bottom-right` will have negative values of the above product. As most points lie in these two regions, the net sum of these values will ultimately be negative and the value of $r_{XY}$ will lie between -1 and 0. 

For these two features, we can see from the matrix that the correlation coefficient is -0.774933.

## Regarding the strength of the correlation and its application.

Often we need to choose the features to feed into a Regression model to predict a target value (in our example, the price of the car). Now that we know the correlation coefficients, we are in a better position to choose the best features for our model. Features having the highest magnitudes will be chosen since they have a linear relationship with the target variable. By manipulating the features, we can increase the accuracy of our model (for example, I chose the logarithm of the price since it handled the skewness and gave higher correlation values).

## Final thoughts

Using some simple mathematical techniques, we have simply divided the graph into four parts (or quadrants) about the mean point: `top-left` of the mean point, `top-right` of the mean point, `bottom-left` of the mean point and `bottom-right` of the mean point. We find the pair of quadrants in which majority of data points live and then infer the nature of the interdependence of the two variables under consideration. 

The correlation matrix can be visualized using heatmaps in seaborn.


```python
sns.heatmap(test_df.corr())
```








![png](/img/pearson_correlation_17_1.png)


For a larger number of features, the correlation can be easily understood with a heatmap.


```python
sns.heatmap(df.corr())
```








![png](/img/pearson_correlation_19_1.png)

### Thanks for reading!
