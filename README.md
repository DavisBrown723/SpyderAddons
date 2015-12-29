<p align="center">
    <img src="https://github.com/SpyderBlack723/SpyderAddons/blob/develop/images/LogoBlack.png" width="265">
</p>

<p align="center">
A collection of modules to aid mission makers in adding depth to their missions.
</p>
<p align="center">
I started this project so that I could use it as a method of learning the addon structure. Please report any bugs/issues to me and I'll attempt to fix them as soon as possible.
</p>

<p align="center">
     <a href="https://forums.bistudio.com/user/802166-spyderblack723">BIF Account</a></strong></sup>
</p>

#Features

####Civilian Interaction
  - Integrated with ALiVE
  - Order civilians to "Get Down", "Go Away", and "Detain" them in order to maintain control over the situation.
  - Ask civilians about personal details such as where they live in order to collect intel.
  - Ask civilians about insurgent activity in the area.
  - Ask civilians about nearby civilians that may be preparing to commit an act of terror.
  - All information is persistent thanks to ALiVE's Civilian Population system.
   - Usage: Define insurgent faction being used
   - Requires: ALiVE

####Loadout Organizer
  - Save, Load, Delete, and Name loadouts
  - View class gear before loading it
  - Transfer loadouts to other players and AI
  - Access Virtual Arsenal
  - Load class on respawn
   - Usage: Sync module to object to add the loadout manager action to it

####Recruitment
  - Specify entire factions of units to whitelist
  - Whitelist units
  - Blacklist units
  - View unit gear before recruiting them
  - Set a maximum limit of units that a player may recruit into his squad at one time
   - Usage: Sync module to object to add recruit action to it

####Detection
 - Easily create scenarios with players as the guerilla fighters
 - Define hostile sides
 - Define cooldown timer
 - Restricted areas
 - Customize whether players can drive offroad without being hostile
 - Customize speed limit
 - Restrict certain vehicles/faction vehicles as hostile
 - Define incognito vehicles which allow you to pose as the enemy
 - Define detection values for each on foot, in vehicle, and incognito vehicles
  - Usage: Sync module to players to have them tracked by the detection system

####Vehicle Spawner
 - Specify entire factions of vehicles to whitelist
 - Whitelist vehicles
 - Blacklist vehicles
 - View vehicle characteristics such as top speed, number of passenger seats, fuel consumption and more prior to spawning it.
  - Usage: Sync module to object to add vehicle spawner action to it

####Ambiance
 - Randomly spawned animal herds, civilian vehicles, undercover enemy vehicles
 - Units are only spawned when players are near
 - Define spawn ranges
 - Whitelist/Blacklist markers
 - Define locations where ambiance will exist
 - Enable/disable each feature
 - Each feature is customizable to fit the mission maker's preferences.
  - Usage: Place module and input preferred parameters

####Insurgency (WIP)
 - Establish recruitment HQ's, weapon depots, and IED factories.
 - Recruit civilians
 - Plan coordinated assaults
  - Usage: Sync module to players to enable them to have access to insurgent abilities.
