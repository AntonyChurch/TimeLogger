-module(timelogger).
-export([start/0, logtime/3, viewall/1, calculatetime/3, findtime/2]).

start() ->
    ets:new(times, [duplicate_bag]).

logtime(TableId, Code, Desc) ->
    ets:insert(TableId, {Code, Desc, erlang:time()}).

calculatetime(TableId, Code1, Code2) ->
    {_, _, Time1} = hd(ets:lookup(TableId, Code1)),
    {_, _, Time2} = hd(ets:lookup(TableId, Code2)),
    calculatetimes(Time1, Time2).

viewall(TableId) ->
    ets:tab2list(TableId).

findtime(TableId, Code) ->
    ets:lookup(TableId, Code).

calculatetimes(Time1, Time2) ->
    {A, B, C} = Time1,
    {X, Y, Z} = Time2,
    {A - X, B - Y, C - Z}.
    
