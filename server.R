#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(readtext)
options(shiny.maxRequestSize = 30*1024^2)

shinyServer(function(input, output) {
  #creating function for input text file
  Dataset <- reactive({
    
    inputfile = input$inputfile
    if (is.null(inputfile$datapath)) { return(NULL) } else
    {
      
      require(stringr)
     
      Data <- readLines(inputfile$datapath, encoding = "UTF-8")
      Data  =  str_replace_all(Data, "<.*?>", "")
      return(Data)
      
    }
  })  
 #reading Model file and creating data frame 
  an <- reactive({
    #print(input$modelfile)
    modelfile = input$modelfile
    if (is.null(modelfile$datapath)) { return(NULL) } else
    lang_model = udpipe_load_model(modelfile$datapath)
    x <- udpipe_annotate(lang_model, Dataset())
    x <- as.data.frame(x)
    return(x)
  })
  
  #output table after annotation
  output$Annotate <- renderDataTable(
    {
      out <- an() 
      return(out)
    }
  )
  #Creating cooccurance graph
  output$Cooccurance <- renderPlot(
    {
      modelfile = input$modelfile
      if (is.null(modelfile$datapath)) { return(NULL) } else
      lang_model = udpipe_load_model(modelfile$datapath)
      x <- udpipe_annotate(lang_model, Dataset())
      x <- as.data.frame(x)
      data_cooc <- cooccurrence(   	# try `?cooccurrence` for parm options
        x = subset(x, upos %in% input$myupos), 
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))
                                        
      # Visualising top-30 co-occurrences using a network plot
      library(igraph)
      library(ggraph)
      library(ggplot2)
      
      wordnetwork <- head(data_cooc, 50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "Co-Occurrences within 3 words distance")
      
      
    }
  )
  
})