-module('queues_supervisor').
-export([start/0, init/1, start_queue/1, stop_queue/1, add_listener/2, is_queue_alive/1]).
-behavior(supervisor).


start() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) -> SysQueue = {sys_queue,{queue_worker, start, [sys_queue]},
            permanent, 2000, worker, [queue_worker]},
            {ok,{{one_for_one,1,1}, [SysQueue]}}.


start_queue(QueueName) ->
    Queue = {QueueName,{queue_worker, start, [QueueName]},
    permanent, 2000, worker, [queue_worker]},
    supervisor:start_child(?MODULE, Queue).


stop_queue(QueueName) -> supervisor:terminate_child(?MODULE, QueueName).

add_listener(Queue, Listener) -> gen_server:cast(Queue,{add_listener,Listener}).
remove_listener(Queue, Listener) -> gen_server:cast(Queue,{remove_listener,Listener}).


is_queue_alive(QueueName) ->
    try process_info(whereis(QueueName)) of
       Val -> case Val of
                    undefined -> false;
                    _ -> true
              end
    catch
        error:badarg -> false
    end.


