library(shiny)

shinyUI(fluidPage(
  
  # Application title
titlePanel("Distribution Explorer"),
  
  # Sidebar with a changing input to set parameters of distribution
sidebarLayout(
    sidebarPanel(
       selectInput("distribution",
                   "Choose a Distribution:",
                   list(`Continuous` = c( "Uniform" = "unif", "Normal" = "norm", "Exponential" = "exp"), `Discrete` = c("Binomial" = "binom","Poisson" = "pois", "Geometric" = "geom")), selectize = FALSE),
       uiOutput("paramPanel"),
       uiOutput("probSlider"),
       checkboxInput("showProb", "Show Probability on Plot", value = FALSE)
    ),
    
    # Main display
    mainPanel(
        tabsetPanel(
            # Tab 1, Main App
            tabPanel("Explore",
                     plotOutput("distPlot"),
                     textOutput("computedProb")
            ),
            # Tab 2, Help/Documentation
            tabPanel("Help", 
                h2("About this App"),
                p("This app helps you understand the differences between various probability distributions by plotting their distribution functions and computing various associated probabilities."),
                h3("How to Use This App"),
                tags$ol(
                    tags$li("Use the drop-down list to select the type of distribution you'd like to explore. After you make your selection, new inputs will appear that allow you to adjust the parameters associated to that distribution."),
                    tags$li("After selecting the distribution type, adjust the parameters for the distribution. The plot will update as you adjust the parameters to show the probability density function associated to your choice of parameters and distribution"),
                    tags$li("Once you have chosen a distribution and set the parameters, you can also compute probabilities associated to that distribution. Use the slider to chose the probability bounds. The probability that a random draw from the selected distribution is between the bounds chosen by the slider is then displayed in the main panel."),
                    tags$li("This computed probability can also be represented graphically on the plot of the distribution, by seleting the checkbox marked 'Show Probability on Plot'. When this option is selected, the probability bounds are shown on the graph to mark the area under the probability density function. Leave this option unselected to make it easier to see how the plot changes as various parameters change, without extra clutter on the graph")
                ),
                h3("Ideas For Use"),
                tags$ul(
                    tags$li("Choose a distribution and see how changing the parameters for the distribution changes the shape of the probability density function."),
                    tags$li("Explore probabilities associated to the normal distribution. What is the probability that a value chosen from the normal distribution is within one standard deviation of the mean? Does this change as you adjust the parameters of the normal distribution?"),
                    tags$li("The normal distribution is sometimes used in statistics to approximate the binomial distribution. Understand why by comparing the shape of the normal distribution to the shape of the binomial distribution for large values of the parameter 'n'.")
                ),
                h3("Troubleshooting"),
                p("Please only use the incremental change arrows in the numeric inputs to adjust the values of the parameters for the distributions. Typing other numeric (or non-numeric) inputs into these fields may cause you to enter invalid parameters that can cause the app to crash. Using these arrows to change the parameters ensures that the parameters for the distribution will always be valid.")
            ),
            type = "tabs"
        )
    )
)

))
