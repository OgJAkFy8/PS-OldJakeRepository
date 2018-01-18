$NestedFolders = Get-ChildItem | 
Where-Object{$_.Name -match 'NestedFolders'} | 
Sort-Object -Property $_.Lastwritetime
$menu = @{}
$folderCount = $NestedFolders.Count-1

for($i = 0;$i -lt $NestedFolders.count;$i++){
  Write-Host ('{0}. {1}' -f $i, $NestedFolders[$i].name)
  $menu.Add($i,($NestedFolders[$i].name))
}

do{[int]$ans = Read-Host -Prompt 'Select number to Remove'
  if($ans -ge $folderCount ){
    Write-Host ('Select a number {0} or below' -f $folderCount)
  }
}while($ans -notin 0..$folderCount)

$selection = $menu.Item($ans)
$selection