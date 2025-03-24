﻿using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace klondike;

public class KlondikeGame : Game
{
    private GraphicsDeviceManager _graphics;
    private SpriteBatch _spriteBatch;

    private Texture2D test;
    private RenderTarget2D rt;

    public KlondikeGame()
    {
        _graphics = new GraphicsDeviceManager(this);
        Content.RootDirectory = "Content";
        IsMouseVisible = true;
    }

    protected override void Initialize()
    {
        _graphics.PreferredBackBufferWidth = 350 * 3;
        _graphics.PreferredBackBufferHeight = 300 * 3;
        _graphics.ApplyChanges();

        base.Initialize();
    }

    protected override void LoadContent()
    {
        _spriteBatch = new SpriteBatch(GraphicsDevice);
        test = Content.Load<Texture2D>("sprites");
        rt = new RenderTarget2D(GraphicsDevice, 350, 300, false, GraphicsDevice.PresentationParameters.BackBufferFormat, DepthFormat.Depth24);
    }

    protected override void Update(GameTime gameTime)
    {
        if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
            Exit();

        base.Update(gameTime);
    }

    protected override void Draw(GameTime gameTime)
    {
        GraphicsDevice.SetRenderTarget(rt);

        GraphicsDevice.Clear(new Color(62, 140, 54));

        _spriteBatch.Begin(SpriteSortMode.Deferred, BlendState.AlphaBlend, SamplerState.PointClamp, DepthStencilState.None);
        _spriteBatch.Draw(test, Vector2.Zero, Atlas.Cards[1, 10], Color.White);
        _spriteBatch.End();

        GraphicsDevice.SetRenderTarget(null);

        _spriteBatch.Begin(SpriteSortMode.Deferred, BlendState.Opaque, SamplerState.PointClamp, DepthStencilState.None);
        _spriteBatch.Draw(rt, new Rectangle(0, 0, 350 * 3, 300 * 3), Color.White);
        _spriteBatch.End();

        base.Draw(gameTime);
    }
}
