-module(timelogger_otp1).
%% gen_server_mini_template
-behaviour(gen_server).
-export([start/0, stop/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).
%% Usage Functions
-export([logtime/2, viewall/0]).

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

init([]) -> {ok, ets:new(?MODULE, [])}.

handle_call({logtime, Code, Desc}, _From, Table) -> 
    Reply = ets:insert(Table, {Code, Desc, erlang:time()}),
    {reply, Reply, Table};
handle_call(viewall, _From, Table) -> 
    Reply = ets:tab2list(Table),
    {reply, Reply, Table};
handle_call(stop, _From, Table) -> 
    {stop, normal, stopped, Table}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, Extra) -> {ok, State}.

