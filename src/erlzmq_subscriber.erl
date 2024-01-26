-module(erlzmq_subscriber).

-export([start/0, start/2, send/2, client/2]).

start() ->
    start("localhost", 8091).

start(Host, Port) ->
    spawn(?MODULE, client, [Host, Port]).

send(Pid, Msg) ->
    Pid ! {send, Msg},
    ok.

client(Host, Port) ->
    io:format("Client connects to ~p:~p~n", [Host, Port]),
    application:start(chumak),
    {ok, Socket} = chumak:socket(req),
    chumak:connect(Socket, tcp, Host, Port),
    loop(Socket).

loop(Socket) ->
    receive
        {send, Msg} ->
            io:format("Client send ~p~n", [Msg]),
            ok = chumak:send(Socket, Msg),
            loop(Socket)
    after 200 ->
            loop(Socket)
    end.
