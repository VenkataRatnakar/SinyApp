#
#Venkata Ratnakar Meka|11810035

#Venkatesh Natarajan|11810082

#Vinod Kumar Punna|11810061
#
if (!require(udpipe)){install.packages("udpipe")}
if (!require(stringr)){install.packages("stringr")}
if (!require(shiny)){install.packages("shiny")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(readtext)){install.packages("readtext")}


library(shiny)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)

shinyUI(
  fluidPage(
    
    
    # Application title
    titlePanel("UDPipe NLP workflow"),
    
    # Sidebar with input for test file and UDpipe model 
    sidebarLayout(
      sidebarPanel(
        # Input: for uploading a text file
        fileInput("inputfile", "Browse .txt file"),
        # line separator
        tags$hr(),
        #Input:MOdel File
        fileInput("modelfile", "Browse UDPipe model file"),
        # line separator
        tags$hr(),
        #Check box for upos selection
        checkboxGroupInput("myupos",label = h4("Select list of part-of-speech tags (UPOS):"),
                           c("Noun(NN)" = "NOUN",
                             "Adjective (JJ)" = "ADJ",
                             "Proper Noun (NNP)" = "PROPN",
                             "Verb (VB)"= "VERB",
                             "Adverb (RB)" = "ADV"),
                           selected = c("ADJ","NOUN","PROPN")
                           
        )
      ),
      #Main panel for Annotate and Cooccuranc Plot
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Annotate",dataTableOutput('Annotate')),
                    tabPanel("Co-Occurance Plot", plotOutput("Cooccurance"))
                    
        )
        
        
      )
      
    )
  ))