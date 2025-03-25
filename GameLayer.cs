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

    public abstract void Draw();
}

public class FlatDeck(Vector2 pos) : Deck(pos, Atlas.PlaceholderEmpty)
{
    public int covered = 0;

    public override void Draw()
    {
        if (cards.Count == 0)
        {
            Atlas.Draw(pos, placeholder);
        }
        else
        {
            int i = 0;
            foreach (Card card in cards)
            {
                Vector2 curPos = new(pos.X, pos.Y + i * Cards.FlatOffset);
                if (i <= covered)
                {
                    Atlas.Draw(curPos, Atlas.CardBack);
                }
                else
                {
                    Cards.Draw(curPos, card);
                }
                i++;
            }
        }
    }
}

public class HomeDeck(Vector2 pos, Suit suit) : Deck(pos, Atlas.PlaceholderHomes[(int)suit - 1])
{
    public override void Draw()
    {
        if (cards.Count == 0)
        {
            Atlas.Draw(pos, placeholder);
        }
        else
        {
            Cards.Draw(pos, cards.Last());
        }
    }
}

public class ReserveDeck(Vector2 pos) : Deck(pos, Atlas.PlaceholderRefresh)
{
    public int index = -1;
    public Vector2 pos2 = new(pos.X + ReserveOffset, pos.Y);

    private const int ReserveOffset = 52;

    public override void Draw()
    {
        if (cards.Count == 0)
        {
            Atlas.Draw(pos, placeholder);
        }
        else
        {
            if (index < cards.Count - 1)
            {
                Atlas.Draw(pos, Atlas.CardBack);
            }
            else
            {
                Atlas.Draw(pos, placeholder);
            }

            if (index >= 0)
            {
                Cards.Draw(pos2, cards[index]);
            }
        }
    }
}

public class GameLayer
{
    private readonly List<Deck> allDecks = [];
    private readonly List<FlatDeck> flatDecks = [];
    private readonly ReserveDeck reserve;

    public GameLayer()
    {
        for (int i = 0; i < 8; i++)
        {
            FlatDeck newDeck = new(new Vector2(2 + 50 * (i - 1), 70));
            allDecks.Add(newDeck);
            flatDecks.Add(newDeck);
        }

        for (Suit suit = Suit.Hearts; suit <= Suit.Spades; suit++)
        {
            allDecks.Add(new HomeDeck(new Vector2(152 + 50 * ((int)suit - 1), 2), suit));
        }

        reserve = new(new Vector2(2, 2));
        allDecks.Add(reserve);
    }

    public void NewGame()
    {
        List<Card> allCards = new(4 * 13);
        for (Suit suit = Suit.Hearts; suit <= Suit.Spades; suit++)
        {
            for (Rank rank = Rank.Ace; rank <= Rank.King; rank++)
            {
                allCards.Add(new Card(suit, rank));
            }
        }

        allCards.Shuffle();

        for (int i = 0; i < 8; i++)
        {
            int count = i + 1;
            flatDecks[i].cards.Clear();
            flatDecks[i].cards.AddRange(allCards.TakeLast(count));
            flatDecks[i].covered = i - 1;
            allCards.RemoveRange(allCards.Count - count, count);
        }

        reserve.cards.AddRange(allCards);
    }

    public void Draw()
    {
        foreach (Deck deck in allDecks)
        {
            deck.Draw();
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