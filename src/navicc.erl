%% -*- coding: utf-8 -*-
%% @author Batrak Denis <baden.i.ua@gmail.com>
%% @copyright 2013 Barak Denis.

%% @doc ernavicc startup code

-module(navicc).
-author('Batrak Denis <baden.i.ua@gmail.com>').

-export([start/0, start_link/0, stop/0]).
-export([start/2, stop/1]).

%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() ->
    navicc_sup:start_link().

%% @spec start() -> ok
%% @doc Start the pymwyfa_web server.
% Manual start over -s erlnavicc
start() ->
    application:load(navicc),

    {ok, Apps} = application:get_key(erlnavicc, applications),
    [startit(App) || App <- Apps],

    ok = application:start(navicc),

    % {ok, Trace} = application:get_env(erlnavicc, trace),
    % navitrace:start(Trace),
    ok.

start(normal, []) ->
    ok.

%% @spec stop() -> ok
%% @doc Stop the pymwyfa_web server.
stop() ->
    Res = application:stop(navicc),
    % % application:stop(ssl),
    % % application:stop(public_key),
    % application:stop(crypto),
    Res.

stop(_) ->
    ok.

% TODO: Перенести в resource

startit(App) ->
    % Res = application:start(App),
    application:ensure_all_started(App).
