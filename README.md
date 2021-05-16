# Send-ccm
Disse scriptene er for testing av klient maskiner
#Ping.ps1
Ping.ps1 
 - Henter ned alle maskinene i et domenet
 - Pinger alle klientene som er hentet ned fra domenet
 - Displayer hvilket OS som kjører på maskina.
 
#Send-ccm
Gitt at ccmevalreport ikke alltid blir kjørt når en ny maskin rulles ut, vil dette scriptet automatisk kjøre ccmeval slik
at en ny rapport blir opprettet.
 - Oppretter ny ccm rapport.
 
 #Read-ccm
 - Leser ccmevalrapport som blir opprettet av send-ccm
 - dette leser fra xml filen som blir

#Powershell script set_hostname og change_hostname

#Change_hostname 
Lager hostname og deployerer det til maskinen i TS
Dette scriptet er embeded

#Set_hostname
Lager hostname og deployerer det til maskin

.gitinore filen ignorer bla text filer og xml filer per dags dato. 
Dette er fordi det ikke var ønskelig at en skulle klunne pushe navn
på klienten og xml filen for klient status.
