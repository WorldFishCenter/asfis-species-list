# Prepare workspace -------------------------------------------------------

library(targets)

# load functions
f <- lapply(list.files(path = here::here("R"), full.names = TRUE,
                       include.dirs = TRUE, pattern = "*.R"), source)

# Plan analysis ------------------------------------------------------------

list(
  tar_target(
    name = dummy_target,
    command = "hello-world"
  )
)

