{
  
  # Installing necessary packages
  #install.packages("rvest")
  #install.packages("dplyr")
  #install.packages('xml2')
  #install.packages("tidyverse")
  #install.packages("stringr")
  #install.packages("ggplot2")
  #install.packages("shiny")
  #install.packages("plotly")
  
  # Reading libraries
  library("ggplot2")
  library("stringr")
  library("tidyverse")
  library('xml2')
  library("rvest")
  library("dplyr")
  library("shiny")
  library("plotly")
  
  # Clearing data workspace
  rm(list=ls())
  
  # Webpage link for PETROL 95 and DIESEL
  pet_95_link <- paste0("https://www.lotos.pl/145/type,oil_95/dla_biznesu/hurtowe_ceny_paliw/archiwum_cen_paliw")
  die_link <- paste0("https://www.lotos.pl/145/type,oil_eurodiesel/dla_biznesu/hurtowe_ceny_paliw/archiwum_cen_paliw")

  # Reading link
  page_95 <- read_html(pet_95_link)
  page_die <- read_html(die_link)
  
  # Creating data frame, scraping date and price from website
  pet_95 <- data.frame(Date = (page_95 %>% html_nodes("td:nth-child(1)") %>% html_text()), 
                       Price = (page_95 %>% html_nodes(".nowrap:nth-child(2)") %>% html_text()))
  die <- data.frame(Date = (page_die %>% html_nodes("td:nth-child(1)") %>% html_text()), 
                    Price = (page_die %>% html_nodes(".nowrap:nth-child(2)") %>% html_text()))
  
  # Tidying data
  tidy_pet_95 <- head(pet_95, -151)
  tidy_die <- head(die, -151)
  
  # Trimming unnecessary symbols from price values
  tidy_pet_95$Price <- gsub(" |,[0-9]*", "", tidy_pet_95$Price)
  tidy_die$Price <- gsub(" |,[0-9]*", "", tidy_die$Price)
  
  # Setting proper data types
  tidy_pet_95$Date <- as.Date(tidy_pet_95$Date)
  tidy_pet_95$Price <- as.numeric(tidy_pet_95$Price)
  tidy_die$Date <- as.Date(tidy_die$Date)
  tidy_die$Price <- as.numeric(tidy_die$Price)
  
  # Creating a plot
  ggplot(NULL, aes(x = Date, y = Price)) + 
    geom_point(data = tidy_pet_95, aes(color="Petrol 95")) + 
    geom_point(data = tidy_die,aes(color="Diesel")) + 
    labs(color="Legend") + 
    scale_x_date(date_labels = "%d-%m-%Y", date_breaks = "12 month") + 
    scale_y_continuous(limits = c(0, 8000), breaks = seq(0, 8000, by = 250)) + 
    ggtitle("95 and Diesel prices [PLN] (for 1000 liters) in Poland in recent years")
  
}
