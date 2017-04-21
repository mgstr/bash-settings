copy memento.pl docker /Y
cd docker
REM docker build -t mementobackend .
REM docker tag mementobackend govnocod/memento:backend_0.2
REM docker push govnocod/memento:backend_0.2

cd ../mement0_bot
jar uvf target/memento-0.1-jar-with-dependencies.jar target/classes/*.class
copy target/memento-0.1-jar-with-dependencies.jar docker
cd docker
REM docker build -t mementobot .
REM docker tag mementobot govnocod/memento:bot_0.2
REM docker push govnocod/memento:bot_0.2

cd ../..


