# copy a file and replace variable names (`${VAR_NAME}`)
file_copy_replace <- function(src, dest, replacements=NULL){
	if (length(replacements) < 1){
		file.copy(src, dest)
	} else {
		lls <- readLines(src)
		for (i in seq_along(replacements)){
			lls <- gsub(paste0("`${",names(replacements)[i],"}`"), replacements[i], lls, fixed=TRUE)
		}
		writeLines(lls, dest)
	}
}
