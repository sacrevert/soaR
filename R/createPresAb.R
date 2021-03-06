#' Process climate data for use in modelling species' distributions
#'
#' Create environmental layers in ascii for a specified region and spatial resolution
#'
#' @param res Numeric. Spatial resolution in decimal degrees (defaults to 0.5)
#' @param inPath String. Path to species data extracted using extract_records.
#' @param taxon String. Taxonomic group. Must match one of the groups in inPath.
#' @param species String. Focal species' name (must be in chosen taxonomic group)
#' @param matchPres Logical. If true, will produce absences such that there are an equal number to presences. Defaults to false
#' @param nAbs Numeric. Number of pseudo absences to produce. Note that this is overriden if matchPres = TRUE.
#' @param minYear Numeric.
#' @param maxYear Numeric.
#' @param maxYear Numeric. Threshold number of records below which species' are dropped.
#' @export
#' @examples
#'

createPresAb <- function(inPath, taxon, species, minYear, maxYear, nAbs, matchPres = FALSE, recThresh) {

  load(paste0(inPath, taxon, "_raw_data.rdata"))

  dat <-dat[dat$year >= minYear & dat$year <= maxYear,]

  pres <- dat[dat$species == species, c("lon", "lat")]

  if (nrow(pres) < recThresh) {

    warning("Number of records does not exceed recThresh")

    out <- NULL

  } else {

  ab <- dat[dat$species != species, c("lon", "lat")]

  "%!in%" <- Negate("%in%")

  ab <- ab[ab %!in% pres]

  if (nrow(ab) < nrow(pres)) {

    warning("More presences than possible locations for absences. Consider lowering the number of pseudo absences.")

  }

  sampInd <- sample(1:nrow(ab), nAbs)

  if (matchPres == TRUE) {

    sampInd <- sampInd[1:nrow(pres)]

  }

  ab <- ab[sampInd, ]

  out <- list(pres, ab)

  names(out) <- c("Presence","pseudoAbsence")

  }

  return(out)

}
