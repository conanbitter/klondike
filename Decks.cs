using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
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
        if (layer == Cards.Layer.Placeholder)
        {
            Atlas.Draw(pos, placeholder);
            return;
        }

        foreach (Card card in cards)
        {
            if (card.layer == layer) Cards.Draw(card);
        }
    }

    public void ClearBounds()
    {
        BoundsGrab = null;
        BoundsDrop = null;
        BoundsClick = null;
        BoundsDblClick = null;
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

    public virtual void SetLayers()
    {
    }

    public virtual int GetGrabCount(int y)
    {
        return 1;
    }

    public static IEnumerable<Card> MoveCards(Deck source, Deck destination, int count = 1)
    {
        if (count == 1)
        {
            Card card = source.cards[^1];
            destination.cards.Add(card);
            card.parent = destination;
            source.cards.RemoveAt(source.cards.Count - 1);
        }
        else
        {
            var cards = source.cards.Skip(source.cards.Count - count);
            foreach (Card card in cards)
            {
                card.parent = destination;
            }
            destination.cards.AddRange(source.cards.Skip(source.cards.Count - count));
            source.cards.RemoveRange(source.cards.Count - count, count);
        }
        return destination.cards.Skip(destination.cards.Count - count);
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
                curPos.Y += Cards.LineOffset;
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
                (int)pos.Y + Cards.LineOffset * firstFaced,
                Cards.CardWidth,
                Cards.CardHeight + Cards.LineOffset * (cards.Count - firstFaced - 1)
            );
            BoundsDblClick = new(
                (int)pos.X,
                (int)pos.Y + Cards.LineOffset * (cards.Count - 1),
                Cards.CardWidth,
                Cards.CardHeight
            );
            BoundsDrop = BoundsDblClick;
        }
    }


    public override Vector2 GetDesiredPos(Card card, bool relative)
    {
        int index = cards.IndexOf(card);
        Vector2 cardPos = new(0, Cards.LineOffset * index);
        if (relative)
        {
            return cardPos;
        }
        else
        {
            return cardPos + pos;
        }
    }

    public override int GetGrabCount(int y)
    {
        int index = Math.Min((y - (int)pos.Y) / Cards.LineOffset, cards.Count - 1);
        Console.WriteLine($"Index     {index,3} {y,3}");
        return cards.Count - index;
    }

    public override void SetLayers()
    {
        foreach (Card card in cards)
        {
            card.layer = Cards.Layer.DeckTop;
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

    public override void SetLayers()
    {
        foreach (Card card in cards)
        {
            card.layer = Cards.Layer.DeckBottom;
        }
        cards[^1].layer = Cards.Layer.DeckTop;
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
        if (cards.Count > 0)
        {
            BoundsClick = new((int)pos.X, (int)pos.Y, Cards.CardWidth, Cards.CardHeight);
        }
        else
        {
            BoundsClick = null;
        }
    }

    public override void SetLayers()
    {
        foreach (Card card in cards)
        {
            card.layer = Cards.Layer.DeckBottom;
        }
        cards[^1].layer = Cards.Layer.DeckTop;
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
        if (cards.Count > 0)
        {
            BoundsClick = new((int)pos.X, (int)pos.Y, Cards.CardWidth, Cards.CardHeight);
        }
        else
        {
            BoundsClick = null;
        }
    }

    public override void SetLayers()
    {
        foreach (Card card in cards)
        {
            card.layer = Cards.Layer.DeckBottom;
        }
        cards[^1].layer = Cards.Layer.DeckTop;
    }
}

public class HandDeck(Vector2 pos, GameLayer parent) : Deck(pos, new Rectangle(), parent)
{
    public Deck previousOwner = null;

    public bool IsActive { get { return cards.Count > 0; } }
    public bool IsFixed = false;

    public void Arrange()
    {
        foreach (Card card in cards)
        {
            card.pos = pos;
            card.flipped = true;
        }
    }

    public void UpdatePos(Vector2 newPos)
    {
        pos = newPos;
        if (IsFixed)
        {
            float y = -(cards.Count > 1 ? Cards.LineOffset / 2 : Cards.CardHeight / 2);
            float x = -Cards.CardWidth / 2;
            foreach (Card card in cards)
            {
                card.pos.X = pos.X + x;
                card.pos.Y = pos.Y + y;
                y += Cards.LineOffset;
            }
        }
    }

    public override void UpdateBounds()
    {
        BoundsClick = new((int)pos.X, (int)pos.Y, Cards.CardWidth, Cards.CardHeight);
    }

    public override Vector2 GetDesiredPos(Card card, bool relative)
    {
        float offset = cards.Count > 1 ? Cards.LineOffset / 2 : Cards.CardHeight / 2;
        int index = cards.IndexOf(card);
        Vector2 cardPos = new(-Cards.CardWidth / 2, -offset + Cards.LineOffset * index);
        if (relative)
        {
            return cardPos;
        }
        else
        {
            return cardPos + pos;
        }
    }
}
