#include <\x\cba\addons\main\script_macros.hpp>

#define MPATH                   \x\PREFIX\addons
#define CPATH(component)        MPATH\component

#define CDATA(component)        CPATH(component)\data
#define CUI(component)          CDATA(component)\ui
#define CIMAGES(component)      CDATA(component)\images
#define CSOUNDS(component)      CDATA(component)\sounds

#define PREVFOLDER              ..\

#define FUNC(function)          PREFIX##_fnc_##function
#define QFUNC(function)         QUOTE(FUNC(function))

#define getControl(disp,ctrl)       (findDisplay disp displayCtrl ctrl)
#define getSelData(ctrlID)          (lbData [ctrlID,lbCurSel ctrlID])
#define ctrlGetSelData(ctrl)        (ctrl lbData (lbCurSel ctrl))

// oop

#define SUPER(mod)      (call compile ([mod,"superclass"] call FUNC(hashGet)))
#define CLASS(mod)      (call compile ([mod,"mainclass"] call FUNC(hashGet)))

#define init_OOP()      scopename "main"; \
                        private ["_result"];

#define method(name)    case name:
#define defaultMethod() default {_result = _this call SUPERCLASS};


#define return(var)     _result = var;\
                        breakto "main"

#define return          _result =

// ui

#define MOD_COLOR_MAIN      {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])",0.7}