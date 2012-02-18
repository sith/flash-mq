-module('queues_supervisor_tests').
-include_lib("eunit/include/eunit.hrl").

start_sp_not_queue_test_() ->
    {spawn, {setup,
            fun setup/0,
            fun cleanup/1,
            ?_test( begin
                ?assertMatch(false,queues_supervisor:is_queue_alive(not_queue))
            end)
        }}.

start_sp_sys_queue_test_() ->
    {spawn, {setup,
            fun setup/0,
            fun cleanup/1,
            ?_test( begin
                 ?assert(queues_supervisor:is_queue_alive(sys_queue))
            end)
        }}.


start_stop_queue_test_()->
    {spawn,
        {setup,
            fun setup/0,
            fun cleanup/1,
            ?_test( begin
                ?assert(queues_supervisor:is_queue_alive(sys_queue)),
                queues_supervisor:start_queue(new_queue),
                ?assert(queues_supervisor:is_queue_alive(new_queue)),
                queues_supervisor:stop_queue(new_queue),
                ?assertMatch(false,queues_supervisor:is_queue_alive(not_queue))
            end)
    }}.



setup () -> queues_supervisor:start().

cleanup (_) -> exit(whereis(queues_supervisor), normal).
