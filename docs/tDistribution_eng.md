---
output: html_document
---

***

## The t-distribution

Notation:

$$ X \sim t_k \quad\text{with}\quad k \in \mathbb{R}^{>0}$$

The t-distribution is a continous and symmetric distribution with $k$ *degrees of freedom*.
The shape of the t-distribution is soley defined by the *degrees of freedom*.
Expected value and variance are given by:

$$ \text{E}(X) = 0 \qquad\text{and}\qquad \text{Var}(X) = \frac{k}{k - 2}\quad\text{for}\quad k > 2 $$

### Density function

The density function is given by:

$$ f(x) = \frac{\Gamma\left(\frac{k + 1}{2}\right)}{\sqrt{k\pi}\Gamma\left(\frac{k}{2}\right)}
\left( 1 + \frac{x^2}{k} \right)^{- \frac{k + 1}{2}} $$

where $\Gamma(x) = \int^{+\infty}_0 t^{x-1}e^{-t} dt$ is the gamma function for $x$. 
The t-distribution converges in distribution to the standard normal distribution for  $k\to\infty$:

$$ t_k \overset{d}{\longrightarrow} N(0, 1) $$

Rule of thumb: for $k \geq 30$ the standard normal distribtuion may be used instead.
We can motivate the t-distribution as a special case of the F-distribution, since if

$$ \frac{\chi^2_1/1}{\chi^2_{k_2}/k_2} = X \sim F(1, k_2) $$

then

$$ \frac{Z}{\sqrt{\chi^2_{k_2}/k_2}} \sim t_k $$

where $Z \sim N(0,1)$. Symbolically $Z$ is the square root of a $\chi^2_1$ distribution, i.g. $Z = \sqrt{\chi^2_1}$. Analogiously, the square root of $X$ is given by $\frac{Z}{\sqrt{\chi^2_{k_2}/k_2}}$. 
Note though: the notation should be understood symbolically. If we draw 
$n$ values of $X$ and  **subsequently** take their square root the distribution **will not** be a t-distribution! 

### Cumulative distribution function

The cumulative distribution function (cdf) is given by:

$$ F(x) = P(X \leq x) = \int^{x}_{-\infty}f(t) dt $$

The value of the cumulative distribution function is the probability that the random variable $X$ is less than or equal to $x$.

### Quantile function

The quantile function returns the value (=quantile) $x_p$ under which is $p$% of the probability mass.
Formally, the quantile function is the inverse of the distribution function:

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)] $$

---

### Excel commands

#### Density and distribution function of the t-distribution

+ `=T.VERT`($x$; $k$; **kumuliert**)

    + $x$ := The value $x$ the function should be evaulated at
    + $k$ := Degrees of freedom
    + kumuliert = 1 := Value of the distribution function (a probability)
    + kumuliert = 0 := Value of the density function (not a probability!)

#### Right-tail of the t-distribution 

+ `=T.VERT.RE`($x$; $k$)

    + $x$ := The value the function should be evaulated at
    + $k$ := Degrees of freedom
    
The function `T.VERT.RE` calculates: $P(X \geq x)$

#### Left and right tail of the t-distribution

+ `=T.VERT.2S`($x$; $k$)

    + $x$ := The value the function should be evaulated at.
    + $k$ := Degrees of freedom

The function `T.VERT.2S` calculates: $P(|X| \geq x) = P(X \leq -x) + P(X \geq x)$

#### Qunatilefunction of the t-distribution

+ `=T.INV`($p$; $k$)

    + $p$ := A probability
    + $k$ := Degrees of freedom

#### Two-sides qunatile of the t-distribution

+ `=T.INV.2S`($p$; $k$)

    + $p$ := A probability
    + $k$ := Degrees of freedom
    
The function `T.INV.2S` calculates: $x =  F^{-1}[P(|X| > x)]$

----

**Note**

1.  `T.VERT.RE` = `1 - T.VERT(...; WAHR)`
1.  `T.VERT.2S` = `2*(1 - T.VERT(...; WAHR))`

since we have (because of symmetrie):

$$\begin{align}
P(X \geq x) &= 1 - P(X \leq x) \\\\
P(|X| \leq x) &= P(X \leq -x) + P(X \geq x) = 1 - P(X \leq x) + (1 - P(X \leq x)) = 2(1 - P(X \leq x)) 
\end{align}$$
