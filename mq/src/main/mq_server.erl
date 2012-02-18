-module('mq_server').
-behaviour(application).
-export([start/2, stop/1]).

start(_Type, StartArgs) ->
    sm_supervisor:start().

stop(_State) ->
    ok.
