using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;

namespace klondike;

using Suit = Cards.Suit;

public abstract class Deck(Vector2 pos, Rectangle placeholder, GameLayer parent)
{
    public Vector2 pos = pos;
    public List<Card> cards = [];
    public readonly Rectangle placeholder = placeholder;
    private readonly GameLayer parent = parent;
    public bool active = true;

    public Rectangle? BoundsGrab { get; protected set; } = null;
    public Rectangle? BoundsDrop { get; protected set; } = null;
    public Rectangle? BoundsClick { get; protected set; } = null;
    public Rectangle? BoundsDblClick { get; protected set; } = null;

    public void Draw(Cards.Layer layer)
    {
        if (layer == Cards.Layer.Placeholder && placeholder.Width > 0)
        {
            Atlas.Draw(pos, placeholder);
            return;
        }

        foreach (Card card in cards)
        {
            if (card.layer == layer) Cards.Draw(card);
        }
    }

    public virtual void UpdateBounds()
    {
        BoundsGrab = null;
        BoundsDrop = null;
        BoundsClick = null;
        BoundsDblClick = null;
    }

    public virtual Vector2 GetDesiredPos(Card card, bool relative)
    {
        if (relative)
        {
            return Vector2.Zero;
        }
        else
        {
            return pos;
        }
    }

    public virtual Cards.Layer GetLayer(Card card)
    {
        return Cards.Layer.DeckTop;
    }
}

public class LineDeck(Vector2 pos, GameLayer parent) : Deck(pos, Atlas.PlaceholderEmpty, parent)
{
    public void Arrange(bool resetFlip)
    {
        if (cards.Count != 0)
        {
            Vector2 curPos = pos;
            foreach (Card card in cards)
            {
                card.pos = curPos;
                if (resetFlip) card.flipped = true;
                curPos.Y += Cards.FlatOffset;
            }
            if (resetFlip) cards[^1].flipped = false;
        }
    }

    public override void UpdateBounds()
    {
        if (cards.Count == 0)
        {
            BoundsGrab = null;
            BoundsDrop = null;
            BoundsDblClick = null;
        }
        else
        {
            int firstFaced = 0;
            foreach (Card card in cards)
            {
                if (!card.flipped)
                {
                    break;
                }
                else
                {
                    firstFaced++;
                }
            }

            BoundsGrab = new(
                (int)pos.X,
                (int)pos.Y + Cards.FlatOffset * firstFaced,
                Cards.CardWidth,
                Cards.CardHeight + Cards.FlatOffset * (cards.Count - firstFaced - 1)
            );
            BoundsDblClick = new(
                (int)pos.X,
                (int)pos.Y + Cards.FlatOffset * (cards.Count - 1),
                Cards.CardWidth,
                Cards.CardHeight
            );
            BoundsDrop = BoundsDblClick;
        }
    }
}

public class HomeDeck(Vector2 pos, Suit suit, GameLayer parent) : Deck(pos, Atlas.PlaceholderHomes[(int)suit - 1], parent)
{
    public void Arrange()
    {
        if (cards.Count == 0)
        {
            foreach (Card card in cards)
            {
                card.pos = pos;
            }
        }
    }

    public override void UpdateBounds()
    {
        if (cards.Count < 13)
        {
            BoundsDrop = new((int)pos.X, (int)pos.Y, Cards.CardWidth, Cards.CardHeight);
        }
        else
        {
            BoundsDrop = null;
        }
        if (cards.Count == 0)
        {
            BoundsGrab = null;
        }
        else
        {
            BoundsGrab = new((int)pos.X, (int)pos.Y, Cards.CardWidth, Cards.CardHeight);
        }
    }
}

public class ReserveLeftDeck(Vector2 pos, GameLayer parent) : Deck(pos, Atlas.PlaceholderRefresh, parent)
{
    public int index = -1;
    public Vector2 pos2 = new(pos.X + ReserveOffset, pos.Y);

    private const int ReserveOffset = 52;

    public void Arrange()
    {
        foreach (Card card in cards)
        {
            card.pos = pos;
            card.flipped = true;
        }
    }

    public override void UpdateBounds()
    {
        BoundsClick = new((int)pos.X, (int)pos.Y, Cards.CardWidth, Cards.CardHeight);
    }
}

public class ReserveRightDeck(Vector2 pos, GameLayer parent) : Deck(pos, Atlas.PlaceholderEmpty, parent)
{
    public int index = -1;
    public Vector2 pos2 = new(pos.X + ReserveOffset, pos.Y);

    private const int ReserveOffset = 52;

    public void Arrange()
    {
        foreach (Card card in cards)
        {
            card.pos = pos;
            card.flipped = true;
        }
    }

    public override void UpdateBounds()
    {
        BoundsClick = new((int)pos.X, (int)pos.Y, Cards.CardWidth, Cards.CardHeight);
    }
}

public class HandDeck(Vector2 pos, GameLayer parent) : Deck(pos, new Rectangle(), parent)
{
    public int index = -1;
    public Vector2 pos2 = new(pos.X + ReserveOffset, pos.Y);

    private const int ReserveOffset = 52;

    public bool IsActive { get { return cards.Count > 0; } }

    public void Arrange()
    {
        foreach (Card card in cards)
        {
            card.pos = pos;
            card.flipped = true;
        }
    }

    public override void UpdateBounds()
    {
        BoundsClick = new((int)pos.X, (int)pos.Y, Cards.CardWidth, Cards.CardHeight);
    }
}
