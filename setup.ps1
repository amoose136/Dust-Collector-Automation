$project_exists = Read-Host -Prompt 'Do you already have a kicad project made? (y/n)'
$project_name = Read-Host -Prompt 'Input board/project name'
$creator_name = Read-Host -Prompt 'Input author name'
$date = Get-Date -Format "yyyy-MM-dd"
if ($project_exists -eq "y") {
    rm *.kicad_pro 
    rm *.kicad_sch
    Read-Host -Prompt 'Please drag a COPY (!) of your .sch/.kicad_sch files, your .pro/.kicad_sch file, your sym-lib-table, and your layout file (.kicad_pcb) into the root directory this folder sits in. Then, press enter to continue.'
}
else {
    Write-Host "file does not exist"
}
# # rename old kicad files
Dir *.pro | %{Rename-Item $_ -NewName "$project_name.kicad_pro"}
Dir *.sch | %{Rename-Item $_ -NewName "$project_name.kicad_sch"}
# # configure kicad files
Dir *.kicad_pro | %{Rename-Item $_ -NewName "$project_name.kicad_pro"}
Dir *.kicad_sch | %{Rename-Item $_ -NewName "$project_name.kicad_sch"}
((Get-Content "$project_name.kicad_sch" -Raw) -replace 'Title ".*"', $('Title "EXAMPLE"' -replace "EXAMPLE",$project_name)) | Set-Content "$project_name.kicad_sch"
((Get-Content "$project_name.kicad_sch" -Raw) -replace 'Comment1 ".*"', $('Comment1 "Schematic and board design by creator_name"' -replace 'creator_name',$creator_name)) | Set-Content "$project_name.kicad_sch"
((Get-Content "$project_name.kicad_sch" -Raw) -replace 'Date ".*?"', $('Date "DDDD"' -replace "DDDD", $date)) | Set-Content "$project_name.kicad_sch"
Dir *.kicad_pcb | %{Rename-Item $_ -NewName "$project_name.kicad_pcb"}
Dir ProjectSpecificSymbols\Project_parts.lib| %{Rename-Item $_ -NewName $("IIII_parts.lib" -replace "IIII", $project_name)}
Dir ProjectSpecificSymbols\Project_parts.dcm| %{Rename-Item $_ -NewName $("III_parts.dcm" -replace "III", $project_name)}
((Get-Content sym-lib-table -Raw) -replace 'Project_parts', $("I_parts" -replace "I",$project_name) ) | Set-Content sym-lib-table