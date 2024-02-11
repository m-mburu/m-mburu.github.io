
library(reticulate)
conda_binary()

library(tensorflow)

reticulate::install_python(version = '3.10')
tensorflow::install_tensorflow(cuda = FALSE)
