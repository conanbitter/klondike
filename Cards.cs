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

    public static void Draw(Vector2 position, Card card)
    {
        Atlas.Draw(position, Atlas.Cards[(int)card.Suit - 1, (int)card.Rank - 1]);
    }

    public static void Draw(Vector2 position, System.Collections.Generic.IEnumerable<Card> cards)
    {
        Vector2 currentPos = position;
        foreach (Card card in cards)
        {
            Atlas.Draw(currentPos, Atlas.Cards[(int)card.Suit, (int)card.Rank]);
            currentPos.Y += FlatOffset;
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

public record Card(Cards.Suit Suit, Cards.Rank Rank);
