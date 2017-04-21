#!/usr/bin/perl
use strict;
use WWW::Telegram::BotAPI;

my $api = WWW::Telegram::BotAPI->new(
# указываем токен вашего бота
token => '343803002:AAHXboC2zSqUiTEr7NaEIh-krt3gE2DMLhM'
);
# получаем очередь сообщений. По умолчанию, отдается массив не более 100
$api->getUpdates();

# включаем бесконечный цикл и погнали обрабатывать
while (1) {
# если в очереди ничего нет, делаем задержку на 1 секунду и начинаем все сначала.
if ( scalar @{ ( $api->getUpdates->{result} ) } == 0 ) { sleep 1; next; }

# ----
my $updateid;
#если в очереди что-то есть начинаем обрабатывать этот массив
for ( my $i = 0 ; $i < scalar @{ ( $api->getUpdates->{result} ) } ; $i++ ) {
# просто всем шлем ответ в цитате его запроса
$api->SendMessage(
{
chat_id => $api->getUpdates->{result}[$i]{message}{from}{id},
reply_to_message_id => $api->getUpdates->{result}[$i]{message}->{message_id},
text => $api->getUpdates->{result}[$i]{message}{text}
}
);

$updateid = ( $api->getUpdates->{result}[$i]->{update_id} );
sleep 1;
}
# делаем апдейт очереди, пометив обработанные сообщения путем задания offset
$api->getUpdates( { offset => $updateid + 1 } );
next;
}
