# ui.R
# Source the dependencies file
source("dependencies.R")

ui <- fluidPage(
  titlePanel("Nifty 50 Stock Data Viewer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("company", "Select Company:", choices = c(
        "Reliance Industries" = "RELIANCE.NS",
        "Tata Consultancy Services" = "TCS.NS",
        "HDFC Bank" = "HDFCBANK.NS",
        "Infosys" = "INFY.NS",
        "ICICI Bank" = "ICICIBANK.NS",
        "Kotak Mahindra Bank" = "KOTAKBANK.NS",
        "Hindustan Unilever" = "HINDUNILVR.NS",
        "State Bank of India" = "SBIN.NS",
        "Bajaj Finance" = "BAJFINANCE.NS",
        "Bharti Airtel" = "BHARTIARTL.NS"
      )),
      dateRangeInput("dates", "Select Date Range:",
                     start = Sys.Date() - 365, end = Sys.Date()),
      actionButton("fetch", "Fetch Data")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Focal Company Data",
                 h3("Real-Time Quote"),
                 tableOutput("quote"),
                 h3("Historical Chart"),
                 plotOutput("firmChart")
        ),
        tabPanel("Stock vs Nifty",
                 h3("Dual-Axis Plot: Stock vs Nifty"),
                 plotOutput("dualPlot")
        )
      )
    )
  )
)
