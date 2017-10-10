---
output: html_document
---

***

## The continous uniform distribution

Notation:

$$ X \sim \text{SG}(a, b) \quad\text{with}\quad a, b \in \mathbb{R}\quad\text{and}\quad a \neq b$$

The continous uniform distribution depends on two parameters: a *lower bound* $a$ and am *upper bound* $b$.
The expected value and the variance are given by

$$ \text{E}(X) = \frac{b + a}{2} \qquad\text{and}\qquad \text{Var}(X) = \frac{(b - a)^2}{12} $$

### Densisty function

The density is given by:

$$ f(x) = \begin{cases} \frac{1}{b-a} & \text{for}\quad a \leq x \leq b \\\\ 0 & \text{sonst} \end{otherwise} $$

### Distribution function

The distribution function is given by:

$$ F(x) = P(X \leq x) = \int^{x}_{-\infty} f(t) dt = \frac{x-a}{b-a} $$

The value of the distribution function is the probability that the random variable $X$ is less 
than or equal to $x$.

### Quantile function

The quantile function returns the value (=quantile) $x_p$ under which is $p$% of the probability mass.
Formally, the quantile function is the inverse of the distribution function:

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)] $$

---

### Excel commands

#### Density of the continous uniform distribution

+ `=1/(b-a)`

    + $a$ := Lower bound
    + $b$ := Upper bound

#### Distribution function of the continous uniform distribution

+ `=(x-a)/(b-a)`

    + $x$ := The value the function should be evaulated at
    + $a$ := Lower bound
    + $b$ := Upper bound

#### Quantile function of the continous uniform distribution

+ `=a + (b-a)*p`

    + $p$ := A probability
    + $a$ := Lower bound
    + $b$ := Upper bound
