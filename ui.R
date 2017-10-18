################################################################################
#
#                               Shiny user interface (ui)
#
################################################################################
### Install packages if necessary

if(!require("shiny")) install.packages("shiny")
if(!require("shinythemes")) install.packages("shinythemes")
if(!require("shinyjs")) install.packages("shinyjs")
if(!require("markdown")) install.packages("markdown")
if(!require("ggplot2")) install.packages("ggplot2")
if(!require("gridExtra")) install.packages("gridExtra")

### Load required packages

library(shiny)
library(shinythemes)
library(markdown)
library(ggplot2)
library(gridExtra)

library(shinyjs)
### Begin ui -------------------------------------------------------------------

shinyUI(
  fluidPage(
    useShinyjs(),
    theme = "stylesheet.css",
    
### Header -----------------------------------------------------------------

    fluidRow(# div(id="titlebar","Verteilungsfunktionen und Hypothesentests"),
      div(id = "spacer",
        div(id = "titlebar",br(),"Probability Distributions",br()," "),
        br(),
        includeHTML("www/lehrstuhl.html"),
        tags$head(
          tags$link(href = "shared/font-awesome/css/font-awesome.min.css",
                    rel = "stylesheet")
        )
      )),

    sidebarLayout(
      
### Sidebar panel ----------------------------------------------------------

      sidebarPanel(
        width = 3,
        tabsetPanel(
          tabPanel(
            "Distributions",
            fluidRow(
              helpText("1. Chose a distribution"),
              selectInput('dist', NULL, list(
                "Continuous distributions" = c('Normal distribution', 
                                           't-distribution',
                                           'Chi-squared distribution', 
                                           'F-distribution', 
                                           'Exponential distribution',
                                           'Continuous uniform distribution'),
                "Discrete distributions" = c('Binomial distribution',
                                            'Poisson distribution')
                )
              )
              ), # END fluidRow 

            ### Conditonal Panels ----------------------------------------------------------
            fluidRow(
            conditionalPanel("input.dist == 'Normal distribution'",
                             helpText("2. Choose the parameters of the distribution."),
                             numericInput(inputId = 'mu', label = '\\(\\mu\\)', value = 0), 
                             numericInput(inputId = 'sigma', label = '\\(\\sigma\\)', value = 1, min = 0, step = 0.5),
                             helpText("3. Choose the x-axis range"),
                             sliderInput("axis.norm", label = NULL, min = -50, max = 50, value = c(-5, 5))),
            conditionalPanel("input.dist == 't-distribution'",
                             helpText("2. Choose the parameter of the distribution."),
                             numericInput(inputId = 'df.t',label = '\\(k\\)', value = 5, min = 0),
                             helpText("3. Choose the x-axis range"),
                             sliderInput("axis.t", label = NULL, min = -50, max = 50, value = c(-5, 5))),
            conditionalPanel("input.dist == 'Chi-squared distribution'",
                             helpText("2. Choose the parameter of the distribution."),
                             numericInput(inputId = 'df.chi',label = '\\(k\\)', value = 3, min = 0),
                             helpText("3. Choose the x-axis range"),
                             sliderInput("axis.chi", label = NULL, min = -1, max = 100, value = c(0, 10))),
            conditionalPanel("input.dist == 'F-distribution'",
                             helpText("2. Choose the parameters of the distribution."),
                             numericInput(inputId = 'df1',label = '\\(k_1\\)', value = 10, min = 0),
                             numericInput(inputId = 'df2',label = '\\(k_2\\)', value = 5, min = 0),
                             helpText("3. Choose the x-axis range"),
                             sliderInput("axis.f", label = NULL, min = -0, max = 50, value = c(0, 5))),
            conditionalPanel("input.dist == 'Exponential distribution'",
                             helpText("2. Choose the parameter of the distribution."),
                             numericInput(inputId = 'rate',label = '\\(\\alpha\\)', value = 1, min = 0, step = 0.5),
                             helpText("3. Choose the x-axis range"),
                             sliderInput("axis.exp", label = NULL, min = -1, max = 100, value = c(0, 5))),
            conditionalPanel("input.dist == 'Continuous uniform distribution'",
                             helpText("2. Choose the parameters of the distribution."),
                             sliderInput("axis.updown", label = "\\(a\\) and \\(b\\)", 
                                         min = -50, max = 50, value = c(-5, 5)),
                             helpText("3. Choose the x-axis range"),
                             sliderInput("axis.cu", label = NULL, min = -50, max = 50, value = c(-10, 10))),
            conditionalPanel("input.dist == 'Binomial distribution'",
                             helpText("2. Choose the parameters of the distribution."),
                             numericInput(inputId = 'size',label = '\\(n\\)', 
                                          value = 5, min = 0, step = 1),
                             numericInput(inputId = 'prob',label = '\\(p\\)', 
                                          value = 0.5, min = 0, max = 1, step = 0.1),
                             helpText("3. Choose the x-axis range"),
                             sliderInput("axis.bin", label = NULL, min = 0, max = 100, value = c(0, 10))),
            conditionalPanel("input.dist == 'Poisson distribution'",
                             helpText("2. Choose the parameter of the distribution."),
                             numericInput(inputId = 'lambda',label = '\\(\\lambda\\)', value = 1, min = 0, step = 0.1),
                             helpText("3. Choose the x-axis range"),
                             sliderInput("axis.pois", label = NULL, min = 0, max = 100, value = c(0, 10)))
            ), # end fluidRow
            br(),
            fluidRow(
                helpText("4.1 Which values should be calculated ?"),
                selectInput('distquant', NULL,
                            c('None',
                              'Value of the density function',
                              'Value of the probability function',
                              'Value of the distribution function',
                              'Value of the quantile function')),
                conditionalPanel("input.distquant == 'Value of the probability function'",
                                 helpText("4.2 For which x should the value of the probability 
                                          function be calculated?"),
                                 numericInput("prob.value", NULL, value = 0)
                                 ),
                conditionalPanel("input.distquant == 'Value of the density function'",
                                 helpText("4.2 For which x should the value of the density 
                                          function be calculated?"),
                                 numericInput("dens.value", NULL, value = 0)
                                 ),
                conditionalPanel("input.distquant == 'Value of the distribution function'",
                                 helpText("4.2 For which x should the value of the distribution
                                          function be calculated?"),
                                 numericInput("dist.value", NULL, value = 0)
                                 ),
                conditionalPanel("input.distquant == 'Value of the quantile function'",
                                 helpText("4.2 For which probability should the quantile be calcualted?"),
                                 numericInput("quant.prob", NULL, value = 0.5, min = 0, max = 1, step = 0.1)
                                 )
            ) # END fluidRow
          ), # tabPanel
          tabPanel("Hypothesis testing",
                   helpText("1. Choose the test"),
                   selectInput('test.type', NULL, c('Right-sided', 'Left-sided', 'Two-sided')),
                   helpText("2. Choose the level of significance"),
                   numericInput("sig.niveau", NULL, value = 0.05, min = 0, max = 1, step = 0.1),
                   helpText("3. Plot the rejection area ?"),
                   checkboxInput('crit.value.checkbox', label = "Yes", value = F)
          ) # END tabPanel
        ) # END tabsetPanel
        ), # END sidebarLayout

### MainPanel ------------------------------------------------------------------
      
      mainPanel(
        
        plotOutput('plot'),
        br(),
        uiOutput("ddq"),
        uiOutput("crit.value.text"),
        br(),
        uiOutput('dist.info')
        
        ) # END mainPanel
    ) # END sidebar layout
  ) # END fluid page
) # END shiny ui