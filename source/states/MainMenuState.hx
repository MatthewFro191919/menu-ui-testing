package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.3'; // This is also used for Discord RPC
	public static var extraKeysVersion:String = '0.4.9'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var character:Character;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [
		'story_mode',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;
		var sky = new FlxSprite(-850, 1550);
		sky.frames = Paths.getSparrowAtlas('god_bg');
		sky.animation.addByPrefix('sky', "bg", 30);
		sky.setGraphicSize(Std.int(sky.width * 0.8));
		sky.animation.play('sky');
		sky.scrollFactor.set(0.1, 0.1);
		sky.antialiasing = true;
		sky.updateHitbox();
		sky.screenCenter(XY);
		sky.y -= 100;
		sky.x -= 50;
		add(sky);

		var bgcloud = new FlxSprite(-850, 1150);
		bgcloud.frames = Paths.getSparrowAtlas('god_bg');
		bgcloud.animation.addByPrefix('c', "cloud_smol", 30);
		bgcloud.animation.play('c');
		bgcloud.scrollFactor.set(0.3, 0.3);
		bgcloud.antialiasing = true;
		bgcloud.screenCenter(XY);
		bgcloud.y += 250;
		add(bgcloud);

		var fgcloud = new FlxSprite(-1150, -500);
		fgcloud.x -= 300;
		fgcloud.frames = Paths.getSparrowAtlas('god_bg');
		fgcloud.animation.addByPrefix('c', "cloud_big", 30);
		fgcloud.animation.play('c');
		fgcloud.scrollFactor.set(0.9, 0.9);
		fgcloud.antialiasing = true;
		fgcloud.screenCenter(XY);
		fgcloud.y += 100;
		add(fgcloud);

		add(new MansionDebris(FlxG.width/2+300, FlxG.height/2+-800, 'norm', 0.4, 1, 0, 1));
		add(new MansionDebris(FlxG.width/2+600, FlxG.height/2+-300, 'tiny', 0.4, 1.5, 0, 1));
		add(new MansionDebris(FlxG.width/2+-150, FlxG.height/2+-400, 'spike', 0.4, 1.1, 0, 1));
		add(new MansionDebris(FlxG.width/2+-750, FlxG.height/2+-850, 'small', 0.4, 1.5, 0, 1));

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);


		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 120 + (i * 220));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.updateHitbox();
			menuItem.antialiasing = true;
			menuItem.x -= 400;
		}

		var ekVer:FlxText = new FlxText(12, FlxG.height - 64, 0, "Extra Keys v" + extraKeysVersion, 12);
		ekVer.scrollFactor.set();
		ekVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(ekVer);
		var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		psychVer.scrollFactor.set();
		psychVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(psychVer);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);
		changeItem();

		character = new Character(0,0,'menushaggy',false);
		character.screenCenter(XY);
		character.x += 290;
		character.y += 25;
		character.scrollFactor.set(.075,.075);
		character.playAnim("back");
		add(character);

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		super.create();

		FlxG.camera.follow(camFollow, null, 9);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;

					if (ClientPrefs.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (optionShit[curSelected])
						{
							case 'story_mode':
				else if(optionShit[curSelected]=='story mode'){
					selectedSomethin=true;
					FlxG.sound.music.fadeOut(.5,0);
					character.playAnim("snap",true);
					new FlxTimer().start(0.85, function(tmr:FlxTimer)
					{
						FlxG.sound.play(Paths.sound('snap'));
						FlxG.sound.play(Paths.sound('menuBad'));
						FlxG.camera.shake(.05,.5);
						new FlxTimer().start(0.06, function(tmr2:FlxTimer){
							character.playAnim('snapped', true);
						});
					});

					PlayState.storyPlaylist = ["god-eater"];
					PlayState.isStoryMode = true;

					PlayState.storyDifficulty = 2;

					PlayState.SONG = Song.loadFromJson("god-eater-hard", "god-eater");
					PlayState.storyWeek = 1;
					PlayState.skipIntro=false;
					PlayState.campaignScore = 0;
					new FlxTimer().start(3, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState(), true);
					});
				}
				else {MusicBeatState.switchState(new StoryMenuState());}
							case 'freeplay':
								MusicBeatState.switchState(new FreeplayState());

							#if MODS_ALLOWED
							case 'mods':
								MusicBeatState.switchState(new ModsMenuState());
							#end

							#if ACHIEVEMENTS_ALLOWED
							case 'awards':
								MusicBeatState.switchState(new AchievementsMenuState());
							#end

							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								MusicBeatState.switchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
									PlayState.stageUI = 'normal';
								}
						}
					});

					for (i in 0...menuItems.members.length)
					{
						if (i == curSelected)
							continue;
						FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								menuItems.members[i].kill();
							}
						});
					}
				}
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		menuItems.members[curSelected].animation.play('idle');
		menuItems.members[curSelected].updateHitbox();
		menuItems.members[curSelected].screenCenter(X);

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.members[curSelected].animation.play('selected');
		menuItems.members[curSelected].centerOffsets();
		menuItems.members[curSelected].screenCenter(X);

		camFollow.setPosition(menuItems.members[curSelected].getGraphicMidpoint().x,
			menuItems.members[curSelected].getGraphicMidpoint().y - (menuItems.length > 4 ? menuItems.length * 8 : 0));
	}
}
