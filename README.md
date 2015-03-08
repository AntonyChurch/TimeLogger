# TimeLogger
Erlang console based time logger.

##To Use
This software is written with rebar so all compilation and running can be done the standard way.
1. Call timelogger:start(). Storing the return value, it is the Table Id used throughout the application.
2. Call timelogger:logtime(TableId, name, description). Do this as many times as needed.
3. To log all of your time call timelogger:viewall(TableId).

##Todo List
1. Migrate implement using OTP Server
2. Get time between tasks calculated
3. Implement tests.
