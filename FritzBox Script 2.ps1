# https://www.msxfaq.de/code/powershell/pssoap.htm

[String] $URL = "http://10.10.10.1:49000/upnp/control/WANCommonIFC1"



write-host "SOAP Request vorbereiten an Ziel: $URL"
$soapWebRequest = [System.Net.WebRequest]::Create($URL) 
$soapWebRequest.Headers.Add("SOAPAction",'"urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1#GetAddonInfos"')
$soapWebRequest.ContentType = 'text/xml;charset="utf-8"'
$soapWebRequest.Accept      = "text/xml" 
$soapWebRequest.Method      = "POST" 
$soapWebRequest.Credentials = new-object System.Net.NetworkCredential("lodhar","Summary7")

write-host "SOAP Request XML in den RequestStream schreiben"
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

write-host "Sende Request"
$resp = $soapWebRequest.GetResponse() 
write-host "Verarbeite Ergebnisse"
$responseStream = $resp.GetResponseStream() 
$soapReader = [System.IO.StreamReader]($responseStream) 
$ReturnXml = [Xml] $soapReader.ReadToEnd() 
$responseStream.Close() 

write-host "Ergebnisse"
$ReturnXml.Envelope.Body.GetAddonInfosResponse
write-host "Ende"