#CLF
By SouD

Version: 1.0

Date: 04/11/2012

##Description
CLF, or CombatLogFixer is an addon for World of Warcraft
version 2.4.3, commonly known as TBC (The Burning Crusade).
This is a pretty simple addon which clears your combat log
on an adjustable interval as well as during certain events.

The need for this addon arises from the known bug introduced
with 2.4 where the COMBAT_LOG_EVENT_UNFILTERED stops firing
and thus cripples addons reliant on said event.

##Installing
Download the project as .zip. Unzip this in your AddOn folder.
The final result should look something like this:
Drive:\PATH_TO_WOW_INSTALLATION\Interface\AddOn\CLF

##Usage
While ingame, type the following: "/clf arg", where arg is any unsigned number. This command will set the
time between updates, a lower number will update more often but
consume more cpu-power, where a higher number is the reverse.
This is the only current functionality.

##Future
1. Fix zoning bug
2. Add more functionality? (Options, settings etc.)
