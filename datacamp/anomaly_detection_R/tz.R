


library(lubridate)

x = ymd_hm("2022-01-24 16:00", tz = "Europe/Zurich")

y = with_tz(x, tzone = Sys.timezone())
