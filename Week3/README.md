## Week 3 Content

This week's directory actually covers Week 3 and Week 4 content.

We covered:
**Intro to R**
- R basics
- R data structures (and dataframes)
- Functions in R
- Importing and exporting data
- Writing and running R code (including debugging)
- Vectorisation

**Data Management and Visualisation**
- Data wrangling principles
- Data exploration using tidyverse
- Handling big data
- Data visualisation in R
  - Base R
  - Using qplot and ggplot

**Language(s):** R - version 3.4.2

**Dependencies:**
- maps
- tidyverse (in particular: tidyr, dplyr, ggplot2, purrr, tibble, readr)
- ggthemes
- reshape2

**Installation:**
Install from within R:
- **maps**
  - `install.packages("maps")`
- **tidyverse**
  - `install.packages(c("tidyverse"))`
- **ggthemes**
  - `install.packages("ggthemes")`
- **reshape2**
  - `install.packages("reshape2")`


### Project structure

4 directories:
- **Code** - python scripts (see 'File descriptions' section)
- **Data** - data that some scripts are run on
- **Results** - results eg. data manipulation outputs/graphs (note: empty until code is run)
- (Local repo also contains **Sandbox** with test files)

### File descriptions

#### Intro to R (Week 3)
- **Apply1.R** - Script demonstrating the use of the apply() function
- **Apply2.R** - Script demonstrating use of a user-written function with apply() function
- **Basic_io.R** - A simple script to illustrate R input-output.
- **Boilerplate.R** - A boilerplate R script
- **Break.R** - Script that demonstrates use of break in while loop
- **Browse.R** - Script that defines a function to simulate exponential growth
- **Control_flow.R** - Demonstrates printing in loops and with if statements
- **Next.R** - Script that demonstrates a simple for loop - prints only odd numbers
- **Preallocate.R** - Script that demonstrates the increased efficiency of preallocation of vectors (when compared to no preallocation)
- **R_conditionals.R** - A set of functions demonstrating the use of conditionals (eg. function to check whether a number is prime)
- **Ricker.R** - Script containing a function that runs a simulation of the Ricker model
- **Sample.R** - Script that demonstrates speed of vectorisation and sapply and lapply functions
- **TAutoCorr.R** - Test hypothesis that temperatures in successive years are correlated by calculating the correlation coefficient of random permutations of the dataset and comparing to the actual dataset to give a p-value
- **TreeHeight.R** - Calculates heights of trees given distance of each tree from its base and angle to its top, using the trigonometric formula
- **Try.R** - Script that demonstrates use of the try() function
- **Vectorize1.R** - Script demonstrating speed of using vectorisation when manipulating matrices
- **Vectorize2.R** - Stochastic implementation of the Ricker model and a vectorised version

#### Data Mangagement and Visualisation (Week 4)
- **Basic_plotting.R** - Exercises demonstrating plotting in base R
- **DataWrang.R** - Wrangling the PoundHill Dataset
- **DataWrangTidy.R** - Wrangling the PoundHill Dataset using
- **GPDD_Data.R** - Script that maps out all the locations from GPDD dataset onto a world map
- **Ggplot.R** - Exercises demonstrating use of ggplot() function
- **Girko.R** - Script that shows a graphical representation of Girko's circular law
- **MyBars.R** - Exercise demonstrating use of geom_text for annotating plots
- **PP_Dists.R** - Script that plots density subplots for predator mass, prey mass and mass ratio by feeding interaction type and outputs their means and medians to a csv file
- **PP_Regress.R** - Script that creates ggplot plot using PredatorPrey data and saves regression results to csv file
- **PlotLin.R** - Plots linear regression and demonstrates use of mathematical display
- **Qplot.R** - Exercises demonstrating use of qplot()
