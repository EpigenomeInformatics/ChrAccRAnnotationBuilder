annotateGenes <- function(genomeParams, dataDir){
	geneAnnoL <- lapply(genomeParams[["geneAnno"]], FUN=function(x){
		res <- list(
			geneGr=NULL,
			promoterGr=NULL,
			tssGr=NULL
		)
		if (x[["parseFun"]] == "getAnnotGrl.gencode"){
			geneGr <- muRtools::getAnnotGrl.gencode(x[["version"]])[["gene"]]
			if (is.element("includedTypes", names(x))){
				# e.g. just include 'protein_coding'
				geneGr <- geneGr[elementMetadata(geneGr)[,"gene_type"] %in% x[["includedTypes"]]]
			}
			res[["geneGr"]] <- geneGr
			res[["tssGr"]]  <- promoters(geneGr, upstream=0, downstream=1)
			res[["promoterGr"]]  <- promoters(geneGr, upstream=genomeParams[["promoterRange"]][1], downstream=genomeParams[["promoterRange"]][2])
		} else {
			logger.error(c("Unknown parsing function:", x[["parseFun"]]))
		}
		return(res)
	})
	names(geneAnnoL) <- names(genomeParams[["geneAnno"]])

	for (anno in names(geneAnnoL)){
		for (type in c("geneGr", "tssGr", "promoterGr")){
			rdsFn <- file.path(dataDir, paste0("gene_annotation_", anno, "_", type, ".rds"))
			saveRDS(geneAnnoL[[anno]][[type]], rdsFn)
		}
	}
}
