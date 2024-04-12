library(DBI)
library(RPostgreSQL)
library(dotenv)
library(here)

load_dot_env(file = here("data/.env"))         # put all of your credentials in this .env file

dsn_database = Sys.getenv("dsn_database")     # database name
dsn_hostname = Sys.getenv("dsn_hostname")     # hostname of db server (or ip)
dsn_port = Sys.getenv("dsn_port")             # port on server
dsn_uid = Sys.getenv("dsn_uid")               # username to access db
dsn_pwd = Sys.getenv("dsn_pwd")               # password


### Fancy version med tryCatch og lækre beskeder
tryCatch({drv <- dbDriver("PostgreSQL")
         print("Forbinder til database")
         connec <- dbConnect(drv,
                             dbname = dsn_database,
                             host = dsn_hostname,
                             port = dsn_port,
                             user = dsn_uid,
                             password = dsn_pwd)
         print("Tilsluttet database!")
         },
         error=function(cond) {
          print("FEJL: Kan ikke forbinde til database")
         })


## Hent tabeller i database

tabeller <- dbListTables(connec)

dbDisconnect(connec)


### Fancy version med tryCatch og lækre beskeder
tryCatch({dbDisconnect(connec)
          print("Database forbindelse lukket")
          },
         error=function(cond) {
          print("FEJL: Kan ikke slutte forbindelse til database")
         })