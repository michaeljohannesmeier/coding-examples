library(RODBC)
mydb <- odbcConnect("MyODBCAzure", uid = "HelperPageRoot", pwd = "Password123")

setwd("C:/Users/Administrator/Desktop/webPages/nodeHelperPage")
products <- read.csv("products.csv", sep = ";")
sqlSave(mydb, products)

# to insert directly into Azure oder SSMS
sqlSave(mydb,"CREATE TABLE Persons (
  PersonID int,
  LastName varchar(255),
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255) 
);")



