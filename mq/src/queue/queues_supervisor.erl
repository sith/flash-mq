-module('queues_supervisor').
-export([start/0,init/1,start_queue/1, stop_queue/1]).
-behavior(supervisor).


start() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) -> UsrChild = {sys_queue,{queue_worker, start, [sys_queue]},
            permanent, 2000, worker, [queue_worker]},
            {ok,{{one_for_one,1,1}, [UsrChild]}}.


start_queue(QueueName) ->
    Queue = {QueueName,{queue_worker, start, [QueueName]},
    permanent, 2000, worker, [queue_worker]},
    supervisor:start_child(?MODULE, Queue).


stop_queue(QueueName) -> supervisor:terminate_child(?MODULE, QueueName).
