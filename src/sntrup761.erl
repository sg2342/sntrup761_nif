-module(sntrup761).

-export([keypair/0, encap/1, decap/2]).

-type pk() :: <<_:9264>>.
-type sk() :: <<_:14104>>.
-type ct() :: <<_:8312>>.
-type k()  :: <<_:256>>.

-export_type([pk/0, sk/0, ct/0, k/0]).

%% pk,sk = KEM_KeyGen()
-spec keypair() -> {pk(), sk()}.
keypair() -> sntrup761_nif:keypair().


%% c,k = Encap(pk)
-spec encap(pk()) -> {ct(), k()}.
encap(PK) when is_binary(PK), byte_size(PK) == 1158 ->
    sntrup761_nif:encap(PK).


%% k = Decap(c,sk)
-spec decap(ct(), sk()) -> k().
decap(CT, SK)
  when is_binary(CT), byte_size(CT) == 1039,
       is_binary(SK), byte_size(SK) == 1763 ->
    sntrup761_nif:decap(CT, SK).
