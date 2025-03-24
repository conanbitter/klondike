using System.Runtime.CompilerServices;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;

namespace klondike;

static partial class Atlas
{
    private static Texture2D atlasTexture;
    private static SpriteBatch spriteBatch;

    public static void Init(ContentManager content, SpriteBatch sb)
    {
        atlasTexture = content.Load<Texture2D>("sprites");
        spriteBatch = sb;
    }

    public static void Draw(Vector2 position, Rectangle sprite)
    {
        spriteBatch.Draw(atlasTexture, position, sprite, Color.White);
    }
}