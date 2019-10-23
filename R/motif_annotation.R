annotateMotifs <- function(genomeParams, dataDir){
	motifAnnoL <- lapply(genomeParams[["tfMotifs"]], FUN=function(x){
		res <- list(
			motifs=NULL,
			motifOccGrl=NULL
		)
		if (x[["parseFun"]] == "prepareMotifmatchr"){
			mmObj <- ChrAccR::prepareMotifmatchr(genomeParams[["genome"]], x[["motifs"]])
			res[["motifs"]] <- mmObj[["motifs"]]
			res[["motifOccGrl"]] <- ChrAccR::getMotifOccurrences(motifNames=NULL, motifDb=x[["motifs"]], genome=genomeParams[["genome"]])
		} else {
			logger.error(c("Unknown parsing function:", x[["parseFun"]]))
		}
		return(res)
	})
	names(motifAnnoL) <- names(genomeParams[["geneAnno"]])

	for (anno in names(motifAnnoL)){
		x <- motifAnnoL[[anno]]
		for (type in c("motifs", "motifOccGrl")){
			rdsFn <- file.path(dataDir, paste0("motif_annotation_", anno, ".rds"))
			saveRDS(motifAnnoL[[anno]][[type]], rdsFn)
		}
	}
}
