# Sentimenal-Analysis

A NPL (Python TextBlob) web application to predict input text trend: positive, negative, or neutral
![sentimental](https://user-images.githubusercontent.com/13625416/136576718-170a1969-1dda-4bb0-8ced-aa6c683ff25c.gif)

## How to run Python in R shiny 

  library(reticulate)

  # = use_python("/usr/local/bin/python3")
  virtualenv_create('pyDev',python = '/usr/bin/python3')
  virtualenv_install("pyDev", packages = c('nltk', 'textblob'))
  reticulate::use_virtualenv("pyDev", required = TRUE)

  py_run_string("import nltk")
  # py_run_string("nltk.download('punkt')")
  py_run_string("from textblob import TextBlob")



