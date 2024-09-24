# A script for extracting historic, contemporary, and projected CHELSA data
# To be stored on the NHM Valentine server under the 'biodivhealth' directory

# 1. Libraries & Setup ----
install.packages("rvest")
install.packages("httr")
install.packages("xml2")

library(rvest)
library(httr)
library(xml2)

# 2. Initialise download ----

# set the url with CHELSA data included
url <- "https://envicloud.wsl.ch/#/?prefix=chelsa%2Fchelsa_V2%2FGLOBAL%2Fclimatologies%2F"

# scrape the url
page <- read_html(url)

# extract all the links from the page
links <- page %>% html_nodes("a") %>% html_attr("href")

# filter out the links that are relevant for downloading 
file_links <- links[grep("\\.nc$|\\.tif$", links)]

# print  first few file links to verify
print(file_links)


# 3. Run and save download ----
# base URL for constructing the complete download link
base_url <- "https://envicloud.wsl.ch/#/?prefix=chelsa%2Fchelsa_V2%2FGLOBAL%2Fclimatologies%2F"

# Create a directory to store the downloaded files
dir.create("/mbl/share/workspaces/groups/biodivhealth/chelsa_files", showWarnings = FALSE)

# loop through each file link and download it
for (link in file_links) {
  file_url <- paste0(base_url, link)
  file_name <- basename(link)
  
  # Construct the full path for saving the file
  destfile <- file.path("chelsa_files", file_name)
  
  # Download the file
  download.file(file_url, destfile, mode = "wb")
  
  # Optional: Add a message to track the progress
  cat("Downloaded:", file_name, "\n")
}





