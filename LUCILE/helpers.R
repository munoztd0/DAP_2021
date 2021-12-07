#for diag plot glm

library(boot)
diag <- glm.diag(model)
glm.diag.plots(model, diag)
