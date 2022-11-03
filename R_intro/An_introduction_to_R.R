##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##            An introduction to R I wish I had
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rm(list = ls())
gc()

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## 1. Data classes in R
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##-----------------------------------------------------------------------------------------------------
## 1.1 Logical statement
typeof(TRUE) 
typeof(FALSE)

typeof(T) ## T also means TRUE
typeof(F) ## F also means FALSE

## example 
cars$speed >= 12

## which can be used for several functions and if/ifelse statements
which(cars$speed >= 12)
ifelse(cars$speed >= 12, "Pretty fast", "Not so fast")

##-----------------------------------------------------------------------------------------------------
## 1.2 Letters, Words and sentences in R
typeof("P")
typeof("Pirate")
typeof("I am a pirate")

## characters are useful to group data and make plots prettier
## we can split characters (strings into parts at positions we want)
library(dplyr)
strsplit("I am a pirate", " ") %>% unlist() %>% .[4]

##-----------------------------------------------------------------------------------------------------
## 1.3 Numeric values in R
## integer
class(3L)
typeof(3L)

## double (or floats)
class(3)
typeof(3)

class(3.1)
typeof(3.1)

## complex numbers
class(3 + 1i)

##-----------------------------------------------------------------------------------------------------
## 1.4 Factor
factor(2) %>% class()
factor("Pirate") %>% class()

## why is it weird?
factor(2) %>% typeof()
factor("Pirate") %>% typeof()

factor(2) %>% as.numeric()
factor("Pirate") %>% as.numeric()

## usually when you try to convert a character into a numeric you get a warning
"Pirate" %>% as.numeric()

## showcase:
test1 <- runif(10) %>% as.factor()
test2 <- runif(10) %>% as.factor()

test1[1] * test1[2]

lm(test1 ~ test2) %>% summary()

test1 %>% as.numeric()
test2 %>% as.numeric()

test1 %>% as.character()
test1 %>% as.character() %>% as.numeric()

## what are they actually useful for?
ggplot(mtcars, aes(x = cyl, y = mpg)) + geom_bar(stat = "identity")

mtcars$cyl <- factor(mtcars$cyl, levels = c(6, 8, 4))
ggplot(mtcars, aes(x = cyl, y = mpg)) + geom_bar(stat = "identity")

rm(list = ls())
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## 2. Data structures in R
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##-----------------------------------------------------------------------------------------------------
## 2.1 Vector
c(T, F, 1L, 3.1, 3 + 2i, "Pirate") %>% typeof()
c(T, F, 1L, 3.1, 3 + 2i) %>% typeof()
c(T, F, 1L, 3.1) %>% typeof()
c(T, F, 1L) %>% typeof()
c(T, F) %>% typeof()

as.factor(c("pirate", 2)) %>% as.numeric()

## indexing a vector
our_vector <- c(runif(10))

names(our_vector) <- month.abb[1:10]

## call any position with: [x]
our_vector[2]
our_vector[3:6]
our_vector[c(3,8,1)]

## same goes for saving: to save anything at any position in the vector
our_vector[3]
our_vector[3] <- "Pirate"
our_vector[3]
our_vector

our_vector[1] <- c(1,3,5)

## you can expand already existing vectors as much as you want
our_vector[11] <- 5
our_vector[1000] <- 20
our_vector

rm(list = ls())
##-----------------------------------------------------------------------------------------------------
## 2.2 Matrix
mat_example <- matrix(0, ncol = 3, nrow = 2)
mat_example

## r sees matrix as long vectors
length(mat_example)

## but they do have columns and rows
nrow(mat_example)
ncol(mat_example)

typeof(mat_example)

## indexing for matrices has two dimensions [rows, columns]
## again, we can call what is in the matrix
mat_example[2, 3] ## calling one cell
mat_example[2, ] ## calling the entire row
mat_example[, 3] ## calling the entire column
mat_example[5] ## this is equal to [1, 3]

## we can also save different things again
mat_example[1, 3] <- "Pirate"
mat_example[5]

## arrays 
mat_example2 <- matrix(1, ncol = 3, nrow = 2)
array_example <- array(c(mat_example, mat_example2), dim = c(2, 3, 2))

## okay what happened here?
## array indexing is a bit more complex as we usually end up having more then 2 dimensions: [row, column, matrix]
array_example[,,2]

##  we can also name our columns
colnames(mat_example2) <- c("col1", "col2", "col3")

## and call those columns with the name index
mat_example2[, "col1"]

rm(list = ls())
##-----------------------------------------------------------------------------------------------------
## 2.3 Data frame
## for this I ask everyone to join me now 
## we will load some data from a Github repository 
muskoxen <- read.csv("https://raw.githubusercontent.com/Martin19910130/Day_1_Tiffany_Knight/main/R_intro/muskox.csv")

## each column of a data frame is a vector and has a name 
muskoxen$character <- rep("Example", nrow(muskoxen)) ## this shows us again that we can extend existing dataframes

## indexing is almost the same as with matrices, except we have more options- now we can use: dat.fra$colname
muskoxen$muskoxen

## you can also see the column names as a vector so you can use that to call multiple columns
muskoxen[, c(1,2)] ## using the numbers of the columns
muskoxen[, c("year", "muskoxen")] ## using the names of the columns

## to my knowledge, you can not use $name to call multiple columns
## okay we don't need this character column, lets drop it from our dataframe
muskoxen <- muskoxen[, -3]

##-----------------------------------------------------------------------------------------------------
## 2.4 List
list_example <- list(c(runif(10)), muskoxen)

## indexing
list_example[[2]][1,2]

## name list entries and call them with the help of that name
names(list_example)[2] <- "muskoxen"
list_example$muskoxen

##-----------------------------------------------------------------------------------------------------
## 3. for loops
for(i in 1:nrow(muskoxen))
  print(i)

for(i in 1:nrow(muskoxen))
{
  paste(muskoxen[i, "year"], muskoxen[i, "muskoxen"]) %>% print()
}

for(i in 1:nrow(muskoxen))
{
  paste("Number of muskoxen in year t + 1 (", muskoxen[i + 1, "year"], ") = ", muskoxen[i + 1, "muskoxen"], sep = "") %>% print()
}

for(i in 1:nrow(cars))
{
  cars[i, "speed"] * cars[i, "dist"] %>% print()
}

example <- function()
{
  out <- cars$speed * cars$dist
  return(out)
}


