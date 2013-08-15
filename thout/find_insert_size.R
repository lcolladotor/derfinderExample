# Read data
sizes <- as.numeric(readLines("check_size.sizes"))

# Summary statistics
mean(sizes, na.rm=TRUE)
median(sizes, na.rm=TRUE)
sd(sizes, na.rm=TRUE)

# More stats after removing outliers
clean <- sizes[!is.na(sizes)]
sizes.cl <- clean[clean < 500]
summary(sizes.cl)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 37.00   78.00   89.00   99.62  104.00  499.00
quantile(sizes.cl, c(0.01, 0.05, 0.95, 0.99))
# 1%  5% 95% 99% 
# 47  63 163 384

# 384 is not far from
111 + 53.3 * 3 + 2 * 37

sd(sizes.cl)
# 51.65074



# Basic exploratory plots
pdf(file="sizes_hist.pdf")
hist(sizes.cl, nclass=50, col="light blue")
dev.off()

pdf(file="sizes_box.pdf")
boxplot(sizes.cl, col="light blue")
dev.off()
