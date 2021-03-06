% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filterVariants.R
\name{filterVariants}
\alias{filterVariants}
\alias{filterBySegment}
\alias{filterByFile}
\alias{filterByChrom}
\alias{filterByPass}
\alias{filterBySNV}
\alias{filterByMAF}
\alias{filterByMAC}
\alias{filterByEffN}
\alias{filterByRare}
\alias{filterByPCAcorr}
\alias{checkSelectedVariants}
\title{Filter SeqVarGDSClass objects}
\usage{
filterBySegment(gds, segment, segment.file, pad.right = 0,
  verbose = TRUE)

filterByFile(gds, idfile, verbose = TRUE)

filterByChrom(gds, chr, verbose = TRUE)

filterByPass(gds, verbose = TRUE)

filterBySNV(gds, biallelic = TRUE, verbose = TRUE)

filterByMAF(gds, sample.id = NULL, maf.min = 0, build = "hg19",
  verbose = TRUE)

filterByMAC(gds, sample.id = NULL, mac.min = 1, build = "hg19",
  verbose = TRUE)

filterByEffN(gds, sample.id = NULL, effN.min = 1, build = "hg19",
  verbose = TRUE)

filterByRare(gds, sample.id = NULL, af.max = 0.01, build = "hg19",
  verbose = TRUE)

filterByPCAcorr(gds, build = "hg19", verbose = TRUE)

checkSelectedVariants(gds)
}
\arguments{
\item{gds}{A \code{\link[SeqArray]{SeqVarGDSClass}} object}

\item{segment}{An integer indicating which segment to select}

\item{segment.file}{The name of the file describing segments (see \code{\link{writeSegmentFile}})}

\item{pad.right}{The number of bases to add to the right of the segment (useful for sliding windows)}

\item{verbose}{Logical for whether to print number of variants selected, etc.}

\item{idfile}{RData file with vector of variant.id}

\item{chr}{Chromosome to select}

\item{biallelic}{Logical for whether to select only biallelic SNVs}

\item{sample.id}{Samples to include in calculating allele frequency}

\item{maf.min}{Minimum MAF to include}

\item{build}{Genome build to use when identifying regions to exclude from PCA because of high correlation (HLA, LCT, inversions)}

\item{mac.min}{Minimum minor allele count to include}

\item{effN.min}{Minimum effective N, calculated as 2 * MAF * (1-MAF) * n.obs}

\item{af.max}{Maximum alternate allele frequency to include}
}
\description{
Set variant filters on SeqVarGDSClass objects
}
\details{
These functions make it easy to apply various types of filters commonly used in association test code.
Most functions will not override previous filters, so they can be used in succession to apply multiple filters.
The one exception is \code{filterBySegment}, which must always be applied first.
}
