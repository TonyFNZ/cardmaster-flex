package
{
    import flash.display.Bitmap;
    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    public class Assets
    {
        // If you're developing a game for the Flash Player / browser plugin, you can directly
        // embed all textures directly in this class. This demo, however, provides two sets of
        // textures for different resolutions. That's useful especially for mobile development,
        // where you have to support devices with different resolutions.
        //
        // For that reason, the actual embed statements are in separate files; one for each
        // set of textures. The correct set is chosen depending on the "contentScaleFactor".
        
        
        // sounds
        [Embed(source="../media/audio/click.mp3")]
        private static const Click:Class;
        
        // static members
        private static var sTextures:Dictionary = new Dictionary();
        private static var sSounds:Dictionary = new Dictionary();
        private static var sTextureAtlas:TextureAtlas;
        private static var sBitmapFontsLoaded:Boolean;
        
        public static function getTexture(name:String):Texture
        {
            if (sTextures[name] == undefined)
            {
                var data:Object = create(name);
                
                if (data is Bitmap)
                    sTextures[name] = Texture.fromBitmap(data as Bitmap, true, false, 1);
                else if (data is ByteArray)
                    sTextures[name] = Texture.fromAtfData(data as ByteArray, 1);
            }
            
            return sTextures[name];
        }
        
        public static function getAtlasTexture(name:String):Texture
        {
            prepareAtlas();
            return sTextureAtlas.getTexture(name);
        }
        
        public static function getAtlasTextures(prefix:String):Vector.<Texture>
        {
            prepareAtlas();
            return sTextureAtlas.getTextures(prefix);
        }
        
        public static function getSound(name:String):Sound
        {
            var sound:Sound = sSounds[name] as Sound;
            if (sound) return sound;
            else throw new ArgumentError("Sound not found: " + name);
        }
        
        public static function loadBitmapFonts():void
        {
            if (!sBitmapFontsLoaded)
            {
                var texture:Texture = getTexture("CardLabelTexture");
                var xml:XML = XML(create("CardLabelXml"));
                TextField.registerBitmapFont(new BitmapFont(texture, xml));

				texture = getTexture("CardHPTexture");
                xml = XML(create("CardHPXml"));
                TextField.registerBitmapFont(new BitmapFont(texture, xml));
				
                sBitmapFontsLoaded = true;
            }
        }
        
        public static function prepareSounds():void
        {
            sSounds["Click"] = new Click();   
        }
        
        private static function prepareAtlas():void
        {
            if (sTextureAtlas == null)
            {
                var texture:Texture = getTexture("AtlasTexture");
                var xml:XML = XML(create("AtlasXml"));
                sTextureAtlas = new TextureAtlas(texture, xml);
            }
        }
        
        private static function create(name:String):Object
        {
            var textureClass:Class = AssetEmbeds;
            return new textureClass[name];
        }
        
    }
}