## SESAR-USGS 
## USGS-SESAR Template



```{r}
library(lubridate)
```

#### Read csv File
```{r}
SESAR.Template.CSV <-read.csv("~/PaleoDatabase/R work/SESAR Template -CSV.csv", sep=",",header=TRUE, na.strings = "")
```

```{r}
Bybell.Template.CSV<-read.csv("~/PaleoDatabase/R work/Bybell_3000.csv", sep=",",header=TRUE, na.strings = "")
```

### Spreadsheet Formatting
#### Removing 1st 3 row from SESAR Template
```{r}
SESAR.Template.CSV <- SESAR.Template.CSV[-c(1),]
```

#### Merging Spreadsheets
```{r}
SESAR.V1 <- merge(SESAR.Template.CSV, Bybell.Template.CSV, by.x=c("Sample.Name","Geological.age","Geological.unit","Comment","Latitude","Longitude","Locality","Location.description","Country","State.Province","County","City.Township","Collector.Chief.Scientist"), by.y=c("USGS..","Period.Epoch.from","Formation","Paleontological.remarks","Latitude....all.N","Longitude...W..unless.marked","Locality.Name","Locality.Remarks","Country.Ocean","Country.Ocean.subunit","County","Quadrangle","Collected.Submitted.by"), all=TRUE)
```


#### Removing Unwanted Columns
```{r}
SESAR.V1[56:107] <- list(NULL)
```

#### Apply data to Individual Columns
```{r}
SESAR.V1$Material <- "Biology"
SESAR.V1$Age.unit..e.g..million.years..Ma.. <- "Ma"
SESAR.V1$Current.archive.contact <- "Laurel Bybell - LBybell@usgs.gov"
SESAR.V1$Current.archive <- "United States Geological Survey - Reston nannofossil lab"
SESAR.V1$Field.name..informal.classification. <- "Microfossils"
```

#### Fixing locality Information
```{r}
SESAR.V1$Country[SESAR.V1$Country=="shoreline map"] <- "United States"
```
```{r}
SESAR.V1$Country[SESAR.V1$Country=="USAA"] <- "United States"
```
```{r}
SESAR.V1$Country[SESAR.V1$Country=="USAa"] <- "United States"
```
```{r}
SESAR.V1$Country[SESAR.V1$Country=="USa"] <- "United States"
```
```{r}
SESAR.V1$Country[SESAR.V1$Country=="USA"] <- "United States"
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

#### Generating Seperate Spreadsheet based on missing values and minimum SESAR requirements
```{r}
Final.SE<-Byebll.Template.CSV[!complete.cases(Bybell.Template.CSV[,11]),]
```

```{r}
write.csv(Final.SE, file = "Rejected.CSV")
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
write.csv(Final.SESARV3, file = "SESAR-Final-Bybellv6.csv")
```
