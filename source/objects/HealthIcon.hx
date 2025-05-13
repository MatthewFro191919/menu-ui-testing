package objects;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false, ?allowGPU:Bool = true)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char, allowGPU);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String, ?allowGPU:Bool = true) {
		if(this.char != char) {
			loadGraphic(Paths.image('gameshit/iconGrid'), true, 150, 150);

		if(char=='pshaggy' || char=='gshaggy' || char=='tshaggy'){
			loadGraphic(Paths.image('shageee'), true, 150, 150);
			antialiasing=true;
			animation.add('pshaggy', [0, 1], 0, false);
			animation.add('gshaggy', [2,3], 0, false);
			animation.add('tshaggy', [2,3], 0, false);
			animation.play(char);
		}
		}else{
			loadGraphic(Paths.image('iconGrid'), true, 150, 150);
			antialiasing=true;
			animation.add('bf', [0, 1], 0, false);
			animation.add('bf-car', [0, 1], 0, false);
			animation.add('bf-christmas', [0, 1], 0, false);
			animation.add('spooky', [2, 3], 0, false);
			animation.add('pico', [4, 5], 0, false);
			animation.add('mom', [6, 7], 0, false);
			animation.add('mom-car', [6, 7], 0, false);
			animation.add('tankman', [8, 9], 0, false);
			animation.add('face', [10, 11], 0, false);
			animation.add('dad', [12, 13], 0, false);
			animation.add('bf-old', [14, 15], 0, false);
			animation.add('gf', [16], 0, false);
			animation.add('lizzy', [16], 0, false);
			animation.add('parents-christmas', [17], 0, false);
			animation.add('monster', [19, 20], 0, false);
			animation.add('monster-christmas', [19, 20], 0, false);
			animation.add('bf-pixel', [21, 21], 0, false);
			animation.add('senpai', [22, 22], 0, false);
			animation.add('senpai-angry', [22, 22], 0, false);
			animation.add('spirit', [23, 23], 0, false);
			animation.add('bf-neb', [24,25], 0, false);
			if(animation.getByName(char)!=null)
				animation.play(char);
			else
				animation.play("face");
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}
