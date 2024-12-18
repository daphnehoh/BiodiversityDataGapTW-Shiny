<h3>Data pre-processing (cleaning):</h3>
- Remove records without scientificName (476,522 records)<br>
- Remove duplicated records (768 records)<br>
- Remove records without coordinates 864,912 records)<br>
- Remove records outside of Taiwan (136,368 records)<br>
<br>


<h3>Notes to consider when viewing different pages:</h3>

#### 1. Taxon data overview<br>
- We have categorized species into 33 major groups for easier presentation. The grouping criteria can be viewed on this [table](https://docs.google.com/spreadsheets/d/1kDXFF94Nkabfzhhj3rZLlEwnAeM8WBSrhqPiCPKggH8/edit?usp=sharing).<br>
- In reference to the [Taiwan Catalogue of Life](https://taicol.tw/) (hereafter referred to as TaiCOL), we have exported the species list not yet recorded in TBIA into a downloadable CSV file.<br>

#### 2. Temporal data overview<br>
- We have not removed records with questionable dates (e.g., years < 1800 & > 2025) as these account for fewer than 200 entries.<br>

#### 3 & 4. Spatial data overview and spatial gap<br>
- Sensitive data have varying degrees of coordinate uncertainty. To facilitate subsequent analysis and presentation of data gaps, we have merged the coordinate fields. For sensitive data, we merged the original coordinate points (standardRawLatitude and standardRawLongitude) with non-sensitive data coordinates (standardLatitude and standardLongitude) to create the latitude and longitude fields for further analysis and presentation.<br> 
- Using the EPSG:4326 WGS84 geodetic coordinate system, we presented the data within a 5x5 km grid covering Taiwan's land and maritime boundaries.<br> 
- When mapping the data onto the grid, we excluded records with coordinate uncertainty greater than 5 km (1,183,339 records).<br> 