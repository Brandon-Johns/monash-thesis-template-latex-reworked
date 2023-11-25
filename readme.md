# Monash University Thesis Template
Compliant with the Monash University requirements.

Good for both
- Traditional thesis.
- Thesis including published works.

The complied PDF looks like [this](./Thesis.pdf).

Also included, is a template to respond to examiner comments. The compiled PDF looks like [this](./response1.pdf).


## My Changes
This template is based on the version provided on the ENG Graduate Research Moodle (Downloaded in 2023).

I completely reworked the Thesis class and template.

Key changes
- Lightly restyled preliminary pages (Still compliant with Monash University requirements)
- Added support for subsubsection to subparagraph depth
- Updated to modern packages which give better control: vmargin->geometry, natbib->biblatex, etc.
- Restyled headings, footers, contents, line/paragraph spacing, float placement
- Disabled hyphenation
- Removed double-sided-page mode (sorry, but it's too complicated for me to bother with)
- Reorganised the files and added comments
- Made the output PDF/A-2u compliant (well, somewhat compliant: figures and maths are like ugh)
- Added ability to restore hyperlinks within the embedded pdfs. Not fully automatic- the user has to help it along
- Completely redid the example scaffolding and example content


## Instructions
### Getting started
1. Open this project in a LaTeX editor (e.g. import into overleaf)
2. Ensure that the main document is set to `Thesis.tex`
3. Test that it compiles
4. To start editing, open `Thesis.tex` and follow the instructions


### Set thesis type
To set for traditional thesis, `Thesis.tex` should use
```latex
%\input{Preamble/Declaration_publications.tex} %% Thesis by Published Works Only
\input{Preamble/Declaration.tex} %% Traditional Thesis Only
```

To set for thesis including published works, `Thesis.tex` should use
```latex
\input{Preamble/Declaration_publications.tex} %% Thesis by Published Works Only
%\input{Preamble/Declaration.tex} %% Traditional Thesis Only
```

This is the only difference between the variants, other than your inclusion of the published work itself.

Examples of how to include your published work are `Chapters\Chapter3.tex` and `Chapters\Chapter4.tex`.


### Responding to examiner comments
The provided template for responding to examiner comments requires running the latexdiff utility and powershell scripts.
- This can not be done through overleaf.
- You will need to install latex and latexdiff on your computer.
- Non-windows users will need to install the cross-platform [PowerShell Core](https://github.com/PowerShell/PowerShell).

Starting from the version of your thesis, as it was submitted for examination
1. Compile `Thesis.tex`
2. Run `RevisionScripts\GenerateFlattened.ps1`
3. Edit your thesis as required to address all examiner comments
4. Compile `Thesis.tex`
5. Run `RevisionScripts\GenerateDiff.ps1`
6. Write `response1.tex`
    - Quotes of the text with tracked-changes markup can be copied from the generated `Thesis_diff.tex` into the response
7. Compile `response1.tex`

Return to step 3 as required, but be sure to follow through all subsequent steps to 3-7 to regenerate everything.

`Thesis_diff.tex` is a stand-alone document which can also be compiled and provided to the examiners.

Not that latexdiff is not perfect, and it defaults to skipping markup in environments and commands that it does not know. You can register more commands in `RevisionScripts\GenerateDiff.ps1`, using the `$DiffOptions` variable. This will require some trial and error.


## License
The original thesis class and template was created by Steve R. Gunn, and has since been modified by many. While no specific license was provided with the received files, the latest version [1](https://www.sunilpatel.co.uk/other-stuff/thesis-template/), [2](https://www.latextemplates.com/template/masters-doctoral-thesis) is distributed under the [Creative Commons CC BY-NC-SA 3.0 license](https://creativecommons.org/licenses/by-nc-sa/3.0/). Interpret this as you will...

The responding to examiner comments class and template are based off [the work of Martin Schrön](https://github.com/mschroen/review_response_letter/blob/master/templates/preamble.tex), and are distributed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).

The powershell scripts are distributed under the [BSD-3-Clause License](https://opensource.org/license/bsd-3-clause/). Copyright (c) 2023 Brandon Johns.

The Monash University logo and ORCIDiD icon are subject to the restrictions applied by the respective organisations.


## Source Code
This project is hosted at https://github.com/Brandon-Johns/monash-thesis-template-latex-reworked

