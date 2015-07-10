Writing text for the TeX FAQ -- the requirements
================================================

There are some ground rules for text for the FAQ which need to be
adhered to.  Some of the rules relate to the Perl program that's used
to create an HTML file of the FAQ from the TeX source, or to the
nature of the macros that Sebastian, Alan and I have written; others
relate to the way in which I try to manage change.  Please remember
that we're attempting distributed authoring of a relatively small
document over a tight time-scale; while I _can_ in principle work into
the night to put things right after a submission, my employers tend to
prefer me awake during the working day ...

Rules for presentation of text
------------------------------

1. Don't line wrap in macro calls.  Ignore the fact that this can mean
   very long lines.  This restriction applies equally to the
   `[]`-surrounded optional arguments of macros (e.g., `\item`).

2. Always put `{}` after 'name' macros (such as `\TeX{}`).  Do this
   - even if you prefer `\TeX\` to ensure the name's delimited
   - even if the name's immediately followed by punctuation

3. Don't use `\verb` or `\shortvrb` -- find alternatives in other
   constructions like `\csx`, `\cmdinvoke`, etc.

Source of the text
------------------

The text currently resides in 
 - `newfaq.tex`    The body of the text
 - `filectan.tex`  Declarations of the locations of individual files on
                   CTAN archives
 - `dirctan.tex`   Declarations of the directories on CTAN archives
 - `faq.sty`       The main package

This pre-production version of the text is printed (by default) in
Adobe Times Roman, etc.  An alternative font may by used by setting
yourself up with a file `faqfont.cfg` that contains the commands that
should be used to define what fonts are needed.

A `faqfont.cfg` which does nothing, and hence leaves LaTeX with its
default of `cm*` fonts, is available with the text; if you *want* the
FAQ printed in Times Roman, you should not transfer the file (or you
should delete it once you *have* transferred it).

Markup commands
---------------

The FAQ is written in LaTeX.  Commands to use are:

    \CTANdirectory{tag}{directory-path}
    \CTANfile{tag}{file-path}

These are used in `dirctan.tex` and `filectan.tex`, respectively.  The
`<tag>` is used in the `\CTANref` command, and the `<*-path>` is is what
gets typeset in respect of a `\CTANref` (and what becomes the anchor
of an HTML link to retrieve the referenced thing).

    \CTANdirectory*{tag}{directory-path}

As `\CTANdirectory`, but appears in HTML as "browse directory" only

    \CTANref{tag} (and the ctanrefs environment)

Make reference to a `<tag>` defined by a `\CTANfile` or `\CTANdirectory`
command; will usually appear in a `ctanrefs` environment at the end of
an answer.  Refer to the files with markup such as `\Package`,
`\Class` or `\ProgName` in the body of the question, and then say:

    \begin{ctanrefs}
    \item[blah.sty]\CTANref{blah}
    \end{ctanrefs}

    \Question[label]{question-title}

Set the title of a question, and define a label for it (in fact, an
unusual sort of subsection command).  The [label] is (now)
mandatory, and must be prefixed by `Q-` (as in
`\Question[Q-newans]{Submitting new material for the FAQ}`).

    \Qref[intro-text]{anchor-text}{label}

Refer to a question.  The `<intro-text>` is set before the reference,
and is "see question" by default.  The `<anchor-text>` is used in
hyper-enabled output, as the anchor for jumping to the labelled
question.  The `<label>` is defined somewhere in the document as a
`\Question` command's (nominally) optional argument.

    \Qref*{anchor-text}{label}

Refer to a question.  In hyper-enabled output, results are the same
as for `\Qref`; in TeX output, produces

    anchor-text (see question <label>)

Special care being taken with surrounding quotes.

    \TUGboat{} <vol>(<number>)

_TUGboat_ reference (we have surprisingly many).  Really does have
that syntax `\TUGboat{} 16(3)`, though as far as the HTML translator
is concerned, the command ends at `\TUGboat{}` so it doesn't matter if
it gets split across lines.

    \begin{booklist}
    ...
    \end{booklist}

Is used to set lists of books; it uses `\item` in the same way that
the description environment does, but sets the label thus defined in
normal weight italic text from the current family

    \htmlignore ... \endhtmlignore

Brackets around bits of text that are to be ignored by the html
generator (deprecated: use environment `typesetversion` instead)

    \begin{htmlversion}
    ...
    \end{htmlversion}

Text to appear in HTML but not in the typeset versions of the FAQ.
(The body of the environment will be processed before appearing in
the HTML output, just the same as text for joint use.)

Similar are:
 - Environment `dviversion` (DVI output only)
 - Environment `pdfversion` (PDF output only)
 - Environment `narrowversion` (DVI output only -- narrow since 2-col output)
 - Environment `wideversion` (HTML or PDF output only)

Note that we use narrow for non-hyper, and wide for hyper versions
of the source.

    \htmlonly{text}
    \narrowonly{text}
    \wideonly{text} 

These three are command versions of the corresponding environments

    \nothtml{text}

Text not to appear in the HTML version

    \latexhtml{latex text}{HTML text}

Typesets LaTeX text, or processes HTML text, according to context

    \csx{name}

A robust command to typeset a control sequence in typewriter.  The
`<name>` should only have letters or (at most) others in it -- no
active characters, please...

    \cmdinvoke{cmd name}<arguments>

Typesets a complete command invocation, and all its arguments.
The LaTeX macro will take arbitrary sequences of optional and
mandatory arguments, but while the HTML processor will deal with a
wide range of variants, its stunning simplemindedness means it's
always good to check such output.

    \cmdinvoke*{cmd name}<arguments>

As `\cmdinvoke`, but arguments are typeset with `\emph`

    \checked{intials}{date}

Records when an answer (or part of an answer) was checked, and by
whom.  Currently typesets as nothing.

    \LastEdit{date}

Date of last editing a Question; argument is yyyy-mm-dd (ISO form)
(placed at the end of an answer)

    \LastEdit*{date}

Last edit was the initial version

    \keywords{<stuff>}

For labelling questions.  Doesn't currently have any effect at all.

    \Email{<name>@<address>}
    \FTP{<site-address>}
    \File{file-path>}
    \path{file-path>}
    \Newsgroup{usenet-group-name}
    \URL{protocol>://site/path}
    \mailto{mail@ddress}

All these things typeset their argument in typewriter, but allowing
line-splitting at appropriate characters (using `url.sty`).  The last
two (`\URL` and `\mailto`) become active in both the HTML and PDF
versions of the FAQ; `\Email` is for formatting a name (e.g., a finger
identifier) that the reader is _not_ supposed to mail.

    \Package{package name}  % (no .sty)
    \Class{class name}      % (no .cls)
    \ProgName{executable command name}

Set the item in an appropriate fashion.  _Please_ use these commands
wherever appropriate.

Names, logos, etc., for use whenever needed (to be used just as
`\name{}`):
`\AllTeX` [(La)TeX], `\LaTeXe`, `\LaTeXo` [LaTeX 2.09, with requisite
precautions about dealing with the undead], `\MF`, `\MP` [MetaPost], `\BV`
[Baskerville], `\PDFTeX`, `\PDFLaTeX`, `\CONTeXT`, `\NTS`, `\eTeX`, `\Eplain`,
`\TeXsis`, `\YandY` [the firm, whose name is a bit tricky in HTML],
`\WYSIWYG`, `\dots`, `\ldots`, `\pounds`, `\arrowhyph` [->, used in
descriptions of selections from menus, and looking better when
typeset], `\textpercent`, `\textasciitilde`

Typesetting things, arguments in braces:
`\acro` [for upper-case acronyms such as CTAN], `\emph`, `\textit`,
`\textsl`, `\meta` [as in `doc.sty`], `\texttt`, `\thinspace`, `\ISBN`

Typesetting environments:
`quote`, `description`, `itemize`, `enumerate`, `verbatim`

Other odds and ends:
`$\pi$`, `$...$`, `\$`, `\#`, `\ `, `\&`, `~` [just produces a space]
