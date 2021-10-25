---
output:
  pdf_document: default
  html_document: default
---

***

## Exponential distribution

Notation:

$$ X \sim \text{Ex}(\alpha) \quad\text{with}\quad \alpha \in \mathbb{R}^{>0} $$

The exponential distribution is a continuous distribution with a distribution parameter $\alpha$.
Expected value and variance are given by:

$$ \text{E}(X) = \frac{1}{\alpha} \qquad\text{and}\qquad \text{Var}(X) = \frac{1}{\alpha^2} $$

### Density function

The density function is given by:

$$ f(x) = \begin{cases} \alpha \exp(-\alpha x) & \text{for}\quad x \geq 0 \\\\
0 & \text{otherwise} \end{cases} $$

### Cumulative distribution function

The cumulative distribution function (cdf) is given by:

$$ F(x) = P(X \leq x) = \int^{x}_{-\infty}f(t) dt $$

The value of the cumulative distribution function is the probability that the random variable $X$ is less than or equal to $x$.

### Quantile function

The quantile function returns the value $x_p$ under which is $p$%  of the probability mass.
Formally, the quantile function is the inverse function of the distribution function:

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)]$$

---

### Excel commands

#### Density function and distribution function of the exponential distribution

+ `=EXPON.VERT`($x$; $\alpha$; **kumuliert**)

    + $x$ := Value $x$ where appropriate function value should be returned
    + $\alpha$ := Distribution parameter (in Excel: $\alpha$ =  $\lambda$)
    + kumuliert = 1 := Value of the distribution function (probability)
    + kumuliert = 0 := Value of the density function (no probability!)
