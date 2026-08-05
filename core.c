#include <stdio.h>
#include <stdlib.h>

#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"

#include "timepass.h"

int main() {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  int status = luaL_loadbuffer(L, (const char *)luaJIT_BC_timepass_script,
                               luaJIT_BC_timepass_script_SIZE, "TimePass");

  if (status == 0) {
    status = lua_pcall(L, 0, LUA_MULTRET, 0);
  }

  if (status != 0) {
    fprintf(stderr, "Error: %s\n", lua_tostring(L, -1));
    lua_pop(L, 1);
  }

  lua_close(L);
  return status == 0 ? 0 : 1;
}
