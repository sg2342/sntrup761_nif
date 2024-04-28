#include <stdint.h>

#include <stdlib.h>
#include "erl_nif.h"
#include "sntrup761.h"



void random_func(void *ctx, size_t length, uint8_t *dst)
{
  arc4random_buf(dst, length); 
}

static ERL_NIF_TERM keypair_nif(ErlNifEnv* env, int argc,
			      const ERL_NIF_TERM argv[])
{
  ErlNifBinary pk, sk;
  char *ctx;

  if (!enif_alloc_binary(SNTRUP761_PUBLICKEY_SIZE, &pk) ||
      !enif_alloc_binary(SNTRUP761_SECRETKEY_SIZE, &sk))
    return enif_make_badarg(env);

  sntrup761_keypair(pk.data, sk.data, ctx,
                    (sntrup761_random_func*) random_func);

  return enif_make_tuple2(env, enif_make_binary(env, &pk),
			  enif_make_binary(env, &sk));

}

static ERL_NIF_TERM encap_nif(ErlNifEnv* env, int argc,
			      const ERL_NIF_TERM argv[])
{
  ErlNifBinary c, k, pk;
  char *ctx;
  
  if (!enif_inspect_binary(env, argv[0], &pk) ||
      pk.size != SNTRUP761_PUBLICKEY_SIZE ||
      !enif_alloc_binary(SNTRUP761_CIPHERTEXT_SIZE, &c) ||
      !enif_alloc_binary(SNTRUP761_SIZE, &k))
    return enif_make_badarg(env);
    
  sntrup761_enc(c.data, k.data, pk.data, ctx,
	        (sntrup761_random_func*) random_func);

  return enif_make_tuple2(env, enif_make_binary(env, &c),
			  enif_make_binary(env, &k));
}


static ERL_NIF_TERM decap_nif(ErlNifEnv* env, int argc,
			      const ERL_NIF_TERM argv[])
{
  ErlNifBinary k, c, sk;

   if (!enif_inspect_binary(env, argv[0], &c) ||
       c.size != SNTRUP761_CIPHERTEXT_SIZE ||
       !enif_inspect_binary(env, argv[1], &sk) ||
       sk.size != SNTRUP761_SECRETKEY_SIZE ||
      !enif_alloc_binary(SNTRUP761_SIZE, &k))
    return enif_make_badarg(env);

   sntrup761_dec(k.data, c.data, sk.data);

   return enif_make_binary(env, &k);
  
}

int on_load(ErlNifEnv* env, void** priv, ERL_NIF_TERM info) {
  return 0;
}

static int on_reload(ErlNifEnv* env, void** priv, ERL_NIF_TERM info) {
  return 0;
}

static int on_upgrade(ErlNifEnv* env, void** priv, void **old, ERL_NIF_TERM info) {
  return 0;
}

static ErlNifFunc nif_funcs[] = {
  {"keypair", 0, keypair_nif},
  {"encap", 1, encap_nif},
  {"decap", 2, decap_nif}
};

ERL_NIF_INIT(sntrup761_nif, nif_funcs, &on_load, &on_reload, &on_upgrade, NULL)
