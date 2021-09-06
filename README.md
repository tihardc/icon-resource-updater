# icon-resource-updater

This updates the icon used by a Windows .exe file. It will not update the .ico
file of a *running* Windows exe file, Windows doesn't allow that.

It is written in Object Pascal, but is easily portable once you know how it's done.

It is sometimes objected that such a routine could be used for nefarious purposes.
But utilities are already freely available that allow you to change the icon of an .exe
file. This procedure just lets you do so in code. It offers nothing to a criminal
enterprise that those utilities don't already offer, but for the developer it has the 
following use-case:

A program can of course be modifiable as much as you like by files telling it on startup 
which bits do what. This means that you can produce all the different versions you want 
for various use-cases all using the same .exe file, and they can all have the same autoupdater 
pointing to the same .exe file on the internet for updates and bugfixes.

*Except* that the icon is baked into the .exe file which means if you just did that then 
every version would have to have the same icon, even though you might well want more than one 
version on the same computer.

Hence the icon updater.

