library(data.table)

# Set download method to avoid issues on some systems
options(download.file.method = "libcurl")
options(timeout = 300) # Increase timeout to 5 minutes for larger files

# Define URLs
urls <- list(
  developers = "https://raw.githubusercontent.com/github/innovationgraph/main/data/developers.csv",
  git_pushes = "https://raw.githubusercontent.com/github/innovationgraph/main/data/git_pushes.csv",
  git_repos = "https://raw.githubusercontent.com/github/innovationgraph/main/data/repositories.csv",
  programming_languages = "https://raw.githubusercontent.com/github/innovationgraph/main/data/languages.csv",
  iso3 = "https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv"
)

# Download data
cat("Downloading data...\n")
github_data <- lapply(urls, fread)

# Save outputs
out_dir <- "posts/github_use/data"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# 1) RDS (recommended for a single object)
rds_path <- file.path(out_dir, "github_innovation_data.rds")
saveRDS(github_data, rds_path)

# 2) RData (requested)
rdata_path <- file.path(out_dir, "github_innovation_data.RData")
save(github_data, file = rdata_path)

cat("Data successfully downloaded and saved to:\n")
cat("- ", rds_path, "\n", sep = "")
cat("- ", rdata_path, "\n", sep = "")
