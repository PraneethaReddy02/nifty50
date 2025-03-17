# dependencies.R
# List of required packages
required_packages <- c("shiny", "quantmod", "xts")

# Check for missing packages and install them if necessary
new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]
if (length(new_packages)) {
  install.packages(new_packages)
}

# Load the packages
lapply(required_packages, library, character.only = TRUE)
