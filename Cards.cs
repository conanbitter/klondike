using Microsoft.Xna.Framework;

namespace klondike;

public static class Cards
{
    public static readonly int CardWidth = 42;
    public static readonly int CardHeight = 60;
    public static readonly int FlatOffset = 14;

    public enum Suit : int
    {
        Hearts = 1,
        Diamonds = 2,
        Clubs = 3,
        Spades = 4
    }

    public enum Rank : int
    {
        Ace = 1,
        Two = 2,
        Three = 3,
        Four = 4,
        Five = 5,
        Six = 6,
        Seven = 7,
        Eight = 8,
        Nine = 9,
        Ten = 10,
        Jack = 11,
        Queen = 12,
        King = 13
    }

    public static void Draw(Card card)
    {
        if (!card.visible) return;

        if (card.flipped)
        {
            Atlas.Draw(card.pos, Atlas.CardBack);
        }
        else
        {
            Atlas.Draw(card.pos, Atlas.Cards[(int)card.suit - 1, (int)card.rank - 1]);
        }
    }

    public static void Draw(System.Collections.Generic.IEnumerable<Card> cards)
    {
        foreach (Card card in cards)
        {
            Draw(card);
        }
    }

    public static void Draw(Deck deck)
    {
        foreach (Card card in deck.cards)
        {
            Draw(card);
        }
    }

    public static bool IsSuitCompatible(Suit suit1, Suit suit2)
    {
        if (suit1 == Suit.Clubs || suit1 == Suit.Spades)
        {
            return suit2 == Suit.Hearts || suit2 == Suit.Diamonds;
        }
        else
        {
            return suit2 == Suit.Clubs || suit2 == Suit.Spades;
        }
    }
}

public class Card
{
    public readonly Cards.Suit suit;
    public readonly Cards.Rank rank;

    public Deck parent;

    public Vector2 pos;
    public bool flipped;
    public bool visible;

    public Card(Cards.Suit suit, Cards.Rank rank)
    {
        this.suit = suit;
        this.rank = rank;
    }
}
