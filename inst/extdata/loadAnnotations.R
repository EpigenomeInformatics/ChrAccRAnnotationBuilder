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
