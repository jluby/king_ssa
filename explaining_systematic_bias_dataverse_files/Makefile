### Makefile to compile main document (and to knit / compile application document)

all: color grayscale clean

color: knit_color
	pdflatex analysis.tex
	pdflatex analysis.tex

knit_color: analysis.Rnw
	echo 'library(knitr); knit("analysis.Rnw")'|R --slave
	
grayscale: knit_grayscale
	pdflatex analysis_grayscale.tex
	pdflatex analysis_grayscale.tex

knit_grayscale: analysis.Rnw
	echo 'library(knitr); knit("analysis_grayscale.Rnw")'|R --slave

clean:
	rm -rf *.aux *.log *.out *.gz *.brf *.bbl *.blg *.toc