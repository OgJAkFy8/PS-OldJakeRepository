#requires -Version 3.0

Function Request-FileDownload 
{
  <#
      .SYNOPSIS
      Download a file from the web

      .DESCRIPTION
      Download a file from the web

      .PARAMETER uri
      Link to file to download.

      .PARAMETER FilePath
      Full filename to save file as.

      .EXAMPLE
      Request-FileDownload -uri http://webserver.com/filename.txt -FilePath c:\temp\filename.txt

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Download-File

  #>


  Param (
    [Parameter(Mandatory,HelpMessage = 'Link to file to download.')] [uri]$uri,
    [Parameter(Mandatory,HelpMessage = 'Full filename to save file as.' )] [string]$FilePath
  )

  #Make sure the destination directory exists
  #System.IO.FileInfo works even if the file/dir doesn't exist, which is better then get-item which requires the file to exist
  If (! ( Test-Path -Path ([IO.FileInfo]$FilePath).DirectoryName ) ) 
  {
    [void](New-Item -Path ([IO.FileInfo]$FilePath).DirectoryName -Force -ItemType directory)
  }

  #see if this file exists
  if ( -not (Test-Path -Path $FilePath) ) 
  {
    #use simple download
    [void] (New-Object -TypeName System.Net.WebClient).DownloadFile($uri.ToString(), $FilePath)
  }
  else 
  {
    try 
    {
      #use HttpWebRequest to download file
      $webRequest = [Net.HttpWebRequest]::Create($uri)
      $webRequest.IfModifiedSince = ([IO.FileInfo]$FilePath).LastWriteTime
      $webRequest.Method = 'GET'
      [Net.HttpWebResponse]$webResponse = $webRequest.GetResponse()

      #Read HTTP result
      $stream = New-Object -TypeName System.IO.StreamReader -ArgumentList ($webResponse.GetResponseStream())
      #Save to file
      $stream.ReadToEnd() | Set-Content -Path $FilePath -Force
    }
    catch [Net.WebException] 
    {
      #Check for a 304
      if ($_.Exception.Response.StatusCode -eq [Net.HttpStatusCode]::NotModified) 
      {
        Write-Host ('  {0} not modified, not downloading...' -f $FilePath)
      }
      else 
      {
        #Unexpected error
        $Status = $_.Exception.Response.StatusCode
        $msg = $_.Exception
        Write-Host ('  Error dowloading {0}, Status code: {1} - {2}' -f $FilePath, $Status, $msg)
      }
    }
  }
}
