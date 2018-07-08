library(shiny)
library(ggplot2)

# Create the panels that allow the choice of parameters for various distribution choices
unifParamPanel <-{
    div(
        p(strong("Choose the parameters for the distribution:")),
        numericInput("uparam1", "Lower Bound", 0, min = -5, max = 0, step = 0.25),
        numericInput("uparam2", "Upper Bound", 1, min = 1, max = 5, step = 0.25)
    )
}

normParamPanel <-{
    div( 
        p(strong("Choose the parameters for the distribution:")),
        numericInput("nparam1", "Mean:", 0, min = -5, max = 5, step = 0.25),
        numericInput("nparam2", "Standard Deviation:", 1, min = 0.25, max = 5, step = 0.25)
    )
}

expParamPanel <-{
    div(
        p(strong("Choose the parameters for the distribution:")),
        numericInput("expparam1", "Rate:", 1, min = 0.1, max = 10, step = .1)
    )
}

binomParamPanel <-{
    div(
        p(strong("Choose the parameters for the distribution:")),
        numericInput("bparam1", "n (number of draws):", 25, min = 1, max = 50, step = 1),
        numericInput("bparam2", "p (success probability):", 0.5, min = 0, max = 1, step = 0.1)
    )
}
poisParamPanel <-{
    div(
        p(strong("Choose the parameters for the distribution:")),
        numericInput("pparam1", "Rate:", 1, min = 0, max = 20, step = .5)
    )
}
geomParamPanel <-{
    div(
        p(strong("Choose the parameters for the distribution:")),
        numericInput("gparam1", "p (probability of success):", 0.5, min = 0, max = 1, step = .1)
    )
}

# Create the sliders that allow for the input of probability bounds
unifSlider <-{
    div(
        p(strong("Choose the probability bounds:")),
        sliderInput("ubounds","Interval", min = -5, max = 5, step = 0.1, value = c(0,1))
    )
}
normSlider <-{
    div(
        p(strong("Choose the probability bounds:")),
        sliderInput("nbounds","Interval", min = -5, max = 5, step = 0.1, value = c(-1,1))
    )
}

expSlider <-{
    div(
        p(strong("Choose the probability bounds:")),
        sliderInput("expbounds","Interval", min = 0, max = 20, step = 0.5, value = c(0,1))
    )
}

binomSlider <-{
    div(
        p(strong("Choose the probability bounds:")),
        sliderInput("bbounds","Interval", min = 0, max = 50, step = 1, value = c(0,1))
    )
}
poisSlider <-{
    div(
        p(strong("Choose the probability bounds:")),
        sliderInput("pbounds","Interval", min = 0, max = 20, step = 1, value = c(0,1))
    )
}
geomSlider <-{
    div(
        p(strong("Choose the probability bounds:")),
        sliderInput("gbounds","Interval", min = 0, max = 40, step = 1, value = c(0,1))
    )
}

# Actual Server and Computations
shinyServer(function(input, output) {
    # Get distribution selection
    distributionName <- reactive({
        input$distribution
        })
    
    # Display the correct parameter panel for the chosen distribution
    output$paramPanel <- renderUI(switch(distributionName(),
                "unif" = unifParamPanel,
                "norm" = normParamPanel,
                "exp" = expParamPanel,
                "binom" = binomParamPanel,
                "pois" = poisParamPanel,
                "geom" = geomParamPanel
                ))
    
    # Display the correct probability slider for the chosen distribution
    output$probSlider <- renderUI(
        switch(distributionName(),
               "unif" = unifSlider,
               "norm" = normSlider,
               "exp" = expSlider,
               "binom" = binomSlider,
               "pois" = poisSlider,
               "geom" = geomSlider
               ))
    
    # Make Convenience accessors for the various input parameters, that also do some error checking (make sure values are present). This prevents the app from trying to redraw the plot with old parameters immediately after switching the distribution, which can cause errors. These accesors basically make sure that all of the parameters update before the plot is drawn.
    
    # lower bound for probability computations
    a <- reactive({
        req(distributionName)
        switch(distributionName(),
               "unif" = req(input$ubounds[1]),
               "norm" = req(input$nbounds[1]),
               "exp" = req(input$expbounds[1]),
               "binom" = req(input$bbounds[1]),
               "pois" = req(input$pbounds[1]),
               "geom" = req(input$gbounds[1]),
               NULL)
    })
    
    # upper bound for probability computations
    b <- reactive({
        req(distributionName)
        switch(distributionName(),
               "unif" = req(input$ubounds[2]),
               "norm" = req(input$nbounds[2]),
               "exp" = req(input$expbounds[2]),
               "binom" = req(input$bbounds[2]),
               "pois" = req(input$pbounds[2]),
               "geom" = req(input$gbounds[2]),
               NULL)
    })
    
    # First parameter (in associated R functions) for the distribution
    p1 <- reactive({
        req(distributionName)
        switch(distributionName(),
               "unif" = req(input$uparam1),
               "norm" = req(input$nparam1),
               "exp" = req(input$expparam1),
               "binom" = req(input$bparam1),
               "pois" = req(input$pparam1),
               "geom" = req(input$gparam1),
               NULL)
    })
    
    # Second parameter (in associated R functions) for the distribution, if present
    p2 <- reactive({
        req(distributionName)
        switch(distributionName(),
               "unif" = req(input$uparam2),
               "norm" = req(input$nparam2),
               "exp" = NULL,
               "binom" = req(input$bparam2),
               "pois" = NULL,
               "geom" = NULL,
               NULL)
    })
    
    # x values for plot
    x <- reactive({
        req(p1, distributionName)
        switch(distributionName(),
            "unif" = seq(-5, 5, length.out = 300),
            "norm" = seq( -5,5, length.out = 100 ),
            "exp" = seq(0, qexp(.99, p1()), length.out = 300),
            "binom" = seq(0, p1(), by = 1),
            "pois" = seq(0, qpois(.99, p1()), by = 1),
            "geom" = seq(0,qgeom(.99, p1()))
        )
    })
      
    # y values for plot  
    y <- reactive({
        req(x, distributionName, p1, p2)
        switch(distributionName(),
            "unif" = dunif(x(), min = p1(), max = p2()),
            "norm" = dnorm(x(), mean = p1(), sd = p2()),
            "exp" = dexp(x(), rate = p1()),
            "binom" = dbinom(x(), size = p1(), prob = p2()),
            "pois" = dpois(x(), lambda = p1()),
            "geom" = dgeom(x(), prob = p1())
        )
    })
        
    # Make the base layer (probability density function) for the plot
    baseplot <- reactive({
        req(x,y,distributionName)
        if (is.discrete(distributionName())){
            plot <- ggplot() + geom_col(aes(x = x(), y = y())) + ylim(0,1)
        } else {
            plot <- ggplot() + geom_line(aes(x = x(), y = y()), lwd = 2) 
            
            # Fix plot window in the y-axis direction to make it easier to see how changes in the parameters change the plot. We do not fix the window for the exponential distribution, though, as this distribution has values well above 1 near 0, and doing so would cut off a great deal of the plot.
            if (distributionName() != "exp"){
                plot <- plot + ylim(0,1)
            }
        }
        plot + labs(x = "Value", y = "Density", title = "Probability Density Function of Selected Distribution")
    })
        
    # Output the plot, including probability bounds if selected
    output$distPlot <- renderPlot({
        req(baseplot, a, b)
        if (input$showProb == TRUE){
            # Draw left boundary of probability. As currently set up, it will always be shown on the plot
            plot <- baseplot() + geom_vline(xintercept = a(), color = "red", lwd = 2) 
            
            # Draw right boundary of probability only if it will appear in the current plot window. 
            rightlim <- ggplot_build(baseplot())$layout$panel_ranges[[1]]$x.range[2]
            if (b() < rightlim){
            plot <- plot + geom_vline(xintercept = b(), color = "red", lwd = 2)
            }
            plot
        } else {
            baseplot()
        }
    })

    # Compute and display probability for interval choices
    output$computedProb <- renderText({
        req(distributionName, a, b, p1, p2)
        prob <- switch(distributionName(),
            "unif" = (punif(b(), min =p1(), max = p2()) -punif(a(), min = p1(), max = p2())) ,
            "norm" = (pnorm(b(), mean = p1(), sd = p2()) - pnorm(a(), mean = p1(), sd = p2())),
            "exp" = (pexp(b(), rate = p1()) - pexp(a(), rate = p1())),
            "binom" = sum(dbinom(seq(a(),b(),1), size = p1(), prob = p2())),
            "pois" = sum(dpois(seq(a(),b(),1),lambda = p1())),
            "geom" = sum(dgeom(seq(a(),b(),1),prob = p1()))
            )
        paste("The probability of a random draw from the distribution falling between ", a(), " and ", b(), " is ", prob, ".", sep = "")
    })
}) # End serve function

# Helper Function - says if a distribution is discrete
is.discrete <- function(string){
    discrete.supported <- c("binom", "pois", "geom")
    string %in% discrete.supported
}
