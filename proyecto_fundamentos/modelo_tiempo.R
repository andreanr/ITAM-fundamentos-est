mediciones_4 <- bd_diabetes %>%
  filter(str_detect(atributo, "medición")) %>% 
  filter(hour(time) %in% c(8, 12, 18, 22), minute(time) == 0, second(time) == 0) %>% 
  mutate(time = as.character(time),
         time = as.factor(time)) %>% 
  filter(!is.na(value))

base_media_mediciones <- mediciones_4 %>% 
  group_by(individual, time) %>% 
  summarise(media_glucosa = mean(value))

n <- nrow(base_media_mediciones)

data<-list("n"=n,"y"=base_media_mediciones$media_glucosa, 
           "x" = base_media_mediciones$time)

inits<-function(){list(alpha = rep(0,n), beta = rep(0,4), yf1=rep(1,n))}

parameters<-c("alpha.adj","beta.adj", "yf1")

mod.reg.hora <-jags(data,inits,parameters,model.file="modelo_prueba_hora.txt",
               n.iter=10000,n.chains=1,n.burnin=1000, n.thin = 1)

out.dic<-mod.reg.hora$BUGSoutput$DIC
print(out.dic)

out<-mod.reg.hora$BUGSoutput$sims.list
out.sum<-mod.reg.hora$BUGSoutput$summary

out.yf<-out.sum[grep("yf1",rownames(out.sum)),]

cor(base_media_mediciones$media_glucosa, out.yf[,1])^2

data.frame(y_obs = base_media_mediciones$media_glucosa, y_pred = out.yf[,1]) %>% 
  ggplot(aes(x = y_pred, y = y_obs)) +
  geom_point() +
  geom_smooth(method = "lm")

data.frame(y_obs = base_media_mediciones$media_glucosa, y_pred = out.yf[,1]) %>% 
  ggplot() +
  geom_point(aes(x = 1:n, y = y_obs)) +
  geom_point(aes(x = 1:n, y = y_pred), color = "red")



