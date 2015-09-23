#######################################################
# Script:  Delete-GoogleSafeSearch-DNSEntries.ps1
$ScriptVersion = "1.0.0"
#
# Copyright Brian Lowrance  brian@bentonschools.org
# License: http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
######################################################
# Requirements:
#   - Powershell 4.0 - Script should be run from a Windows Server 2012 R2 or Windows 8.1 system.
#   - Windows 2003, 2008, 2012 DNS Server
#   - User must be logged in with permission to remotely access and modify the Windows DNS Server Zone and Resource Records
######################################################



##################################################
# BEGIN  CONFIGURATION SECTION                   #
##################################################
$VerboseMode = $True  #$Truea or $False  - Display a lot of data on the screen about processing? (Errors are always displayed)
$AD_DNS_Server = "DC1.DOMAIN.LOCAL"  # "Server.Domain.Local" - Replace this line with one of your Active Directory DNS servers

#Google Zones according to:  https://www.google.com/supported_domains
$GoogleDomains=@()
$GoogleDomains=@(".google.com",".google.ad",".google.ae",".google.com.af",".google.com.ag",".google.com.ai",".google.al",".google.am",".google.co.ao",".google.com.ar",".google.as",".google.at",".google.com.au",".google.az",".google.ba",".google.com.bd",".google.be",".google.bf",".google.bg",".google.com.bh",".google.bi",".google.bj",".google.com.bn",".google.com.bo",".google.com.br",".google.bs",".google.bt",".google.co.bw",".google.by",".google.com.bz",".google.ca",".google.cd",".google.cf",".google.cg",".google.ch",".google.ci",".google.co.ck",".google.cl",".google.cm",".google.cn",".google.com.co",".google.co.cr",".google.com.cu",".google.cv",".google.com.cy",".google.cz",".google.de",".google.dj",".google.dk",".google.dm",".google.com.do",".google.dz",".google.com.ec",".google.ee",".google.com.eg",".google.es",".google.com.et",".google.fi",".google.com.fj",".google.fm",".google.fr",".google.ga",".google.ge",".google.gg",".google.com.gh",".google.com.gi",".google.gl",".google.gm",".google.gp",".google.gr",".google.com.gt",".google.gy",".google.com.hk",".google.hn",".google.hr",".google.ht",".google.hu",".google.co.id",".google.ie",".google.co.il",".google.im",".google.co.in",".google.iq",".google.is",".google.it",".google.je",".google.com.jm",".google.jo",".google.co.jp",".google.co.ke",".google.com.kh",".google.ki",".google.kg",".google.co.kr",".google.com.kw",".google.kz",".google.la",".google.com.lb",".google.li",".google.lk",".google.co.ls",".google.lt",".google.lu",".google.lv",".google.com.ly",".google.co.ma",".google.md",".google.me",".google.mg",".google.mk",".google.ml",".google.com.mm",".google.mn",".google.ms",".google.com.mt",".google.mu",".google.mv",".google.mw",".google.com.mx",".google.com.my",".google.co.mz",".google.com.na",".google.com.nf",".google.com.ng",".google.com.ni",".google.ne",".google.nl",".google.no",".google.com.np",".google.nr",".google.nu",".google.co.nz",".google.com.om",".google.com.pa",".google.com.pe",".google.com.pg",".google.com.ph",".google.com.pk",".google.pl",".google.pn",".google.com.pr",".google.ps",".google.pt",".google.com.py",".google.com.qa",".google.ro",".google.ru",".google.rw",".google.com.sa",".google.com.sb",".google.sc",".google.se",".google.com.sg",".google.sh",".google.si",".google.sk",".google.com.sl",".google.sn",".google.so",".google.sm",".google.sr",".google.st",".google.com.sv",".google.td",".google.tg",".google.co.th",".google.com.tj",".google.tk",".google.tl",".google.tm",".google.tn",".google.to",".google.com.tr",".google.tt",".google.com.tw",".google.co.tz",".google.com.ua",".google.co.ug",".google.co.uk",".google.com.uy",".google.co.uz",".google.com.vc",".google.co.ve",".google.vg",".google.co.vi",".google.com.vn",".google.vu",".google.ws",".google.rs",".google.co.za",".google.co.zm",".google.co.zw",".google.cat")
#$GoogleDomains=@(".google.com",".google.ad",".google.ae",".google.com.af",".google.com.ag",".google.com.ai",".google.al",".google.am",".google.co.ao",".google.com.ar",".google.as",".google.at",".google.com.au",".google.az",".google.ba",".google.com.bd",".google.be",".google.bf",".google.bg",".google.com.bh",".google.bi",".google.bj",".google.com.bn",".google.com.bo",".google.com.br",".google.bs",".google.bt",".google.co.bw",".google.by",".google.com.bz",".google.ca",".google.cd",".google.cf",".google.cg",".google.ch",".google.ci",".google.co.ck",".google.cl",".google.cm",".google.cn",".google.com.co",".google.co.cr",".google.com.cu",".google.cv",".google.com.cy",".google.cz",".google.de",".google.dj",".google.dk",".google.dm",".google.com.do",".google.dz",".google.com.ec",".google.ee",".google.com.eg",".google.es",".google.com.et",".google.fi",".google.com.fj",".google.fm",".google.fr",".google.ga",".google.ge",".google.gg",".google.com.gh",".google.com.gi",".google.gl",".google.gm",".google.gp",".google.gr",".google.com.gt",".google.gy",".google.com.hk",".google.hn",".google.hr",".google.ht",".google.hu",".google.co.id",".google.ie",".google.co.il",".google.im",".google.co.in",".google.iq",".google.is",".google.it",".google.je",".google.com.jm",".google.jo",".google.co.jp",".google.co.ke",".google.com.kh",".google.ki",".google.kg",".google.co.kr",".google.com.kw",".google.kz",".google.la",".google.com.lb",".google.li",".google.lk",".google.co.ls",".google.lt",".google.lu",".google.lv",".google.com.ly",".google.co.ma",".google.md",".google.me",".google.mg",".google.mk",".google.ml",".google.com.mm",".google.mn",".google.ms",".google.com.mt",".google.mu",".google.mv",".google.mw",".google.com.mx",".google.com.my",".google.co.mz",".google.com.na",".google.com.nf",".google.com.ng",".google.com.ni",".google.ne",".google.nl",".google.no",".google.com.np",".google.nr",".google.nu",".google.co.nz",".google.com.om",".google.com.pa",".google.com.pe",".google.com.pg",".google.com.ph",".google.com.pk",".google.pl",".google.pn",".google.com.pr",".google.ps",".google.pt",".google.com.py",".google.com.qa",".google.ro",".google.ru",".google.rw",".google.com.sa",".google.com.sb",".google.sc",".google.se",".google.com.sg",".google.sh",".google.si",".google.sk",".google.com.sl",".google.sn",".google.so",".google.sm",".google.sr",".google.st",".google.com.sv",".google.td",".google.tg",".google.co.th",".google.com.tj",".google.tk",".google.tl",".google.tm",".google.tn",".google.to",".google.com.tr",".google.tt",".google.com.tw",".google.co.tz",".google.com.ua",".google.co.ug",".google.co.uk",".google.com.uy",".google.co.uz",".google.com.vc",".google.co.ve",".google.vg",".google.co.vi",".google.com.vn",".google.vu",".google.ws",".google.rs",".google.co.za",".google.co.zm",".google.co.zw",".google.cat")

#################################################
# END CONFIGURATION SECTION                     #
#################################################




###############################################################################################################################
# Unless you are fluent with Powershell programming                                                                           #
# DO NOT EDIT BELOW THIS LINE                                                                                                 #
###############################################################################################################################
###############################################################################################################################
# Not kidding, don't edit below!                                                                                              #
###############################################################################################################################

# Add each Google Zone with a CNAME record for forcesafesearch.google.com to the AD DNS Forward Lookup Zones
$x=0
$CNameMethodCompatible = $true #Start with this, the script will detect failure and switch it.

function Write-Verbose ([string]$msg){
  if ($VerboseMode){ Write-Host "VERBOSE: $msg" }
}

ForEach($GoogleDomain in $GoogleDomains){
	$x++
    $ZoneFound = $false
    $CNameFound = $false
    $ARecordFound = $false
    $ErrorOccurred = $false
    $ErrorActionPreference = "Stop"  #Some errors are non-terminating errors and do not work with Try/Catch/Finally; make all errors terminating for error control

    Write-Verbose ""
    Write-Verbose "Domain $x of $(($GoogleDomains).Count)"
    Write-Verbose "Start Processing: $GoogleDomain"
    #Check for Zone Existence
    Try {
        if ((get-dnsserverzone -name "www$GoogleDomain" -ComputerName $AD_DNS_Server | select ZoneName) -ne $null) { $ZoneFound = $true }
    } Catch {
        $ZoneFound = $false
    }
    If ($ZoneFound) { Write-Verbose "Zone exists" }
    If (!($ZoneFound)) { Write-Verbose "Zone does not exist" }

    if ($ZoneFound) {
        Try {
            #Delete the zone ("www.google.com, www.google.ae, etc)
            Write-Verbose "Attempting to delete zone"
            $ZoneFound = $true
            #Add-DnsServerPrimaryZone -Name "www$GoogleDomain" -ReplicationScope "Forest" -ComputerName $AD_DNS_Server
			#Get-DnsServerResourceRecord -ZoneName "www$GoogleDomain" | Remove-DnsServerResourceRecord -Force -ZoneName "www$GoogleDomain"
			dnscmd $AD_DNS_Server /ZoneDelete "www$GoogleDomain" /DsDel /f
        } Catch {
            Write-Verbose "Could not delete zone"
            Write-Host "An error occurred delete the DNS zone for www$GoogleDomain"
            $ErrorOccurred = $true
            $ZoneFound = $false
        }
    }
}

Write-Host ""
Write-Host "Added/Modified $x DNS zones for Google Safe Search Enforcement"
if ($ErrorOccurred) {
    Write-Host "Errors Occurred during processing, some records could not be created/updated" -ForegroundColor Red
}
Write-Host "--Script Version: $ScriptVersion"
Write-Host ""
