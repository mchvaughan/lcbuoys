library(RCurl)
library(tidyverse)
library(lubridate)
library(viridis)
library(scales)
library(plotly)
library(rmarkdown)

valcour_url <- "ftp://02d0c8c.netsolhost.com/valcour_pushed_data.csv"
userpwd <- "lcbp_data:Data123"

valcour <- getURL(valcour_url, 
              userpwd = userpwd) %>%
 read_csv(skip = 1) %>%
 rename(timestamp = `Time America/New_York UTC-04:00`) %>%
 drop_na() %>%
 mutate(timestamp = mdy_hms(timestamp)) %>%
 mutate_if(is.character, as.numeric) %>% # convert all those characters to numeric
 filter(timestamp > ymd_hms("2021-06-24 00:00:00"))

valcour_watertemp <- valcour %>%
 select(c(timestamp, starts_with("Temp"))) %>% # select only timestamp and TempXY columns
 rename(depth_01m = Temp01,
        depth_02m = Temp02,
        depth_03m = Temp03,
        depth_04m = Temp04,
        depth_05m = Temp05,
        depth_06m = Temp06,
        depth_07m = Temp07,
        depth_08m = Temp08,
        depth_09m = Temp09,
        depth_10m = Temp10,
        depth_11m = Temp11,
        depth_12m = Temp12,
        depth_13m = Temp13,
        depth_14m = Temp14,
        depth_15m = Temp15,
        depth_16m = Temp16,
        depth_17m = Temp17,
        depth_18m = Temp18,
        depth_19m = Temp19,
        depth_20m = Temp20,
        depth_21m = Temp21,
        depth_22m = Temp22,
        depth_23m = Temp23,
        depth_24m = Temp24,
        depth_25m = Temp25,
        depth_26m = Temp26,
        depth_27m = Temp27,
        depth_28m = Temp28,
        depth_29m = Temp29,
        depth_31m = Temp30,
        depth_33m = Temp31,
        depth_35m = Temp32,
        depth_37m = Temp33,
        depth_39m = Temp34,
        depth_41m = Temp35,
        depth_43m = Temp36,
        depth_45m = Temp37,
        depth_47m = Temp38) %>%
 pivot_longer(!timestamp,
              names_to = "var",
              values_to = "degC") %>%
 mutate(depth_m = var %>%
                  substr(7, 8) %>%
                  as.numeric())

plot <- valcour_watertemp %>%
 ggplot() +
 geom_line(aes(x = timestamp,
                y = degC,
                color = var,
               group = var),
            size = 1) +
 scale_color_viridis(discrete = TRUE, 
                     direction = -1)
 
plot
ggplotly(plot)

plot2 <- valcour_watertemp %>%
  ggplot() +
  geom_tile(aes(x = timestamp,
                y = depth_m,
                fill = degC)) +
  scale_fill_viridis("Temperature (deg C)",
                     option = "plasma") +
  scale_y_reverse() +
  labs(x = "",
       y = "Depth below water surface (m)")

ggplotly(plot2)

render("data_site_writer.Rmd", 
       "html_document")

  # ftpUpload(what = "buoyPlots_v2.R",
  #           to = "ftp://02d0c8c.netsolhost.com/test_r_script_upload.r",
  #           userpwd = userpwd)