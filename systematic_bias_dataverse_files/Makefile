### Makefile to compile main document (and to knit / compile application document)

all: paper appendix clean

paper: knit_paper
	pdflatex analysis.tex
	pdflatex analysis.tex

knit_paper: analysis.Rnw
	echo 'library(knitr); knit("analysis.Rnw")'|R --slave

appendix: knit_appendix
	pdflatex analysis_appendix.tex
	pdflatex analysis_appendix.tex

knit_appendix: analysis_appendix.Rnw
	echo 'library(knitr); knit("analysis_appendix.Rnw")'|R --slave

clean:
	rm -rf *.aux *.log *.out *.gz *.brf *.bbl *.blg *.toc

