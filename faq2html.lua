
function file_to_html (filename)

  for line in io.lines(filename) do


    line=string.gsub(line,"&","&amp;")

    if (not(quoteverbatim) and string.match(line,"\\begin{verbatim}")) then
      line=string.gsub(line,"\\begin{verbatim}","<pre>")
      verbatim=true
    end
    if (string.match(line,"\\begin{quoteverbatim}")) then
      line=string.gsub(line,"\\begin{quoteverbatim}","<pre>")
      quoteverbatim=true
    end

    if (verbatim or quoteverbatim) then
    
      if (verbatim and string.match(line,"\\end{verbatim}")) then
        line=string.gsub(line,"\\end{verbatim}","</pre>")
        verbatim=false
      end
      if (quoteverbatim and string.match(line,"\\end{quoteverbatim}")) then
        line=string.gsub(line,"\\end{quoteverbatim}","</pre>")
        quoteverbatim=false
      end


    else -- not verbatim

      if(string.match(line,"\\section{")) then
        section=faq_convert_line((string.gsub(line,".*\\section{(.*)} *$","%1")))
	secid=string.gsub(section,"[^%a]","")
        line=(introduction and "<h2>" .. section .. "</h2>") or ""
      end

      if(string.match(line,"\\subsection{")) then
        subsection=faq_convert_line((string.gsub(line,".*\\subsection{(.*)} *$","%1")))
	subsecid=string.gsub(subsection,"[^%a]","")
        line=(introduction and "<h3>" .. subsection .. "</h3>") or ""
      end

      if(string.match(line,"\\begin{introduction}")) then
        line=""
        introduction=true
  
        io.output("index.html")
        io.write("<!DOCTYPE html>\n<html>\n<head>\n")
        io.write("<meta charset=\"UTF-8\">\n")
        io.write("<title>UKTUG FAQ</title>\n")
        io.write("<link rel=\"stylesheet\" href=\"faq.css\">\n")
        io.write("</head>\n<body>\n")
      end


      if(string.match(line,"\\end{introduction}")) then
        line=""
        introduction=false
	faq_make_toc()
      end


      if(string.match(line,"\\Question%[")) then
        qid=string.gsub(line,".*\\Question%[([^%]]*)]{(.*)} *$","%1")
        qid=string.gsub(qid,"%*","star")
        qtitle=faq_convert_line((string.gsub(line,".*\\Question%[([^%]]*)]{(.*)} *$","%2")))
        line=""

--        print("XXX: " .. qid)
  
        io.output("FA" .. qid .. ".html")
        io.write("<!DOCTYPE html>\n<html>\n<head>\n")
        io.write("<meta charset=\"UTF-8\">\n")
        io.write("<title>" .. qid .. "</title>\n")
        io.write("<link rel=\"stylesheet\" href=\"faq.css\">\n")
        io.write("</head>\n<body>\n")
        io.write("<div class=\"breadcrumbs\">\n")
	io.write("<a href=\"index.html\">FAQ</a> &gt; ")
	io.write("<a href=\"index.html#" .. secid .."\">" .. section .. "</a> &gt; ")
	io.write("<a href=\"index.html#" .. subsecid .."\">" .. subsection .. "</a> &gt; ")
        io.write("</div>\n")
        io.write("<h1>" .. qtitle .. "</h1>\n\n")
      end

      line=faq_convert_line(line)
    end
    io.write(line .. "\n")
  end
end

function faq_convert_line (line)
    line=string.gsub(line,"^[ ]*$","\n<p>")

    line=string.gsub(line,"%-%-%-","&mdash;")
    line=string.gsub(line,"%-%-","&ndash;")
    line=string.gsub(line,"~","&nbsp;")
    line=string.gsub(line,"\\nobreakspace","&nbsp;")
    line=string.gsub(line,"\\textless","&lt;")
    line=string.gsub(line,"\\textgreater","&gt;")
    line=string.gsub(line,"\\%%","&#x25;;")
    line=string.gsub(line,"\\{","&#x7b;")
    line=string.gsub(line,"\\obracesymbol{}","&#x7b;")
    line=string.gsub(line,"\\}","&#x7d;")
    line=string.gsub(line,"\\cbracesymbol{}","&#x7d;")
    line=string.gsub(line,"\\%$","&#x24;")
    line=string.gsub(line,"\\ss{}","&szlig;")
    line=string.gsub(line,"\\ss ","&szlig;")
    line=string.gsub(line,"\\bsbs([^%a])","&#x5c;%1")
    line=string.gsub(line,"\\relax([^%a])","%1")
    line=string.gsub(line,"\\protect([^%a])","%1")
    line=string.gsub(line,"\\textemdash([^%a])","&mdash;%1")
    line=string.gsub(line,"\\textasciicircum([^%a])","^%1")
    line=string.gsub(line,"\\textbackslash([^%a])","&#x5c;%1")
    line=string.gsub(line,"\\arrowhyph[ ]*{}","&rarr;")


    line=string.gsub(line,"\\`([aoe])","&%1grave;")
    line=string.gsub(line,"\\'([aoe])","&%1acute;")
    line=string.gsub(line,"\\&amp;","&amp;")

    line=string.gsub(line,"``","&ldquo;")
    line=string.gsub(line,"''","&rdquo;")

    line=string.gsub(line,"`","&lsquo;")
    line=string.gsub(line,"'","&rsquo;")

    line=string.gsub(line,"%%.*","")

    line=string.gsub(line,"\\ctan{}","CTAN")

    line=string.gsub(line,"\\plaintex{}","Plain TeX")
    line=string.gsub(line,"\\Eplain}","Eplain}") -- hmmm
    line=string.gsub(line,"\\Eplain{}","Eplain")
    line=string.gsub(line,"\\PS{}","PostScript")
    line=string.gsub(line,"\\YandY{}","Y&amp;Y")
    line=string.gsub(line,"\\WYSIWYG{}","WYSIWYG")
    line=string.gsub(line,"\\eTeX{}","e-TeX") -- why both?
    line=string.gsub(line,"\\etex{}","e-TeX")
    line=string.gsub(line,"\\TeX{}","TeX")-- why both?
    line=string.gsub(line,"\\tex{}","TeX")
    line=string.gsub(line,"\\ExTeX{}","ExTeX")
    line=string.gsub(line,"\\Omega{}","Omega")
    line=string.gsub(line,"\\latex{}","LaTeX")
    line=string.gsub(line,"\\twee{}","2<sub>&epsilon;</sub>")
    line=string.gsub(line,"\\pictex{}","PicTeX")
    line=string.gsub(line,"\\LuaTeX{}","LuaTeX") -- why both?
    line=string.gsub(line,"\\luatex{}","LuaTeX")
    line=string.gsub(line,"\\xetex{}","XeTeX")
    line=string.gsub(line,"\\miktex{}","MiKTeX")
    line=string.gsub(line,"\\texlive{}","texlive")
    line=string.gsub(line,"\\PDFTeX{}","PDFTeX")-- why both?
    line=string.gsub(line,"\\pdftex{}","PDFTeX")
    line=string.gsub(line,"\\AMSLaTeX{}","AMSLaTeX")
    line=string.gsub(line,"\\AMSTeX{}","AMSTeX")
    line=string.gsub(line,"\\CONTeXT{}","CONTeXT")
    line=string.gsub(line,"\\context{}","Context")
    line=string.gsub(line,"\\PDFLaTeX{}","PDFLaTeX")-- why both?
    line=string.gsub(line,"\\pdflatex{}","PDFLaTeX")
    line=string.gsub(line,"\\BibTeX{}","BibTeX") -- why both?
    line=string.gsub(line,"\\bibtex{}","BibTeX")
    line=string.gsub(line,"\\MP{}","MetaPost")
    line=string.gsub(line,"\\MF{}","MetaFont")
    line=string.gsub(line,"\\AllTeX{}","(La)TeX")
    line=string.gsub(line,"\\alltex{}","(La)TeX")
    line=string.gsub(line,"\\LaTeX{}","LaTeX")
    line=string.gsub(line,"\\LaTeXo{}","LaTeX 2.09")
    line=string.gsub(line,"\\latexo{}","LaTeX 2.09")
    line=string.gsub(line,"\\LaTeXe{}","LaTeX 2e") -- why both?
    line=string.gsub(line,"\\latexe{}","LaTeX 2e")
    
    line=string.gsub(line,"\\TUGboat{}","TUGboat") -- make link?
    line=string.gsub(line,"\\BV{}","Baskerville") -- make link?
    line=string.gsub(line,"\\The[ ]*{}","Th&#x1ebf;")


    line=string.gsub(line,"\\dots{}","&hellip;")

    line=string.gsub(line,"\\MSDOS{}","MSDOS")
    line=string.gsub(line,"\\macosx{}","Mac OS/X")

    line=string.gsub(line,"\\Package[ ]*{([^{}]*)}","<i class=\"package\">%1</i>")
    line=string.gsub(line,"\\Class[ ]*{([^{}]*)}","<i class=\"class\">%1</i>")
    line=string.gsub(line,"\\ProgName[ ]*{([^{}]*)}","<i class=\"progname\">%1</i>")
    line=string.gsub(line,"\\FontName[ ]*{([^{}]*)}","<i class=\"fontname\">%1</i>")
    line=string.gsub(line,"\\File[ ]*{([^{}]*)}","<i class=\"filename\">%1</i>")
    line=string.gsub(line,"\\Newsgroup[ ]*{([^{}]*)}","<i class=\"newsgroup\">%1</i>")
    line=string.gsub(line,"\\extension[ ]*{([^{}]*)}","<code class=\"extension\">%1</code>")
    line=string.gsub(line,"\\pkgoption[ ]*{([^{}]*)}","<code class=\"pkgoption\">%1</code>")
    line=string.gsub(line,"\\environment[ ]*{([^{}]*)}","<code class=\"environment\">%1</code>")
    line=string.gsub(line,"\\meta[ ]*{([^{}]*)}","&lsaquo;<i>%1</i>&rsaquo;")
    line=string.gsub(line,"\\acro[ ]*{([^{}]*)}","%1")
    line=string.gsub(line,"\\ensuremath[ ]*{([^{}]*)}","%1")
    line=string.gsub(line,"\\cmdinvoke([%*]*)(%b{})(%b{})(%b{})","<code>&#x5c;QQQ%2ZZZ</code><code>&#x7b;QQQ%3ZZZ&#x7d;</code></code><code>&#x7b;QQQ%4ZZZ&#x7d;</code>")
    line=string.gsub(line,"\\cmdinvoke([%*]*)(%b{})(%b[])(%b{})","<code>&#x5c;QQQ%2ZZZ</code><code>%3</code></code><code>&#x7b;QQQ%4ZZZ&#x7d;</code>")
    line=string.gsub(line,"\\cmdinvoke([%*]*)(%b{})(%b{})","<code>&#x5c;QQQ%2ZZZ</code><code>&#x7b;QQQ%3ZZZ&#x7d;</code>")
    line=string.gsub(line,"\\csx[ ]*{([^{}]*)}","<code>&#x5c;%1</code>")
    line=string.gsub(line,"\\marg[ ]*(%b{})","&#x7b;QQQ%1ZZZ&#x7d;")
    line=string.gsub(line,"|p{%.%.%.}|","<code class=\"verb\">p&#x7b;...&#x7d;</code>")-- short verb allowed?
    line=string.gsub(line,"|([^ |]*)|","<code class=\"verb\">%1</code>")-- short verb allowed?
    line=string.gsub(line,"\\textsf[ ]*(%b{})","<span class=\"sans\">QQQ%1ZZZ</span>")
    line=string.gsub(line,"\\textsl[ ]*(%b{})","<i class=\"slanted\">QQQ%1ZZZ</i>")
    line=string.gsub(line,"\\texttt[ ]*(%b{})","<tt>QQQ%1ZZZ</tt>")
    line=string.gsub(line,"\\path[ ]*(%b{})","<tt class=\"path\">QQQ%1ZZZ</tt>")
    line=string.gsub(line,"\\emph[ ]*(%b{})","<em>QQQ%1ZZZ</em>")
    line=string.gsub(line,"\\textbf[ ]*(%b{})","<b>QQQ%1ZZZ</b>")
    line=string.gsub(line,"\\paragraph[ ]*(%b{})","<b>QQQ%1ZZZ</b> ")

    line=string.gsub(line,"\\ISBN%*(%b{})(%b{})","<span class=\"isbn\">ISBN-10 QQQ%1ZZZ</span>, <span class=\"isbn\">ISBN-13 QQQ%1ZZZ</span>")
    line=string.gsub(line,"\\ISBN(%b{})","<span class=\"isbn\">ISBN-10 QQQ%1ZZZ</span>")

    line=string.gsub(line,"\\\\","<br>")
    line=string.gsub(line,"\\,","&thinsp;")
    line=string.gsub(line,"\\ "," ")
    
    line=string.gsub(line,"\\htmlonly[ ]*{([^{}]*)}","%1")
    line=string.gsub(line,"\\nothtml%b{}","")
    line=string.gsub(line,"\\AliasQuestion%b{}","")
    line=string.gsub(line,"%-{}%-{}%-","")
    line=string.gsub(line,"\\latexhtml%b{}(%b{})","QQQ%1ZZZ") -- need to unquote &


    line=string.gsub(line,"\\CTANhref%{faq}%b{}","<a href=\"http://www.ctan.org/pkg/uk-tex-faq\">FAQ's CTAN directory</a>")
    line=string.gsub(line,"\\CTANhref%{faq%-a4%}%b{}","<a href=\"http://www.ctan.org/tex-archive/help/uk-tex-faq/newfaq.pdf\">A4 paper</a>")
    line=string.gsub(line,"\\CTANhref{faq%-letter}%b{}","<a href=\"http://www.ctan.org/tex-archive/help/uk-tex-faq/letterfaq.pdf\">North American &ldquo;letter&rdquo; paper</a>")
    line=string.gsub(line,"\\CTANhref{visualFAQ}%b{}","<a href=\"http://www.ctan.org/tex-archive/info/visualFAQ/visualFAQ.pdf\">Visual FAQ</a>")


    line=string.gsub(line,"\\URL[ ]*(%b{})","<a href=\"QQQ%1ZZZ.html\">QQQ%1ZZZ</a>")-- hmm
    line=string.gsub(line,"\\url[ ]*(%b{})","<a href=\"QQQ%1ZZZ.html\">QQQ%1ZZZ</a>")
    line=string.gsub(line,"\\href[ ]*(%b{})(%b{})","<a href=\"QQQ%1ZZZ.html\">QQQ%2ZZZ</a>")
    line=string.gsub(line,"\\Qref[*]?(%b[])(%b{})(%b{})","<a class=\"FAQQQ%1ZZZ.html\" href=\"FAQQQ%3ZZZ.html\">QQQ%2ZZZ</a>")
    line=string.gsub(line,"\\Qref[*]?(%b{})(%b{})","<a href=\"FAQQQ%2ZZZ.html\">QQQ%1ZZZ</a>")
    line=string.gsub(line,"\\CTANref(%b{})","<a class=\"ctan\" href=\"https://www.ctan.org/pkg/QQQ%1ZZZ\">QQQ%1ZZZ</a>")

    line=string.gsub(line,"\\begin{quote}","<blockquote>")
    line=string.gsub(line,"\\end{quote}","</blockquote>")

    if (string.match(line,"\\begin{ctanrefs}")) then
      line=string.gsub(line,"\\begin{ctanrefs}","<dl>")
      ctanrefs=true
    end
    if (string.match(line,"\\end{ctanrefs}")) then
      line=string.gsub(line,"\\end{ctanrefs}","</dl>")
      ctanrefs=false
    end
    if(ctanrefs and string.match(line,"\\item")) then
      line=string.gsub(line,"\\item[ ]*(%b[])","<dt class=\"ctanref\">QQQ%1ZZZ</dt><dd>")
    end


    if (string.match(line,"\\begin{description}") or
        string.match(line,"\\begin{booklist}") ) then
      line=string.gsub(line,"\\begin%b{}","<dl>")
      description=true
    end
    if (string.match(line,"\\end{description}") or
        string.match(line,"\\end{booklist}") ) then
      line=string.gsub(line,"\\end%b{}","</dl>")
      description=false
    end
    if(description and string.match(line,"\\item")) then
      line=string.gsub(line,"\\item[ ]*(%b[])","<dt class=\"description\">QQQ%1ZZZ</dt><dd>")
    end


    line=string.gsub(line,"\\begin{itemize}","<ul>")
    line=string.gsub(line,"\\end{itemize}","</ul>")
    line=string.gsub(line,"\\begin{enumerate}","<ol>")
    line=string.gsub(line,"\\end{enumerate}","</ol>")

    line=string.gsub(line,"\\item","<li>")


    if (string.match(line,"\\begin{narrowversion}")) then
      line=""
      skipline=true
    end
    if (string.match(line,"\\end{narrowversion}")) then
      line=""
      skipline=false
    end

    if (string.match(line,"\\begin{typesetversion}")
        or string.match(line,"\\begin{pdfversion}")
        or string.match(line,"\\begin{dviversion}")
        or string.match(line,"\\htmlignore")
	or string.match(line,"\\begin{flatversion}")) then
      line=""
      skipline=true
    end
    if (string.match(line,"\\end{typesetversion}")
        or string.match(line,"\\end{pdfversion}")
        or string.match(line,"\\end{dviversion}")
        or string.match(line,"\\endhtmlignore")
	or string.match(line,"\\end{flatversion}")) then
      line=""
      skipline=false
    end


    if (skipline) then
      line=""
    end

      line=string.gsub(line,"\\begin{wideversion}","")
      line=string.gsub(line,"\\end{wideversion}","")


      line=string.gsub(line,"\\begin{htmlversion}","") -- need to unquote &
      line=string.gsub(line,"\\end{htmlversion}","")

      line=string.gsub(line,"\\begin{hyperversion}","") 
      line=string.gsub(line,"\\end{hyperversion}","")



    line=string.gsub(line,"\\LastEdit[%* ]*{([^{}]*)}",
    "\n<p class=\"lastedit\">This answer last edited: %1</p>\n" ..
"<p>This question on the Web: <a href=\"http://www.tex.ac.uk/cgi-bin/texfaq2html?label=" ..
(qid or "")..
"\">http://www.tex.ac.uk/cgi-bin/texfaq2html?label=" ..
(qid or "")..
"</a>")


    line=string.gsub(line,"QQQ.","")
    line=string.gsub(line,".ZZZ","")
    line=string.gsub(line,"\\(%a+)","[[[%1]]]")
    line=string.gsub(line,"{","[[[LBRACE]]]")
    line=string.gsub(line,"}","[[[RBRACE]]]")
return line
end



function file_to_toc(file)
  local line
  for line in io.lines(file) do

    if(string.match(line,"^[ ]*\\section{") and
       not(string.match(line,"{hello}")) and
       not(string.match(line,"{my\\us")) and
       not(string.match(line,"\\mytable")) and
       not(string.match(line,"Mumble")) and
       not(string.match(line,"{title\\footnote")) and
       not(string.match(line,"{\\filled{foo"))
       ) then
      section=faq_convert_line((string.gsub(line,".*\\section{(.*)} *$","%1")))
      secid=string.gsub(section,"[^%a]","")
      if(lastlevel==0) then
        io.write("<ul>\n")
      end
--[[ not right
      if(lastlevel==1) then
        io.write("  </li>\n")
      end
      if(lastlevel==2) then
        io.write("  </li></ul></li>\n")
      end
      if(lastlevel==3) then
        io.write("  </li></ul></li></ul></li>\n")
      end
--]]
      io.write("  <li class=\"tocsec\" id=\"" .. secid .. "\"><span>" .. section .. "</span>\n")
      lastlevel=1
    end

    if(string.match(line,"^[ ]*\\subsection{")) then
      subsection=faq_convert_line((string.gsub(line,".*\\subsection{(.*)} *$","%1")))
      subsecid=string.gsub(subsection,"[^%a]","")
--[[ not right
      if(lastlevel==1) then
        io.write("  <ul>\n")
      end
      if(lastlevel==2) then
        io.write("  </li>\n")
      end
--]]
     io.write("    <li class=\"tocsubsec\" id=\"" .. subsecid .. "\"><span>" .. subsection .. "</span>\n")
     lastlevel=2
    end

    if(string.match(line,"\\Question%[")) then
      qid=string.gsub(line,".*\\Question%[([^%]]*)]{(.*)} *$","%1")
      qid=string.gsub(qid,"%*","star")
      qtitle=faq_convert_line((string.gsub(line,".*\\Question%[([^%]]*)]{(.*)} *$","%2")))
--[[ not right
      if(lastlevel==1) then
        io.write("  <ul>\n")
      end
      if(lastlevel==2) then
        io.write("  <ul>\n")
      end
      if(lastlevel==3) then
        io.write("  </li>\n")
      end
--]]
      io.write("      <li class=\"tocqn\" id\"" .. qid .. "\"><a href=\"FA" .. qid .. ".html\">" .. qtitle .. "</a></li>\n")
      lastlevel=3
    end
  end
end


function faq_make_toc ()
  local line
  lastlevel=0
  io.write("\n<div class=\"toc\">\n")
  for line in io.lines("gather-faqbody.tex") do
    if(string.match(line,"\\faqinput{")) then
      tocfile=string.gsub(line,"^.*\\faqinput{(.*)}.*$","%1.tex")
      file_to_toc(tocfile)
    end
  end
  io.write("\n</div>\n")
end


for line in io.lines("gather-faqbody.tex") do
  if(string.match(line,"\\faqinput{")) then
    file=string.gsub(line,"^.*\\faqinput{(.*)}.*$","%1.tex")
    file_to_html(file)
  end
end


