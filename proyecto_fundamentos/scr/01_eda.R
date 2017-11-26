#análisis exploratorio de los datos
rm(list = ls())
#cargamos librerias
library(tidyverse)
library(stringi)
library(stringr)
#cargamos los datos
base_diabetes_raw <- read_csv("datos/data_diabetes.csv") %>% 
  mutate(value = as.numeric(value))

#catálogo de códigos
cat_code <- read_csv("docs/catalogo_code.csv")

#unimos el código con su atributo
base_diabetes <- base_diabetes_raw %>% 
  left_join(cat_code, by = "code") %>% 
  mutate(atributo = str_replace_all(atributo, " ", "_")) %>% 
  filter(str_detect(atributo, "medición"))

base_diabetes %>% 
  group_by(individual) %>% 
  summarise(medicion_glucosa = mean(value, na.rm = TRUE)) %>% 
  ggplot(aes(x = individual, y = medicion_glucosa)) +
  geom_point()+
  geom_line()
