
$hash_table = @{'key1' = 'value1';'key2' = 'value2';'key3' = 'value3'}
$hash_table.GetEnumerator() | Foreach-Object { $t = (@'

This is test {0}
{1} 

'@ -f $($_.Value),$($_.Key))
$t
}




$hash_table = @{'key1' = 'value1';'key2' = 'value2';'key3' = 'value3'}
Foreach($item in $($hash_table.GetEnumerator())) { 

$t = (@'

This is test {0}
{1} 

'@ -f $($item.Value),$($item.Key))
$t
}


