##USGS-SESAR-Template

```{r}
library(lubridate)
```

### Read csv File

```{r}
SESAR.Template.CSV <-read.csv("~/PaleoDatabase/R work/SESAR Template -CSV.csv", sep=",",header=TRUE, na.strings = "")
```

```{r}
Cobban.Template.CSV<-read.csv("~/PaleoDatabase/R work/Cobban_USGS-CSV.csv", sep=",",header=TRUE)
```

### Spreadsheet Formatting
===========================
#### Removing 1st row from SESAR Template
```{r}
SESAR.Template.CSV <- SESAR.Template.CSV[-c(1),]
```

#### Merging Spreadsheets
```{r}
SESAR.V1 <- merge(SESAR.Template.CSV, Cobban.Template.CSV, by.x=c("Field.name..informal.classification.","Age..max.","Geological.age","Geological.unit","Comment","Latitude","Longitude","Locality","Locality.description","Country","State.Province","County","Collector.Chief.Scientist","Collection.date"), by.y=c("Resume_of_Fauna","Stage","Age","Formation","Comments","Lat_Pub","Long_Pub","USGS7.5","LocDescr","Country","State","County","Collector","Date"), all=TRUE)
```

#### Removing Unwanted Columns
```{r}
SESAR.V1[56:65] <- list(NULL)
```

#### Apply data to Individual Columns
```{r}
SESAR.V1$Material <- "Biology"
SESAR.V1$Age.unit..e.g..million.years..Ma.. <- "Ma"
SESAR.V1$Current.archive.contact <- "Kevin McKinney - kcmckinney@usgs.gov"
SESAR.V1$Current.archive <- "United States Geological Survey - Denver Lab"
```

#### Reordering of columns to match SESAR Template 
```{r}
Final.SESARV2 <-rbind(SESAR.Template.CSV,SESAR.V1)
```

#### Removing rows with NAs accros Columns
```{r}
Final.SESARV3<-Final.SESARV2[-which(apply(Final.SESARV2,1,function(x)all(is.na(x)))),]
```

```{r}
Final.SESARV3<-Final.SESARV3[complete.cases(Final.SESARV3[,5]),]
```

#### Date Formating
```{r}
Final.SESARV3$Collection.date<-stamp("12/31/9999")(Final.SESARV3[,44])
```

#### GPS Fuzzing
```{r}
Final.SESARV3$Latitude<-format((Final.SESARV3[,19]), digits=2, nsmall=3)
```

#### Removing 1st column
```{r}
row.names(Final.SESARV3)<-NULL
```

#### Removing the term "NA" from spreadhsheet
```{r}
Final.SESARV3[is.na(Final.SESARV3)] <- c("")
```

#### Saving CSV file
```{r}
write.csv(Final.SESARV3, file = "SESAR-Final-Cobbanv6.csv")
```
