package
{
    import starling.errors.AbstractClassError;

    public class Constants
    {
        public function Constants() { throw new AbstractClassError(); }
        
        public static const STAGE_WIDTH:int  = 480;
        public static const STAGE_HEIGHT:int = 800;
        
        public static const ASPECT_RATIO:Number = STAGE_HEIGHT / STAGE_WIDTH;
    }
}