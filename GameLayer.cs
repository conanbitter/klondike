using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using Microsoft.Xna.Framework;

namespace klondike;

using Suit = Cards.Suit;
using Rank = Cards.Rank;

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
        foreach (Card card in cards)
        {
            if (card.layer == layer) Cards.Draw(card);
        }
    }

    public void DrawPlaceholder()
    {
        Atlas.Draw(pos, placeholder);
    }

    public void UpdateVisibility()
    {
        Card top = null;
        foreach (Card card in cards)
        {
            if (card.pos == pos)
            {
                card.visible = false;
                top = card;
            }
            else
            {
                card.visible = true;
            }
        }
        if (top != null) top.visible = true;
    }

    public void ShowAll()
    {
        foreach (Card card in cards)
        {
            card.visible = true;
        }
    }

    public virtual void UpdateBounds()
    {
        BoundsGrab = null;
        BoundsDrop = null;
        BoundsClick = null;
        BoundsDblClick = null;
    }
}

public class FlatDeck(Vector2 pos, GameLayer parent) : Deck(pos, Atlas.PlaceholderEmpty, parent)
{
    public void Arrange(bool resetFlip)
    {
        if (cards.Count != 0)
        {
            Vector2 curPos = pos;
            foreach (Card card in cards)
            {
                card.visible = true;
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
                card.visible = false;
            }
            cards[^1].visible = true;
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

public class ReserveDeck(Vector2 pos, GameLayer parent) : Deck(pos, Atlas.PlaceholderRefresh, parent)
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

public class GameLayer
{
    public readonly List<Deck> allDecks = [];
    private readonly List<FlatDeck> flatDecks = [];
    private readonly List<HomeDeck> homeDecks = [];
    private readonly ReserveDeck reserve;
    private readonly List<Card> allCards;

    public GameLayer()
    {
        reserve = new(new Vector2(2, 2), this);
        allDecks.Add(reserve);

        for (Suit suit = Suit.Hearts; suit <= Suit.Spades; suit++)
        {
            HomeDeck newDeck = new(new Vector2(152 + 50 * ((int)suit - 1), 2), suit, this);
            allDecks.Add(newDeck);
            homeDecks.Add(newDeck);
        }

        for (int i = 0; i < 7; i++)
        {
            FlatDeck newDeck = new(new Vector2(2 + 50 * i, 70), this);
            allDecks.Add(newDeck);
            flatDecks.Add(newDeck);
        }

        allCards = new(4 * 13);
        for (Suit suit = Suit.Hearts; suit <= Suit.Spades; suit++)
        {
            for (Rank rank = Rank.Ace; rank <= Rank.King; rank++)
            {
                allCards.Add(new Card(suit, rank));
            }
        }

        AdvancedMouse.OnGrab += OnGrab;
        AdvancedMouse.OnDrag += OnDrag;
        AdvancedMouse.OnDrop += OnDrop;
        AdvancedMouse.OnClick += OnClick;
        AdvancedMouse.OnDblClick += OnDblClick;
    }

    public void NewGame()
    {
        allCards.Shuffle();

        foreach (Card card in allCards)
        {
            card.pos = reserve.pos;
            card.flipped = true;
        }

        int offset = 0;

        AnimSequential animCard = new();

        for (int i = 0; i < 7; i++)
        {
            int count = i + 1;
            flatDecks[i].cards.Clear();
            flatDecks[i].cards.AddRange(allCards.Skip(offset).Take(count));
            offset += count;
            //flatDecks[i].Arrange(true);
            Vector2 curPos = Vector2.Zero;
            foreach (Card card in flatDecks[i].cards)
            {
                //card.pos = curPos;
                animCard.Add(new AnimCardMoveFixed(card, curPos, 0.2f + 0.1f * i / 7.0f, Easing.EaseInOutCubic, flatDecks[i]));
                curPos.Y += Cards.FlatOffset;
            }
            //flatDecks[i].cards[^1].flipped = false;
            animCard.Add(new AnimCardFlip(flatDecks[i].cards[^1]));
            if (i == 5)
            {
                animCard.Add(new AnimCardFlip(flatDecks[i].cards[^2]));
            }
            if (i == 6)
            {
                animCard.Add(new AnimCardFlip(flatDecks[i].cards[^2]));
                animCard.Add(new AnimCardFlip(flatDecks[i].cards[^3]));
            }
        }

        animCard.OnEnd += () =>
        {
            foreach (Deck deck in allDecks) deck.UpdateBounds();
        };
        Animations.Add(animCard);
        Animations.SkipAll();

        reserve.cards.AddRange(allCards.Skip(offset));
        //Animations.SkipAll();
        //reserve.Arrange();
    }

    public void Draw()
    {
        foreach (Deck deck in allDecks)
        {
            deck.DrawPlaceholder();
        }

        foreach (Deck deck in allDecks)
        {
            deck.Draw(Cards.Layer.Background);
        }

        foreach (Deck deck in allDecks)
        {
            deck.Draw(Cards.Layer.Foreground);
        }
    }

    public void Update()
    {
        reserve.UpdateVisibility();

        foreach (Deck deck in homeDecks)
        {
            deck.UpdateVisibility();
        }

        foreach (Deck deck in flatDecks)
        {
            deck.ShowAll();
        }

        /*foreach (Card card in allCards)
        {
            card.visible = true;
        }*/
    }

    public void OnGrab(Point pos)
    {
        Console.WriteLine($"Grab     {pos.X,3} x {pos.Y,3}");
    }
    public void OnDrag(Point pos)
    {
        Console.WriteLine($"Drag     {pos.X,3} x {pos.Y,3}");
    }
    public void OnDrop(Point pos)
    {
        Console.WriteLine($"Drop     {pos.X,3} x {pos.Y,3}");
    }
    public void OnClick(Point pos)
    {
        Console.WriteLine($"Click    {pos.X,3} x {pos.Y,3}");
    }
    public void OnDblClick(Point pos)
    {
        Console.WriteLine($"DblClick {pos.X,3} x {pos.Y,3}");
    }
}

static class Shuffler
{
    private static readonly Random rng = new();

    public static void Shuffle<T>(this IList<T> list)
    {
        int n = list.Count;
        while (n > 1)
        {
            n--;
            int k = rng.Next(n + 1);
            (list[n], list[k]) = (list[k], list[n]);
        }
    }
}