using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using Microsoft.Xna.Framework;

namespace klondike;

using Suit = Cards.Suit;
using Rank = Cards.Rank;

public class GameLayer
{
    public readonly List<Deck> allDecks = [];
    private readonly List<LineDeck> lineDecks = [];
    private readonly List<HomeDeck> homeDecks = [];
    private readonly ReserveLeftDeck reserveLeft;
    private readonly ReserveRightDeck reserveRight;
    private readonly HandDeck hand;
    private readonly List<Card> allCards;

    public GameLayer()
    {
        reserveLeft = new(new Vector2(2, 2), this);
        allDecks.Add(reserveLeft);
        reserveRight = new(new Vector2(2 + 50, 2), this);
        allDecks.Add(reserveRight);

        for (Suit suit = Suit.Hearts; suit <= Suit.Spades; suit++)
        {
            HomeDeck newDeck = new(new Vector2(152 + 50 * ((int)suit - 1), 2), suit, this);
            allDecks.Add(newDeck);
            homeDecks.Add(newDeck);
        }

        for (int i = 0; i < 7; i++)
        {
            LineDeck newDeck = new(new Vector2(2 + 50 * i, 70), this);
            allDecks.Add(newDeck);
            lineDecks.Add(newDeck);
        }

        allCards = new(4 * 13);
        for (Suit suit = Suit.Hearts; suit <= Suit.Spades; suit++)
        {
            for (Rank rank = Rank.Ace; rank <= Rank.King; rank++)
            {
                allCards.Add(new Card(suit, rank));
            }
        }

        hand = new(Vector2.Zero, this);
        //allDecks.Add(hand);

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
            card.pos = reserveLeft.pos;
            card.flipped = true;
            card.layer = Cards.Layer.DeckBottom;
        }

        int offset = 0;

        AnimSequential animCard = new();

        for (int i = 0; i < 7; i++)
        {
            int count = i + 1;
            lineDecks[i].cards.Clear();
            lineDecks[i].cards.AddRange(allCards.Skip(offset).Take(count));
            offset += count;
            //flatDecks[i].Arrange(true);
            Vector2 curPos = Vector2.Zero;
            foreach (Card card in lineDecks[i].cards)
            {
                //card.pos = curPos;
                animCard.Add(new AnimCardMoveFixed(card, curPos, 0.2f + 0.1f * i / 7.0f, Easing.EaseInOutCubic, lineDecks[i]));
                curPos.Y += Cards.LineOffset;
                card.layer = Cards.Layer.DeckTop;
            }
            //flatDecks[i].cards[^1].flipped = false;
            animCard.Add(new AnimCardFlip(lineDecks[i].cards[^1]));
            if (i == 5)
            {
                animCard.Add(new AnimCardFlip(lineDecks[i].cards[^2]));
            }
            if (i == 6)
            {
                animCard.Add(new AnimCardFlip(lineDecks[i].cards[^2]));
                animCard.Add(new AnimCardFlip(lineDecks[i].cards[^3]));
            }
        }

        animCard.OnEnd += () =>
        {
            foreach (Deck deck in allDecks) deck.UpdateBounds();
        };
        Animations.Add(animCard);

        reserveLeft.cards.AddRange(allCards.Skip(offset));
        reserveLeft.cards[^1].layer = Cards.Layer.DeckTop;
        Animations.SkipAll();
        //reserve.Arrange();
    }

    private void DrawLayer(Cards.Layer layer)
    {
        foreach (Deck deck in allDecks)
        {
            deck.Draw(layer);
        }
    }

    public void Draw()
    {
        DrawLayer(Cards.Layer.Placeholder);
        // DeckBottom is not visible
        DrawLayer(Cards.Layer.DeckTop);
        DrawLayer(Cards.Layer.Flying);
        if (hand.IsActive) hand.Draw(Cards.Layer.Hand);
    }

    public void Update()
    {

    }

    public void OnGrab(Point pos)
    {
        foreach (Deck deck in allDecks)
        {
            if (deck.BoundsGrab is Rectangle rect && rect.Contains(pos))
            {
                hand.pos = pos.ToVector2();
                var cards = Deck.MoveCards(deck, hand, deck.GetGrabCount(pos.Y));
                foreach (Card card in cards)
                {
                    card.layer = Cards.Layer.Hand;
                    card.pos = hand.GetDesiredPos(card, false);
                }
                hand.previousOwner = deck;
                break;
            }
        }
        Console.WriteLine($"Grab     {pos.X,3} x {pos.Y,3}");
        Console.WriteLine($"Hand     {hand.pos.X,3} x {hand.pos.Y,3}");
    }
    public void OnDrag(Point pos)
    {
        if (hand.IsActive)
        {
            hand.pos = pos.ToVector2();
            foreach (Card card in hand.cards)
            {
                card.pos = hand.GetDesiredPos(card, false);
            }
        }
        Console.WriteLine($"Drag     {pos.X,3} x {pos.Y,3}");
    }
    public void OnDrop(Point pos)
    {
        if (hand.IsActive)
        {
            var cards = Deck.MoveCards(hand, hand.previousOwner, hand.cards.Count);
            foreach (Card card in cards)
            {
                card.layer = Cards.Layer.DeckTop;
                card.pos = hand.previousOwner.GetDesiredPos(card, false);
            }
            hand.previousOwner.UpdateBounds();
        }
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