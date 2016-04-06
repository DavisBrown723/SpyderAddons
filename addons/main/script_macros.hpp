#define MPATH                   \x\PREFIX\addons
#define CPATH(component)        MPATH\component

#define CDATA(component)        CPATH(component)\data
#define CUI(component)          CDATA(component)\ui
#define CIMAGES(component)      CDATA(component)\images
#define CSOUNDS(component)      CDATA(component)\sounds

#define PREVFOLDER              ..\

#define FUNC(function) PREFIX##_fnc_##function

#define HASH_CREATE(array)                  array call FUNC(hashCreate)
#define HASH_SET(hash, key, val)            [hash, key, val] call FUNC(hashSet)
#define HASH_GET(hash, key, default)        [hash, key, default] call FUNC(hashGet)
#define HASH_REM(hash, key)                 [hash, key] call FUNC(hashRem)
#define IS_HASH(array)                      array call FUNC(isHash)

#include <\x\cba\addons\main\script_macros.hpp>