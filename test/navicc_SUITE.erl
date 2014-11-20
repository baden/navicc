-module(navicc_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

suite() ->
    [{timetrap,{minutes,1}}].

all() -> [
    {group, single},
    {group, replication}
].

groups() ->
    [
        {single, [parallel], [test1, test2]},
        {replication, [parallel], [test3]}
    ].

init_per_suite(Config) ->
    error_logger:tty(false),
    {ok, Modules} = application:ensure_all_started(navicc),
    {ok, GunModules} = application:ensure_all_started(gun),
    [{modules, Modules ++ GunModules} | Config].

end_per_suite(Config) ->
    Modules = ?config(modules, Config),
    [application:stop(Module) || Module <- lists:reverse(Modules)],
    application:unload(navicc),
    error_logger:tty(true),
    ok.

% init_per_testcase(_Case, Config) ->
%     % TODO: Authorize here?
%     Config.
%
% end_per_testcase(_Case, Config) ->
%     Config.

init_per_group(_Group, Config) ->
    Config.

end_per_group(_Group, Config) ->
    Config.

test1(_Config) ->
    ok.

test2(_Config) ->
    ok.

test3(_Config) ->
    ok.
