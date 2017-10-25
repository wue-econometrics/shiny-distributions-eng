
##############################################################################
#                                                                            #
#                               Shiny Server                                 #
#                                                                            #
##############################################################################
### Begin server ---------------------------------------------------------------

shinyServer(function(input, output, session) {
  
  observeEvent(input$dist, {
    # This function checks, whether the selected distribution is changed by the
    # users input and disables the drawing of the rejection area if so.
    updateCheckboxInput(session, 'crit.value.checkbox', value = F)
    updateSliderInput(session, "distquant", value = "None")
  }) # END observeEvent
  
  ### Distributions plots including rejection areas ----------------------------
  
  output$plot <- renderPlot({
    
    if (!is.null(input$dist)) {
      
      uniblue <- "#063D79"
      
      sig.niveau.local = ifelse(input$test.type == "Two-sided",
                                input$sig.niveau/2, input$sig.niveau)
      switch (input$dist,
              "Normal distribution" = {
                x <- seq(input$axis.norm[1], input$axis.norm[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = dnorm(x, mean = input$mu, sd = input$sigma), 
                                       "y2" = pnorm(x, mean = input$mu, sd = input$sigma))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  labs(title = "Density of the normal distribution",
                       y     = "f(x)")
                  
                # Cumulative distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  labs(title = "Cumulative distribution function of the normal distribution",
                       y     = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "None" = {}, # END None 
                        
                        "Value of the density function" = {
                          
                          d <- dnorm(input$dens.value, mean = input$mu, sd = input$sigma)
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.norm[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                           
                        }, # END Value of the density function
                        
                        "Value of the cumulative distribution function" = {
                          
                          p <- pnorm(input$dist.value, mean = input$mu, sd = input$sigma)
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.norm[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the cumulative distribution function
                        
                        "Value of the quantile function" = {
                          
                          q <- qnorm(input$quant.prob, mean = input$mu, sd = input$sigma)
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.norm[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Value of the quantile function
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qnorm(sig.niveau.local, mean = input$mu, sd = input$sigma)
                  q_up <- qnorm(1 - sig.niveau.local, mean = input$mu, sd = input$sigma)
                  
                  switch (input$test.type,
                          "Right-sided" = {
                            
                              # shaded density
                              a <- a + 
                                geom_ribbon(data = subset(plotdata, y2 > 1 - input$sig.niveau), 
                                            aes(ymax = y1, ymin = 0), fill = uniblue)
                              
                              # shaded distribution function
                              b <- b +
                                geom_segment(aes(x = input$axis.norm[1], y = 1 - input$sig.niveau, 
                                                 xend = q_up, yend = 1 - input$sig.niveau), 
                                             linetype = "dashed", colour = uniblue) +
                                geom_segment(aes(x = q_up, y = 1 - input$sig.niveau, xend = q_up, yend = 1), 
                                             linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Left-sided" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < input$sig.niveau), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.norm[1], y = input$sig.niveau, 
                                               xend = q_low, yend = input$sig.niveau), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = input$sig.niveau, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Two-sided" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.norm[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.norm[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END Normal distribution
              
              "t-distribution" = {
                x <- seq(input$axis.t[1], input$axis.t[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = dt(x, df = input$df.t), 
                                       "y2" = pt(x, df = input$df.t))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Density of the t-distribution") +
                  labs(y = "f(x)")
                
                # Cumulative distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Cumulative distribution function of the t-distribution") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "None" = {}, # END None 
                        
                        "Value of the density function" = {
                          
                          d <- dt(input$dens.value, df = input$df.t)
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.t[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the density function
                        
                        "Value of the cumulative distribution function" = {
                          
                          p <- pt(input$dist.value, df = input$df.t)
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.t[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the cumulative distribution function
                        
                        "Value of the quantile function" = {
                          
                          q <- qt(input$quant.prob, df = input$df.t)
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.t[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Value of the quantile function
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qt(sig.niveau.local, df = input$df.t)
                  q_up <- qt(1 - sig.niveau.local, df = input$df.t)
                  
                  switch (input$test.type,
                          "Right-sided" = {
                            
                            # shaded density
                            a <- a + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - input$sig.niveau), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.t[1], y = 1 - input$sig.niveau, 
                                               xend = q_up, yend = 1 - input$sig.niveau), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - input$sig.niveau, xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Left-sided" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < input$sig.niveau), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.t[1], y = input$sig.niveau, 
                                               xend = q_low, yend = input$sig.niveau), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = input$sig.niveau, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Two-sided" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.t[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.t[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END t-distribution
              
              "Chi-squared distribution" = {
                x <- seq(input$axis.chi[1], input$axis.chi[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = dchisq(x, df = input$df.chi), 
                                       "y2" = pchisq(x, df = input$df.chi))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Density of the chi-squared distribution") +
                  labs(y = "f(x)")
                
                # Cumulative distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Cumulative distribution function of the chi-squared distribution") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "None" = {}, # END None 
                        
                        "Value of the density function" = {
                          
                          d <- dchisq(input$dens.value, df = input$df.chi)
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.chi[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the density function
                        
                        "Value of the cumulative distribution function" = {
                          
                          p <- pchisq(input$dist.value, df = input$df.chi)
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.chi[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the cumulative distribution function
                        
                        "Value of the quantile function" = {
                          
                          q <- qchisq(input$quant.prob, df = input$df.chi)
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.chi[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Value of the quantile function
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qchisq(sig.niveau.local, df = input$df.chi)
                  q_up <- qchisq(1 - sig.niveau.local, df = input$df.chi)
                  
                  switch (input$test.type,
                          "Right-sided" = {
                            
                            # shaded density
                            a <- a + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.chi[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Left-sided" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.chi[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Two-sided" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.chi[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.chi[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END Chi-squared distribution
              
              "F-distribution" = {
                x <- seq(input$axis.f[1], input$axis.f[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = df(x, df1 = input$df1, df2 = input$df2), 
                                       "y2" = pf(x, df1 = input$df1, df2 = input$df2))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Density of the F-distribution") +
                  labs(y = "f(x)")
                
                # Cumulative distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Cumulative distribution function of the F-distribution") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "None" = {}, # END None 
                        
                        "Value of the density function" = {
                          
                          d <- df(input$dens.value, df1 = input$df1, df2 = input$df2)
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.f[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the density function
                        
                        "Value of the cumulative distribution function" = {
                          
                          p <- pf(input$dist.value, df1 = input$df1, df2 = input$df2)
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.f[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the cumulative distribution function
                        
                        "Value of the quantile function" = {
                          
                          q <- qf(input$quant.prob, df1 = input$df1, df2 = input$df2)
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.f[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Value of the quantile function
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qf(sig.niveau.local, df1 = input$df1, df2 = input$df2)
                  q_up <- qf(1 - sig.niveau.local, df1 = input$df1, df2 = input$df2)
                  
                  switch (input$test.type,
                          "Right-sided" = {
                            
                            # shaded density
                            a <- a + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.f[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Left-sided" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.f[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Two-sided" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.f[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.f[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END F-distribution
              
              "Exponential distribution" = {
                x <- seq(input$axis.exp[1], input$axis.exp[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = dexp(x, rate = input$rate), 
                                       "y2" = pexp(x, rate = input$rate))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Density of the exponential distribution") +
                  labs(y = "f(x)")
                
                # Cumulative distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Cumulative distribution function of the exponential distribution") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "None" = {}, # END None 
                        
                        "Value of the density function" = {
                          
                          d <- dexp(input$dens.value, rate = input$rate)
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.exp[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the density function
                        
                        "Value of the cumulative distribution function" = {
                          
                          p <- pexp(input$dist.value, rate = input$rate)
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.exp[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the cumulative distribution function
                        
                        "Value of the quantile function" = {
                          
                          q <- qexp(input$quant.prob, rate = input$rate)
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.exp[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Value of the quantile function
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qexp(sig.niveau.local, rate = input$rate)
                  q_up <- qexp(1 - sig.niveau.local, rate = input$rate)
                  
                  switch (input$test.type,
                          "Right-sided" = {
                            
                            # shaded density
                            a <- a + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.exp[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Left-sided" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.exp[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Two-sided" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.exp[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.exp[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END Exponential distribution
              
              "Continuous uniform distribution" = {
                x <- seq(input$axis.cu[1], input$axis.cu[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = dunif(x, min = input$axis.updown[1], max = input$axis.updown[2]), 
                                       "y2" = punif(x, min = input$axis.updown[1], max = input$axis.updown[2]))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Density of the continous uniform distribution") +
                  labs(y = "f(x)")
                
                # Cumulative distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Cumulative distribution function of the continous uniform distribution") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "None" = {}, # END None 
                        
                        "Value of the density function" = {
                          
                          d <- dunif(input$dens.value, min = input$axis.updown[1],
                                     max = input$axis.updown[2])
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.cu[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the density function
                        
                        "Value of the cumulative distribution function" = {
                          
                          p <- punif(input$dist.value, min = input$axis.updown[1], 
                                     max = input$axis.updown[2])
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.cu[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Value of the cumulative distribution function
                        
                        "Value of the quantile function" = {
                          
                          q <- qunif(input$quant.prob, min = input$axis.updown[1], 
                                     max = input$axis.updown[2])
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.cu[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Value of the quantile function
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qunif(sig.niveau.local, min = input$axis.updown[1], max = input$axis.updown[2])
                  q_up <- qunif(1 - sig.niveau.local, min = input$axis.updown[1], max = input$axis.updown[2])
                  
                  switch (input$test.type,
                          "Right-sided" = {
                            
                            # shaded density
                            a <- a + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.cu[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Left-sided" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.cu[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Two-sided" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.cu[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.cu[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END Continuous uniform distribution
              
              "Binomial distribution" = {
                x <- input$axis.bin[1]:input$axis.bin[2]
                plotdata <- data.frame("x" = x, 
                                       "y1" = dbinom(x, size = input$size, prob = input$prob), 
                                       "y2" = pbinom(x, size = input$size, prob = input$prob))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_bar(stat = "identity") + 
                  scale_x_continuous(breaks = input$axis.bin[1]:input$axis.bin[2]) +
                  ggtitle("Probability mass function of the binomial distribution") + 
                  labs(y = "Probability: p(x)")
                
                # Cumulative distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_step() +
                  scale_x_continuous(breaks = input$axis.bin[1]:input$axis.bin[2]) +
                  ggtitle("Cumulative distribution function of the binomial distribution") +
                  labs(y = "F(x) = P(X ≤ x)")
                
                switch (input$distquant,
                        "None" = {}, # END None 
                        
                        "Value of the probability mass function" = {
                          
                          # d <- dbinom(input$prob.value, size = input$size, prob = input$prob)
                          
                          a <- a + 
                            geom_bar(data = subset(plotdata, x == input$prob.value), 
                                     stat="identity", fill = uniblue)
                          
                        }, # END Value of the probability mass function
                        
                        "Value of the cumulative distribution function" = {
                          
                          # p <- pbinom(input$dist.value, size = input$size, prob = input$prob)
                          
                          a <- a +  
                            geom_bar(data = subset(plotdata, x <= input$dist.value), 
                                     stat="identity", fill = uniblue)
                          
                        }, # END Value of the cumulative distribution function
                        
                        "Value of the quantile function" = {
                          
                          # q <- qbinom(input$quant.prob, size = input$size, prob = input$prob)
                          
                          a <- a +  
                            geom_bar(data = subset(plotdata, y2 <= input$quant.prob), 
                                     stat="identity", fill = uniblue)
                          
                        } # END Value of the quantile function
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qbinom(sig.niveau.local, size = input$size, prob = input$prob)
                  q_up <- qbinom(1 - sig.niveau.local, size = input$size, prob = input$prob)
                  
                  switch (input$test.type,
                          "Right-sided" = {
                            
                            # shaded bars 
                            a <- a + 
                              geom_bar(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                       stat="identity", fill = uniblue)
                              
                          }, # END Right-Sided
                          
                          "Left-sided" = {
                            
                            # shaded density
                            a <- a +  
                              geom_bar(data = subset(plotdata, y2 <= sig.niveau.local), 
                                          stat="identity", fill = uniblue)
                            
                          }, # END Left-Sided
                          
                          "Two-sided" = {
                            
                            # shaded density
                            a <- a +
                              geom_bar(data = subset(plotdata, y2 <= sig.niveau.local | y2 > 1 - sig.niveau.local), 
                                       stat="identity", fill = uniblue)
                            
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END Binomial distribution
              
              "Poisson distribution" = {
                x <- input$axis.pois[1]:input$axis.pois[2]
                plotdata <- data.frame("x" = x, 
                                       "y1" = dpois(x, lambda = input$lambda), 
                                       "y2" = ppois(x, lambda = input$lambda))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_bar(stat = "identity") + 
                  scale_x_continuous(breaks = input$axis.pois[1]:input$axis.pois[2]) +
                  ggtitle("Probability function of the poisson distribution") + 
                  labs(y = "Probability: p(x)")
                
                # Cumulative distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_step() +
                  scale_x_continuous(breaks = input$axis.pois[1]:input$axis.pois[2]) +
                  ggtitle("Cumulative distribution function of the poisson distribution") +
                  labs(y = "F(x) = P(X ≤ x)")
                
                switch (input$distquant,
                        "None" = {}, # END None 
                        
                        "Value of the probability mass function" = {
                          
                          # d <- dpois(input$prob.value, lambda = input$lambda)
                          
                          a <- a + 
                            geom_bar(data = subset(plotdata, x == input$prob.value), 
                                     stat="identity", fill = uniblue)
                          
                        }, # END Value of the probability mass function
                        
                        "Value of the cumulative distribution function" = {
                          
                          # p <- ppois(input$dist.value, lambda = input$lambda)
                          
                          a <- a +  
                            geom_bar(data = subset(plotdata, x <= input$dist.value), 
                                     stat="identity", fill = uniblue)
                          
                        }, # END Value of the cumulative distribution function
                        
                        "Value of the quantile function" = {
                          
                          # q <- qpois(input$quant.prob, lambda = input$lambda)
                          
                          a <- a +  
                            geom_bar(data = subset(plotdata, y2 <= input$quant.prob), 
                                     stat="identity", fill = uniblue)
                          
                        } # END Value of the quantile function
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qpois(sig.niveau.local, lambda = input$lambda)
                  q_up <- qpois(1 - sig.niveau.local, lambda = input$lambda)
                  
                  switch (input$test.type,
                          "Right-sided" = {
                            
                            # shaded bars 
                            a <- a + 
                              geom_bar(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                       stat="identity", fill = uniblue)
                            
                          }, # END Right-Sided
                          
                          "Left-sided" = {
                            
                            # shaded density
                            a <- a +  
                              geom_bar(data = subset(plotdata, y2 <= sig.niveau.local), 
                                       stat="identity", fill = uniblue)
                            
                          }, # END Left-Sided
                          
                          "Two-sided" = {
                            
                            # shaded density
                            a <- a +
                              geom_bar(data = subset(plotdata, y2 <= sig.niveau.local | y2 > 1 - sig.niveau.local), 
                                       stat="identity", fill = uniblue)
                            
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              } # END Poisson distribution
              
      ) # END switch(input$dist)
      
    } else { # makes sure that the normal distribution appears at start
             # so uses "see something" when they acess the page for the first time
      # Density function
      a <- ggplot(data.frame(x = -5:5), aes(x)) +
        stat_function(fun = dnorm) +
        ggtitle("Density of the normal distribution") +
        labs(y = "f(x)")
      
      # Cumulative distribution function
      b <- ggplot(data.frame(x = -5:5), aes(x)) +
        stat_function(fun = pnorm) +
        ggtitle("Cumulative distribution function of the normal distribution") +
        labs(y = "F(x) = P(X < x)")
      
    } # END else statement
    
    grid.arrange(a, b) # This acutally arranges both plots for the final plot
    
  }) # END output$plot

  ### Density, Distribution, Quantile text -------------------------------------
  
  output$ddq <- renderUI({
    
    if(!input$distquant == "None") {
    
    seg1 <- paste0("The ", strong(tolower(input$distquant)), " of the ", strong(tolower(input$dist)))
    
    switch (input$dist,
            'Normal distribution' = {
              
              param <- paste0(" with expected value \\(\\mu =\\) ", code(input$mu), 
                              " and a standard deviation of \\(\\sigma =\\) ", code(input$sigma))
              
              d <- dnorm(input$dens.value, mean = input$mu, sd = input$sigma)
              p <- pnorm(input$dist.value, mean = input$mu, sd = input$sigma)
              q <- qnorm(input$quant.prob, mean = input$mu, sd = input$sigma)
              
            }, # END Normal distribution
            't-distribution' = {
              
              param <- paste0(" with \\(k\\) = ", code(input$df.t), " degrees of freedom")
              
              d <- dt(input$dens.value, df = input$df.t)
              p <- pt(input$dist.value, df = input$df.t)
              q <- qt(input$quant.prob, df = input$df.t)
              
            }, # END t-distribution
            'Chi-squared distribution' = {
              
              param <- paste0(" with \\(k\\) = ", code(input$df.chi), " degrees of freedom")
              
              d <- dchisq(input$dens.value, df = input$df.chi)
              p <- pchisq(input$dist.value, df = input$df.chi)
              q <- qchisq(input$quant.prob, df = input$df.chi)
            },
            'F-distribution' = {
              
              param <- paste0(" with \\(k_1\\) = ", code(input$df1), " enumerator", "-", 
                              " and \\(k_2\\) = ", code(input$df2), " denominator")
              
              d <- df(input$dens.value, df1 = input$df1, df2 = input$df2)
              p <- pf(input$dist.value, df1 = input$df1, df2 = input$df2)
              q <- qf(input$quant.prob, df1 = input$df1, df2 = input$df2)
            },
            'Exponential distribution' = {
              
              param <- paste0(" with \\(\\alpha\\) = ", code(input$rate))
              
              d <- dexp(input$dens.value, rate = input$rate)
              p <- pexp(input$dist.value, rate = input$rate)
              q <- qexp(input$quant.prob, rate = input$rate)
            },
            'Continuous uniform distribution' = {
              
              param <- paste0(" with lowerbound \\(a\\) = ", code(input$axis.updown[1]), 
                              " and upperbound \\(b\\) = ", code(input$axis.updown[2]))
              
              d <- dunif(input$dens.value, min = input$axis.updown[1], max = input$axis.updown[2])
              p <- punif(input$dist.value, min = input$axis.updown[1], max = input$axis.updown[2])
              q <- qunif(input$quant.prob, min = input$axis.updown[1], max = input$axis.updown[2])
            },
            'Binomial distribution' = {
              
              param <- paste0(" with \\(n\\) = ", code(input$size), " trials ",
                              " and probability of success \\(p\\) = ", code(input$prob))
              
              d <- dbinom(input$prob.value, size = input$size, prob = input$prob)
              p <- pbinom(input$dist.value, size = input$size, prob = input$prob)
              q <- qbinom(input$quant.prob, size = input$size, prob = input$prob)
            },
            'Poisson distribution' = {
              
              param <- paste0(" with \\(\\lambda\\) = ", code(input$lambda))
              
              d <- dpois(input$prob.value, lambda = input$lambda)
              p <- ppois(input$dist.value, lambda = input$lambda)
              q <- qpois(input$quant.prob, lambda = input$lambda)
            }
    )
    
    switch (input$distquant,
            
            "Value of the probability mass function" = {
              
              seg2 <- ifelse(!(input$dist == "Binomial distribution" | input$dist == "Poisson distribution"),
                             paste0(" is: ", 
                             h4(code("Continous distributions do not have a probability mass function. 
                                     Use the density function instead."))),
                             paste0(" for \\(x =\\) ", code(input$prob.value), " is: ", 
                                    h4(code(round(d, 4))))
              )
              
            }, # END Value of the probability mass function
            
            "Value of the density function" = {
              
              seg2 <- ifelse(input$dist == "Binomial distribution" | input$dist == "Poisson distribution",
                             paste0(" is: ", 
                                    h4(code("Discrete distributions do not have a density function. 
                                            Use the probability mass function instead."))),
                             paste0(" for \\(x =\\) ", code(input$dens.value), " is: ", 
                                    h4(code(round(d, 4))))
                                    )
              
            }, # END Value of the density function
            
            "Value of the cumulative distribution function" = {
              
              seg2 <- paste0(" for \\(x =\\) ", code(input$dist.value), " is: ", 
                             h4(code(round(p, 4))))
              
            }, # END Value of the cumulative distribution function
            
            "Value of the quantile function" = {
              
              seg2 <- paste0(" for \\(p =\\) ", code(input$quant.prob), " is: ", 
                             h4(code(round(q, 4))))
              
            } # END Value of the quantile function
    )
    
    withMathJax(HTML(paste(seg1, param, seg2)))
    } # END if statement
  }) # END output$ddq
  
  ### Critical values ----------------------------------------------------------
  
  output$crit.value.text <- renderUI({

    if(input$crit.value.checkbox){

      seg1 <- paste0("For a ", strong("significance level"), " of:",
                     code(input$sig.niveau), ifelse(input$test.type == "Two-sided",
                                                        " the critical values of the ",
                                                        " the critical value of the ")
                     , strong(input$dist))

      switch (input$dist,
              'Normal distribution' = {

                param <- paste0(" with expected value \\(\\mu\\) = ", code(input$mu),
                                " and standard deviation \\(\\sigma\\) = ", code(input$sigma))

              }, # END Normal distribution
              't-distribution' = {

                param <- paste0(" with \\(k\\) = ", code(input$df.t), " degrees of freedom")

              }, # END t-distribution
              'Chi-squared distribution' = {

                param <- paste0(" with \\(k\\) = ", code(input$df.chi), " degrees of freedom")

              },
              'F-distribution' = {

                param <- paste0(" with \\(k_1\\) = ", code(input$df1), " enumerator",
                                " and \\(k_2\\) = ", code(input$df2), " denominator")

              },
              'Exponential distribution' = {

                param <- paste0(" with \\(\\alpha\\) = ", code(input$rate))

              },
              'Continuous uniform distribution' = {

                param <- paste0(" with lower bound \\(a\\) = ", code(input$axis.updown[1]),
                                " and upper bound \\(b\\) = ", code(input$axis.updown[2]))

              },
              'Binomial distribution' = {

                param <- paste0(" with \\(n\\) = ", code(input$size), " trials ",
                                " and a probability of success \\(p\\) = ", code(input$prob))

              },
              'Poisson distribution' = {

                param <- paste0(" with \\(\\lambda\\) = ", code(input$lambda))

              }
      ) # END switch dist

      seg2 <- paste0(" for a ",
                     strong(ifelse(input$test.type == "Right-sided", "right-sided",
                                   ifelse(input$test.type == "Left-sided", "left-sided", "two-sided"))),
                     " test is:")
      sig.niveau.local = ifelse(input$test.type == "Two-sided",
             input$sig.niveau/2, input$sig.niveau)

      switch (input$dist,
                          'Normal distribution' = {

                            q_low <- qnorm(sig.niveau.local, mean = input$mu, sd = input$sigma)
                            q_up <- qnorm(1 - sig.niveau.local, mean = input$mu, sd = input$sigma)

                          }, # END Normal distribution
                          't-distribution' = {

                            q_low <- qt(sig.niveau.local, df = input$df.t)
                            q_up <- qt(1 - sig.niveau.local, df = input$df.t)

                          }, # END t-distribution
                          'Chi-squared distribution' = {

                            q_low <- qchisq(sig.niveau.local, df = input$df.chi)
                            q_up <- qchisq(1 - sig.niveau.local, df = input$df.chi)

                          }, # END Chi-squared distribution
                          'F-distribution' = {

                            q_low <- qf(sig.niveau.local, df1 = input$df1, df2 = input$df2)
                            q_up <- qf(1 - sig.niveau.local, df1 = input$df1, df2 = input$df2)

                          },
                          'Exponential distribution' = {

                            q_low <- qexp(sig.niveau.local, rate = input$rate)
                            q_up <- qexp(1 - sig.niveau.local, rate = input$rate)

                          },
                          'Continuous uniform distribution' = {

                            q_low <- qunif(sig.niveau.local, min = input$axis.updown[1], max = input$axis.updown[2])
                            q_up <- qunif(1 - sig.niveau.local, min = input$axis.updown[1], max = input$axis.updown[2])

                          },
                          'Binomial distribution' = {

                            q_low <- qbinom(sig.niveau.local, size = input$size, prob = input$prob)
                            q_up <- qbinom(1 - sig.niveau.local, size = input$size, prob = input$prob)

                          },
                          'Poisson distribution' = {

                            q_low <- qpois(sig.niveau.local, lambda = input$lambda)
                            q_up <- qpois(1 - sig.niveau.local, lambda = input$lambda)

                          }
      ) # END switch dist

     crit.val <-  switch (input$test.type,
              "Right-sided" = {
                h4(code(round(q_up, 4)))
              },

              "Left-sided" = {
                h4(code(round(q_low, 4)))
              },

              "Two-sided" = {
                paste(h4(code(round(q_low, 4))), " and ", h4(code(round(q_up, 4))))
              }

      ) # END switch input$test.type

      withMathJax(HTML(paste(seg1, param, seg2, crit.val)))

      } # END if statement
  }) # END output$crit.value.text
  
  ### Distribution Information -------------------------------------------------
  
  output$dist.info <- renderUI({
      withMathJax(switch(input$dist,
                         'Normal distribution' = includeMarkdown("docs/NormalDistribution_eng.md"),
                         't-distribution' = includeMarkdown("docs/tDistribution_eng.md"),
                         'Chi-squared distribution' = includeMarkdown("docs/ChiSquaredDistribution_eng.md"),
                         'F-distribution' = includeMarkdown("docs/FDistribution_eng.md"),
                         'Exponential distribution' = includeMarkdown("docs/ExponentialDistribution_eng.md"),
                         'Continuous uniform distribution' = includeMarkdown("docs/UniformDistribution_eng.md"),
                         'Binomial distribution' = includeMarkdown("docs/BinomialDistribution_eng.md"),
                         'Poisson distribution' = includeMarkdown("docs/PoissonDistribution_eng.md")
      )) # END switch
    }) # END output$dist.info
}) # END shinyServer