# UNComtrade Data Download and Panel Data formation
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

