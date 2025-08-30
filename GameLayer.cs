using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;

namespace klondike;

using Suit = Cards.Suit;
using Rank = Cards.Rank;

public abstract class Deck(Vector2 pos, Rectangle placeholder)
{
    public Vector2 pos = pos;
    public List<Card> cards = [];
    public readonly Rectangle placeholder = placeholder;

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
}

public class FlatDeck(Vector2 pos) : Deck(pos, Atlas.PlaceholderEmpty)
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
}

public class HomeDeck(Vector2 pos, Suit suit) : Deck(pos, Atlas.PlaceholderHomes[(int)suit - 1])
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
}

public class ReserveDeck(Vector2 pos) : Deck(pos, Atlas.PlaceholderRefresh)
{
    public int index = -1;
    public Vector2 pos2 = new(pos.X + ReserveOffset, pos.Y);

    private const int ReserveOffset = 52;

    public void Arrange()
    {

    }
}

public class GameLayer
{
    private readonly List<Deck> allDecks = [];
    private readonly List<FlatDeck> flatDecks = [];
    private readonly List<HomeDeck> homeDecks = [];
    private readonly ReserveDeck reserve;
    private List<Card> allCards;

    public GameLayer()
    {
        reserve = new(new Vector2(2, 2));
        allDecks.Add(reserve);

        for (Suit suit = Suit.Hearts; suit <= Suit.Spades; suit++)
        {
            HomeDeck newDeck = new(new Vector2(152 + 50 * ((int)suit - 1), 2), suit);
            allDecks.Add(newDeck);
            homeDecks.Add(newDeck);
        }

        for (int i = 0; i < 8; i++)
        {
            FlatDeck newDeck = new(new Vector2(2 + 50 * (i - 1), 70));
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
    }

    public void NewGame()
    {
        allCards.Shuffle();

        int offset = 0;

        for (int i = 0; i < 8; i++)
        {
            int count = i + 1;
            flatDecks[i].cards.Clear();
            flatDecks[i].cards.AddRange(allCards.Skip(offset).Take(count));
            offset += count;
            flatDecks[i].Arrange(true);
        }

        reserve.cards.AddRange(allCards.Skip(offset));
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