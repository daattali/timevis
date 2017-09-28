#!usr/bin/make -f
# All commands are run as R functions rather than shell commands so that it will work easily on any Windows machine, even if the Windows machine isn't properly set up with all the right tools

all: README.md

clean:
	Rscript -e 'suppressWarnings(file.remove("README.md", "vignettes/timevis.md"))'

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

README.md : vignettes/timevis.Rmd
#	echo "Rendering the timevis vignette"
	Rscript -e 'rmarkdown::render("vignettes/timevis.Rmd", output_format = "md_document", output_options = list(pandoc_args = c("-t", "commonmark")))'
#	echo "Correcting image paths"
#	sed -i -- 's,../inst,inst,g' vignettes/timevis.md
	Rscript -e 'file <- gsub("\\.\\./inst", "inst", readLines("vignettes/timevis.md")); writeLines(file, "vignettes/timevis.md")'
#	echo "Copying output to README.md"
#	cp vignettes/timevis.md README.md
	Rscript -e 'file.copy("vignettes/timevis.md", "README.md", overwrite = TRUE)'
	Rscript -e 'suppressWarnings(file.remove("vignettes/timevis.md"))'
