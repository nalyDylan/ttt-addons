# Map Fixed
Edits in many of the popular TTT maps, notably a lot of maps use custom door sounds which have a long standing source engine bug causing their sound to loop constantly in 0.1 second intervals. This fixes some of those maps and the notation is pretty simple to add more maps.

Notice the file is an array of functions, Lua does not support switch-case statements and so this code emulates that.

Also, some of the edits reference custom entities which are not in this repo(yet). Their code is old and a mess and I'm not ready to publish them in their current state. ttt_confetti and the baloon entities at the bottom specifically.
