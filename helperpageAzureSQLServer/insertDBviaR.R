library(RMySQL)
# mydb <- odbcConnect("MyODBCAzure", uid = "HelperPageRoot", pwd = "Password123")
# 
# 
# sqlSave(mydb, tableProducts)
# 
# mydb = dbConnect(MySQL(), user='noderoot', password='root', host='localhost', db= "helperpage")
# dbGetQuery(mydb,"CREATE DATABASE helperpage;")
# 
# 
# mydb = dbConnect(MySQL(), user='root', password='eisvogel', dbname='helperpage', host='localhost')
# setwd("C:/Users/Michael/Desktop/webPages/nodeHelperPage")
# setwd("C:/Users/Administrator/Desktop/webPages/nodeHelperPage")
# tableProducts <- read.csv("products.csv", sep = ";")
# dbGetQuery(mydb,"DROP TABLE products;")
# dbGetQuery(mydb,"CREATE TABLE products;")
# 
# 
# 
# 
# 
# 
# dbGetQuery(mydb,"CREATE TABLE Persons (
#   PersonID int,
#   LastName varchar(255),
#   FirstName varchar(255),
#   Address varchar(255),
#   City varchar(255) 
# );")
# 
# dbWriteTable(mydb, name="products", value=tableProducts)
# products <- dbReadTable(mydb, name = "products")
# 
# 
# mydb = dbConnect(MySQL(), user='root', password='eisvogel', dbname='helperpage', host='localhost')
# dbGetQuery(mydb, "
#            DROP TABLE registrate;
#            "
# )
# 
# dbGetQuery(mydb, "
#            CREATE TABLE registrate (
#            email varchar(255),
#            password varchar(255),
#            firstName varchar(255),
#            lastName varchar(255),
#            street varchar(255),
#            numberHouse varchar(255),
#            zip varchar(255),
#            city varchar(255)
#            );
#            "
# )
# 
# # dbGetQuery(mydb, "INSERT INTO registrate
# #            VALUES ('michael@gmailcom', 'jvc', 'Mustermanstrasse', '3', '87464', 'Dortmund');")
# 
# registrate <- dbReadTable(mydb, name = "registrate")

####################################### to start from scratch new again
mydb = dbConnect(MySQL(), user='noderoot', password='root', host='localhost')
dbGetQuery(mydb,"CREATE DATABASE helperpage;")
setwd("C:/Users/Administrator/Desktop/webPages/express-cc-master")
products <- read.csv("products.csv", sep = ";")
dbGetQuery(mydb, "DROP TABLE products")
dbWriteTable(mydb, name="products", value=products)
dbGetQuery(mydb, "ALTER TABLE `products` DROP `row_names`")
dbGetQuery(mydb, "ALTER TABLE `products` CHANGE `productId` `productId` TINYINT(4) PRIMARY KEY NOT NULL AUTO_INCREMENT")



dbGetQuery(mydb, "DROP TABLE registration")
dbGetQuery(mydb, "
           CREATE TABLE registration (
           id MEDIUMINT(9) PRIMARY KEY NOT NULL AUTO_INCREMENT,
           email varchar(255),
           password varchar(255),
           firstName varchar(255),
           lastName varchar(255),
           street varchar(255),
           numberHouse varchar(255),
           zip varchar(255),
           city varchar(255)
);
           "
           )
dbGetQuery(mydb, "DROP TABLE orders")
dbGetQuery(mydb, "
           CREATE TABLE orders (
           orderId MEDIUMINT(9) PRIMARY KEY NOT NULL AUTO_INCREMENT,
           customerEmail varchar(50),
           customerId int(11),
           description varchar(50),
           name varchar(50),
           orderedDate datetime,
           productId int(11),
           status varchar(50)
);
           "
           )
dbGetQuery(mydb, "DROP TABLE regkeys")
dbGetQuery(mydb, "
           CREATE TABLE regkeys (
           id MEDIUMINT(9) PRIMARY KEY NOT NULL AUTO_INCREMENT,
           dateUsed datetime,
           emailUsed text,
           regKeys varchar(50),
           used tinyint(1)
);
           "
           )

dbGetQuery(mydb, "
           INSERT INTO `regkeys` (`id`, `dateUsed`, `emailUsed`, `regKeys`, `used`) 
            VALUES  (NULL, NULL, NULL, '111111', 0), 
                    (NULL, NULL, NULL, '222222', 0),
                    (NULL, NULL, NULL, '333333', 0),
                    (NULL, NULL, NULL, '444444', 0),
                    (NULL, NULL, NULL, '555555', 0),
                    (NULL, NULL, NULL, '666666', 0),
                    (NULL, NULL, NULL, '777777', 0),
                    (NULL, NULL, NULL, '888888', 0)
           ")

