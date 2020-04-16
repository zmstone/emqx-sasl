%%--------------------------------------------------------------------
%% Copyright (c) 2020 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emqx_sasl).

-export([ load/0
        , unload/0
        , init/0
        , check/3
        , supported/0
        ]).

load() ->
    emqx:hook('client.enhanced_authenticate', fun ?MODULE:check/3, []).

unload() ->
    emqx:unhook('client.enhanced_authenticate', fun ?MODULE:check/3).

init() ->
    emqx_sasl_scram:init().

check(Method, Data, Cache) ->
    case Method of
        <<"SCRAM-SHA-1">> ->
            emqx_sasl_scram:check(Data, Cache);
        _ ->
            {error, unsupported_mechanism}
    end.

supported() ->
    [<<"SCRAM-SHA-1">>].
