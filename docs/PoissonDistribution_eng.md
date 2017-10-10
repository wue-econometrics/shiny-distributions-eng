---
output: html_document
---

## Poisson distribution

Notation:

$$ X \sim \text{Po}(\lambda) \quad\text{with}\quad \lambda \in \mathbb{N} $$

The poisson distribution is a discrete distribution with distribution parameter $\lambda$.
Expected value and variance are indentical and given by:

$$ \text{E}(X) = \text{Var}(X) = \lambda $$

### Probability function

The probability function is given by:

$$ p(x) = P(X = x) = \begin{cases} \frac{\lambda^k}{x!}\exp(-\lambda) & \text{for}\quad x\in \mathbb{N} \\\\ 0 & \text{otherwise} \end{cases} $$

### Distribution function

The distribution function is defined as:

$$ F(x) = P(X \leq x) = \sum_{x_i < x}P(X = x_i) $$

The value of the distribution function specifies the probability that the random variable $X$ is less than or equal to $x$.

### Quantile function

The quantile function returns the value $x_p$ under which is $p$%  of the probability mass.
Formally, the quantile function is the inverse function of the distribution function:

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)] $$

### Excel commands

#### Probability function and distribution function of the poisson distribution

+ `=POISSON.VERT`($x$; $\lambda$; **kumuliert**)

    + $x$ := Value $x$ where the appropriate function value should be returned
    + $\lambda$ := Distribution parameter
    + kumuliert = 1 := Value of distribution function (probability)
    + kumuliert = 0 := Value of probability function (no probability!)

