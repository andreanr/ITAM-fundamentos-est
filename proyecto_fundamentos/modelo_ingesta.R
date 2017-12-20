# Lectura de datos
library(tidyverse)
library(stringr)
library(lubridate)
library(R2jags)

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
  summarise(media_glu = mean(medicion)) %>% 
  filter(media_glu>2)

base_ingesta %>% 
  ggplot(aes(x = 1:104, y = media_glu, color=as.factor(ingesta))) +
  geom_point()

n <- nrow(base_ingesta)

data<-list("n"=n,"y"=base_ingesta$media_glu, "x" = base_ingesta$ingesta, "individual" = base_ingesta$individual)

inits<-function(){list(alpha = rep(0,70), beta = rep(0,2), yf1=rep(1,n))}

parameters<-c("alpha","beta.adj", "yf1")

mod.reg <-jags(data,inits,parameters,model.file="modelo_ingesta_normal",
               n.iter=30000,n.chains=1,n.burnin=3000, n.thin = 1)

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

data.frame(y_obs = base_ingesta$media_glu, y_pred = out.yf[,1], y_inf = out.yf[,3],
           y_sup = out.yf[,7]) %>% 
  ggplot() +
  geom_point(aes(x = 1:n, y = y_obs)) +
  geom_point(aes(x = 1:n, y = y_pred), color = "red") +
  geom_errorbar(aes(x = 1:n, ymin = y_inf, ymax=y_sup))  +
  labs(x = "Observaciones", y = "Glucosa")

data.frame(Beta1 = out$beta.adj[,1], Beta2 = out$beta.adj[,2]) %>% 
  gather() %>% 
  ggplot(aes(x = value, fill = key)) +
  geom_histogram(alpha = .3) +
  scale_fill_discrete(name = "Parámetro")

out.alpha<-out.sum[grep("alpha",rownames(out.sum)),]

out.alpha %>% 
  data.frame() %>% 
  arrange(mean) %>% 
  ggplot(aes(x = 1:70, y = mean)) +
  geom_point() +
  geom_errorbar(aes(x=1:70, ymin = X2.5., ymax=X97.5.))

# modelo horarios ---------------------------------------------------------

base_horarios <- bd_diabetes %>% 
  mutate(hora = hour(time)) %>% 
  filter(hora %in% c(8, 12, 18, 22),
         atributo %in% atributo[str_detect(atributo, "medición")],
         !is.na(atributo)) %>% 
  mutate(hora_dummy = NA,
         hora_dummy = ifelse(hora == 8, 1,
                             ifelse(hora == 12, 2,
                                    ifelse(hora ==18, 3,
                                           ifelse(hora == 22, 4, hora_dummy))))) %>% 
  group_by(individual, hora_dummy) %>% 
  summarise(media_glu = mean(value)) %>% 
  na.omit()

base_horarios %>% 
  ggplot(aes(x = 1:244, y = media_glu, color=as.factor(hora_dummy))) +
  geom_point()

n <- nrow(base_horarios)

data<-list("n"=n,"y"=base_horarios$media_glu, "x" = base_horarios$hora_dummy)

inits<-function(){list(alpha = rep(0,n), beta = rep(0,4), yf1=rep(1,n))}

parameters<-c("alpha.adj","beta.adj", "yf1")

mod.reg <-jags(data,inits,parameters,model.file="modelo_horas_mg.txt",
               n.iter=30000,n.chains=1,n.burnin=3000, n.thin = 1)

out.dic<-mod.reg$BUGSoutput$DIC
print(out.dic)

out<-mod.reg$BUGSoutput$sims.list
out.sum<-mod.reg$BUGSoutput$summary

out.yf<-out.sum[grep("yf1",rownames(out.sum)),]

cor(base_horarios$media_glu, out.yf[,1])^2

data.frame(y_obs = base_horarios$media_glu, y_pred = out.yf[,1]) %>% 
  ggplot(aes(x = y_pred, y = y_obs)) +
  geom_point() +
  geom_smooth(method = "lm")

data.frame(y_obs = base_horarios$media_glu, y_pred = out.yf[,1], y_inf = out.yf[,3],
           y_sup = out.yf[,7]) %>% 
  ggplot() +
  geom_point(aes(x = 1:n, y = y_obs)) +
  geom_point(aes(x = 1:n, y = y_pred), color = "red") +
  geom_errorbar(aes(x = 1:n, ymin = y_inf, ymax=y_sup))  +
  labs(x = "Observaciones", y = "Glucosa")

data.frame(Beta1 = out$beta.adj[,1], Beta2 = out$beta.adj[,2], 
           Beta3 = out$beta.adj[,3], Beta4 = out$beta.adj[,4]) %>% 
  gather() %>% 
  ggplot(aes(x = value, fill = key)) +
  geom_histogram(alpha = .3) +
  scale_fill_discrete(name = "Parámetro") +
  facet_wrap(~key, scales = "free")

out.alpha<-out.sum[grep("alpha",rownames(out.sum)),]

out.alpha %>% 
  data.frame() %>% 
  arrange(mean) %>% 
  ggplot(aes(x = 1:244, y = mean)) +
  geom_point() +
  geom_errorbar(aes(x=1:244, ymin = X2.5., ymax=X97.5.))


