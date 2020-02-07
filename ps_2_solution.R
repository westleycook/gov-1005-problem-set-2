---
  title: "Problem Set 2"
author: "Gov 1005 Spring 2020"
output: html_document
---
  
  Read [how we grade problem sets](https://www.davidkane.info/post/2019-08-31-problem-sets-and-exams/). 

**Objectives for this problem set:**
  
  * Students will be able to distinguish between different types of data
* Students will practice  introductory tidyverse commands
* Students will practice basic competencies in making plots 

---
  In each problem set, we aim to show you how **data informs politics and governance** in the modern world. Sometimes the connections will be obvious --- today's problem set uses endorsements data for the 2020 presidential election. But keep an eye out for less obviously "political" data in the future, like public health data the Chinese government might use to control the coronavirus outbreak, or data on Uber that the New York DOT might use to address traffic questions.

To set up this pset, you'll need two packages, **tidyverse** (which you should have installed in class), and  **fivethirtyeight**. See the textbook if you need a reminder on how to install and load packages.


**fivethirtyeight** gives you a whole database of user-friendly datasets to explore. The website also publishes additional data outside of the package, which you can find [here.](https://data.fivethirtyeight.com/) We're going to use the `endorsements_2020` data (check out the article [here](https://fivethirtyeight.com/features/the-2020-endorsement-race-is-getting-interesting/)).


```{r setup, include=FALSE}
# Note that the "setup" R code chunk --- which I think is defined as whatever
# code chunk is named "setup," although it might also have to be the first chunk
# --- is special. By default, it does not print out messages. So, it is a handly
# place to run library(tidyverse) and other library() commands. Otherwise, we
# would either need to wrap it in suppressPackageStartupMessages() or set a
# bunch of chunk options.

knitr::opts_chunk$set(echo = FALSE)
library(tidyverse)
library(fivethirtyeight)
library(ggthemes)
library(gov.1005.data)
endorse <- endorsements_2020
```



### Mad Libs 
Fill in the answers to these madlibs, using the commands that we have learned in the readings and in class.

``` {r madlib1, include = FALSE}
#It's nice to keep your answers to each madlib in a separate chunk of code. Name the object a name that means something, like ml_1
ml_1 <- endorse %>% 
  arrange(date) %>% 
  slice(1) %>% 
  pull(date)

```

1. The earliest date for an endorsement in the dataset is `r ml_1`


``` {r madlib2, include = FALSE}
ml_2 <- endorse %>% 
  arrange(desc(date)) %>% 
  slice(1) %>% 
  pull(date)

#Note that now we specify desc in arrange to get the opposite order
```

2. The most recent date for an endorsement is `r ml_2`

```{r madlib3, include = FALSE}
ml_3 <- endorse %>% 
  filter(position == "mayor" & endorsee == "Pete Buttigieg") %>%
  slice(1)%>%
  pull(endorser)

```
3. `r ml_3` is the mayor that has endorsed Pete Buttigieg. 


```{r madlib4, include =FALSE }
ml_4 <- endorse %>%
  filter(state  == "NH") %>%
  summarise(mean(points))

```
4. Endorsers from New Hampshire have an average of `r ml_4` endorsement points. (Learn how fivethirtyeight calculates endorsement points [here](https://fivethirtyeight.com/methodology/how-our-presidential-endorsement-tracker-works/).)



```{r fmadlib5, include =FALSE}
ml_5 <- endorse %>% 
  filter(endorsee == "Amy Klobuchar"| endorsee == "Elizabeth Warren")%>% 
  summarize(sum(points))
#We've learned the summarize command in the Datacamps, but not yet in the textbook. Check out Introduction   to the Tidyverse Chapter 3 for some tips 
```

5. Between them, the two female candidates who remain in the race (Amy Klobuchar and Elizabeth Warren) have a total of `r ml_5` endorsement points. 


```{r madlib6}


ml_6a <- class(endorse$position)
ml_6b <- class(endorse$endorser)
ml_6c <- class(endorse$points)
```

6. The type of data you are working with (words, numbers, categories, or fancier data types like dates) determines what kinds of operations you can perform on it. To distinguish different types of data, it's useful to use the function `class()`. This function allows you to get to know what kind of data you're working with. 

6a.  The variable "position" is a `r ml_6a`  class of variable.

6b.  The variable "endorser" is a `r ml_6b` class of variable.

6c.  The variable "points" is a `r ml_6c`  class of variable. 

### Put It Into Practice
Using the congress data in you ``gov.1005.data`` package, finish replicating this graph from fivethirtyeight. You don't need to make yours look exactly like [this one](https://fivethirtyeight.com/features/both-republicans-and-democrats-have-an-age-problem/) on their website, but try and get as close to the one we have here is possible.  Remember that you can use ``?`` to look up a package or command's help page. The tidyverse functions will be helpful in selecting the right segments of data. Some useful commands for graphing are:
  
  * ``scale_colour_manual``
* ``labs``
* ``scale_x_continuous``
* ``scale_y_continuous``
* ``annotate``

You also might want to explore the ``ggthemes`` package and see if it has anything to help you. 
```{r age_graphic}
congress %>%
  # Interspersing comments within a pipe is a good idea. This allows you to
  # discuss/explain each section of code as you use it. And, as long as you are
  # using CMD-Shift-/, you get the right indenting for free.
  # Note the use of select() to pick out just the variables we are using. Doing
  # so makes it easier to take a look at the interim steps.
  select(year, party, age) %>% 
  group_by(year, party) %>% 
  summarize(avg_age = mean(age)) %>% 
  filter(party %in% c("R", "D")) %>% 
  # Start the plotting. 
  ggplot(mapping = aes(x = year, y = avg_age, color = party)) +
  # There are many ways to make the legend of the plot disappear, but I like
  # this approach best.
  geom_line(show.legend = FALSE) +
  # We want the Republican line to be red and the Democratic line to be blue.
  # There are two approaches. First, we could just use
  # scale_color_fivethirtyeight(). This, magically, tries to look at the plot
  # (and the variables) and figure out what colors you want. Perhaps it is
  # better to tell R exactly what colors you want:
  scale_colour_manual(values = c("blue", "red")) + 
  # The order is the tricky part. How does R know you want blue for the
  # Democratic line? In this case, R does not know it. (I gthink that
  # scale_color_fivethirtyeight() guesses it.) Instead, R keeps track of the
  # natural "order"" of things. Because party is a character variable, the
  # natural order is alphabetical, so D comes before R. scale_color_manual()
  # maps its values in that same order.
  # Every plot should have a title, subtitle and caption. If we were cool, we
  # would not hard code 1947 and 2013 in this subtitle. Instead, we would
  # determine the date range dynamically, by looking at the tibble, and the
  # construct the subtitle on the fly. But that is too much for the third week
  # of the semester.
# I could not figure out how to make that dark band at the bottom. I also
# purposely used a different source since, in truth, I got my data from the
# fivethirtyeight package.
labs(title    = "Average Age of Members of Congress",
     subtitle = "At start of term, 1947-2013",
     caption  = "Source: fivethirtyeight package") +
  # Scale labels and break points are important, but confusing. The entire
  # family of scale_ commands is something we will work on over the semester.
  scale_x_continuous(breaks = seq(1950, 2010, by = 10),
                     labels = c("1950", "'60", "'70", "'80",
                                "'90", "2000", "'10")) +
  scale_y_continuous(breaks = seq(40, 60, by = 5),
                     labels = c("40", "45", "50", "55", "60 yrs"),
                     limits = c(40, 63)) +
  # annotate() is the easiest way to place specific text. Sadly, you need to use
  # trial-and-error to make it look good. ggrepel is a great package for
  # labelling all the points in your plot. gghighlight is also fun.
  annotate(geom = "text", x = 1997, y = 58, 
           label = "Democrats", color = "blue", size = 5) +
  annotate(geom = "text", x = 1966, y = 57, 
           label = "Republicans", color = "red", size = 5) +
  # Never do something on your own that someone has already done for you.
  # ggthemes has an extensive collection of themes for you to use. Also, check
  # out the new bbplot package for making your work look like the BBC's.
  theme_fivethirtyeight()
```

