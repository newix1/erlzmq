-module(erlzmq_dialer).
-export([start_server/0, start_server/2]).

%% You can start server on any port and host. To do it use erlzmq_dialer:start_server(Host, Port) 
%% or erlzmq_dialer:start_server w/o any arguments to start server on default port 8091 and "localhost"
start_server() ->
    start_server("localhost", 8091).

start_server(Host, Port) ->
    application:start(chumak),
    {ok, Socket} = chumak:socket(rep),

    {ok, _BindPid} = chumak:bind(Socket, tcp, Host, Port),
    handle(Socket).

%% Displaying in shell
handle(Socket) ->
    Msg = chumak:recv(Socket),
    io:format("Server got message: ~p~n", [Msg]),
    handle(Socket).
