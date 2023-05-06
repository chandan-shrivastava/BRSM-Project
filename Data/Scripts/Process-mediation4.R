
  




data1 <- read.csv("DataTrials.csv")
is.numeric(data1$Rep1)

# PROCESS Model 4

for(i in 1:160) {
  a=(i*60)-59;
  b=i*60;
  data<- data1[a:b, ] 
  res <- process (data = data,
                    y = "Sharing", x = "Rep1", m = "PercAccuracy",
                    model = 4,
                    boot = 10000, seed = 654321, save =2,total =1)
  
  
  write.csv(res, paste0(i, ".csv"), row.names = FALSE)
}
