-module(timelogger).
-export([start/0, logtime/3, viewall/1, calculatetimes/2]).

start() ->
    ets:new(times, [duplicate_bag]).

logtime(TableId, Code, Desc) ->
    ets:insert(TableId, {Code, Desc, erlang:time()}).

viewall(TableId) ->
    ets:tab2list(TableId).

calculatetimes(Time1, Time2) ->
    {A, B, C} = Time1,
    {X, Y, Z} = Time2,
    {A - X, B - Y, C - Z}.
    
