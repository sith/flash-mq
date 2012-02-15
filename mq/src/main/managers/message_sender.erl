-module('message_sender').
-export([send/2]).

send(Queue,Message) -> gen_server:cast(Queue,{new_message,Message}).
