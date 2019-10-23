# create R directory structure
createPackageScaffold <- function(annoName, dest, genomeParams){
	pkgName <- paste0("ChrAccRAnnotation", annoName)
	pkgDir <- file.path(dest, pkgName)
	if (dir.exists(pkgDir)) logger.error(c("Could not create package in", pkgDir, "make sure that the directory does not exist"))
	
	# create directory structure
	dir.create(pkgDir)
	dir.create(file.path(pkgDir, "R"))
	dir.create(file.path(pkgDir, "data"))
	dir.create(file.path(pkgDir, "inst"))
	dir.create(file.path(pkgDir, "inst", "extdata"))

	desc <- c(
		paste("Package:", pkgName),
		paste("Title: ChrAccR annotation -", annoName),
		paste("Description: Annotation data for ChrAccR -", annoName),
		"Author: ChrAccRAnnotationBuilder",
		paste("Date:", format(Sys.time(), "%Y-%m-%d")),
		"Suggests:",
		"    motifmatchr,",
		"    chromVARmotifs,",
		"    Biostrings,",
		"    matrixStats,",
		"    TFBSTools",
		"Imports:",
		"    S4Vectors,",
		"    IRanges,",
		"    GenomeInfoDb,",
		"    GenomicRanges,",
		"    ChrAccR",
		"Version: 0.0.1",
		"Encoding: UTF-8"
	)
	writeLines(desc, file.path(pkgDir, "DESCRIPTION"))

	# copy source code files
	file_copy_replace(
		system.file("extdata", "loadAnnotations.R", package="ChrAccRAnnotationBuilder"),
		file.path(pkgDir, "inst", "extdata", "loadAnnotations.R"),
		replacements=c(
			PKG_NAME = pkgName,
			DEFAULT_GENE_ANNO = genomeParams[["defaultNames"]][["geneAnno"]]
		)
	)

	return(pkgDir)
}

createPackage <- function(annoName, outDir="."){
	if (!is.element(annoName, names(.genomeParams))){
		logger.error(c("Could not build package because no parameter settings are specified for genome", genome))
	}
	pps <- validateGenomeParams(.genomeParams[[annoName]])
	print(pps)
	pkgDir <- createPackageScaffold(annoName, outDir, pps)
	dataDir <- file.path(pkgDir, "inst", "extdata")

	if (is.element("geneAnno", names(pps))){
		logger.start("Preparing gene annotations")
			annotateGenes(pps, dataDir)
		logger.completed()
	} else {
		logger.error("Missing information in how to create gene annotation")
	}	

	logger.info(c("Created annotation package for genome", genome, "@", pkgDir))
	return(pkgDir)
}
