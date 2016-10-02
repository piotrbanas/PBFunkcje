# PBFunkcje
Moduł z często używanymi funkcjami. Zbudowany wg. modelu narzędzi administracyjnych Dona Jones'a.

* Moduł udostępniany klientowi (najczęściej firmowemu IT) 
* Funkcje w nim zawarte gwarantują kompatybilność bardziej złożonych skrytpów (tzw. kontrolerów)
* Funkcje mają przypominać "cmdlety". Powinny:
  - być jak najbardziej ogólne
  - przestrzegać nazewnictwa czasownik-rzeczownik
  - oferować pomoc opartą na komentarzach (get-help)
  - przyjmować obiekty z pipe'a
  - oddawać okreslone obiekty do pipe'a
  - nie formatować prezezntacji danych
* Jeśli funkcja jest specyficzna dla danej firmy lub środowiska, powinno to być odzwierciedlone w jej nazwie
* Funkcje są narzędziami wykorzystywanymi przez "kontrolery" - skrypty sterujące. To w nich odbywa się formatowanie i prezentacja danych.
