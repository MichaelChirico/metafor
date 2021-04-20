print.permutest.rma.uni <- function(x, digits=x$digits, signif.stars=getOption("show.signif.stars"), signif.legend=signif.stars, ...) {

   mstyle <- .get.mstyle("crayon" %in% .packages())

   .chkclass(class(x), must="permutest.rma.uni")

   digits <- .get.digits(digits=digits, xdigits=x$digits, dmiss=FALSE)

   if (!exists(".rmspace"))
      cat("\n")

   if (!x$int.only) {
      cat(mstyle$section(paste0("Test of Moderators (coefficient", ifelse(x$m == 1, " ", "s "), .format.btt(x$btt),"):")))
      cat("\n")
      if (is.element(x$test, c("knha","adhoc","t"))) {
         cat(mstyle$result(paste0("F(df1 = ", x$QMdf[1], ", df2 = ", x$QMdf[2], ") = ", .fcf(x$QM, digits[["test"]]), ", p-val* ", .pval(x$QMp, digits=digits[["pval"]], showeq=TRUE, sep=" "))))
      } else {
         cat(mstyle$result(paste0("QM(df = ", x$QMdf[1], ") = ", .fcf(x$QM, digits[["test"]]), ", p-val* ", .pval(x$QMp, digits[["pval"]], showeq=TRUE, sep=" "))))
      }
      cat("\n\n")
   }

   if (is.element(x$test, c("knha","adhoc","t"))) {
      res.table <- data.frame(estimate=.fcf(c(x$beta), digits[["est"]]), se=.fcf(x$se, digits[["se"]]), tval=.fcf(x$zval, digits[["test"]]), df=round(x$ddf, 2), "pval*"=.pval(x$pval, digits[["pval"]]), ci.lb=.fcf(x$ci.lb, digits[["ci"]]), ci.ub=.fcf(x$ci.ub, digits[["ci"]]))
      colnames(res.table)[5] <- "pval*" # rename 'pval.' to 'pval*'
      if (x$permci)
         colnames(res.table)[6:7] <- c("ci.lb*", "ci.ub*")
   } else {
      res.table <- data.frame(estimate=.fcf(c(x$beta), digits[["est"]]), se=.fcf(x$se, digits[["se"]]), zval=.fcf(x$zval, digits[["test"]]), "pval*"=.pval(x$pval, digits[["pval"]]), ci.lb=.fcf(x$ci.lb, digits[["ci"]]), ci.ub=.fcf(x$ci.ub, digits[["ci"]]))
      colnames(res.table)[4] <- "pval*" # rename 'pval.' to 'pval*'
      if (x$permci)
         colnames(res.table)[5:6] <- c("ci.lb*", "ci.ub*")
   }
   rownames(res.table) <- rownames(x$beta)
   signif <- symnum(x$pval, corr=FALSE, na=FALSE, cutpoints=c(0, 0.001, 0.01, 0.05, 0.1, 1), symbols = c("***", "**", "*", ".", " "))
   if (signif.stars) {
      res.table <- cbind(res.table, signif)
      colnames(res.table)[ncol(res.table)] <- ""
   }

   if (x$int.only)
      res.table <- res.table[1,]

   cat(mstyle$section("Model Results:"))
   cat("\n\n")
   if (x$int.only) {
      tmp <- capture.output(.print.vector(res.table))
   } else {
      tmp <- capture.output(print(res.table, quote=FALSE, right=TRUE, print.gap=2))
   }
   .print.table(tmp, mstyle)

   if (signif.legend) {
      cat("\n")
      cat(mstyle$legend("---\nSignif. codes: "), mstyle$legend(attr(signif, "legend")))
      cat("\n")
   }

   if (!exists(".rmspace"))
      cat("\n")

   invisible()

}
