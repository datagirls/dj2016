anscombe
install.packages('ggplot2')
install.packages('dplyr')
install.packages('reshape2')
library(ggplot2)
library(dplyr)
library(reshape2)
setA=select(anscombe, x=x1,y=y1)
setB=select(anscombe, x=x2,y=y2)
setC=select(anscombe, x=x3,y=y3)
setD=select(anscombe, x=x4,y=y4)
setA$group ='SetA'
setB$group ='SetB'
setC$group ='SetC'
setD$group ='SetD'
head(setA,4) 
all_data=rbind(setA,setB,setC,setD)
all_data[c(1,13,23,43),]  
summary_stats =all_data%>%group_by(group)%>%summarize("mean x"=mean(x),
                                                      "Sample variance x"=var(x),
                                                      "mean y"=round(mean(y),2),
                                                      "Sample variance y"=round(var(y),1),
                                                      'Correlation between x and y '=round(cor(x,y),2) )
models = all_data %>% 
  group_by(group) %>%
  do(mod = lm(y ~ x, data = .)) %>%
  do(data.frame(var = names(coef(.$mod)),
                coef = round(coef(.$mod),2),
                group = .$group)) %>%
  dcast(., group~var, value.var = "coef")
summary_reg = data_frame("Linear regression" = paste0("y = ",models$"(Intercept)"," + ",models$x,"x"))
summary_stats_and_linear_fit = cbind(summary_stats,  summary_reg)
summary_stats_and_linear_fit
ggplot(all_data, aes(x=x,y=y)) +geom_point(shape = 21, colour = "red", fill = "orange", size = 3)+
  ggtitle("Anscombe's data sets")+geom_smooth(method = "lm",se = FALSE,color='blue') + 
  facet_wrap(~group, scales="free")
