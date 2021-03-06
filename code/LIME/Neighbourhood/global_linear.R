### Simulation refering to the subsubsection "Global Linear Relationships" of
### "Simulated data" of "The problem in more complex settings"
set.seed(1)

### Data simulation based on function out of utils.R
data_set <- simulate_data(2500, 
                          3, 
                          seed = 1, 
                          mu = c(5, 5, 5), 
                          Sigma = matrix(
                            c(1, 0.3, 0.4, 0.3, 0.9, 0.2, 0.4, 0.2, 0.8), 
                            ncol = 3, nrow = 3, byrow = TRUE),
                          true_coefficients = c(4, -3, 5), 
                          intercept = 5) %>% make_split(0.9)

### Define the task (mlr)
task <- makeRegrTask(data = data_set$train, target = "y")
### Define the learner (mlr)
learner <- makeLearner("regr.glm", family = "gaussian")
### Train the model (mlr)
black_box <- train(learner, task)
### predict
task_pred <- predict(black_box, newdata = data_set$test)
saveRDS(task_pred, file = "R-results/LIME/Neighbourhood/task_pred_lm.RDS")

# Set up LIME explainer
explainer <- lime(data_set$train[ , 2:4], black_box,
                  bin_continuous = FALSE, use_density = FALSE)

### We choose 4 different observations (random) for which we aim to analyse
### how the model estimates change as the kernel size changes.
# obs 1 .- plot 8a
kernel_widths <- seq(0.1, 3, 0.1)
kernel_widths <- c(0.025, 0.05, kernel_widths)
kernel_matrix1 <- analyse_multivariate_kernel_width(kernel_widths,
                                                    data_set$test[1, 2:4], 
                                                    explainer,
                                                    n_features = 3, 
                                                    n_permutations = 1000, 
                                                    dist_fun = "euclidean",
                                                    seed = 1)

# obs 21 .- plot 8b
kernel_matrix2 <- analyse_multivariate_kernel_width(kernel_widths,
                                                    data_set$test[21, 2:4], 
                                                    explainer,
                                                    n_features = 3, 
                                                    n_permutations = 1000, 
                                                    dist_fun = "euclidean",
                                                    seed = 2)

# obs 33 - plot 8c
kernel_matrix3 <- analyse_multivariate_kernel_width(kernel_widths,
                                                    data_set$test[33, 2:4], 
                                                    explainer,
                                                    n_features = 3, 
                                                    n_permutations = 1000, 
                                                    dist_fun = "euclidean",
                                                    seed = 3)

# obs 103 - plot 8d
kernel_matrix4 <- analyse_multivariate_kernel_width(kernel_widths,
                                                   data_set$test[103, 2:4], 
                                                   explainer,
                                                   n_features = 3, 
                                                   n_permutations = 1000, 
                                                   dist_fun = "euclidean",
                                                   seed = 4)

### Save for reproducibility and plots.
saveRDS(kernel_matrix1, 
        file = "R-results/LIME/Neighbourhood/kernelmatrix-global_linear1.RDS")
saveRDS(kernel_matrix2, 
        file = "R-results/LIME/Neighbourhood/kernelmatrix-global_linear2.RDS")
saveRDS(kernel_matrix3, 
        file = "R-results/LIME/Neighbourhood/kernelmatrix-global_linear3.RDS")
saveRDS(kernel_matrix4, 
        file = "R-results/LIME/Neighbourhood/kernelmatrix-global_linear4.RDS")
saveRDS(kernel_widths, 
        file = "R-results/LIME/Neighbourhood/kw_global_linear.RDS")
