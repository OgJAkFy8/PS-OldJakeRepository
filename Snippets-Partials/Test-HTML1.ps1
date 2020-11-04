
  $head = @"
<style>
body   {
    color:Yellow;
    background-color:Navy;
    font-family:Tahoma;
    font-size:12pt;
    }

table, tr, td {
    border:1px solid Crimson;
    color:Pink;
    background-color:Green;
    }

th  {
    color:Cyan;
    background-color:blank;
    }

table  {
    margin-left:50px;
    }

</style>
"@

$PingReply = Test-NetConnection -ComputerName yahoo.com

$PingReply | ConvertTo-Html -Title 'Ping-O-Matic!' -As Table -Head $head | Out-File C:\temp\fibertest.html -Append
$PingReply | ConvertTo-Html -Title 'Ping-O-Matic!' -As Table -Fragment | Out-File C:\temp\fibertest.html -Append

    
Start-Process -FilePath msedge.exe -ArgumentList  C:\temp\fibertest.html








