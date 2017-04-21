copy memento.pl docker /Y
cd docker
docker build -t mementobackend .
docker tag mementobackend govnocod/memento:backend_0.2
docker push govnocod/memento:backend_0.2

pause

cd ../mement0_bot
copy target/memento-0.1-jar-with-dependencies.jar docker
cd docker
docker build -t mementobot .
docker tag mementobot govnocod/memento:bot_0.2
docker push govnocod/memento:bot_0.2

cd ../..


