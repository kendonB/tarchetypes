% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tar_skip.R
\name{tar_skip}
\alias{tar_skip}
\title{Target with a custom cancellation condition.}
\usage{
tar_skip(
  name,
  command,
  skip,
  tidy_eval = targets::tar_option_get("tidy_eval"),
  packages = targets::tar_option_get("packages"),
  library = targets::tar_option_get("library"),
  format = targets::tar_option_get("format"),
  iteration = targets::tar_option_get("iteration"),
  error = targets::tar_option_get("error"),
  memory = targets::tar_option_get("memory"),
  deployment = targets::tar_option_get("deployment"),
  priority = targets::tar_option_get("priority"),
  resources = targets::tar_option_get("resources"),
  storage = targets::tar_option_get("storage"),
  retrieval = targets::tar_option_get("retrieval"),
  cue = targets::tar_option_get("cue")
)
}
\arguments{
\item{name}{Symbol, name of the target.}

\item{command}{R code to run the target.}

\item{skip}{R code for the skipping condition. If it evaluates to \code{TRUE}
during \code{tar_make()}, the target will cancel itself.}

\item{tidy_eval}{Whether to invoke tidy evaluation
(e.g. the \verb{!!} operator from \code{rlang}) as soon as the target is defined
(before \code{tar_make()}). Applies to arguments \code{command} and \code{skip}.}

\item{packages}{Character vector of packages to load right before
the target builds. Use \code{tar_option_set()} to set packages
globally for all subsequent targets you define.}

\item{library}{Character vector of library paths to try
when loading \code{packages}.}

\item{format}{Optional storage format for the target's return value.
With the exception of \code{format = "file"}, each target
gets a file in \verb{_targets/objects}, and each format is a different
way to save and load this file.
Possible formats:
\itemize{
\item \code{"rds"}: Default, uses \code{saveRDS()} and \code{readRDS()}. Should work for
most objects, but slow.
\item \code{"qs"}: Uses \code{qs::qsave()} and \code{qs::qread()}. Should work for
most objects, much faster than \code{"rds"}. Optionally set the
preset for \code{qsave()} through the \code{resources} argument, e.g.
\code{tar_target(..., resources = list(preset = "archive"))}.
\item \code{"fst"}: Uses \code{fst::write_fst()} and \code{fst::read_fst()}.
Much faster than \code{"rds"}, but the value must be
a data frame. Optionally set the compression level for
\code{fst::write_fst()} through the \code{resources} argument, e.g.
\code{tar_target(..., resources = list(compress = 100))}.
\item \code{"fst_dt"}: Same as \code{"fst"}, but the value is a \code{data.table}.
Optionally set the compression level the same way as for \code{"fst"}.
\item \code{"fst_tbl"}: Same as \code{"fst"}, but the value is a \code{tibble}.
Optionally set the compression level the same way as for \code{"fst"}.
\item \code{"keras"}: Uses \code{keras::save_model_hdf5()} and
\code{keras::load_model_hdf5()}. The value must be a Keras model.
\item \code{"file"}: A dynamic file. To use this format,
the target needs to manually identify or save some data
and return a character vector of paths
to the data. Those paths must point to files or directories,
and they must not contain characters \code{|} or \code{*}.
Then, \code{targets} automatically checks those files and cues the
appropriate build decisions if those files are out of date.
\item \code{"url"}: A dynamic input URL. It works like \code{format = "file"}
except the return value of the target is a URL that already exists
and serves as input data for downstream targets. Optionally
supply a custom \code{curl} handle through the \code{resources} argument, e.g.
\code{tar_target(..., resources = list(handle = curl::new_handle()))}.
The data file at the URL needs to have an ETag or a Last-Modified
time stamp, or else the target will throw an error because
it cannot track the data. Also, use extreme caution when
trying to use \code{format = "url"} to track uploads. You must be absolutely
certain the ETag and Last-Modified time stamp are fully updated
and available by the time the target's command finishes running.
\code{targets} makes no attempt to wait for the web server.
}}

\item{iteration}{Character of length 1, name of the iteration mode
of the target. Choices:
\itemize{
\item \code{"vector"}: branching happens with \code{vectors::vec_slice()} and
aggregation happens with \code{vctrs::vec_c()}.
\item \code{"list"}, branching happens with \verb{[[]]} and aggregation happens with
\code{list()}.
\item \code{"group"}: \code{dplyr::group_by()}-like functionality to branch over
subsets of a data frame. The target's return value must be a data
frame with a special \code{tar_group} column of consecutive integers
from 1 through the number of groups. Each integer designates a group,
and a branch is created for each collection of rows in a group.
See the \code{\link[targets:tar_group]{tar_group()}} function to see how you can
create the special \code{tar_group} column with \code{dplyr::group_by()}.
}}

\item{error}{Character of length 1, what to do if the target
runs into an error. If \code{"stop"}, the whole pipeline stops
and throws an error. If \code{"continue"}, the error is recorded,
but the pipeline keeps going.}

\item{memory}{Character of length 1, memory strategy.
If \code{"persistent"}, the target stays in memory
until the end of the pipeline.
If \code{"transient"}, the target gets unloaded
after every new target completes.
Either way, the target gets automatically loaded into memory
whenever another target needs the value.}

\item{deployment}{Character of length 1, only relevant to
\code{\link[targets:tar_make_clustermq]{tar_make_clustermq()}} and \code{\link[targets:tar_make_future]{tar_make_future()}}. If \code{"remote"},
the target builds on a remote parallel worker. If \code{"local"},
the target builds on the host machine / process managing the pipeline.}

\item{priority}{Numeric of length 1 between 0 and 1. Controls which
targets get deployed first when multiple competing targets are ready
simultaneously. Targets with priorities closer to 1 get built earlier.}

\item{resources}{A named list of computing resources. Uses:
\itemize{
\item Template file wildcards for \code{future::future()} in \code{\link[targets:tar_make_future]{tar_make_future()}}.
\item Template file wildcards \code{clustermq::workers()} in \code{\link[targets:tar_make_clustermq]{tar_make_clustermq()}}.
\item Custom \code{curl} handle if \code{format = "url"},
e.g. \code{resources = list(handle = curl::new_handle())}.
\item Custom preset for \code{qs::qsave()} if \code{format = "qs"}, e.g.
\code{resources = list(handle = "archive")}.
\item Custom compression level for \code{fst::write_fst()} if
\code{format} is \code{"fst"}, \code{"fst_dt"}, or \code{"fst_tbl"}, e.g.
\code{resources = list(compress = 100)}.
}}

\item{storage}{Character of length 1, only relevant to
\code{\link[targets:tar_make_clustermq]{tar_make_clustermq()}} and \code{\link[targets:tar_make_future]{tar_make_future()}}.
If \code{"local"}, the target's return value is sent back to the
host machine and saved locally. If \code{"remote"}, the remote worker
saves the value.}

\item{retrieval}{Character of length 1, only relevant to
\code{\link[targets:tar_make_clustermq]{tar_make_clustermq()}} and \code{\link[targets:tar_make_future]{tar_make_future()}}.
If \code{"local"}, the target's dependencies are loaded on the host machine
and sent to the remote worker before the target builds.
If \code{"remote"}, the remote worker loads the targets dependencies.}

\item{cue}{An optional object from \code{tar_cue()} to customize the
rules that decide whether the target is up to date.}
}
\value{
A target with \code{targets::tar_cancel(your_condition)} inserted
into the command.
}
\description{
Create a target that cancels itself if a user-defined
decision rule is met.
}
\details{
\code{tar_skip()} creates a target that cancels itself
whenever a custom condition is met. The mechanism of cancellation
is \code{targets::tar_cancel(your_condition)}, which allows skipping to happen
even if the target does not exist yet. This behavior differs from
\code{tar_cue(mode = "never")}, which still runs if the target does not exist.
}
\examples{
\dontrun{
# Without loss of generality,
# tar_skip(your_target, command = run_stuff(), skip = should_skip())
# is equivalent to:
# tar_target(your_target, {
#   tar_cancel(should_skip())
#   run_stuff()
# })
# Try it out.
targets::tar_dir({
targets::tar_script({
  tar_pipeline(
    tarchetypes::tar_skip(x, command = "value", skip = 1 > 0)
  )
})
targets::tar_make()
})
}
}
