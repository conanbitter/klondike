using System.Runtime.CompilerServices;
using Microsoft.Xna.Framework;

namespace klondike;

static class Atlas
{
    // Cards

    public static readonly Rectangle[,] Cards = new Rectangle[4, 13] {
        // Hearts
        {
            new(), // Ace
            new(), // Two
            new(), // Three
            new(), // Four
            new(), // Five
            new(), // Six
            new(), // Seven
            new(), // Eight
            new(), // Nine
            new(), // Ten
            new(), // Jack
            new(), // Queen
            new(), // King
        },
        // Diamonds
        {
            new(), // Ace
            new(), // Two
            new(), // Three
            new(), // Four
            new(), // Five
            new(), // Six
            new(), // Seven
            new(), // Eight
            new(), // Nine
            new(), // Ten
            new(), // Jack
            new(), // Queen
            new(), // King
        },
        // Clubs
        {
            new(), // Ace
            new(), // Two
            new(), // Three
            new(), // Four
            new(), // Five
            new(), // Six
            new(), // Seven
            new(), // Eight
            new(), // Nine
            new(), // Ten
            new(), // Jack
            new(), // Queen
            new(), // King
        },
        // Spades
        {
            new(), // Ace
            new(), // Two
            new(), // Three
            new(), // Four
            new(), // Five
            new(), // Six
            new(), // Seven
            new(), // Eight
            new(), // Nine
            new(), // Ten
            new(), // Jack
            new(), // Queen
            new(), // King
        }
    };
    public static readonly Rectangle CardBack = new();
    public static readonly Rectangle PlaceholderEmpty = new();
    public static readonly Rectangle PlaceholderRefresh = new();
    public static readonly Rectangle[] PlaceholderHomes = [
        new(), // Hearts
        new(), // Diamonds
        new(), // Clubs
        new(), // Spades
    ];

    // UI

    public static readonly Rectangle LabelScaleRu = new();
    public static readonly Rectangle LabelScaleEn = new();

    public static readonly Rectangle[] ButtonMenu = [
        new(),
        new(),
        new(),
    ];

    public static readonly Rectangle[] ButtonClose = [
        new(),
        new(),
        new(),
    ];

    public static readonly Rectangle[] ButtonNewEn = [
        new(),
        new(),
        new(),
    ];

    public static readonly Rectangle[] ButtonNewRu = [
        new(),
        new(),
        new(),
    ];

    public static readonly Rectangle[] ButtonQuitEn = [
        new(),
        new(),
        new(),
    ];

    public static readonly Rectangle[] ButtonQuitRu = [
        new(),
        new(),
        new(),
    ];

    public static readonly Rectangle[,] OptionScale = new Rectangle[4, 4] {
        // 1x
        {
            new(),
            new(),
            new(),
            new(),
        },
        // 2x
        {
            new(),
            new(),
            new(),
            new(),
        },
        // 3x
        {
            new(),
            new(),
            new(),
            new(),
        },
        // 4x
        {
            new(),
            new(),
            new(),
            new(),
        },
    };

    public static readonly Rectangle[,] OptionLang = new Rectangle[2, 4] {
        // EN
        {
            new(),
            new(),
            new(),
            new(),
        },
        // RU
        {
            new(),
            new(),
            new(),
            new(),
        },
    };
}