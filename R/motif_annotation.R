computeWindowKmerFreqM <- function(gr, genomeObj, flank=250L, k=6){
	windowGr <- unique(trim(resize(gr, width=2*flank+1, fix="center", ignore.strand=TRUE)))
	ww <- width(windowGr)
	wm <- as.integer(median(ww))
	idx <- ww==wm
	if (!all(idx)){
		logger.warning(c("Not all elements in GRanges have the same width. --> discarding", sum(!idx), "of", length(idx), "motif windows that do not."))
		windowGr <- windowGr[idx]
	}
	kmerFreqM <- do.call("cbind", lapply(0:(wm-1), FUN=function(i){
		if (i%%50 == 0) logger.status(paste0("i=",i))
		wGr <- trim(resize(GenomicRanges::shift(windowGr, i-ceiling(k/2)), width=k, fix="start", ignore.strand=TRUE))
		rr <- Biostrings::oligonucleotideFrequency(Biostrings::Views(genomeObj, wGr), width=k, simplify.as="collapsed")
		return(rr)
	}))
	return(kmerFreqM)
}

annotateMotifs <- function(genomeParams, dataDir, cmdrObj=NULL){
	motifAnnoL <- lapply(genomeParams[["tfMotifs"]], FUN=function(x){
		logger.start(c("Preparing motif annotation for motif set", x[["motifs"]]))
			res <- list(
				motifs=NULL,
				motifOccGrl=NULL,
				motifWindowKmerFreq=NULL
			)
			if (is.element(x[["parseFun"]], c("prepareMotifmatchr", "prepareTfClusters_altius"))){
				if (x[["parseFun"]] == "prepareMotifmatchr"){
					logger.status("Preparing motif occurrences ...")
					mmObj <- ChrAccR::prepareMotifmatchr(genomeParams[["genome"]], x[["motifs"]])
					go <- mmObj[["genome"]]
					motifGrl <- ChrAccR::getMotifOccurrences(motifNames=NULL, motifDb=x[["motifs"]], genome=genomeParams[["genome"]])
				} else if (x[["parseFun"]] == "prepareTfClusters_altius"){
					mobj <- readRDS(x[["rdsFn"]])
					if (class(mobj) != "TfMotifClusters") logger.error("Invalid TfMotifClusters object")
					motifGrl <- mobj$clusterOcc
					mobj$clusterOcc <- NULL
					mmObj <- mobj
					go <- getGenomeObject(genomeParams[["genome"]])
				}
				
				
				logger.status("Preparing motif window k-mer frequencies ...")
				motifNames <- names(motifGrl)
				if (is.null(cmdrObj)){
					kmerFreqML <- lapply(motifNames, FUN=function(mn){
						logger.start(c("Motif:", mn))
							kmerFreqM <- computeWindowKmerFreqM(motifGrl[[mn]], go)
						logger.completed()
						return(kmerFreqM)
					})
				} else {
					logger.start("Parallel computation")
						envList <- list(
							computeWindowKmerFreqM=computeWindowKmerFreqM,
							motifGrl=motifGrl,
							genomeObj=go
						)
						f <- function(x){computeWindowKmerFreqM(motifGrl[[x]], genomeObj)}
						kmerFreqML <- lapplyExec(
							cmdrObj,
							lapply(seq_along(motifGrl), identity),
							f,
							env=envList,
							Rexec="Rscript",
							name=paste0("kmers_", x[["motifs"]])
						)
					logger.completed()
				}
				names(kmerFreqML) <- motifNames

				res[["motifs"]] <- mmObj[["motifs"]]
				res[["motifOccGrl"]] <- motifGrl
				res[["motifWindowKmerFreq"]] <- kmerFreqML
			} else {
				logger.error(c("Unknown parsing function:", x[["parseFun"]]))
			}
		logger.completed()
		return(res)
	})
	names(motifAnnoL) <- names(genomeParams[["tfMotifs"]])

	logger.start("Saving")
		for (anno in names(motifAnnoL)){
			for (type in c("motifs", "motifOccGrl", "motifWindowKmerFreq")){
				rdsFn <- file.path(dataDir, paste0("motif_annotation_", anno, "_", type, ".rds"))
				saveRDS(motifAnnoL[[anno]][[type]], rdsFn)
			}
		}
	logger.completed()
}
