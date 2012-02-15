-module('queue_worker') .
-export([ start / 1 , stop / 1 ]) .
-export([ terminate / 2 , handle_cast / 2 ,init/1]) .
-behavior(gen_server) .
-include_lib("mq/include/queue.hrl").

%% Start/Stop
start (QueueName) ->
    Queue = #queue{name=QueueName},
    gen_server:start_link({local , QueueName} , ?MODULE , Queue , [ ]) .

stop (QueueName) ->
    gen_server : cast (QueueName , stop) .


%%Callback functions

init (Queue) -> {ok , Queue}.

terminate (_Reason ,Queue) ->ok .

handle_cast (stop , Queue) ->{stop , normal , Queue};

handle_cast({add_listener,Listener},#queue{name = Name,listeners=[]} = Queue) ->
    {noreply, Queue#queue{listeners = [Listener]}};

handle_cast({add_listener,Listener},#queue{name = Name,listeners=Listeners} = Queue) ->
    {noreply, Queue#queue{listeners = Listeners ++ [Listener]}};


handle_cast({new_message,Message},#queue{listeners=[]} = Queue) -> {noreply, Queue};

handle_cast({new_message,Message},#queue{listeners=[H|_]} = Queue) ->
    H ! Message,
    {noreply, Queue}.
