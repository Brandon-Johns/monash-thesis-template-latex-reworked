<#
Written By:			Brandon Johns
Version Created:	2023-11-20
Last Edited:		2023-11-22

********************************************************************************
Purpose
****************************************
This script runs the latexdiff utility, and does some extra post-processing

latexdiff generates tex file which can be built into a tracked changes pdf
	Read more about latexdiff here
	https://www.overleaf.com/learn/latex/Articles/Using_Latexdiff_For_Marking_Changes_To_Tex_Documents

This script is only for documents using the NUMERIC citation type
	The issue with direct use of latexdiff is that the citation numbers change
		without consideration of if the cite is inside of a \DIFdel{} or \DIFadd{}.
		Therefore, the resultant citation numbers don't match any document.
	This script post-processes the diff file to make
		\DIFdel{\cite{...}}: uses the numbers of old version
		\DIFadd{\cite{...}}: uses the numbers of new version
		\cite{...}:          uses the numbers of new version

This script also generates a .nocite file, which holds the citation order of the new version
	This is for use to \input{} into the top of your author response to reviewers comments.
	Hence, the response will use these same citation numbers as the diff file


********************************************************************************
Instructions
****************************************
Starting from the version of your thesis, as it was submitted for examination

Install latexdiff

Save old version (DO THIS ONLY ONCE)
1) Compile Thesis.tex
2) Run RevisionScripts\GenerateFlattened.ps1

Generate dif (REPEAT AS YOU MAKE CHANGES)
1) Revise the thesis as required
2) Compile Thesis.tex
3) Run RevisionScripts\GenerateDiff.ps1
4) Write a review response using ReviewResponse.cls


********************************************************************************
Notes
****************************************
$fileOld.tex and $fileOld.bibkeys should be in the same directory
$fileOld.tex should be self-contained (no \input{} commands)
$fileOld.bibkeys should hold all citation keys in the order that the appear in the bibliography
	It should be formatted as follows
```
% Comments prefixed by a percent are permitted
example2
example1
example3
example4
```

#>
#********************************************************************************
# CONFIG
#****************************************
# Files to compare
$fileOld = 'Revisions\Thesis_flat'
$fileNew = 'Thesis'

# Filename for output
$fileDiff = 'Thesis_diff'

# Optional arguments passed to latexdiff
$DiffOptions = @()
$DiffOptions += '--flatten'
$DiffOptions += '--preamble=RevisionScripts\DiffPreamble.tex'
#$DiffOptions += '--graphics-markup=none'

# Add to list of commands that latexdiff is allowed to markup
#	Errors if you add "thesisUniversity,thesisTitle,thesisAuthor" due to use in the xmpdata.
#	latexdiff struggles with table environments, particularly if you delete a whole row. Not much I can do.
# safecmd means the command can appear inside of a DIFadd/DIFdel
# textcmd means DIFadd/DIFdel can appear inside of the last argument of the command
$DiffOptions += '--append-safecmd="figref,tbref,eqref,chapref,secref,appref,algoref,algoRefLine,algoRefLines"'
$DiffOptions += '--append-textcmd="thesisSchool,thesisDepartment,thesisGradtime,thesisDegree,thesisPriorDegrees,listOfAbbreviations,listOfConstants,listOfNomenclature"'


#********************************************************************************
# AUTOMATED
#****************************************
Push-Location $PSScriptRoot\..
If(-not (Test-Path "${fileOld}.tex"))     { throw "Can't find old file" }
If(-not (Test-Path "${fileOld}.bibkeys")) { throw "Can't find bibkeys file" }
If(-not (Test-Path "${fileNew}.tex"))     { throw "Can't find new file" }
If(-not (Test-Path "${fileNew}.bbl"))     { throw "Can't find bbl file. Compile ${fileNew}.tex, then try again" }

# Generate diff file
latexdiff $DiffOptions "${fileOld}.tex" "${fileNew}.tex" | Out-File "${fileDiff}.tex" -Encoding utf8
$diffFileContent = Get-Content -Path "${fileDiff}.tex" -Raw

#********************************************************************************
# AUTOMATED - Replace all \DIFdel{\cite{...}} with citation numbers according to 
#****************************************
# Create associative array (hash table) of key to citation number
$citedKeys = [ordered]@{}
$citeNumber = 1
foreach ($line in Get-Content -Path "${fileOld}.bibkeys") {
	if ($line -match '^(?!%)(?<citeKey>.+?)$') {
		$citedKeys[$Matches.citeKey] = $citeNumber;
		$citeNumber += 1;
	}
}

# Search diff file for a '\cite{}' inside of a '\DIFdel{}'
# Case sensitive match
$reCite = '\\DIFdel\{[^\}]*?' + '(?<citeCommand>\\cite\{(?<citeKeys>.+?)\})'
while($diffFileContent -cmatch $reCite) {
	# Split into array of individual keys
	$keysInCite = $Matches.citeKeys -split ','

	# Exchange keys for citation numbers and sort numerically
	$citeNumbersInCite = @()
	foreach ($key in $keysInCite) {
		$citeNumbersInCite += $citedKeys[$key];
	}
	$citeNumbersInCite = $citeNumbersInCite | Sort-Object {[int]$_}

	# String to write out
	$FormattedCite = '[' + ($citeNumbersInCite -join ',') + ']'

	# Replace the cite command with the formatted cite
	$diffFileContent = $diffFileContent.Replace($Matches.citeCommand, $FormattedCite)

	Write-Host $Matches.citeKeys
	Write-Host $FormattedCite
	Write-Host ''
}

# Perform write
$diffFileContent | Set-Content -Path "${fileDiff}.tex" -Encoding utf8


#********************************************************************************
# AUTOMATED - generate nocite
#****************************************
$bibItems = @(@"
% AUTO-GENERATED FILE
% This file contains the \bibitem{} or \entry{} content from the .bbl file from compiling ${fileNew}.tex
% The order of the keys therefore matches the citation numbers
"@)
$reBib = '^\s*\\(bibitem|entry)\{(?<bibItem>.+?)\}'
foreach  ($line in Get-Content -Path "${fileNew}.bbl") {
	if ($line -cmatch $reBib) {
		$bibItems += '\nocite{'+$Matches.bibItem+'}'
	}
}

$bibItems | Out-File -LiteralPath "${fileNew}.nocite" -Encoding utf8


#********************************************************************************
# AUTOMATED - Build and clean up
#****************************************
# Build pdf
#latexmk -interaction=nonstopmode -pdf "${fileDiff}.tex"

# Clean up
#Remove-Item -LiteralPath "${fileDiff}.tex"

# Open pdf with chrome
#Start-Process chrome -ArgumentList (Get-ChildItem "${fileDiff}.pdf").FullName

Pop-Location

