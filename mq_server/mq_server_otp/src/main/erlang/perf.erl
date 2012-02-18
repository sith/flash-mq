-module('perf').
-export([send/1,prepare/0,send_seria/2]).
-export([send/2,get_message/2]).

prepare() ->
    queues_supervisor:start(),
    queues_supervisor:start_queue(test_queue),
    queues_supervisor:add_listener(test_queue,self()).

send(N) ->
    Send = timer:tc(perf,send,[N,test_queue]),
    Receive = timer:tc(perf,get_message,[0,N]),
    {Send,Receive}.


send(0,_)-> ok;
send(N, Queue) ->
    message_sender:send(Queue,'Hello world'),
    send(N-1,Queue).

get_message(Count,N) when Count == N -> Count;
get_message(Count,N) ->
    receive
        Message -> get_message(Count+1,N)
    end.


print_stat(L) ->
    Length = length(L),
    Min = lists:min(L),
    Max = lists:max(L),
    Med = lists:nth(round((Length / 2)), lists:sort(L)),
    Avg = round(lists:foldl(fun(X, Sum) -> X + Sum end, 0, L) / Length),
    io:format("Range: ~b - ~b mics~n"
        "Median: ~b mics~n"
        "Average: ~b mics~n",
        [Min, Max, Med, Avg]),
    Med.

send_seria(N,M) ->
    {Req,Res} = send_seria(N,M,[],[]),
    print_stat(Req),
    print_stat(Res).



send_seria(N,0,ReqList,RespList) -> {ReqList,RespList};
send_seria(N,M,ReqList,RespList) ->
    {{Req,_},{Resp,_}}=send(N),
    send_seria(N,M-1,ReqList++[Req],RespList++[Resp]).




