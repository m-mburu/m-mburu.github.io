Writing Efficient R Code
================
Mburu
8/13/2021

## R version

One of the relatively easy optimizations available is to use an
up-to-date version of R. In general, R is very conservative, so
upgrading doesn’t break existing code. However, a new version will often
provide free speed boosts for key functions.

The version command returns a list that contains (among other things)
the major and minor version of R currently being used.

``` r
# Print the R version details using version
version
```

    ##                _                           
    ## platform       x86_64-pc-linux-gnu         
    ## arch           x86_64                      
    ## os             linux-gnu                   
    ## system         x86_64, linux-gnu           
    ## status                                     
    ## major          4                           
    ## minor          1.0                         
    ## year           2021                        
    ## month          05                          
    ## day            18                          
    ## svn rev        80317                       
    ## language       R                           
    ## version.string R version 4.1.0 (2021-05-18)
    ## nickname       Camp Pontanezen

``` r
# Assign the variable major to the major component
major <- version$major

# Assign the variable minor to the minor component
minor <- version$minor
```

## Comparing read times of CSV and RDS files

One of the most common tasks we perform is reading in data from CSV
files. However, for large CSV files this can be slow. One neat trick is
to read in the data and save as an R binary file (rds) using saveRDS().
To read in the rds file, we use readRDS().

Note: Since rds is R’s native format for storing single objects, you
have not introduced any third-party dependencies that may change in the
future.

To benchmark the two approaches, you can use system.time(). This
function returns the time taken to evaluate any R expression. For
example, to time how long it takes to calculate the square root of the
numbers from one to ten million, you would write the following:

``` r
# How long does it take to read movies from CSV?
system.time(read.csv("movies.csv"))
```

    ##    user  system elapsed 
    ##   0.126   0.004   0.130

``` r
# How long does it take to read movies from RDS?
system.time(readRDS("movies.rds"))
```

    ##    user  system elapsed 
    ##   0.031   0.000   0.031

## Elapsed time

Using system.time() is convenient, but it does have its drawbacks when
comparing multiple function calls. The microbenchmark package solves
this problem with the microbenchmark() function.

``` r
# Load the microbenchmark package
library(microbenchmark)

# Compare the two functions
compare <- microbenchmark(read.csv("movies.csv"), 
                          readRDS("movies.rds"), 
                          times = 100)

# Print compare
compare
```

<div class="kable-table">

| expr                   |      time |
|:-----------------------|----------:|
| readRDS(“movies.rds”)  |  31071458 |
| readRDS(“movies.rds”)  |  30031711 |
| read.csv(“movies.csv”) | 127878070 |
| readRDS(“movies.rds”)  |  35910087 |
| read.csv(“movies.csv”) | 120675864 |
| read.csv(“movies.csv”) | 123733109 |
| read.csv(“movies.csv”) | 123285662 |
| readRDS(“movies.rds”)  |  30170839 |
| readRDS(“movies.rds”)  |  33132470 |
| read.csv(“movies.csv”) | 125732459 |
| readRDS(“movies.rds”)  |  30302471 |
| read.csv(“movies.csv”) | 121926533 |
| readRDS(“movies.rds”)  |  30585383 |
| readRDS(“movies.rds”)  |  29378145 |
| read.csv(“movies.csv”) | 126186806 |
| read.csv(“movies.csv”) | 125436070 |
| read.csv(“movies.csv”) | 148366956 |
| readRDS(“movies.rds”)  |  30550730 |
| read.csv(“movies.csv”) | 125148429 |
| read.csv(“movies.csv”) | 128983758 |
| read.csv(“movies.csv”) | 146951663 |
| read.csv(“movies.csv”) | 120612347 |
| read.csv(“movies.csv”) | 121701061 |
| read.csv(“movies.csv”) | 123711031 |
| read.csv(“movies.csv”) | 130127017 |
| read.csv(“movies.csv”) | 123931513 |
| read.csv(“movies.csv”) | 124668132 |
| readRDS(“movies.rds”)  |  33604666 |
| read.csv(“movies.csv”) | 130222079 |
| read.csv(“movies.csv”) | 154414607 |
| read.csv(“movies.csv”) | 132892261 |
| read.csv(“movies.csv”) | 122885438 |
| read.csv(“movies.csv”) | 133527646 |
| readRDS(“movies.rds”)  |  36807043 |
| readRDS(“movies.rds”)  |  33894375 |
| read.csv(“movies.csv”) | 132544443 |
| readRDS(“movies.rds”)  |  30303654 |
| read.csv(“movies.csv”) | 132432035 |
| readRDS(“movies.rds”)  |  33749810 |
| read.csv(“movies.csv”) | 157976966 |
| read.csv(“movies.csv”) | 123789107 |
| readRDS(“movies.rds”)  |  30611962 |
| read.csv(“movies.csv”) | 132239202 |
| read.csv(“movies.csv”) | 131219638 |
| readRDS(“movies.rds”)  |  32842114 |
| readRDS(“movies.rds”)  |  36534550 |
| readRDS(“movies.rds”)  |  32274455 |
| readRDS(“movies.rds”)  |  32299301 |
| readRDS(“movies.rds”)  |  32677420 |
| read.csv(“movies.csv”) | 133557894 |
| readRDS(“movies.rds”)  |  32385523 |
| readRDS(“movies.rds”)  |  34636364 |
| readRDS(“movies.rds”)  |  34080161 |
| readRDS(“movies.rds”)  |  31864697 |
| read.csv(“movies.csv”) | 129884016 |
| readRDS(“movies.rds”)  |  34148438 |
| readRDS(“movies.rds”)  |  31315152 |
| readRDS(“movies.rds”)  |  34390950 |
| readRDS(“movies.rds”)  |  31455542 |
| readRDS(“movies.rds”)  |  32529648 |
| readRDS(“movies.rds”)  |  34486180 |
| read.csv(“movies.csv”) | 131607749 |
| readRDS(“movies.rds”)  |  32049431 |
| read.csv(“movies.csv”) | 134759972 |
| read.csv(“movies.csv”) | 130439288 |
| readRDS(“movies.rds”)  |  32907691 |
| readRDS(“movies.rds”)  |  34058312 |
| readRDS(“movies.rds”)  |  34039455 |
| read.csv(“movies.csv”) | 135812431 |
| read.csv(“movies.csv”) | 128895360 |
| readRDS(“movies.rds”)  |  33734700 |
| readRDS(“movies.rds”)  |  31160528 |
| readRDS(“movies.rds”)  |  40388806 |
| readRDS(“movies.rds”)  |  31951567 |
| read.csv(“movies.csv”) | 132760932 |
| read.csv(“movies.csv”) | 161375927 |
| read.csv(“movies.csv”) | 135502640 |
| readRDS(“movies.rds”)  |  32185501 |
| read.csv(“movies.csv”) | 138912864 |
| read.csv(“movies.csv”) | 139245325 |
| read.csv(“movies.csv”) | 139879167 |
| readRDS(“movies.rds”)  |  33943486 |
| readRDS(“movies.rds”)  |  34358778 |
| read.csv(“movies.csv”) | 144498532 |
| read.csv(“movies.csv”) | 136898951 |
| readRDS(“movies.rds”)  |  34670409 |
| readRDS(“movies.rds”)  |  30660295 |
| read.csv(“movies.csv”) | 134729185 |
| read.csv(“movies.csv”) | 174763357 |
| read.csv(“movies.csv”) | 151010100 |
| readRDS(“movies.rds”)  |  41809617 |
| readRDS(“movies.rds”)  |  34862472 |
| read.csv(“movies.csv”) | 157293434 |
| readRDS(“movies.rds”)  |  32217468 |
| read.csv(“movies.csv”) | 139276963 |
| read.csv(“movies.csv”) | 131344302 |
| read.csv(“movies.csv”) | 138504457 |
| read.csv(“movies.csv”) | 132392786 |
| readRDS(“movies.rds”)  |  33189477 |
| readRDS(“movies.rds”)  |  33647501 |
| read.csv(“movies.csv”) | 137409314 |
| read.csv(“movies.csv”) | 127768104 |
| readRDS(“movies.rds”)  |  32129318 |
| readRDS(“movies.rds”)  |  36365543 |
| read.csv(“movies.csv”) | 140875123 |
| read.csv(“movies.csv”) | 141590123 |
| readRDS(“movies.rds”)  |  35385726 |
| read.csv(“movies.csv”) | 134029756 |
| readRDS(“movies.rds”)  |  34254107 |
| readRDS(“movies.rds”)  |  39655783 |
| readRDS(“movies.rds”)  |  32829800 |
| readRDS(“movies.rds”)  |  35411691 |
| readRDS(“movies.rds”)  |  46157611 |
| readRDS(“movies.rds”)  |  35333245 |
| read.csv(“movies.csv”) | 192933983 |
| read.csv(“movies.csv”) | 130325062 |
| readRDS(“movies.rds”)  |  39203410 |
| readRDS(“movies.rds”)  |  33398740 |
| read.csv(“movies.csv”) | 129614344 |
| read.csv(“movies.csv”) | 129094900 |
| read.csv(“movies.csv”) | 126923224 |
| read.csv(“movies.csv”) | 127713700 |
| read.csv(“movies.csv”) | 149302337 |
| readRDS(“movies.rds”)  |  31173404 |
| readRDS(“movies.rds”)  |  31941574 |
| read.csv(“movies.csv”) | 124697345 |
| readRDS(“movies.rds”)  |  31141371 |
| read.csv(“movies.csv”) | 125332288 |
| readRDS(“movies.rds”)  |  31066922 |
| readRDS(“movies.rds”)  |  29348509 |
| read.csv(“movies.csv”) | 128301698 |
| read.csv(“movies.csv”) | 129265695 |
| read.csv(“movies.csv”) | 143580319 |
| read.csv(“movies.csv”) | 124068476 |
| read.csv(“movies.csv”) | 123699803 |
| readRDS(“movies.rds”)  |  32939924 |
| readRDS(“movies.rds”)  |  29666126 |
| read.csv(“movies.csv”) | 125279675 |
| read.csv(“movies.csv”) | 127478141 |
| readRDS(“movies.rds”)  |  31402954 |
| readRDS(“movies.rds”)  |  30233230 |
| readRDS(“movies.rds”)  |  30096529 |
| read.csv(“movies.csv”) | 128091503 |
| readRDS(“movies.rds”)  |  29951123 |
| read.csv(“movies.csv”) | 131455466 |
| readRDS(“movies.rds”)  |  30279235 |
| read.csv(“movies.csv”) | 124059495 |
| readRDS(“movies.rds”)  |  33063307 |
| read.csv(“movies.csv”) | 123194662 |
| read.csv(“movies.csv”) | 125069300 |
| readRDS(“movies.rds”)  |  33999359 |
| readRDS(“movies.rds”)  |  29652806 |
| read.csv(“movies.csv”) | 128184651 |
| read.csv(“movies.csv”) | 126437738 |
| readRDS(“movies.rds”)  |  30619506 |
| readRDS(“movies.rds”)  |  30516408 |
| read.csv(“movies.csv”) | 127079810 |
| readRDS(“movies.rds”)  |  33805763 |
| readRDS(“movies.rds”)  |  30189456 |
| readRDS(“movies.rds”)  |  32706030 |
| readRDS(“movies.rds”)  |  32859696 |
| readRDS(“movies.rds”)  |  30086247 |
| readRDS(“movies.rds”)  |  29618974 |
| read.csv(“movies.csv”) | 126630163 |
| readRDS(“movies.rds”)  |  33671213 |
| read.csv(“movies.csv”) | 130386795 |
| read.csv(“movies.csv”) | 130646045 |
| read.csv(“movies.csv”) | 152636659 |
| read.csv(“movies.csv”) | 136962497 |
| read.csv(“movies.csv”) | 134501125 |
| readRDS(“movies.rds”)  |  31167499 |
| readRDS(“movies.rds”)  |  33411497 |
| readRDS(“movies.rds”)  |  31271058 |
| readRDS(“movies.rds”)  |  32624942 |
| read.csv(“movies.csv”) | 133210866 |
| readRDS(“movies.rds”)  |  31669344 |
| read.csv(“movies.csv”) | 130200396 |
| readRDS(“movies.rds”)  |  30600080 |
| read.csv(“movies.csv”) | 128931407 |
| read.csv(“movies.csv”) | 136212978 |
| read.csv(“movies.csv”) | 128596088 |
| readRDS(“movies.rds”)  |  34287619 |
| readRDS(“movies.rds”)  |  30359770 |
| read.csv(“movies.csv”) | 129000861 |
| read.csv(“movies.csv”) | 133138012 |
| readRDS(“movies.rds”)  |  30538352 |
| read.csv(“movies.csv”) | 127710923 |
| readRDS(“movies.rds”)  |  31137000 |
| read.csv(“movies.csv”) | 134962805 |
| readRDS(“movies.rds”)  |  33483668 |
| read.csv(“movies.csv”) | 155828548 |
| readRDS(“movies.rds”)  |  30690721 |
| readRDS(“movies.rds”)  |  31236778 |
| readRDS(“movies.rds”)  |  31037677 |
| read.csv(“movies.csv”) | 128369150 |
| read.csv(“movies.csv”) | 127832456 |
| readRDS(“movies.rds”)  |  33950104 |
| read.csv(“movies.csv”) | 133269865 |
| readRDS(“movies.rds”)  |  30280731 |
| readRDS(“movies.rds”)  |  30362842 |

</div>

My hardware For many problems your time is the expensive part. If having
a faster computer makes you more productive, it can be cost effective to
buy one. However, before you splash out on new toys for yourself, your
boss/partner may want to see some numbers to justify the expense.
Measuring the performance of your computer is called benchmarking, and
you can do that with the benchmarkme package.

``` r
# Load the benchmarkme package
library(benchmarkme)

# Assign the variable ram to the amount of RAM on this machine
ram <- get_ram()
ram
```

    ## 16.5 GB

``` r
# Assign the variable cpu to the cpu specs
cpu <- get_cpu()
cpu
```

    ## $vendor_id
    ## [1] "GenuineIntel"
    ## 
    ## $model_name
    ## [1] "11th Gen Intel(R) Core(TM) i7-11370H @ 3.30GHz"
    ## 
    ## $no_of_cores
    ## [1] 8

## Benchmark DataCamp’s machine

The benchmarkme package allows you to run a set of standardized
benchmarks and compare your results to other users. One set of
benchmarks tests is reading and writing speeds.

The function call

res = benchmark\_io(runs = 1, size = 5) records the length of time it
takes to read and write a 5MB file.

``` r
# Run the io benchmark
res <- benchmark_io(runs = 1, size = 50)
```

    ## Preparing read/write io

    ## # IO benchmarks (2 tests) for size 50 MB:

    ##   Writing a csv with 6250000 values: 4.02 (sec).

    ##   Reading a csv with 6250000 values: 1.44 (sec).

``` r
# Plot the results
plot(res)
```

    ## You are ranked 2 out of 119 machines.

    ## Press return to get next plot

    ## You are ranked 2 out of 119 machines.

![](efficient_R_code_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->![](efficient_R_code_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->

## Benchmark r operations

``` r
# Run each benchmark 3 times
res <- benchmark_std(runs = 10)
```

    ## # Programming benchmarks (5 tests):

    ##  3,500,000 Fibonacci numbers calculation (vector calc): 0.113 (sec).

    ##  Grand common divisors of 1,000,000 pairs (recursion): 0.396 (sec).

    ##  Creation of a 3,500 x 3,500 Hilbert matrix (matrix calc): 0.171 (sec).

    ##  Creation of a 3,000 x 3,000 Toeplitz matrix (loops): 1.15 (sec).

    ##  Escoufier's method on a 60 x 60 matrix (mixed): 0.762 (sec).

    ## # Matrix calculation benchmarks (5 tests):

    ##  Creation, transp., deformation of a 5,000 x 5,000 matrix: 0.282 (sec).

    ##  2,500 x 2,500 normal distributed random matrix^1,000: 0.155 (sec).

    ##  Sorting of 7,000,000 random values: 0.538 (sec).

    ##  2,500 x 2,500 cross-product matrix (b = a' * a): 7.35 (sec).

    ##  Linear regr. over a 5,000 x 500 matrix (c = a \ b'): 0.605 (sec).

    ## # Matrix function benchmarks (5 tests):

    ##  Cholesky decomposition of a 3,000 x 3,000 matrix: 3.83 (sec).

    ##  Determinant of a 2,500 x 2,500 random matrix: 2.16 (sec).

    ##  Eigenvalues of a 640 x 640 random matrix: 0.457 (sec).

    ##  FFT over 2,500,000 random values: 0.174 (sec).

    ##  Inverse of a 1,600 x 1,600 random matrix: 2.09 (sec).

``` r
plot(res)
```

    ## You are ranked 5 out of 749 machines.

    ## Press return to get next plot

    ## You are ranked 96 out of 747 machines.

![](efficient_R_code_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

    ## Press return to get next plot

    ## You are ranked 160 out of 747 machines.

![](efficient_R_code_files/figure-gfm/unnamed-chunk-6-2.png)<!-- -->![](efficient_R_code_files/figure-gfm/unnamed-chunk-6-3.png)<!-- -->

## Timings - growing a vector

Growing a vector is one of the deadly sins in R; you should always avoid
it.

The growing() function defined below generates n random standard normal
numbers, but grows the size of the vector each time an element is added!

Note: Standard normal numbers are numbers drawn from a normal
distribution with mean 0 and standard deviation 1.

n &lt;- 30000 \# Slow code growing &lt;- function(n) { x &lt;- NULL
for(i in 1:n) x &lt;- c(x, rnorm(1)) x }

``` r
growing <- function(n) {
    x = NULL
    for(i in 1:n) 
        x = c(x, rnorm(1))
    x
}

# Use <- with system.time() to store the result as res_grow
system.time(res_grow <- growing(30000))
```

    ##    user  system elapsed 
    ##    0.62    0.00    0.62

Timings - pre-allocation In the previous exercise, growing the vector
took around 2 seconds. How long does it take when we pre-allocate the
vector? The pre\_allocate() function is defined below.

``` r
n <- 30000
# Fast code
pre_allocate <- function(n) {
    x <- numeric(n) # Pre-allocate
    for(i in 1:n) 
        x[i] <- rnorm(1)
    x
}


# Use <- with system.time() to store the result as res_allocate
n <- 30000
system.time(res_allocate <- pre_allocate(n))
```

    ##    user  system elapsed 
    ##   0.033   0.000   0.034
