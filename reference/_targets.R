library(targets)
targets::tar_pipeline(tarchetypes::tar_map(targets::tar_target(x, 
    a + b), targets::tar_target(y, x + a, pattern = map(x)), 
    values = list(a = c(12, 34), b = c(45, 78))))
