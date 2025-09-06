using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace klondike;

public class KlondikeGame : Game
{
    private GraphicsDeviceManager _graphics;
    private SpriteBatch _spriteBatch;

    private SpriteFont debugFont;
    private Texture2D debugTexture;
    private Color debugGrab = new(Color.Red, 0.5f);
    private Color debugDrop = new(Color.Blue, 0.5f);
    private Color debugClick = new(Color.Purple, 0.5f);
    private Color debugDblClick = new(Color.OrangeRed, 0.5f);
    private int debugBounds = 0;

    private RenderTarget2D rt;

    private readonly GameLayer gameLayer;

    private float deltaTime;

    public KlondikeGame()
    {
        _graphics = new GraphicsDeviceManager(this);
        Content.RootDirectory = "Content";
        IsMouseVisible = true;
        gameLayer = new();
    }

    protected override void Initialize()
    {
        _graphics.PreferredBackBufferWidth = 350 * 3;
        _graphics.PreferredBackBufferHeight = 300 * 3;
        _graphics.ApplyChanges();

        gameLayer.NewGame();

        base.Initialize();
    }

    protected override void LoadContent()
    {
        _spriteBatch = new SpriteBatch(GraphicsDevice);
        Atlas.Init(Content, _spriteBatch);
        rt = new RenderTarget2D(GraphicsDevice, 350, 300, false, GraphicsDevice.PresentationParameters.BackBufferFormat, DepthFormat.Depth24);
        debugFont = Content.Load<SpriteFont>("mainfont");

        debugTexture = new Texture2D(GraphicsDevice, 1, 1);
        debugTexture.SetData([Color.White]);
    }

    protected override void Update(GameTime gameTime)
    {
        if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
            Exit();

        if (Keyboard.GetState().IsKeyDown(Keys.D1)) debugBounds = 1;
        if (Keyboard.GetState().IsKeyDown(Keys.D2)) debugBounds = 2;
        if (Keyboard.GetState().IsKeyDown(Keys.D3)) debugBounds = 3;
        if (Keyboard.GetState().IsKeyDown(Keys.D4)) debugBounds = 4;
        if (Keyboard.GetState().IsKeyDown(Keys.D0)) debugBounds = 0;

        deltaTime = (float)gameTime.ElapsedGameTime.TotalSeconds;
        AdvancedMouse.Update(gameTime.ElapsedGameTime.TotalSeconds);
        Animations.Update(deltaTime);
        gameLayer.Update();

        base.Update(gameTime);
    }

    protected override void Draw(GameTime gameTime)
    {
        Cards.DrawReset();

        GraphicsDevice.SetRenderTarget(rt);

        GraphicsDevice.Clear(new Color(62, 140, 54));

        _spriteBatch.Begin(SpriteSortMode.Deferred, BlendState.NonPremultiplied, SamplerState.PointClamp, DepthStencilState.None);
        //Atlas.Draw(new Vector2(10, 10), Atlas.Cards[1, 10]);
        gameLayer.Draw();
        if (debugBounds == 1)
        {
            foreach (Deck deck in gameLayer.allDecks)
            {
                if (deck.BoundsGrab is { } bounds) _spriteBatch.Draw(debugTexture, bounds, debugGrab);
            }
        }
        if (debugBounds == 2)
        {
            foreach (Deck deck in gameLayer.allDecks)
            {
                if (deck.BoundsDrop is { } bounds) _spriteBatch.Draw(debugTexture, bounds, debugDrop);
            }
        }
        if (debugBounds == 3)
        {
            foreach (Deck deck in gameLayer.allDecks)
            {
                if (deck.BoundsClick is { } bounds) _spriteBatch.Draw(debugTexture, bounds, debugClick);
            }
        }
        if (debugBounds == 4)
        {
            foreach (Deck deck in gameLayer.allDecks)
            {
                if (deck.BoundsDblClick is { } bounds) _spriteBatch.Draw(debugTexture, bounds, debugDblClick);
            }
        }
        _spriteBatch.End();

        GraphicsDevice.SetRenderTarget(null);

        _spriteBatch.Begin(SpriteSortMode.Deferred, BlendState.Opaque, SamplerState.PointClamp, DepthStencilState.None);
        _spriteBatch.Draw(rt, new Rectangle(0, 0, 350 * 3, 300 * 3), Color.White);
        _spriteBatch.End();

        _spriteBatch.Begin();
        _spriteBatch.DrawString(debugFont, $"Cards drawed: {Cards.DebugDrawed}", new Vector2(300, 10), Color.White);
        _spriteBatch.DrawString(debugFont, $"deltaTime {deltaTime}", new Vector2(300, 30), Color.White);
        _spriteBatch.End();

        base.Draw(gameTime);
    }
}
