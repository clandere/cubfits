### This script collect the poster means of MCMC runs.

rm(list = ls())

library(cubfits)
source("00-set_env.r")

# Get all cases.
for(i.case in case.names){
  fn.in <- paste(prefix$subset, i.case, "_PM_scaling.rda", sep = "")
  if(!file.exists(fn.in)){
    next
  }
  load(fn.in)

  all.names <- names(b.PM)
  id.intercept <- grep("log.mu", all.names)
  id.slop <- grep("omega", all.names)

  log.mu <- b.PM[id.intercept]
  omega <- b.PM[id.slop]

  AA <- gsub("(.)\\.(.*)", "\\1", b.label)
  CODON <- gsub("(.)\\.(.*)", "\\2", b.label)
  
  ret <- data.frame(AA = AA, CODON = CODON, omega = omega, log.mu = log.mu)
  for(i.aa in unique(AA)){
    tmp <- .CF.GV$synonymous.codon.split[[i.aa]]
    tmp <- data.frame(AA = i.aa, CODON = tmp[length(tmp)],
                      omega = 0, log.mu = 0)
    ret <- rbind(ret, tmp)
  }

  order.id <- order(ret$AA, ret$CODON)
  ret <- ret[order.id,] 

  fn.out <- paste(prefix$table, "param_", i.case, "_PM_scaling.tsv", sep = "")
  write.table(ret, file = fn.out, quote = FALSE, sep = "\t", row.names = FALSE)

  ### Dump phi.
  ret <- cbind(phi.PM, phi.PM.log10, phi.MED)
  colnames(ret) <- c("Posterior.Mean", "Posterior.Mean.log10", "Median")
  rownames(ret) <- names(phi.PM)

  fn.out <- paste(prefix$table, "phi_", i.case, "_PM_scaling.tsv", sep = "")
  write.table(ret, file = fn.out, quote = FALSE, sep = "\t", row.names = FALSE)
}