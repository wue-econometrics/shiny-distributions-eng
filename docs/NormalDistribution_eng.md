---
output: html_document
---

***

## Normal distribution

Notation:

$$ X \sim N(\mu, \sigma^2)$$

The normal distribution is a continuous distribution which is symmetric about $\mu$. Expected value and variance are given by:

$$ \text{E}(X) = \mu \qquad\text{and}\qquad \text{Var}(X) = \sigma^2 $$

### Density function

The density function is given by:

$$ f(x) = \frac{1}{\sqrt{2\pi}\sigma}\exp\left(-\frac{1}{2}\frac{(x - \mu)^2}{\sigma^2}\right) $$

### Distribution function

The distribution function is given by:

$$ F(x) = P(X \leq x) = \int^{x}_{-\infty}f(t) dt $$

The value of the distribution function is the probability that the random variable $X$ is less 
than or equal to $x$.

### Quantile function

The quantile function returns the value (=quantile) $x_p$ under which is $p$%  of the probability mass.
Formally, the quantile function is the inverse of the distribution function:

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)] $$

---

### Excel commands

#### Density and distribution function of the normal distribution

+ `=NORM.VERT`($x$; $\mu$; $\sigma$; **kumuliert**)

    + $x$ := The value $x$ the function should be evaulated at.
    + $\mu$ := Mean
    + $\sigma$ := Standard deviation (not variance!)
    + kumuliert = 1 := Value of distribution function (a probability)
    + kumuliert = 0 := Value of density function (not a probability!)

#### Density function and distribution function of the standard normal distribution

+ `=NORM.S.VERT`($x$; **kumuliert**)

    + $x$ := The value the function should be evaulated at.
    + kumuliert = 1 := Value of distribution function (a probability)
    + kumuliert = 0 := Value of density function (not a probability)

#### Quantile function of the normal distribution

+ `=NORM.INV`($p$; $\mu$; $\sigma$)

    + $p$ := Probability
    + $\mu$ := Mean 
    + $\sigma$ := Standard deviation (not variance!)

#### Quantile function of the standard normal distribution

+ `=NORM.S.INV`($p$)

    + $p$ := Probability
