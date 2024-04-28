# Streamlined NTRU Prime: sntrup761 NIF

[![Build Status](https://github.com/sg2342/sntrup761_nif/workflows/Common%20Test/badge.svg)](https://github.com/sg2342/sntrup761_nif/actions?query=branch%3Amain+workflow%3A"Common+Test")

 * c_src/sntrup761.c and c_src/sntrup761.h are (unmodified) from [the IETF draft](https://www.ietf.org/archive/id/draft-josefsson-ntruprime-streamlined-00.html).
 * c_src/hash_sha512_cp.c is from libsodium


## Build

    $ rebar3 compile

## Test

    $ rebar3 check
