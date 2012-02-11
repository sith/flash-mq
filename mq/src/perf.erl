-module('perf').
-export([send/1,prepare/0]).
-export([send/2,get_message/1]).

prepare() ->
    queues_supervisor:start(),
    queues_supervisor:start_queue(test_queue),
    queues_supervisor:add_listener(test_queue,self()).

send(N) ->
    Send = timer:tc(perf,send,[N,test_queue]),
    Receive = timer:tc(perf,get_message,[0]),
    {Send,Receive}.


send(0,_)-> ok;
send(N, Queue) ->
    message_sender:send(Queue,'Hello world'),
    send(N-1,Queue).


get_message(Count) ->
    receive
        Message -> get_message(Count+1)
        after 10 -> Count
    end.





