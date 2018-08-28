setwd('~/Documents/Research/product-aesthetic/Jason')
library(rstan); library(shinystan); library(reshape2)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


aes_data <- read.csv('aesthetic-7-17.csv', header = T)
aes_data <- aes_data[aes_data$PT_WTP < 40, ]
aes_data <- aes_data[aes_data$R_WTP < 350, ]
aes_compare <- aes_data[aes_data$Version == "AC" | aes_data$Version == "AFH", 
                        c(grep(glob2rx("*_AEV"), names(aes_data)), 
                          grep("Version", names(aes_data)))]
aes_compare <- melt(aes_compare, id.vars = c("Version"), 
                    variable.name="product", value.name="aes_eval")
aes_compare <- aes_compare[!is.na(aes_compare$aes_eval), ]
aes_compare$product <- as.factor(as.character(gsub("_AEV", "", aes_compare$product)))
levels(aes_compare$product)[levels(aes_compare$product)=="CD"] <- "D"
aes_ac <- aes_compare[aes_compare$Version=="AC", ]
aes_afh <- aes_compare[aes_compare$Version == "AFH", ]
X_ac <- as.matrix(model.matrix(aes_eval ~ product -1, data=aes_ac))
N_ac <- nrow(X_ac)
K_ac <- ncol(X_ac)
stan_inputs_ac <- list(X=X_ac, N=N_ac, y=aes_ac$aes_eval, K=K_ac)
R <- 2000
ac_fit <- stan(file='regression.stan', data=stan_inputs_ac, cores=2, chains=2, iter=R)
draws_ac <- extract(ac_fit)
#launch_shinystan(ac_fit)
X_afh <- as.matrix(model.matrix(aes_eval ~ product -1, data=aes_afh))
N_afh <- nrow(X_afh)
K_afh <- ncol(X_afh)
stan_inputs_afh <- list(X=X_afh, N=N_afh, y=aes_afh$aes_eval, K=K_afh)
afh_fit <- stan(file='regression.stan', data=stan_inputs_afh, cores=2, chains=2, iter=R)
draws_afh <- extract(afh_fit)
# Compare sigmas
sigs_ac <- draws_ac$sigma
sigs_afh <- draws_afh$sigma
sig_diff_a <- sigs_ac - sigs_afh
cat("95% Posterior Density Interval for difference in s.d.:", 
    quantile(sig_diff_a, 0.025), ", ", quantile(sig_diff_a, 0.975))
# Compare means (mu = X %*% beta)
mu_ac <- rep(NA, R)
mu_afh <- rep(NA, R)
for (r in (R / 2):R) {
    mu_ac[r] <- mean(X_ac %*% draws_ac$beta[r, ])
    mu_afh[r] <- mean(X_afh %*% draws_afh$beta[r, ])
}
mu_ac <- mu_ac[!is.na(mu_ac)]
mu_afh <- mu_afh[!is.na(mu_afh)]
mu_diff_a <- mu_ac - mu_afh
cat("95% Posterior Density Interval for difference in means:", 
    quantile(mu_diff_a, 0.025), ", ", quantile(mu_diff_a, 0.975))
# Significantly different mean: much lower in control condition



# For impact of aesthetic ratings on functional distribution
fun_compare <- aes_data[aes_data$Version == "FC" | aes_data$Version == "FAH", 
                        c(grep(glob2rx("*_FEV"), names(aes_data)), 
                          grep("Version", names(aes_data)))]
fun_compare <- melt(fun_compare, id.vars = c("Version"), 
                    variable.name="product", value.name="fun_eval")
fun_compare <- fun_compare[!is.na(fun_compare$fun_eval), ]
fun_compare$product <- as.factor(as.character(gsub("_FEV", "", fun_compare$product)))
levels(fun_compare$product)[levels(fun_compare$product)=="CD"] <- "D"
fun_fc <- fun_compare[fun_compare$Version=="FC", ]
fun_fah <- fun_compare[fun_compare$Version == "FAH", ]
X_fc <- as.matrix(model.matrix(fun_eval ~ product -1, data=fun_fc))
N_fc <- nrow(X_fc)
K_fc <- ncol(X_fc)
stan_inputs_fc <- list(X=X_fc, N=N_fc, y=fun_fc$fun_eval, K=K_fc)
fc_fit <- stan(file='regression.stan', data=stan_inputs_fc, cores=2, chains=2, iter=R)
draws_fc <- extract(fc_fit)
#launch_shinystan(fc_fit)
X_fah <- as.matrix(model.matrix(fun_eval ~ product -1, data=fun_fah))
N_fah <- nrow(X_fah)
K_fah <- ncol(X_fah)
stan_inputs_fah <- list(X=X_fah, N=N_fah, y=fun_fah$fun_eval, K=K_fah)
fah_fit <- stan(file='regression.stan', data=stan_inputs_fah, cores=2, chains=2, iter=R)
draws_fah <- extract(fah_fit)
sigs_fc <- draws_fc$sigma[(R / 2):R]
sigs_fah <- draws_fah$sigma[(R / 2):R]
sig_diff_f <- sigs_fc - sigs_fah
cat("95% Posterior Density Interval for difference in s.d.:", 
    quantile(sig_diff_f, 0.025), ", ", quantile(sig_diff_f, 0.975))
# Compare means (mu = X %*% beta)
mu_fc <- rep(NA, R)
mu_fah <- rep(NA, R)
for (r in (R / 2):R) {
    mu_fc[r] <- mean(X_fc %*% draws_fc$beta[r, ])
    mu_fah[r] <- mean(X_fah %*% draws_fah$beta[r, ])
}
mu_fc <- mu_fc[!is.na(mu_fc)]
mu_fah <- mu_fah[!is.na(mu_fah)]
mu_diff_f <- mu_fc - mu_fah
cat("95% Posterior Density Interval for difference in means:", 
    quantile(mu_diff_f, 0.025), ", ", quantile(mu_diff_f, 0.975))
# Significantly different mean: much lower in control condition

