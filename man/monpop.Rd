% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/poppr.R
\docType{data}
\name{monpop}
\alias{monpop}
\title{Peach brown rot pathogen *Monilinia fructicola*}
\format{a [genclone-class] object with 3 hierarchical levels 
  coded into one population factor. These are named "Tree", "Year", and 
  "Symptom"}
\usage{
data(monpop)
}
\description{
This is microsatellite data for a population of the haploid 
  plant pathogen *Monilinia fructicola* that causes disease within peach
  tree canopies (Everhart & Scherm, 2014). Entire populations within trees
  were sampled across 3 years (2009, 2010, and 2011) in a total of four
  trees, where one tree was sampled in all three years, for a total of 6
  within-tree populations. Within each year, samples in the spring were taken
  from affected blossoms (termed "BB" for blossom blight) and in late summer
  from affected fruits (termed "FR" for fruit rot). There are a total of 694 
  isolates with 65 to 173 isolates within each canopy population that were 
  characterized using a set of 13 microsatellite markers.
}
\examples{
data(monpop)
splitStrata(monpop) <- ~Tree/Year/Symptom
setPop(monpop) <- ~Symptom/Year
monpop
}
\references{
SE Everhart, H Scherm, (2015) Fine-scale genetic structure of 
  *Monilinia fructicola* during brown rot epidemics within individual
  peach tree canopies. Phytopathology 105:542-549 doi:
  \href{https://doi.org/10.1094/PHYTO-03-14-0088-R}{10.1094/PHYTO-03-14-0088-R}
}
