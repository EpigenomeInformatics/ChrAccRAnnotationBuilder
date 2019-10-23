.PKG_NAME <- "`${PKG_NAME}`"

#' getGeneAnnotation
#' 
#' Load the gene annotation stored in this package
#' @param anno  annotation name
#' @param type  annotation type: valid options include \code{'geneGr', 'tssGr', 'promoterGr'}
#' @return \code{GRanges} object with gene annotation
#' @export 
getGeneAnnotation <- function(anno="`${DEFAULT_GENE_ANNO}`", type="geneGr"){
	res <- readRDS(system.file("extdata", paste0("gene_annotation_", anno, "_", type, ".rds"), package=.PKG_NAME))
	return(res)
}

#' getMotifAnnotation
#' 
#' Load the TF motif annotation stored in this package
#' @param anno  annotation name
#' @param type  annotation type: valid options include \code{'motifs', 'motifOccGrl'}
#' @return motif annotation. The return type depends on the \code{type} argument
#' @export 
getMotifAnnotation <- function(anno="`${DEFAULT_MOTIF_ANNO}`", type="motifs"){
	res <- readRDS(system.file("extdata", paste0("motif_annotation_", anno, "_", type, ".rds"), package=.PKG_NAME))
	return(res)
}
