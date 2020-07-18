## Add data for display
# library(dplyr)
# library(stringr)
# 
# df_loupan = readxl::read_xlsx("./data/nanjing_xinloupan_2020-07-11.xlsx") %>% select(-c(1)) %>% distinct()
# ## Extract the min, max area and Total price
# df_loupan <- df_loupan %>% mutate(Total_Price = str_replace(Total_Price,"\\s","")) %>%  mutate(Area_small = str_extract(Area,"建面\\d*"), Area_big = str_extract(Area, "-\\d*"), T_price = str_extract(Total_Price,"\\d+\\.*\\d*万"), Unit_price = str_extract(Total_Price, "^\\d*元")) %>% mutate(Area_small = str_replace(Area_small, "建面",""), Area_big = str_replace(Area_big,"-",""), T_price = str_replace_all(T_price, c("万" = ""," " = "")), Unit_price = str_replace_all(Unit_price,c("元" ="", "\\s" = "")))
# ## Get the house dietribution by district
# usethis::use_data(df_loupan, overwrite = T)