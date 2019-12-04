.genomeParams <- list(
	"Hg38"=list(
		genome = "hg38",
		geneAnno = list(
			"gencode" = list(
				"parseFun" = "getAnnotGrl.gencode",
				"version" = "gencode.v27"
			),
			"gencode_coding" = list(
				"parseFun" = "getAnnotGrl.gencode",
				"version" = "gencode.v27",
				"includedTypes" = c("protein_coding")
			)
		),
		promoterRange = c(up=1500, down=500),
		tfMotifs = list(
			"jaspar" = list(
				"parseFun" = "prepareMotifmatchr",
				"motifs" = "jaspar" 
			),
			"jaspar_vert" = list(
				"parseFun" = "prepareMotifmatchr",
				"motifs" = "jaspar_vert" 
			),
			"cisbp" = list(
				"parseFun" = "prepareMotifmatchr",
				"motifs" = "cisbp" 
			)
		),
		defaultNames = list(
			geneAnno = "gencode",
			tfMotifs = "jaspar"
		)
	),
	"Hg19"=list(
		genome = "hg19",
		geneAnno = list(
			"gencode" = list(
				"parseFun" = "getAnnotGrl.gencode",
				"version" = "gencode.v19"
			),
			"gencode_coding" = list(
				"parseFun" = "getAnnotGrl.gencode",
				"version" = "gencode.v19",
				"includedTypes" = c("protein_coding")
			)
		),
		promoterRange = c(up=1500, down=500),
		tfMotifs = list(
			"jaspar" = list(
				"parseFun" = "prepareMotifmatchr",
				"motifs" = "jaspar" 
			),
			"jaspar_vert" = list(
				"parseFun" = "prepareMotifmatchr",
				"motifs" = "jaspar_vert" 
			)
		),
		defaultNames = list(
			geneAnno = "gencode",
			tfMotifs = "jaspar"
		)
	),
	"Mm10"=list(
		genome = "mm10",
		geneAnno = list(
			"gencode" = list(
				"parseFun" = "getAnnotGrl.gencode",
				"version" = "gencode.vM16"
			),
			"gencode_coding" = list(
				"parseFun" = "getAnnotGrl.gencode",
				"version" = "gencode.vM16",
				"includedTypes" = c("protein_coding")
			)
		),
		promoterRange = c(up=1500, down=500),
		tfMotifs = list(
			"jaspar" = list(
				"parseFun" = "prepareMotifmatchr",
				"motifs" = "jaspar" 
			),
			"jaspar_vert" = list(
				"parseFun" = "prepareMotifmatchr",
				"motifs" = "jaspar_vert" 
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
