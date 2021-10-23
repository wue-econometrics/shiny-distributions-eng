#Binomial Distribution

## PDF
plot(seq(0,10,1), dbinom(seq(0,10,1), 10, 0.3), type='h', lwd = 2, xlab= 'x', ylab='p(x) = P(X=x)', main='Probability Mass Function')
axis(1, at = 1:10)


## CDF
plot(0:10, pbinom(0:10,10,0.3), xlim = c(-1, 11), type="s", lwd=2, xlab = 'x', ylab='F(x) = P(X <= x)', main ='Cumulative Distribution Function')
axis(1, at = 1:10)

## Quantile Function
z <- c(0, 0.1, 0.2, 0.3,0.4,0.5,0.6,0.7,0.8,0.9,1)
curve(qbinom(x,10,0.3), 0, 1, n=10001, lwd=2, xlab ='p', ylab ='x_{p} = F^{-1}(p)', main='Quantile Function')
axis(1, at = z)

#CHi Quadrat Distribution

##PDF
curve(dchisq(x, df = 10), from = 0, to = 40, lwd=2)


