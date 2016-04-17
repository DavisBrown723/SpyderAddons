#define MPATH                   \x\PREFIX\addons
#define CPATH(component)        MPATH\component

#define CDATA(component)        CPATH(component)\data
#define CUI(component)          CDATA(component)\ui
#define CIMAGES(component)      CDATA(component)\images
#define CSOUNDS(component)      CDATA(component)\sounds

#define PREVFOLDER              ..\

#define FUNC(function) PREFIX##_fnc_##function

#include <\x\cba\addons\main\script_macros.hpp>