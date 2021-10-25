#Binomial Distribution

## PDF
plot(seq(0,10,1), dbinom(seq(0,10,1), 10, 0.3), type='h', lwd = 2, xlab= 'x', ylab='p(x)', main='Probability mass function', sub = 'pdf of binomial distribution with n = 10 and p = 0.3')
axis(1, at = 1:10)


## CDF
plot(0:10, pbinom(0:10,10,0.3), xlim = c(-1, 11), type="s", lwd=2, xlab = 'x', ylab='F(x)', main ='Cumulative distribution function', sub = 'cdf of binomial distribution with n = 10 and p = 0.3')
axis(1, at = 1:10)

## Quantile Function
z <- c(0, 0.1, 0.2, 0.3,0.4,0.5,0.6,0.7,0.8,0.9,1)
curve(qbinom(x,10,0.3), 0, 1, n=10001, lwd=2, xlab ='p', ylab ='x_p', main='Quantile function', sub='quantile function of binomial distribution with n = 10 and p = 0.3')
axis(1, at = z)
##################################################################################################################
#CHi Quadrat Distribution

##PDF
z <- c(0,5,10,15,20,25,30,35,40)
curve(dchisq(x, df = 10), from = 0, to = 40, lwd=2, ylab='f(x)', main='Density function', sub='pdf with k = 10')
axis(1, at=z)

##CDF
z <- c(0,5,10,15,20,25,30,35,40)
curve(pchisq(x, df=10, ncp = 0,  lower.tail = TRUE), xlim = c(-1,40), lwd=2, main='Cumulative distribution function', ylab = 'F(x)', sub='cdf with k = 10')
axis(1,at=z)      

##QF
z <- c(0, 0.1, 0.2, 0.3,0.4,0.5,0.6,0.7,0.8,0.9,1)
curve(qchisq(x,df=10),n=100001, ylim =c(0,40),lwd=2, main='Quantile function', ylab = 'x_p', sub='quantile functin with k = 10')
axis(1, at = z)
##################################################################################################################
#Exponential Distribution

##PDF
z <- c(0:10)
curve(dexp(x, rate = 2), from=0, to=10, lwd=2, ylim =c(0,2), main = 'Density function', ylab='f(x)')
axis(1, at = z)

##CDF
z <- c(0:10)
curve(pexp(x, rate = 2), from=0, to=10, lwd=2, ylim =c(0,1), main = 'Cumulative distribution function', ylab='F(x)')
axis(1, at = z)

##QF
z <- c(0, 0.1, 0.2, 0.3,0.4,0.5,0.6,0.7,0.8,0.9,1)
curve(qexp(x, rate = 2), from = 0, to=.9999999999, lwd=2, ylim =c(0,5), main = 'Quantile function', ylab='F(x)')
axis(1, at = z)

