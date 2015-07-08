# define variables WEB, WEB_BETA, CGI_BIN, HOME_DIR, CTAN_HOME, CTAN_ROOT
include locations.mk

# list of subdocuments of gather-faqbody
include subdocuments.mk

BODY	= gather-faqbody.tex filectan.tex dirctan.tex $(SUBDOCS)
MACROS	= faq.cls faq.sty
CONFIGS	= archive.cfg
CMFONTS	= cmz
PATCH   = newfaq-patch.tex add-general.tex add-hammond.tex
MAKEF	= Makefile

HTML_TAR = FAQ-html.tar.gz

LATEX	= latex
PDFLATEX = pdflatex

CTAN_HOME = help/uk-tex-faq

#h
#hThe main targets of this Makefile are
#h	release		build a distribution
#h
#h	patch		build latest patched version
#h
#h	ctan		install distribution on CTAN
#h			(to be run on the CTAN machine)
#h	web		install files required for web access
#h			(must be run on the machine that hosts
#h			the CGI script)
#h	web-index	web access files, just (dir|file)ctan
#h	web-beta	as web, except beta distribution
#h
#h	inst-perl	install texfaq2html and sanitize.pl
#h			in the cgi-bin directory
#h	inst-perl-beta	ditto, for texfaq2html-beta, sanitize-beta
#h	inst-perl-gamma	ditto, for texfaq2html-gamma
#h
#h	html		make html files in html/
#h	html-gamma	make html files in html, copy for -gamma tests

help:;	@sed -n 's/^#h//p' < $(MAKEF)

release: all html-tar
all:	newfaq.pdf letterfaq.pdf

# did have faqfont.cfg in here, but that caused problems, since it
# typically doesn't exist...

# pdf generation has to be done one a different base file name because
# of incompatibilities in the .aux and .toc files
newfaq.pdf: newfaq.tex $(BODY) $(MACROS) $(CONFIGS)
	ln -sf newfaq.tex ./pdf-newfaq.tex
	rm -f faqfont.cfg
	while ( \
	  $(PDFLATEX) \\def\\Status{1} \\input pdf-newfaq ; \
	  grep "Rerun to get cross" pdf-newfaq.log > /dev/null ) do true ; \
        done
	thumbpdf pdf-newfaq
	$(PDFLATEX) \\def\\Status{1} \\input pdf-newfaq
	mv pdf-newfaq.pdf newfaq.pdf
	rm pdf-newfaq.tex

letterfaq.pdf: letterfaq.tex $(BODY) $(MACROS) $(CONFIGS)
	ln -sf letterfaq.tex ./pdf-letterfaq.tex
	rm -f faqfont.cfg
	while ( \
	  $(PDFLATEX) \\def\\Status{1} \\input pdf-letterfaq ; \
	  grep "Rerun to get cross" pdf-letterfaq.log > /dev/null ) do true ; \
        done
	thumbpdf pdf-letterfaq
	$(PDFLATEX) \\def\\Status{1} \\input pdf-letterfaq
	mv pdf-letterfaq.pdf letterfaq.pdf
	rm pdf-letterfaq.tex

patch:	newfaq-patch

newfaq-patch: newfaq-patch.pdf newfaq-patch.ps

patch.pdf: newfaq-patch.pdf

newfaq-patch.pdf: $(PATCH) $(BODY) $(MACROS) $(CONFIGS)
	./find-add-files
	ln -sf newfaq-patch.tex ./pdf-newfaq-patch.tex
	rm -f faqfont.cfg
	while ( \
	  $(PDFLATEX) \\def\\Status{1} \\input pdf-newfaq-patch ; \
	  grep "Rerun to get cross" pdf-newfaq-patch.log > /dev/null ) do true ; \
        done
	thumbpdf pdf-newfaq-patch
	$(PDFLATEX) \\def\\Status{1} \\input pdf-newfaq-patch
	mv pdf-newfaq-patch.pdf newfaq-patch.pdf
	ln -sf newfaq-patch.pdf patch.pdf
	rm pdf-newfaq-patch.tex

patch.dvi: newfaq-patch.dvi

newfaq-patch.dvi: $(PATCH) $(BODY) $(MACROS) $(CONFIGS)
	./find-add-files
	while ( \
	  $(LATEX) newfaq-patch ; \
	  grep "Rerun to get cross" newfaq-patch.log > /dev/null ) do true ; \
        done
	ln -sf newfaq-patch.dvi patch.dvi

newfaq.aux: newfaq.dvi

newfaq.dvi: newfaq.tex $(BODY) $(MACROS) $(CONFIGS)
	echo $(LATEX)
	while ( \
	  $(LATEX) newfaq ; \
	  grep "Rerun to get cross" newfaq.log > /dev/null ) do true ; \
        done

letterfaq.dvi: letterfaq.tex $(BODY) $(MACROS) $(CONFIGS)
	while ( \
	  $(LATEX) letterfaq ; \
	  grep "Rerun to get cross" letterfaq.log > /dev/null ) do true ; \
        done

newfaq-cm.dvi: newfaq.tex $(BODY) $(MACROS) $(CONFIGS)
	ln -sf faqfont.cfg.cmfonts faqfont.cfg
	ln -sf newfaq.tex newfaq-cm.tex
	while ( \
	  $(LATEX) newfaq-cm ; \
	  grep "Rerun to get cross" newfaq-cm.log > /dev/null ) do true ; \
        done
	rm faqfont.cfg newfaq-cm.tex

letterfaq-cm.dvi: letterfaq.tex $(BODY) $(MACROS) $(CONFIGS)
	ln -sf faqfont.cfg.cmfonts faqfont.cfg
	ln -sf letterfaq.tex letterfaq-cm.tex
	while ( \
	  $(LATEX) letterfaq-cm ; \
	  grep "Rerun to get cross" letterfaq-cm.log > /dev/null ) do true ; \
        done
	rm faqfont.cfg letterfaq-cm.tex

$(HTML_TAR):
	tar czvf $(HTML_TAR) html/*

ctan:	$(HTML_TAR)
	(cd $(CTAN_ROOT)/$(CTAN_HOME); \
	 really -u ctan make -f /home/rf/tex/faq/Makefile.CTAN)

# faqbody for all the webbery stuff
faqbody.tex:	$(SUBDOCS) gather-faqbody.tex
	./build-faqbody

web: $(WEB)/dirctan.tex $(WEB)/filectan.tex $(WEB)/faqbody.tex $(WEB)/newfaq.aux $(WEB)/archive.list

web-index: $(WEB)/dirctan.tex $(WEB)/filectan.tex

$(WEB)/dirctan.tex: dirctan.tex
$(WEB)/filectan.tex: filectan.tex
$(WEB)/faqbody.tex: faqbody.tex
$(WEB)/newfaq.aux: newfaq.aux
$(WEB)/archive.list: archive.list
$(WEB)/aliasquestion.list: aliasquestion.list
$(WEB)/label-to-file.pl: label-to-file.pl

$(WEB)/dirctan.tex $(WEB)/filectan.tex $(WEB)/faqbody.tex $(WEB)/newfaq.aux $(WEB)/archive.list $(WEB)/aliasquestion.list $(WEB)/label-to-file.pl:
	if [ -f $@ ]; then	\
	  chmod 644 $@; 	\
	  cp -p $< $@-t;	\
	  mv $@-t $@;		\
	else			\
	  cp -p $< $@;		\
	fi
	chmod 444 $@

web-beta: $(WEB_BETA)/dirctan.tex $(WEB_BETA)/filectan.tex $(WEB_BETA)/faqbody.tex $(WEB_BETA)/newfaq.aux $(WEB_BETA)/archive.list $(WEB_BETA)/aliasquestion.list $(WEB_BETA)/label-to-file.pl

$(WEB_BETA)/dirctan.tex: dirctan.tex
$(WEB_BETA)/filectan.tex: filectan.tex
$(WEB_BETA)/faqbody.tex: faqbody.tex
$(WEB_BETA)/newfaq.aux: newfaq.aux
$(WEB_BETA)/archive.list: archive.list
$(WEB_BETA)/aliasquestion.list: aliasquestion.list
$(WEB_BETA)/label-to-file.pl: label-to-file.pl

$(WEB_BETA)/dirctan.tex $(WEB_BETA)/filectan.tex $(WEB_BETA)/faqbody.tex $(WEB_BETA)/newfaq.aux $(WEB_BETA)/archive.list $(WEB_BETA)/aliasquestion.list $(WEB_BETA)/label-to-file.pl:
	if [ -f $@ ]; then	\
	  chmod 644 $@;		\
	  cp -p $< $@-t;	\
	  mv $@-t $@;		\
	else			\
	  cp -p $< $@;		\
	fi
	chmod 444 $@

inst-perl: $(CGI_BIN)/texfaq2html $(CGI_BIN)/sanitize.pl
inst-perl-beta: $(CGI_BIN)/texfaq2html-beta $(CGI_BIN)/sanitize-beta.pl
inst-perl-gamma: $(CGI_BIN)/texfaq2html-gamma

$(CGI_BIN)/texfaq2html: $(HOME_DIR)/texfaq2html
$(CGI_BIN)/texfaq2html-beta: $(HOME_DIR)/texfaq2html-beta
$(CGI_BIN)/texfaq2html-gamma: $(HOME_DIR)/texfaq2html-gamma
$(CGI_BIN)/sanitize.pl: $(HOME_DIR)/sanitize.pl
$(CGI_BIN)/sanitize-beta.pl: $(HOME_DIR)/sanitize-beta.pl

$(CGI_BIN)/texfaq2html $(CGI_BIN)/texfaq2html-beta $(CGI_BIN)/texfaq2html-gamma $(CGI_BIN)/sanitize.pl $(CGI_BIN)/sanitize-beta.pl:
#	co -l $@
	cp -p $? $@
#	ci -u -m"automatic check-in" $@

html:	$(HTMLDIR)/index.html

$(HTMLDIR)/index.html: $(BODY) newfaq.aux faqbody.tex
	./texfaq2file

html-tar: html
	tar czf FAQ-html.tar.gz $(HTMLDIREL)/

html-gamma:	$(HTMLDIR_GAMMA)/index.html

$(HTMLDIR_GAMMA)/index.html: $(BODY) newfaq.aux faqbody.tex
	./texfaq2file -2 -w
	cp -p $(HTMLDIR_GAMMA)/* $(GAMMADIR)/

clean:
	rm -f *.pdf *.dvi *.log *.bak *.toc *.out *.lab *.tpt *.png
	rm -f *.aux html/*.html html_gamma/*.html htmltext/*.txt
	rm -f pdf-newfaq*.tex comment.cut additions.tex aliasquestion.list
	rm -f faqbody.tex FAQ-html.tar.gz
