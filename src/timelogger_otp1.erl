-module(timelogger_otp1).
%% gen_server_mini_template
-behaviour(gen_server).
-export([start/0, stop/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).
%% Usage Functions
-export([logtime/2, viewall/0, calculatediff/2]).

%% Defines
-define(SERVER, ?MODULE).

start() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() ->
    gen_server:call(?MODULE, stop).

logtime(Code, Desc) ->
    gen_server:call(?MODULE, {logtime, Code, Desc}).

viewall() ->
    gen_server:call(?MODULE, viewall).

calculatediff(Code1, Code2) ->
		gen_server:call(?MODULE, {calculatediff, Code1, Code2}).

calculatetimes(Time1, Time2) ->
    {A, B, C} = Time1,
    {X, Y, Z} = Time2,
    {A - X, B - Y, C - Z}.

init([]) ->
		{ok, Ref} = dets:open_file(timelog, []),
		{ok, Ref}.

handle_call({logtime, Code, Desc}, _From, Table) ->
    Reply = dets:insert(Table, {Code, Desc, erlang:time()}),
    {reply, Reply, Table};
handle_call(viewall, _From, Table) ->
		EtsTable = ets:new(times, []),
    Reply = ets:tab2list(dets:to_ets(Table, EtsTable)),
		ets:delete(EtsTable),
    {reply, Reply, Table};
handle_call({calculatediff, Code1, Code2}, _From, Table) ->
		{_, _, Time1} = hd(dets:lookup(Table, Code1)),
		{_, _, Time2} = hd(dets:lookup(Table, Code2)),
		Reply = calculatetimes(Time1, Time2),
		{reply, Reply, Table};
handle_call(stop, _From, Table) ->
		dets:close(Table),
    {stop, normal, stopped, Table}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, Extra) -> {ok, State}.
