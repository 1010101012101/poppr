#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#
# This software was authored by Zhian N. Kamvar and Javier F. Tabima, graduate 
# students at Oregon State University; and Dr. Nik Grünwald, an employee of 
# USDA-ARS.
#
# Permission to use, copy, modify, and distribute this software and its
# documentation for educational, research and non-profit purposes, without fee, 
# and without a written agreement is hereby granted, provided that the statement
# above is incorporated into the material, giving appropriate attribution to the
# authors.
#
# Permission to incorporate this software into commercial products may be
# obtained by contacting USDA ARS and OREGON STATE UNIVERSITY Office for 
# Commercialization and Corporate Development.
#
# The software program and documentation are supplied "as is", without any
# accompanying services from the USDA or the University. USDA ARS or the 
# University do not warrant that the operation of the program will be 
# uninterrupted or error-free. The end-user understands that the program was 
# developed for research purposes and is advised not to rely exclusively on the 
# program for any reason.
#
# IN NO EVENT SHALL USDA ARS OR OREGON STATE UNIVERSITY BE LIABLE TO ANY PARTY 
# FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
# LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, 
# EVEN IF THE OREGON STATE UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF 
# SUCH DAMAGE. USDA ARS OR OREGON STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY 
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE AND ANY STATUTORY 
# WARRANTY OF NON-INFRINGEMENT. THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS"
# BASIS, AND USDA ARS AND OREGON STATE UNIVERSITY HAVE NO OBLIGATIONS TO PROVIDE
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS. 
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#==============================================================================#

#==============================================================================#
#' Genclone class
#' 
#' Genclone is an S4 class that extends the \code{\linkS4class{genind}}
#' from the \emph{\link{adegenet}} package. It will have all of the same
#' attributes as the \code{\linkS4class{genind}}, but it will contain two
#' extra slots that will help retain information about population hierarchies
#' and multilocus genotypes.
#' 
#' @section Extends: 
#' Class \code{"\linkS4class{genind}"}, directly.
#' 
#' @details The genclone class will allow for more optimized methods of clone
#' correcting and analyzing data over multiple levels of population hierarchy.
#' 
#' Previously, for hierarchical analysis to work in a \code{\link{genind}}
#' object, the user had to place a data frame in the \code{\link{other}} slot of
#' the object. The suggested name of the data frame was 
#' \code{population_hierarchy}, and this was used to be able to store the
#' hierarchical information inside the object so that the user did not have to
#' keep track of that information. This method worked, but it became apparent
#' that this method of doing things became a bit confusing to the user as the
#' method for changing the population of an object became:
#' 
#' \code{pop(object) <- other(object)$population_hierarchy$population_name}
#' 
#' That is a lot to keep track of. The new hierarchy slot will allow the user
#' to be able to insert a population hierarchy into the slot and then change it
#' with one function and a formula:
#' 
#' \code{sethierarchy(object, ~Population/Subpopulation)}
#' 
#' making this become slightly more intuitive and tractable.
#' 
#' Calculations of multilocus genotypes is rapid, but unfortunately, the
#' assignments can change if the number of individuals in the population is
#' different. This means that if you analyze the multilocus genotypes for two
#' subpopulations, they will have different multilocus genotype assignments even
#' though they may share multilocus genotypes. The new slot allows us to be able
#' to assign the multilocus genotypes and retain that information no matter how 
#' we subset the data set.
#' 
#' @name genclone-class
#' @rdname genclone-class
#' @export
#' @slot mlg a vector representing multilocus genotypes for the data set.
#' @slot hierarchy a data frame containing hierarchical levels.
#' @author Zhian N. Kamvar
#' @import methods
#==============================================================================#
setClass("genclone", 
         contains = "genind",
         representation = representation(mlg = "numeric", 
                                         hierarchy = "data.frame"),
)

valid.genclone <- function(object){
  inds    <- length(object@ind.names)
  mlgs    <- length(object@ind.names)
  hier    <- length(object@hierarchy)
  hierobs <- nrow(object@hierarchy)
  if (mlgs != inds){  
    cat("Multilocus genotypes do not match the number of observations")
    return(FALSE)
  }
  if (hier > 0 & hierobs != inds){
    cat("Hierarchy does not match the number of observations")
    return(FALSE)
  }
  return(TRUE)
}

setValidity("genclone", valid.genclone)
#==============================================================================#
#' bruvomat object
#' 
#' An internal object used for bruvo's distance. 
#' Not intended for user interaction.
#' 
#' 
#' @name bruvomat-class
#' @rdname bruvomat-class
#' @export
#' @slot mat a matrix of genotypes with one allele per locus. Number of rows will
#' be equal to (ploidy)*(number of loci)
#' @slot replen repeat length of microsatellite loci
#' @slot ploidy the ploidy of the data set
#' @slot ind.names names of individuals in matrix rows.
#' @author Zhian Kamvar
#' @import methods
#==============================================================================#
setClass(
  Class = "bruvomat", 
  representation = representation(
    mat = "matrix", 
    replen = "numeric",
    ploidy = "numeric",
    ind.names = "character"
  ),
  prototype = prototype(
    mat = matrix(ncol = 0, nrow = 0),
    replen = 0,
    ploidy = 2,
    ind.names = "none"
  )
)

#==============================================================================#
#' Bootgen object
#' 
#' An internal object used for bootstrapping. Not intended for user interaction.
#' 
#' @section Extends: 
#' Class \code{"\linkS4class{genind}"}, directly.
#' 
#' @name bootgen-class
#' @rdname bootgen-class
#' @export
#' @slot replen repeat length of microsatellite loci
#' @author Zhian Kamvar
#' @import methods
#==============================================================================#
setClass("bootgen", 
         contains = c("genind"),
         representation = representation(replen = "numeric"),
)