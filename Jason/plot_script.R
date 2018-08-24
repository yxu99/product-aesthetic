setwd('~/Documents/Research/product-aesthetic/Jason')
aes_data <- read.csv('aesthetic-7-17.csv', header = T)
aes_data <- aes_data[aes_data$PT_WTP < 40, ]
aes_data <- aes_data[aes_data$R_WTP < 350, ]
version <- aes_data$Version
pt_aev <- aes_data$PT_AEV # paper towel
pt_fev <- aes_data$PT_FEV
s_aev <- aes_data$S_AEV # sock
s_fev <- aes_data$S_FEV
c_aev <- aes_data$C_AEV # car
c_fev <- aes_data$C_FEV
d_aev <- aes_data$CD_AEV # drill
d_fev <- aes_data$CD_FEV
r_aev <- aes_data$R_AEV # razor
r_fev <- aes_data$R_FEV
wb_aev <- aes_data$WB_AEV # water bottle
wb_fev <- aes_data$WB_FEV
pt_wtp <- aes_data$PT_WTP 
s_wtp <- aes_data$S_WTP
r_wtp <- aes_data$R_WTP
wb_wtp <- aes_data$WB_WTP
c_wtp <- aes_data$C_WTP
d_wtp <- aes_data$CD_WTP
dist_comp <- function(vector, v1, v2, version, title) {
  version <- version[!is.na(vector)]
  vector <- vector[!is.na(vector)]
  d1 <- density(vector[version == v1])
  d2 <- density(vector[version == v2])
  x1 <- min(d1$x, d2$x)
  x2 <- max(d1$x, d2$x)
  y1 <- min(d1$y, d2$y)
  y2 <- max(d1$y, d2$y)
  vec1 <- vector[version == v1]
  vec2 <- vector[version == v2]
  par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
  plot(c(x1, x2), c(y1, y2), type = 'n', bty = 'n', 
       ylab = '', xlab = '',
       main = title, col.main = '#909090', axes = F)
  lines(density(vec1))
  lines(density(vec2), lty = 2, col = 'blue')
  legend("topright", inset=c(-0,0), legend = c(v1, v2), text.col = c('black', 'blue'),
         col = c('black', 'blue'), lty = c(1, 2), bty = 'n')
  legend("topleft", inset=c(-0.06, 0), legend = c(round(sd(vec1), 2), round(sd(vec2), 2)), 
         text.col = c('black', 'blue'), bty = 'n')
  text(x =x1 - (x2 - x1) * 0.1, y = y1 + (y2 - y1) * 1.001, 'SD', col = '#909090')
}

dist_comp(pt_aev, "AC", "AFH", version, "Paper Towel: Aesthetic Evaluations")
dist_comp(s_aev, "AC", "AFH", version, "Sock: Aesthetic Evaluations")
dist_comp(r_aev, "AC", "AFH", version, "Razor: Aesthetic Evaluations")
dist_comp(wb_aev, "AC", "AFH", version, "Water Bottle: Aesthetic Evaluations")
dist_comp(c_aev, "AC", "AFH", version, "Car: Aesthetic Evaluations")
dist_comp(d_aev, "AC", "AFH", version, "Drill: Aesthetic Evaluations")

dist_comp(pt_fev, "FC", "FAH", version, "Paper Towel: Functional Evaluations")
dist_comp(s_fev, "FC", "FAH", version, "Sock: Functional Evaluations")
dist_comp(r_fev, "FC", "FAH", version, "Razor: Functional Evaluations")
dist_comp(wb_fev, "FC", "FAH", version, "Water Bottle: Functional Evaluations")
dist_comp(c_fev, "FC", "FAH", version, "Car: Functional Evaluations")
dist_comp(d_fev, "FC", "FAH", version, "Drill: Functional Evaluations")

dist_comp(pt_wtp, "AC", "AFH", version, "Paper Towel: WTP")
dist_comp(s_wtp, "AC", "AFH", version, "Sock: WTP")
dist_comp(r_wtp, "AC", "AFH", version, "Razor: WTP")
dist_comp(wb_wtp, "AC", "AFH", version, "Water Bottle: WTP")
dist_comp(c_wtp, "AC", "AFH", version, "Car: WTP")
dist_comp(d_wtp, "AC", "AFH", version, "Drill: WTP")

dist_comp(pt_wtp, "FC", "FAH", version, "Paper Towel: WTP")
dist_comp(s_wtp, "FC", "FAH", version, "Sock: WTP")
dist_comp(r_wtp, "FC", "FAH", version, "Razor: WTP")
dist_comp(wb_wtp, "FC", "FAH", version, "Water Bottle: WTP")
dist_comp(c_wtp, "FC", "FAH", version, "Car: WTP")
dist_comp(d_wtp, "FC", "FAH", version, "Drill: WTP")









aes_ind <- version %in% c("AC", "AFH")
summary(lm(pt_wtp[aes_ind] ~ pt_aev[aes_ind]))
summary(lm(s_wtp[aes_ind] ~ s_aev[aes_ind]))
summary(lm(r_wtp[aes_ind] ~ r_aev[aes_ind]))
summary(lm(wb_wtp[aes_ind] ~ wb_aev[aes_ind]))
summary(lm(c_wtp[aes_ind] ~ c_aev[aes_ind]))
summary(lm(d_wtp[aes_ind] ~ d_aev[aes_ind]))

fun_ind <- version %in% c("FC", "FAH")
summary(lm(pt_wtp[fun_ind] ~ pt_fev[fun_ind]))
summary(lm(s_wtp[fun_ind] ~ s_fev[fun_ind]))
summary(lm(r_wtp[fun_ind] ~ r_fev[fun_ind]))
summary(lm(wb_wtp[fun_ind] ~ wb_fev[fun_ind]))
summary(lm(c_wtp[fun_ind] ~ c_fev[fun_ind]))
summary(lm(d_wtp[fun_ind] ~ d_fev[fun_ind]))

summary(lm(pt_wtp ~ pt_fev + pt_aev))
summary(lm(s_wtp ~ s_fev + s_aev))
summary(lm(r_wtp ~ r_fev + r_aev))
summary(lm(wb_wtp ~ wb_fev + wb_aev))
summary(lm(c_wtp ~ c_fev + c_aev))
summary(lm(d_wtp ~ d_fev + d_aev))

sd_test <- function(vector, v1, v2, version, R = 10000) {
  version <- version[!is.na(vector)]
  vector <- vector[!is.na(vector)]
  d1 <- density(vector[version == v1])
  d2 <- density(vector[version == v2])
  x1 <- min(d1$x, d2$x)
  x2 <- max(d1$x, d2$x)
  y1 <- min(d1$y, d2$y)
  y2 <- max(d1$y, d2$y)
  vec1 <- vector[version == v1]
  vec2 <- vector[version == v2]
  sd_diff <- rep(NA, R)
  for (r in 1:R) {
    vec1_r <- sample(vec1, replace = TRUE)
    vec2_r <- sample(vec2, replace = TRUE)
    sd_diff[r] <- sd(vec1_r) - sd(vec2_r)
  }
  return(c(quantile(sd_diff, .05), quantile(sd_diff, .95)))
}

sd_test(pt_aev, "AC", "AFH", version)
sd_test(s_aev, "AC", "AFH", version)
sd_test(r_aev, "AC", "AFH", version)
sd_test(wb_aev, "AC", "AFH", version)
sd_test(c_aev, "AC", "AFH", version)
sd_test(d_aev, "AC", "AFH", version)
sd_test(pt_fev, "FC", "FAH", version)
sd_test(s_fev, "FC", "FAH", version)
sd_test(r_fev, "FC", "FAH", version)
sd_test(wb_fev, "FC", "FAH", version)
sd_test(c_fev, "FC", "FAH", version)
sd_test(d_fev, "FC", "FAH", version)
