# Lectura de datos
diabetes <- read_csv("datos/data_diabetes.csv", col_types = list(
  X1 = col_integer(),
  date = col_character(),
  time = col_time(format = ""),
  code = col_integer(),
  value = col_double(),
  individual = col_integer())) %>% 
  select(-X1)

# Catalogo de codigos
catalogo_code <- read_csv("docs/catalogo_code.csv")

bd_diabetes <- diabetes %>% 
  left_join(catalogo_code)

base_ingesta <- bd_diabetes %>% 
  mutate(hora = hour(time)) %>% 
  filter(atributo %in% c(atributo[str_detect(atributo, "medición")], atributo[str_detect(atributo, "ingestión de comida mayor")]),
         !is.na(atributo)) %>% 
  mutate(tipo = ifelse(str_detect(atributo,"medición"), "medicion", "ingesta")) %>% 
  group_by(date, individual, tipo) %>% 
  summarise(media_glucosa = mean(value)) %>% 
  spread(tipo, media_glucosa, fill = 1) %>% 
  ungroup() %>% 
  mutate(ingesta = ifelse(ingesta == 0, 2, ingesta),
         unos = 1) %>% 
  group_by(individual, ingesta) %>% 
  summarise(media_glu = mean(medicion))

n <- nrow(base_ingesta)

data<-list("n"=n,"y"=base_ingesta$media_glu, "x" = base_ingesta$ingesta)

inits<-function(){list(alpha = rep(0,n), beta = rep(0,2), yf1=rep(1,n))}

parameters<-c("alpha.adj","beta.adj", "yf1")

mod.reg <-jags(data,inits,parameters,model.file="modelo_prueba.txt",
               n.iter=10000,n.chains=1,n.burnin=1000, n.thin = 1)

out.dic<-mod.reg$BUGSoutput$DIC
print(out.dic)

out<-mod.reg$BUGSoutput$sims.list
out.sum<-mod.reg$BUGSoutput$summary

out.yf<-out.sum[grep("yf1",rownames(out.sum)),]

cor(base_ingesta$media_glu, out.yf[,1])^2

data.frame(y_obs = base_ingesta$media_glu, y_pred = out.yf[,1]) %>% 
  ggplot(aes(x = y_pred, y = y_obs)) +
  geom_point() +
  geom_smooth(method = "lm")

data.frame(y_obs = base_ingesta$media_glu, y_pred = out.yf[,1]) %>% 
  ggplot() +
  geom_point(aes(x = 1:n, y = y_obs)) +
  geom_point(aes(x = 1:n, y = y_pred), color = "red")



