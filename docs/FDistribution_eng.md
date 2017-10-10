---
output: html_document
---

***

## F distribution

Notation:

$$ X \sim F_{k_1, k_2} \quad\text{with}\quad k_1, k_2 \in \mathbb{R}^{>0} $$

The F distribution is a continuous distribution with $k_1$ *numerator degrees of freedom* and $k_2$ *denominator degrees of freedom*. Expected value and variance are given by:

$$ \text{E}(X) = \frac{k_2}{k_2 - 2}\quad\text{for}\quad k_2 > 2 \qquad\text{and}\qquad \text{Var}(X) = \frac{2k_2^2(k_1 + k_2 - 2)}{k_1(k_2 - 2)^2(k_2 - 4)}\quad\text{for}\quad k_2 > 4 $$

### Density function

The density function is given by:

$$ f(x) = \begin{cases}
k_1^{\frac{k_1}{2}}k_2^{\frac{k_2}{2}}\cdot \frac{\Gamma\left(\frac{k_1}{2} + \frac{k_2}{2}\right)}{\Gamma\left(\frac{k_1}{2}\right)\cdot\Gamma\left(\frac{k_2}{2}\right)}\cdot
\frac{x^{\frac{k_1}{2}-1}}{(k_1x + k_2)^{\frac{k_1 + k_2}{2}}} & \text{for}\quad x \geq 0 \\\\
0 & \text{otherwise}
\end{cases} $$

where $\Gamma(x) = \int^{+\infty}_0 t^{x-1}e^{-t} dt$ is the "gamma function" at $x$.

The quotient of two $\chi^2$ distributed random variables divided by their degrees of freedom follows the F distribution. Therefore, the F distribution is often defined as:

$$ F_{k_1, k_2} = \frac{\frac{\chi^2_{k_1}}{k_1}}{\frac{\chi^2_{k_2}}{k_2}} = 
\frac{\chi^2_{k_1}}{\chi^2_{k_2}}\cdot \frac{k_2}{k_1}$$

### Distribution function

The distribution function is defined as:

$$ F(x) = P(X \leq x) = \int^{x}_{-\infty}f(t) dt $$

The value of the distribution function specifies the probability that the random variable $X$ is less than or equal to $x$.

### Quantile function

The quantile function returns the value $x_p$ under which is $p$%  of the probability mass.
Formally, the quantile function is the inverse function of the distribution function:

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)] $$

---

### Excel commands

#### Density function and distribution function of the F distribution

+ `=F.VERT`($x$; $k_1$; $k_2$; **kumuliert**)

    + $x$ := Value $x$ where the appropriate function value should be returned
    + $k_1$ := Number of numerator degrees of freedom
    + $k_2$ := Number of denominator degrees of freedom
    + kumuliert = 1 := Value of the distribution function (probability)
    + kumuliert = 0 := Value of the density function (no probability!)

#### Right probability mass of the F distribution

+ `=F.VERT.RE`($x$; $k_1$; $k_2$)

    + $x$ := Value $x$ where the appropriate function value should be returned
    + $k_1$ := Number of numerator degrees of freedom
    + $k_2$ := Number of denominator degrees of freedom
    
The function `F.VERT.RE` calculates: $P(X \ge x)$

#### Quantile function of the F distribution

+ `=F.INV`($p$; $k_1$; $k_2$)

    + $p$ := Probability
    + $k_1$ := Number of numerator degrees of freedom
    + $k_2$ := Number of denominator degrees of freedom

#### Right sided quantile of the F distribution

+ `=F.INV.RE`($p$; $k_1$; $k_2$)

    + $p$ := Probability
    + $k_1$ := Number of numerator degrees of freedom
    + $k_2$ := Number of denominator degrees of freedom
    
The function `F.INV.RE` calculates: $x = F^{-1}[P(X > x)] = F^{-1}[1 - P(X \leq x)]$
