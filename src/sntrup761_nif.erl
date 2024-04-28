-module(sntrup761_nif).

-export([keypair/0, encap/1, decap/2]).

-on_load(init/0).

-define(APPNAME, ?MODULE).
-define(LIBNAME, ?APPNAME).


-spec keypair() -> {PublicKey :: <<_:9264>>, SecretKey :: <<_:14104>>}.
keypair() ->
    erlang:nif_error({nif_not_loaded, module, ?MODULE, line, ?LINE}).


-spec encap(PublicKey :: <<_:9264>>) ->
	  {CiperText :: <<_:8312>>, SharedKey :: <<_:256>>}.
encap(_PublicKey) ->
    erlang:nif_error({nif_not_loaded, module, ?MODULE, line, ?LINE}).


-spec decap(CiperText :: <<_:8312>>, SecretKey :: <<_:14104>>) ->
	  SharedKey :: <<_:256>>.
decap(_CipherText, _SecretKey) ->
    erlang:nif_error({nif_not_loaded, module, ?MODULE, line, ?LINE}).


init() ->
    SoName =
	case code:priv_dir(?APPNAME) of
	    {error, bad_name} ->
		case filelib:is_dir(filename:join(["..", priv])) of
		    true -> filename:join(["..", priv, ?LIBNAME]);
		    _ -> filename:join([priv, ?LIBNAME])
		end;
	    Dir -> filename:join(Dir, ?LIBNAME)
	end,
    ok = erlang:load_nif(SoName, 0).
