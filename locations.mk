# the locations of files that are targets of the Makefile rules

# on web server
WEB		= /anfs/www/VH-tex/faq-source
WEB_BETA	= /anfs/www/VH-tex/faq-source/beta
CGI_BIN		= /anfs/www/VH-tex/cgi-bin

# on archive machine
HOME_DIR	= /home/rf/tex/faq
CTAN_ROOT	= /anfs/ctan/tex-archive

# on vlan 100 host
HTMLDIREL	= html
HTMLDIR		= $(HOME_DIR)/$(HTMLDIREL)

HTMLDIR_GAMMA	= $(HOME_DIR)/html_gamma
GAMMADIR	= $(HOME_DIR)/gamma
