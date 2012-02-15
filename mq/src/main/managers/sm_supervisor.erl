-module('sm_supervisor').
-export([start/0]).
-export([init/1]).
-behavior(supervisor).


start() -> supervisor:start_link({local, ?MODULE},?MODULE,[]).


init([]) -> QueuesSupervisor = {queue_s,{queues_supervisor, start, []},
            permanent, 2000, supervisor, [queues_supervisor,queue_worker]},
            {ok,{{one_for_one,1,1}, [QueuesSupervisor]}}.
