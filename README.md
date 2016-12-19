# PBFunkcje
Moduł z często używanymi funkcjami.
* Moduł udostępniany klientowi (najczęściej firmowemu IT) 
* Funkcje w nim zawarte gwarantują kompatybilność bardziej złożonych skryptów (tzw. kontrolerów)
* Funkcje mają przypominać "cmdlety". Powinny:
  - być jak najbardziej ogólne
  - przestrzegać nazewnictwa czasownik-rzeczownik
  - oferować pomoc opartą na komentarzach (get-help)
  - przyjmować obiekty z pipe'a
  - oddawać okreslone obiekty do pipe'a
  - nie formatować prezezntacji danych
* Jeśli funkcja jest specyficzna dla danej firmy lub środowiska, powinno to być odzwierciedlone w jej nazwie
* Funkcje są narzędziami wykorzystywanymi przez "kontrolery" - skrypty sterujące. To w nich odbywa się formatowanie i prezentacja danych.

Przykładowe funkcje:

  <b>Get-wmiUrz</b> Inwentaryzator komputerów i urządzeń za pomocą WMI.
  
  <b>Get-HDDinfo</b> Inwentaryzator twardych dysków.
  
  <b>Get-ADpassDate</b> oraz <b>Set-ADpassDate</b> Pobieranie oraz resetowanie daty ważności hasła domenowego.

  <b>Get-AdminPass</b> Funkcja uzupełniająca do Local Administrator Password Solution.
  
  <b>New-PassFile, New-Mount</b> oraz <b>New-Sesja</b> Funkcje zarządzające przechowywaniem i budowaniem poświadczeń pozadomenowych oraz połączeniami do celów automatyzacyjnych.
  
  <b>Enter-CiscoVPN</b> Automatyzacja połączeń Cisco AnyConnect bez przechowywania hasła.
  
  <b>Open-Xlsx, Set-Xlsx i Save-xlsx</b> Edycja plików excel - np. wypełnianie checklist.
  
  <b>Import-Cennik</b> Konwersja danych tekstowych do postaci obiektowej.
  
  <b>Get-Droplet i Set-Droplet</b> Przykład interakcji z API dostawcy infrastruktury chmurowej - w tym przypadku: Digital Ocean.
