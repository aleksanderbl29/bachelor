
hent_geodata_afstemningssteder_fra_api <- FALSE

if (hent_geodata_afstemningssteder_fra_api == TRUE) {

  # Henter geojson til tempfile
  geofile_afstemningssteder <- tempfile()
  
  starttid <- Sys.time()
  download.file(url, geofile_afstemningssteder)
  sluttid <- Sys.time()
  
  download_tid <- sluttid - starttid
  print(download_tid)
  
  # Læser datafilen ind i R
  geodata_afstemningssteder <- st_read(geofile_afstemningssteder)
  
  vind_afstemningssteder_geodata <- st_as_sf(geodata_afstemningssteder)
  
  ## Gemmer vind_afstemningssteder_geodata til disk
  saveRDS(vind_afstemningssteder_geodata, "data/downloads/mine_data/vind_afstemningssteder_geodata.rds")
}

rm(url, hent_geodata_afstemningssteder_fra_api)
  
