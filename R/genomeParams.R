.genomeParams <- list(
	"Hg38"=list(
		genome = "hg38",
		geneAnno = list(
			"gencode" = list(
				"parseFun" = "getAnnotGrl.gencode",
				"version" = "gencode.v27"
			)
		),
		promoterRange = c(up=1500, down=500),
		tfMotifs = list(
			"jaspar" = list(
				"parseFun" = ""
			)
		),
		defaultNames = list(
			geneAnno = "gencode",
			tfMotifs = "jaspar"
		)
	)
)

validateGenomeParams <- function(x){
	if (!is.list(x)) logger.error("Invalid genome parameters")
	missingSlots <- setdiff(c("genome", "geneAnno", "promoterRange", "tfMotifs", "defaultNames"), names(x))
	if (length(missingSlots) > 0){
		logger.error(c("Missing genome parameters:", paste(missingSlots, collapse=",")))
	}
	return(x)
}
