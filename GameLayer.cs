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

public class GameLayer
{
    private readonly List<Deck> allDecks = [];
    private readonly List<FlatDeck> flatDecks = [];

    public GameLayer()
    {
        for (int i = 0; i < 8; i++)
        {
            FlatDeck newDeck = new(new Vector2(2 + 50 * (i - 1), 70));
            allDecks.Add(newDeck);
            flatDecks.Add(newDeck);
        }
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