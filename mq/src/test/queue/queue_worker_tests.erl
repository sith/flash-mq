-module('queue_worker_tests').
-include_lib("eunit/include/eunit.hrl").

happy_test_() ->
                {setup,
                fun setup/0,
                fun cleanup/1,
                ?_test( begin
                            gen_server:cast(test_queue,{add_listener,self()}),
                            Message = 'Test Message',
                            gen_server:cast(test_queue,{new_message,Message}),
                            receive
                                M-> ?assertMatch(Message,M)
                                after 100 -> ?assertMatch(true,false)
                            end
                        end)
                }.


no_listener_test_() ->
    {setup,
        fun setup/0,
        fun cleanup/1,
            ?_test( begin
                gen_server:cast(test_queue,{add_listener,self()}),
                Message = 'Test Message',
                gen_server:cast(test_queue,{new_message,Message}),
                receive
                    M-> ?assertMatch(true,false)
                    after 100 -> ?assert(true)
                end
            end)
    }.


setup () -> queue_worker:start(test_queue).

cleanup (_) -> queue_worker:stop(test_queue).






