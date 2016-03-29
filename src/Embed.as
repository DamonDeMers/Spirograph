package
{
	public class Embed
	{
		[Embed(source = "../src/assets/images/Spirograph.png")]
		public static const Spirograph:Class;
		
		[Embed(source="../src/assets/images/Spirograph.xml", mimeType="application/octet-stream")]
		public static const Spirograph_Xml:Class;
	}
}