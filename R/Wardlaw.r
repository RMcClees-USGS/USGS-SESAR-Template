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
Wardlaw.Template.CSV<-read.csv("~/PaleoDatabase/R work/Wardlaw_USGS-CSV.csv", sep=",",header=TRUE, na.strings = "")
```

### Spreadsheet Formatting

#### Removing 1st row from SESAR Template

```{r}
SESAR.Template.CSV <- SESAR.Template.CSV[-c(1),]
```

#### Merging Spreadsheets
```{r}
SESAR.V1 <- merge(SESAR.Template.CSV, Wardlaw.Template.CSV, by.x=c("Sample.Name","Elevation.start..in.meters.","Field.name..informal.classification.","Geological.age","Geological.unit","Comment","Latitude","Longitude","Collector.Chief.Scientist", "Locality"), by.y=c("Sample","mab","Fossil.Unit","Age","Geologic.Unit.s.","projectName","Latitude","Longitude","Sample.Collector","Locality"), all=TRUE)
```

#### Removing Unwanted Columns
```{r}
SESAR.V1[56:65] <- list(NULL)
```


#### Apply data to Individual Columns
```{r}
SESAR.V1$Material <- "Biology"
SESAR.V1$Country <- "United States"
SESAR.V1$State.Province <- "Texas"
SESAR.V1$Locality.description <- "Guadalupe Peak"
SESAR.V1$Current.archive.contact <- "Kevin McKinney - kcmckinney@usgs.gov"
SESAR.V1$Current.archive <- "United States Geological Survey - Denver Lab"
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
Final.SE<-Wardlaw.Template.CSV[!complete.cases(Wardlaw.Template.CSV[,11]),]
```

```{r}
write.csv(Final.SE, file = "Rejected.CSV")
```


#### GPS Fuzzing
```{r}
Final.SESARV3$Latitude<-format((Final.SESARV3[,19]), digits=3, nsmall=3)
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
write.csv(Final.SESARV3, file = "SESAR-Final-Wardlawv6.csv")
```
