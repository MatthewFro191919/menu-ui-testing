#!/bin/sh
# SETUP FOR MAC AND LINUX SYSTEMS!!!
# REMINDER THAT YOU NEED HAXE INSTALLED PRIOR TO USING THIS
# https://haxe.org/download
cd ..
echo Makking the main haxelib and setuping folder in same time..
mkdir ~/haxelib && haxelib setup ~/haxelib
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
          haxelib install hxcpp > nul
          haxelib install lime 8.0.0
          haxelib install openfl
          haxelib install flixel 4.11.0
          haxelib run lime setup flixel
          haxelib run lime setup         
          haxelib remove flixel-addons
          haxelib remove flixel-tools
          haxelib remove flixel-ui
          haxelib install flixel-tools
          haxelib install flixel-ui
          haxelib install flixel-addons 3.2.0
          haxelib install tjson
          haxelib install hxjsonast
          haxelib install hxCodec 2.5.1
          haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit
          haxelib install hscript
          haxelib git SScript https://github.com/AtonyGit/SScript-Old.git
          haxelib git hscript-ex https://github.com/ianharrigan/hscript-ex
          haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
          haxelib git hxvm-luajit https://github.com/nebulazorua/hxvm-luajit
          haxelib git faxe https://github.com/uhrobots/faxe
          haxelib git polymod https://github.com/larsiusprime/polymod.git
          haxelib install hxcpp-debug-server
          haxelib git hxdiscord_rpc https://github.com/MAJigsaw77/hxdiscord_rpc.git
          haxelib git SScript https://github.com/AtonyGit/SScript-Old.git
          haxelib git flxanimate https://github.com/Dot-Stuff/flxanimate
echo Finished!
