##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                           ~~
## Lab 1 - Exponential growth, Muskoxen                      ~~
##                                                           ~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rm(list = ls())
gc()

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## 1. Read and plot the muskoxen data
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## read the data from Github
muskoxen <- read.csv("https://raw.githubusercontent.com/Martin19910130/Lab1_Exponential_population_growth/main/muskox.csv")

## remove the one entry in the muskoxen column that makes the column character and change it to numeric
muskoxen[which(muskoxen$muskoxen == "206+"), "muskoxen"] <- 206
muskoxen$muskoxen <- as.numeric(muskoxen$muskoxen)

## plot the muskoxen population through time, I will use a package (ggplot)
library(ggplot2)

ggplot(muskoxen, aes(x = year, y = muskoxen)) + geom_point(size = 2) + theme_bw()  + 
  ylab("Number of Muskoxen") + xlab("Year") + scale_x_continuous(breaks = seq(1936, 1968, 2)) + 
  theme(axis.text.x = element_text(angle = 45, vjust = 0.8, size = 10), axis.text.y = element_text(size = 10))

ggplot(muskoxen, aes(x = year, y = muskoxen, color = ifelse(year >= 1947, "red", "black"))) + geom_point(size = 2) + theme_bw() + 
  geom_vline(xintercept = c(1946, 1969), linetype = 2) + 
  ylab("Number of Muskoxen") + xlab("Year") + theme(legend.position = "none", axis.text.x = element_text(angle = 45, vjust = 0.8, size = 10),
                                                    axis.text.y = element_text(size = 10)) + 
  scale_color_manual(values = c("black", "orange")) + scale_x_continuous(breaks = seq(1936, 1968, 2)) + 
  scale_y_continuous(limits = c(0, 800)) + geom_text(mapping = aes(y = 755, x = 1957.5, label = "Calculate growth rate between years"), 
                                                     color = "black", size = 5) + 
  geom_segment(data = muskoxen %>% subset(year >= 1947),mapping = aes(x = lag(year), y = lag(muskoxen),
                                                          xend = year, yend = muskoxen), 
               arrow = arrow(length = unit(0.25, "cm"))) + 
  geom_text(data = muskoxen %>% subset(year >= 1947 & year <1968),mapping = aes(x = year + 0.5, y = muskoxen + 1, label = "?"), 
                                                                     color = "black")

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## 2. Calculate the population 
##    growth from 1947 ~ 1968
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## subset data, a few different ways
muskox47_68 <- subset(muskoxen, year >= 1947)
dplyr::filter(muskoxen, year >= 1947)
muskoxen[which(muskoxen$year >= 1947),]

## use a for loop for calculating the growth rate
for(i in 1:nrow(muskox47_68))
{
  muskox47_68[i+1, "growthrate"] <- muskox47_68[i+1, "muskoxen"] / muskox47_68[i, "muskoxen"]
}

## Histogram of the growth rates 
hist(muskox47_68$growthrate, xlab = "Growth rate", main = "Muskoxen, frequency of the different growth rates")

muskox47_68$dplyr_gr <- muskox47_68$muskoxen / dplyr::lag(muskox47_68$muskoxen)

## Get the maximum and minimum
library(dplyr)

## Maximum
muskox47_68$growthrate %>% max(na.rm = T)
## Minimum
muskox47_68$growthrate %>% min(na.rm = T)

## geometric mean
## first get your n
n <- which(!is.na(muskox47_68$growthrate)) %>% length()

## calculate the geographic mean
muskox47_68$growthrate %>% prod(na.rm = T) %>% .^(1/n)

## use a package 
muskox47_68$dplyr_gr %>% psych::geometric.mean()

## Same again this time just with out using pipes
max(muskox47_68$growthrate, na.rm = T)
min(muskox47_68$growthrate, na.rm = T)

n <- length(which(!is.na(muskox47_68$growthrate)))

prod(muskox47_68$growthrate, na.rm = T)^(1/n)

psych::geometric.mean(muskox47_68$growthrate)

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Project the population growth 5 years into the future
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## plot I used for visualizing what we want to do
ggplot(muskox47_68, aes(x = year, y = muskoxen)) + geom_point() + theme_bw() + ylab("Number of Muskoxen") + xlab("") + 
  scale_x_continuous(breaks = seq(1947, 1974, 2), limits = c(1946, 1974)) + 
  theme(axis.text.x = element_text(angle = 45, vjust = 0.8, size = 10), axis.text.y = element_text(size = 10)) + 
  scale_y_continuous(limits = c(0, 1500)) + geom_vline(xintercept = c(1968.5, 1973.5), linetype = 3) + 
  geom_text(mapping = aes(x = 1971, y = 900, label = "?"), size = 30)

## get the number of muskoxen of the last year
n <- muskox47_68[22, "muskoxen"]

## We have Na's in our data, we don't want to "draw" those randomly, so we get rid of it 
R <- subset(muskox47_68, !is.na(growthrate))$growthrate

## using a for loop, each time the loop is running I sample a randome growth rate
for(i in 1:5)
  n[i+1] <- n[i] * sample(R, 1)


## since data frames that are already existing can be expended in for loops we can also do everything like this, storing a few more values
## this provides a better overview and control over what we did
R <- subset(muskox47_68, !is.na(growthrate))$growthrate

for(i in 22 : 26 )
{
  samp_R <- sample(R, 1)
  
  muskox47_68[i+1, "muskoxen"] <- muskox47_68[i, "muskoxen"] * samp_R
  muskox47_68[i+1, "year"] <- muskox47_68[i, "year"] + 1
  muskox47_68[i+1, "growthrate"] <- samp_R
}

ggplot(muskox47_68, aes(x = year, y = muskoxen)) + geom_point(mapping = aes(color = ifelse(year >= 1969, "red", "black")), size = 2) + 
  geom_line(mapping = aes(linetype = ifelse(year >= 1969, "red", "black"))) + theme_bw() + ylab("Number of muskoxen") + 
  xlab("") + theme(axis.text.x = element_text(angle = 45, vjust = 0.8, size = 10), axis.text.y = element_text(size = 10),
                   legend.position = "none") + geom_vline(xintercept = c(1968.5, 1973.5), linetype = 3) + 
  geom_line(linetype = 3) + scale_linetype_manual(values = c(1, 3)) + scale_color_manual(values = c("Black", "orange"))

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##      Do the same 1000 times
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## set up a data frame we will fill
muskox <- data.frame("1968" = rep(714, 1000), "1969" = NA, "1970" = NA, "1971" = NA, "1972" = NA, "1973" = NA)
for(i in 1:5)
  for(j in 1:nrow(muskox))
{
  muskox[j, i+1] = muskox[j, i] * sample(R, 1)
}
  
musk_list <- c()
for(i in 1:1000)
{
  dat <- data.frame(year = 1968:1973, muskoxen = 714)
  
  for(j in 1:nrow(dat))
  {
    samp_R <- sample(R, 1)
    dat[j + 1, "muskoxen"] <- dat[j, "muskoxen"] * samp_R
    dat[j + 1, "growth_rate"] <- samp_R
  }
  print(j)
  musk_list[[i]] <- dat
}
    
n <- c()  
for(i in 1:length(musk_list))
{
  n[i] <- which(musk_list[[i]][,"year"] == 1973) %>% musk_list[[i]][., "muskoxen"]
}

## calculate the mean and the 95% confidence intervals 
meanR <- mean(n)
ci975 <- quantile(n, .975)
ci025 <- quantile(n, .025)
hist(n, main = "Histogram of number of muskoxen in the 5th year", xlab = "Number of muskoxen")

abline(c(ci025, ci975, meanR))
line(c(ci025, ci975, meanR))

