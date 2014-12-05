Enforce-GoogleSafeSearch-DNSEntries
===================================
Configure Active Directory DNS with zones and records to enforce Google Safe Search

* The script requires Powershell 4.0 (Windows Server 2012 R2 or Windows 8.1)
* This powershell script creates Active Directory DNS zones and CName(2003) or A(2008+) records where needed to lock in Safe Search for the Google Search Engine.
* It is based on the direction provided by Google here: https://support.google.com/websearch/answer/186669?hl=en
* This will create several www.google.ad, www.google.ae, etc domains in your AD DNS Forward Lookup Zones and set the CNAME/A record for each of these to forcesafesearch.google.com (or IP of this domain for A record)
* Your clients must use your AD DNS servers for all lookups for this to work. Your AD DNS servers can then forward unknown requests on to the State DNS servers for further lookups. (This is required for Active Directory clients to operate properly anyway).

1. Download the script and save it locally
2. Edit the script in your favorite editor (Notepad.exe, Notepad++ , etc)
  1. Change **$VerboseMode** to $False if you do not want detailed data on the screen (probably want this as $true for your first run to see what it's doing)
  2. Change **$AD_DNS_Server = "DC1.DOMAIN.LOCAL"** to use one of your AD DNS Servers (keep the double quotes!)
  3. Save
3. Ensure that you can run local powershell scripts
  1. Go to command prompt:
    1. Run **powershell Get-ExecutionPolicy**
    2. Note the result
  2. Run **powershell Set-ExecutionPolicy RemoteSigned**
    1. RemoteSigned: Allows running of local scripts, requires network/remote scripts be signed
4. Run the script: Go to command prompt and run: **powershell -F "c:\path\where\you\saved\the\script\Enforce-GoogleSafeSearch-DNSEntries-1.0.2.ps1"**
5. Change Powershell mode back to your results in step 3.1.2: Go to command prompt and run: **powershell Set-ExecutionPolicy *result_from_step_3.1.2_goes_here***
6. Give AD time to replicate the information (~15 - 30 minutes depending on your configuration)
