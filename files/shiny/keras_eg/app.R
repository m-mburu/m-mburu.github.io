library(keras)
library(tensorflow)
mnist <- dataset_mnist()

mnist$train$x <- (mnist$train$x/255) %>% 
    array_reshape(., dim = c(dim(.), 1))

mnist$test$x <- (mnist$test$x/255) %>% 
    array_reshape(., dim = c(dim(.), 1))
library(keras)
library(tensorflow)
mnist <- dataset_mnist()

mnist$train$x <- (mnist$train$x/255) %>% 
    array_reshape(., dim = c(dim(.), 1))

mnist$test$x <- (mnist$test$x/255) %>% 
    array_reshape(., dim = c(dim(.), 1))

model <- keras_model_sequential() %>% 
    layer_conv_2d(filters = 16, kernel_size = c(3,3), activation = "relu") %>% 
    layer_max_pooling_2d(pool_size = c(2,2)) %>% 
    layer_conv_2d(filters = 16, kernel_size = c(3,3), activation = "relu") %>% 
    layer_max_pooling_2d(pool_size = c(2,2)) %>% 
    layer_flatten() %>% 
    layer_dense(units = 128, activation = "relu") %>% 
    layer_dense(units = 10, activation = "softmax")

model %>% 
    compile(
        loss = "sparse_categorical_crossentropy",
        optimizer = "adam",
        metrics = "accuracy"
    )
model %>% 
    fit(
        x = mnist$train$x, y = mnist$train$y,
        batch_size = 32,
        epochs = 5,
        validation_sample = 0.2,
        verbose = 2
    )

model %>% evaluate(x = mnist$test$x, y = mnist$test$y)

library(shiny)
library(keras)

# Load the model
model <- load_model_tf("cnn-mnist/")

# Define the UI
ui <- fluidPage(
    # App title ----
    titlePanel("Hello TensorFlow!"),
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        # Sidebar panel for inputs ----
        sidebarPanel(
            # Input: File upload
            fileInput("image_path", label = "Input a JPEG image")
        ),
        # Main panel for displaying outputs ----
        mainPanel(
            # Output: Histogram ----
            textOutput(outputId = "prediction"),
            plotOutput(outputId = "image")
        )
    )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
    
    image <- reactive({
        req(input$image_path)
        jpeg::readJPEG(input$image_path$datapath)
    })
    
    output$prediction <- renderText({
        
        img <- image() %>% 
            array_reshape(., dim = c(1, dim(.), 1))
        
        paste0("The predicted class number is ", predict_classes(model, img))
    })
    
    output$image <- renderPlot({
        plot(as.raster(image()))
    })
    
}

shinyApp(ui, server)
