copy /y ..\memento.pl .
copy /y ..\other.memento .
copy /y ..\shortcut.memento .


docker build -t mgstr/memento-cli:latest .
