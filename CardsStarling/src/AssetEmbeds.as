package
{
    public class AssetEmbeds
    {
        
		// Texture Atlas
        [Embed(source="../media/textures/atlas.xml", mimeType="application/octet-stream")]
        public static const AtlasXml:Class;
        
        [Embed(source="../media/textures/atlas.png")]
        public static const AtlasTexture:Class;
		
		
		
		// Bitmap Fonts
		[Embed(source="../media/fonts/card_label.fnt", mimeType="application/octet-stream")]
		public static const CardLabelXml:Class;
		[Embed(source = "../media/fonts/card_label.png")]
		public static const CardLabelTexture:Class;

		[Embed(source="../media/fonts/card_hp.fnt", mimeType="application/octet-stream")]
		public static const CardHPXml:Class;
		[Embed(source = "../media/fonts/card_hp.png")]
		public static const CardHPTexture:Class;
		
		
		
		// Particle Effects
		[Embed(source="../media/particles/particle_poof.pex", mimeType="application/octet-stream")]
		public static const PoofConfig:Class;
		
		// embed particle texture
		[Embed(source = "../media/particles/poof.png")]
		public static const PoofParticle:Class;
        
    }
}