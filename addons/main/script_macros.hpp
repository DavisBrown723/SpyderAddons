#define MPATH                   \PPREFIX\PREFIX\addons
#define CPATH(component)        MPATH\component

#define CDATA(component)        QUOTE(CPATH(component)\data)
#define CUI(component)          QUOTE(CDATA(component)\ui)
#define CIMAGES(component)      QUOTE(CDATA(component)\images)
#define CSOUNDS(component)      QUOTE(CDATA(component)\sounds)

#define PREVFOLDER              ..\

#define FUNC(function) PREFIX##_fnc_##function

#define HASH_CREATE(array)                  array call FUNC(hashCreate)
#define HASH_SET(hash, key, val)            [hash, key, val] call FUNC(hashSet)
#define HASH_GET(hash, key, default)        [hash, key, default] call FUNC(hashGet)
#define HASH_REM(hash, key)                 [hash, key] call FUNC(hashRem)
#define IS_HASH(array)                      array call FUNC(isHash)

#include <\x\cba\addons\main\script_macros.hpp>