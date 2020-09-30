
## ---- descriptive-statistics

ds <- describe(dat.s)

flextable(ds) %>% autofit()
