#curlOutput1=$(curl -s -k -m 5 --anyauth -u "$BoxUSER:$BoxPW" http://$BoxIP:49000$location -H 'Content-Type: text/xml; charset="utf-8"' -H "SoapAction:$uri#$action" -d "<?xml version='1.0' encoding='utf-8'?><s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'><s:Body><u:$action xmlns:u='$uri'></u:$action></s:Body></s:Envelope>" | grep NewEnable | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
#curlOutput2=$(curl -s -k -m 5 --anyauth -u "$BoxUSER:$BoxPW" http://$BoxIP:49000$location -H 'Content-Type: text/xml; charset="utf-8"' -H "SoapAction:$uri#$action" -d "<?xml version='1.0' encoding='utf-8'?><s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'><s:Body><u:$action xmlns:u='$uri'></u:$action></s:Body></s:Envelope>" | grep NewSSID | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
#-s silent
#-k --insecure      Allow connections to SSL sites without certs (H)
#-m 5 -m, --max-time SECONDS  Maximum time allowed for the transfer
#-u --user USER[:PASSWORD]  Server user and password
#-H --header LINE   Pass custom header LINE to server (H)
#-d  --data DATA     HTTP POST data (H)
# --anyauth       Pick "any" authentication method (H)

Clear-Host 
date

$BoxIP="fritz.box"
$BoxUSER="lodhar"
$BoxPW="Summary7"

$pair = "${BoxUSER}:${BoxPW}"



$location="/upnp/control/wlanconfig2"
$uri="urn:dslforum-org:service:WLANConfiguration:2"
$action='GetInfo'

[xml]$SOAPRequest="<?xml version='1.0' encoding='utf-8'?>
<s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'>
<s:Body><u:$action xmlns:u='$uri'>
</u:$action>
</s:Body>
</s:Envelope>"


	[String] $URL = "http://10.10.10.1:49000"


write-host "Préparer la demande SOAP pour la cible: $URL"
$soapWebRequest = [System.Net.WebRequest]::Create($URL) 
$soapWebRequest.Headers.Add("SOAPAction",'"urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1#GetAddonInfos"')
$soapWebRequest.ContentType = 'text/xml;charset="utf-8"'
$soapWebRequest.Accept      = "text/xml" 
$soapWebRequest.Method      = "POST" 
$soapWebRequest.Credentials = new-object System.Net.NetworkCredential("lodhar","Summary7")

write-host "Ecriture d'un XML de requête SOAP dans le RequestStream"
$requestStream = $soapWebRequest.GetRequestStream() 
[string]$SOAPRequest='
   <?xml version="1.0" encoding="utf-8"?>
   <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <soap:Body>
         <u:urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1 xmlns:u=GetAddonInfos />
      </soap:Body>
   </soap:Envelope>'
$SOAPRequestbytearray = ([system.Text.Encoding]::ASCII).GetBytes($SOAPRequest)
$requestStream.write($SOAPRequestbytearray,0,$SOAPRequestbytearray.count)
$requestStream.Close() 

write-host "Envoyer la demande"
$resp = $soapWebRequest.GetResponse() 
write-host "Verarbeite Ergebnisse"
$responseStream = $resp.GetResponseStream() 
$soapReader = [System.IO.StreamReader]($responseStream) 
$ReturnXml = [Xml] $soapReader.ReadToEnd() 
$responseStream.Close() 

write-host "Résultats"
$ReturnXml.Envelope.Body.GetAddonInfosResponse
write-host "FIN"

#$R=Invoke-WebRequest -Uri "http://10.10.10.1:49000"

<# $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)

# Create the Auth value as the method, a space, and then the encoded pair Method Base64String
$basicAuthValue = "Basic $base64"

# Create the header Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
$headers = @{ Authorization = $basicAuthValue }

# Invoke the web-request
Invoke-WebRequest -uri "https://10.10.10.1:49000" -Headers $headers
 #>


# Use the session variable that you created in Example 1. Output displays values for Headers, Cookies, Credentials, etc.
<# 
$FB
# Gets the first form in the Forms property of the HTTP response object in the $R variable, and saves it in the $Form variable.
$Form = $R.Forms[0]
# Pipes the form properties that are stored in the $Forms variable into the Format-List cmdlet, to display those properties in a list.
$Form | Format-List
# Displays the keys and values in the hash table (dictionary) object in the Fields property of the form.
$Form.fields
# The next two commands populate the values of the "email" and "pass" keys of the hash table in the Fields property of the form. Of course, you can replace the email and password with values that you want to use.
$Form.Fields["user"] = "lodhar"
$Form.Fields["pass"] = "Summary7"
# The final command uses the Invoke-WebRequest cmdlet to sign in to the Facebook web service.
$R=Invoke-WebRequest -Uri ("http://fritz.box:49000$location" + $Form.Action) -WebSession $FB -Method POST -Body $Form.Fields

 #>