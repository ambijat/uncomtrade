# UN Comtrade Data Download and Panelling in R
This program is created for managing the data download from UNComtrade API. The class and aggregate level dressing is done so as to create a template for data dressing once the data is downloaded. This is necessary for many panel data operations uniform number of variables (columns) and observations (rows) are needed to create comparitive visualisations over a period of time.
## Downloading the Data
The data by UN Comtrade is supplied via API page available at [UNComtrade Portal](https://comtrade.un.org/api/swagger/ui/index#!/Data/Data_GetData). You need to feed values in the various columns to fetch data. There are various limitations to the amount of data that can be fetched in one time. This is usually limited to  100 requests per hour for a guest user. This is more or less a preferred option as most of us are not really interested in buying the API license keys. There are other request contraints as well. We cannot fetch data for more than 5 years one at a time. So if you have to get data for a decade then at least 2 requests are to be fed into the API form. 
Similarly, not more than 5 reporter areas can be queried in a single request. And, also if partner areas is other than 'ALL', then also the request is limited to 5 queries. Any, violation of the usage limits usually blocks the ip address for 1 hour and only after we can re-start data query.
## Objective of these scripts
The scripts coded here in R programming language are aimed at harmonsing the needs for downloading large volume of data with proper utlisation of the options within given constraints without having to bother much about these. The purpose is to work on various structure of data that are made avaialable by the UN Comtrade data in various formats. A short description here would be fruitful.

## Typology of UN Comtrade Data
* Trade Type
  + Export
  + Import
* Annual or Monthly
* Trade Type
  + Commodity
  + Services

## Classification
* HS - Harmonized System
    + H0 - 1992
    + H1 - 1996
    + H2 - 2002
    + H3 - 2007
    + H4 - 2012
* ST - Standard International Trade Classification (SITC)
    + S1 - Revision 1
    + S2 - Revision 2
    + S3 - Revision 3
    + S4 - Revision 4    

## Levels of Classification
* TOTAL
* Levels
  + AG1 - 01 digits code
  + AG2 - 02 digits code
  + AG3 - 03 digits code
  + AG4 - 04 digits code
  + AG5 - 05 digits code
  + AG6 - 06 digits code  


## Data formats and the Constraints
The data are downloaded in the JSON or CSV format. It is important to understand the nature of data dissemination that makes the use of UN Comtrade data a little tricky. The UN Comtrade data is non-regular in the sense, if the commodity for which there is no data or null data are omitted from data rows. Similarly, the countries for which there is no data or null data are omitted from columns. Hence for different years the same matrix of rows and columns are not fetched due to variability of trade data. Therefore, it is needed to have a uniform matrix across the batch of 10 years in order to conduct a meaningful enquiry.

## Task Performed
The code steps provided here are aimed to create a uniform panel of data in order to create a uniform matrix of data. An example is stored here in the form of raw data stored for India in folder. And, the subsequent processed data stored in the processed folder to see the difference.

# STEPS
[Partner_list](https://github.com/ambijat/uncomtrade/blob/master/partner_list.md)

The first step is to create a domain of partner countries. Partner countries are the ones who report their export or import with country in question or the reporter country. The final list of [partner countries](https://github.com/ambijat/uncomtrade/blob/master/partner_list.csv) can be seen here.

[Classification-Level Matrix](https://github.com/ambijat/uncomtrade/blob/master/s4ag4.md)

We will take S4 classification with aggregate level 5 for the current project. There are several other popular choices such as S4AG2, HS2AG2, HS4AG4, HS4AG6 which define various levels of detailing the commodity classification. The lower the AG level lesser are the number of the rows and similarly higher the AG level higher the number of rows of commodity class. The AG4 level has almost 3000 commodities.

The S4 of the SITC, Revision 4 was launched in 2006 for International Merchandise Trade Statistics. It has 9 major sections with long array of divisions followed by the sub-groups under each section. For example, Section-0 pertains to Food and live animals, which has meat, dairy, vegetables and fruits etc as broad categories. Te vegetable and fruit section has further 5 divisions and 27 subgroups which expand to 92 basic headings.

[Commodity Download](https://github.com/ambijat/uncomtrade/blob/master/dnld_s4ag5.md)

The panel format developed in above step is used to download data from the UN Comtrade API. The online provision of download can be accessed at [UNComtrade API](https://comtrade.un.org/api/swagger/ui/index#!/Data/Data_GetData) webpage. Since this demonstration is limited to only specific commodities pertaining to the query for iron products only. There are around 54 commodities at S4AG5 level that contain the word iron. We shall see how it is download. 

Once having downloaded the raw data can be seen [here](https://github.com/ambijat/uncomtrade/tree/master/India_iron_raw).

[Data Dressing](https://github.com/ambijat/uncomtrade/blob/master/dress_s4ag5.md)

Data dressing refers to make the data readymade for secondary level applications that can directly use it without having to bother about its rows and columns. This panel formation is useful for many econometric and statistical analysis that allows us to measure various relations between variables. However, one of the most presentable forms of data is the data visualisation. It makes inferences quick and visibly simple. Such visualisation techniques can be neatly deployed in R with the dressed up data such as one prepared here. Once it is converted into uniform matrix across the yearwise files then a final step is needed before utilising the data for study.

[Data Transpose]()
