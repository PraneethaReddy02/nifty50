# server.R
# Source the dependencies file
source("dependencies.R")

server <- function(input, output) {
  
  # Reactive expression to fetch data when "Fetch Data" is clicked
  fetchedData <- eventReactive(input$fetch, {
    req(input$company)
    
    # Fetch the selected company's historical data
    firmData <- getSymbols(input$company, src = "yahoo",
                           from = input$dates[1],
                           to = input$dates[2],
                           auto.assign = FALSE)
    
    # Fetch Nifty index historical data (Yahoo Finance ticker "^NSEI")
    indexData <- getSymbols("^NSEI", src = "yahoo",
                            from = input$dates[1],
                            to = input$dates[2],
                            auto.assign = FALSE)
    
    list(firm = firmData, index = indexData)
  })
  
  # Render the focal company's historical chart
  output$firmChart <- renderPlot({
    req(fetchedData())
    firmData <- fetchedData()$firm
    chartSeries(firmData, name = input$company, theme = chartTheme("white"))
  })
  
  # Render the real-time quote for the focal company
  output$quote <- renderTable({
    req(input$company)
    getQuote(input$company)
  }, rownames = TRUE)
  
  # Render the dual-axis plot in the "Stock vs Nifty" tab
  output$dualPlot <- renderPlot({
    data <- fetchedData()
    req(data)
    
    firmData <- data$firm
    indexData <- data$index
    
    # Extract closing prices
    firmClose <- Cl(firmData)
    indexClose <- Cl(indexData)
    
    # Merge the two series to align dates
    mergedData <- merge(indexClose, firmClose)
    colnames(mergedData) <- c("Nifty", "Firm")
    
    if (nrow(mergedData) == 0) return(NULL)
    
    # Plot Nifty index prices on the left Y-axis
    plot(index(mergedData), mergedData$Nifty, type = "l", col = "red", lwd = 2,
         xlab = "Date", ylab = "Nifty Price",
         main = paste("Price Movements:", input$company, "vs Nifty 50"))
    
    # Overlay the focal stock's prices (without axes)
    par(new = TRUE)
    plot(index(mergedData), mergedData$Firm, type = "l", col = "blue", lwd = 2,
         axes = FALSE, xlab = "", ylab = "")
    
    # Add a secondary axis on the right for the focal stock
    axis(side = 4, col.axis = "blue", col = "blue")
    mtext("Focal Stock Price", side = 4, line = 3, col = "blue")
    
    # Add a legend to distinguish the series
    legend("topleft", legend = c("Nifty 50", input$company),
           col = c("red", "blue"), lty = 1, lwd = 2)
  })
}
