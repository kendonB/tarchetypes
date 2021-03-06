% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tar_plan.R
\name{tar_plan}
\alias{tar_plan}
\title{A \code{drake}-plan-like pipeline archetype}
\usage{
tar_plan(...)
}
\arguments{
\item{...}{Named and unnamed targets. All named targets must follow
the \code{drake}-plan-like \code{target = command} syntax, and all unnamed
arguments must be explicit calls to create target objects,
e.g. \code{tar_target()}, target archetypes like \code{\link[=tar_render]{tar_render()}}, or similar.}
}
\value{
A \code{targets::tar_pipeline()} object.
}
\description{
Simplify target specification in pipelines.
}
\details{
Allows targets with just targets and commands
to be written in the pipeline as \code{target = command} instead of
\code{tar_target(target, command)}. Also supports ordinary
target objects if they are unnamed.
\code{tar_plan(x = 1, y = 2, tar_target(z, 3), tar_render(r, "r.Rmd"))}
is equivalent to
\code{tar_plan(tar_target(x, 1), tar_target(y, 2), tar_target(z, 3), tar_render(r, "r.Rmd"))}. # nolint
}
\examples{
\dontrun{
targets::tar_dir({
lines <- c(
  "---",
  "title: report",
  "output_format: html_document",
  "---",
  "",
  "```{r}",
  "targets::tar_read(data)",
  "```"
)
writeLines(lines, "report.Rmd")
targets::tar_script({
  library(tarchetypes)
  tar_plan(
    data = data.frame(x = seq_len(26), y = sample.int(26)),
    means = colMeans(data),
    tar_render(report, "report.Rmd")
  )
})
targets::tar_make()
})
}
}
