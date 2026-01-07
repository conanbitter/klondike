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
            /*if (i == 5)
            {
                animCard.Add(new AnimCardFlip(lineDecks[i].cards[^2]));
            }
            if (i == 6)
            {
                animCard.Add(new AnimCardFlip(lineDecks[i].cards[^2]));
                animCard.Add(new AnimCardFlip(lineDecks[i].cards[^3]));
            }*/
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
                hand.IsFixed = false;
                AnimParallel animContainer = new();
                var cards = Deck.MoveCards(deck, hand, deck.GetGrabCount(pos.Y));
                deck.SetLayers();
                foreach (Card card in cards)
                {
                    card.layer = Cards.Layer.Hand;
                    animContainer.Add(new AnimCardMoveDynamic(
                        card,
                        hand.GetDesiredPos(card, true),
                        0.1f,
                        hand));
                }
                hand.previousOwner = deck;
                deck.ClearBounds();
                animContainer.OnEnd += () => { hand.IsFixed = true; };
                Animations.Add(animContainer);
                break;
            }
        }
        //Console.WriteLine($"Grab     {pos.X,3} x {pos.Y,3}");
        //Console.WriteLine($"Hand     {hand.pos.X,3} x {hand.pos.Y,3}");
    }

    public void OnDrag(Point pos)
    {
        if (hand.IsActive)
        {
            hand.UpdatePos(pos.ToVector2());
        }
        //Console.WriteLine($"Drag     {pos.X,3} x {pos.Y,3}");
    }

    public void OnDrop(Point pos)
    {
        if (hand.IsActive)
        {
            Deck target = hand.previousOwner;

            Rectangle handBounds = hand.GetBounds();
            Deck closest = null;
            float minDistance = float.MaxValue;
            foreach (Deck deck in allDecks)
            {
                if (deck.BoundsDrop is Rectangle dropBounds &&
                dropBounds.Intersects(handBounds) &&
                deck.CanDrop(hand.cards[0]))
                {
                    float dx = dropBounds.X - handBounds.X;
                    float dy = dropBounds.Y - handBounds.Y;
                    float distance = dx * dx + dy * dy;
                    if (distance < minDistance)
                    {
                        closest = deck;
                        minDistance = distance;
                    }
                }
            }
            if (closest != null) target = closest;

            var cards = Deck.MoveCards(hand, target, hand.cards.Count);
            AnimParallel animContainer = new();
            foreach (Card card in cards)
            {
                card.layer = Cards.Layer.Flying;
                animContainer.Add(new AnimCardMoveFixed(
                    card,
                    target.GetDesiredPos(card, false),
                    0.2f,
                    Easing.EaseInOutCubic));
                //card.pos = hand.previousOwner.GetDesiredPos(card, false);
            }
            animContainer.OnEnd += () =>
            {
                target.SetLayers();
                target.UpdateBounds();
            };
            if (target != hand.previousOwner)
            {

                if (hand.previousOwner.cards.Count > 0 && hand.previousOwner.cards[^1].flipped)
                {
                    AnimCardFlip flip = new(hand.previousOwner.cards[^1]);
                    flip.OnEnd += () =>
                    {
                        hand.previousOwner.UpdateBounds();
                    };
                    Animations.Add(flip);
                }
                else
                {
                    hand.previousOwner.UpdateBounds();
                }
            }
            Animations.Add(animContainer);
        }
        //Console.WriteLine($"Drop     {pos.X,3} x {pos.Y,3}");
    }
    public void OnClick(Point pos)
    {
        if (reserveLeft.BoundsClick is Rectangle clickBounds && clickBounds.Contains(pos))
        {
            if (reserveLeft.lastAnim is Animation lastAnim)
            {
                lastAnim.Skip();
                reserveLeft.lastAnim = null;
            }

            if (reserveLeft.cards.Count > 0)
            {
                var cards = Deck.MoveCards(reserveLeft, reserveRight);
                foreach (Card card in cards)
                {
                    //card.pos = reserveRight.pos;
                    card.layer = Cards.Layer.Flying;
                    AnimParallel anim = new();
                    anim.Add(new AnimCardMoveFixed(
                       card,
                       reserveRight.pos,
                       0.2f,
                       Easing.EaseInOutCubic
                    ));
                    anim.Add(new AnimCardFlip(card));
                    anim.OnEnd += () =>
                    {
                        reserveRight.SetLayers();
                        reserveRight.UpdateBounds();
                    };
                    Animations.Add(anim);
                    reserveLeft.lastAnim = anim;
                    card.flipped = false;
                }
                reserveLeft.SetLayers();
                reserveLeft.UpdateBounds();
            }
            else
            {
                reserveLeft.cards.AddRange(reserveRight.cards);
                reserveLeft.cards.Reverse();
                foreach (Card card in reserveLeft.cards.Skip(1))
                {
                    card.pos = reserveLeft.pos;
                    card.flipped = true;
                }
                reserveLeft.cards[0].layer = Cards.Layer.Flying;
                AnimParallel anim = new();
                anim.Add(new AnimCardMoveFixed(
                       reserveLeft.cards[0],
                       reserveLeft.pos,
                       0.2f,
                       Easing.EaseInOutCubic
                    ));
                anim.Add(new AnimCardFlip(reserveLeft.cards[0]));
                anim.OnEnd += () =>
                {
                    reserveLeft.SetLayers();
                    reserveLeft.UpdateBounds();
                };
                Animations.Add(anim);
                reserveRight.cards.Clear();
            }
        }

    }
    public void OnDblClick(Point pos)
    {
        foreach (Deck deck in allDecks)
        {
            if (deck.BoundsDblClick is Rectangle rect && rect.Contains(pos))
            {
                Card card = deck.cards[^1];
                HomeDeck home = homeDecks[(int)card.suit - 1];
                if ((home.cards.Count == 0 && card.rank == Rank.Ace) ||
                (home.cards.Count > 0 && card.rank - home.cards[^1].rank == 1))
                {
                    Deck.MoveCards(deck, home);
                    card.layer = Cards.Layer.Flying;
                    deck.UpdateBounds();
                    deck.SetLayers();
                    home.ClearBounds();
                    AnimParallel anim = new();
                    if (deck.cards.Count > 0 && deck.cards[^1].flipped)
                    {
                        anim.Add(new AnimCardFlip(deck.cards[^1]));
                    }
                    anim.Add(new AnimCardMoveFixed(
                        card,
                        home.pos,
                        0.3f,
                        Easing.EaseOutCubic));
                    anim.OnEnd += () =>
                    {
                        home.UpdateBounds();
                        home.SetLayers();
                    };
                    Animations.Add(anim);
                }
                break;
            }
        }
        //Console.WriteLine($"DblClick {pos.X,3} x {pos.Y,3}");
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