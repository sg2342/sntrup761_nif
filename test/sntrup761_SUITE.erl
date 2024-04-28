-module(sntrup761_SUITE).

-export([init_per_suite/1, end_per_suite/1,
	 init_per_testcase/2, end_per_testcase/2,
	 all/0, suite/0,
	 kat/1, e2e/1]).

-include_lib("common_test/include/ct.hrl").

suite() -> [{timetrap, {seconds, 30}}].


init_per_suite(Config) -> Config.


end_per_suite(_Config) -> ok.


init_per_testcase(_TestCase, Config) -> Config.


end_per_testcase(_TestCase, _Config) -> ok.


all() -> [kat, e2e].


kat(Config) ->
    D = ?config(data_dir, Config),
    {ok, [SK, CT, SS]} = file:consult(filename:join(D, "kat")),
    K = sntrup761:decap(binary:decode_hex(CT), binary:decode_hex(SK)),
    K = binary:decode_hex(SS).


e2e(_Config) ->
    {PK, SK} = sntrup761:keypair(),
    {CT, K} = sntrup761:encap(PK),
    K = sntrup761:decap(CT, SK).
