---
output: html_document
---

***

## B  inomial distribution

Notation:
  
  $$ X \sim \text{B}(n, p) \quad\text{mit}\quad n \in \mathbb{N} \quad\text{und}\quad 0 \leq p \leq 1 $$
  
The binomial distribution is a discrete distribution with distribution parameters $n$ and $p$, where $n$ is called the *number of "trials"* and $p$ the *probability of "success"*.
Expected value and variance are given by:

$$ \text{E}(X) = np \qquad\text{and}\qquad \text{Var}(X) = np(1-p) $$

### Probability mass function

The probability mass function (pdf) is given as follows:

$$ p(x) = P(X=x) = \begin{cases} \binom{n}{x}p^x (1 - p)^{n-x} & \text{for}\quad x \in \{0,1,2,\dots,n\} \\\\
0 & \text{otherwise} \end{cases} $$
  
with $x$ := Number of "matches" and $\binom{n}{x}$ := Binomial coefficient. 

### Cumulative distribution function

The cumulative distribution function (cdf) is defined as:
  
  $$ F(x) = P(X \leq x) = \sum_{x_i < x}P(X = x_i) $$

The value of the cumulative distribution function specifies the probability that the random variable $X$ is less than or equal to $x$.

### Quantile function

The quantile function returns the value $x_p$ under which is $p$%  of the probability mass.
Formally, the quantile function is the inverse function of the distribution function:

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)] $$

---

### Excel commands

#### Probability function and distribution function of the binomial distribution

+ `=BINOM.VERT`($x$; $n$; $p$; **kumuliert**)

    + $x$ := Number "matches"
    + $n$ := Number "experiments"
    + $p$ := Probability of success
    + kumuliert = 1 := Value of the distribution function (probability)
    + kumuliert = 0 := Value of the probability function (probability)

#### Probability range

+ `=BINOM.VERT.BEREICH`($n$; $p$; $x_1$; $x_2$)

    + $n$ := Number "experiments"
    + $p$ := Probability of success
    + $x_1$ := Lower limit
    + $x_1$ := Upper limit
    
The function `BINOM.VERT.BEREICH` calculates: $P(x_1 \leq X \leq x_2)$

#### Quantile function of the binomial distribution:

+ `=BINOM.INV`($n$; $p$; $\alpha$)

    + $n$ := Number "experiments"
    + $p$ := Probability of success
    + $\alpha$ := Probability

----

**Note**

`BINOM.VERT.BEREICH`($n$; $p$; $x_1$; $x_2$) = `BINOM.VERT`($x_2$; $n$; $p$; WAHR) - `BINOM.VERT`($x_1 - 1$; $n$; $p$; WAHR)

because

$$ P(x_1 \leq X \leq x_2) = P(X \leq x_2) - P(X < x_1) = P(X \leq x_2) - P(X \leq (x_1 - 1)) $$
