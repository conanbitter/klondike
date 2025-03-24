using Microsoft.Xna.Framework;

namespace klondike;

static partial class Atlas
{
    // Cards

    public static readonly Rectangle[,] Cards = new Rectangle[4, 13] {
        // Hearts
        {
            new(2, 45, 42, 60), // Ace
            new(310, 293, 42, 60), // Two
            new(134, 355, 42, 60), // Three
            new(354, 160, 42, 60), // Four
            new(222, 107, 42, 60), // Five
            new(46, 107, 42, 60), // Six
            new(354, 346, 42, 60), // Seven
            new(134, 45, 42, 60), // Eight
            new(2, 169, 42, 60), // Nine
            new(266, 231, 42, 60), // Ten
            new(90, 231, 42, 60), // Jack
            new(398, 346, 42, 60), // Queen
            new(178, 107, 42, 60), // King
        },
        // Diamonds
        {
            new(442, 346, 42, 60), // Ace
            new(222, 169, 42, 60), // Two
            new(46, 169, 42, 60), // Three
            new(354, 408, 42, 60), // Four
            new(134, 107, 42, 60), // Five
            new(2, 231, 42, 60), // Six
            new(266, 45, 42, 60), // Seven
            new(90, 45, 42, 60), // Eight
            new(354, 222, 42, 60), // Nine
            new(178, 169, 42, 60), // Ten
            new(46, 355, 42, 60), // Jack
            new(310, 231, 42, 60), // Queen
            new(134, 293, 42, 60), // King
        },
        // Clubs
        {
            new(310, 45, 42, 60), // Ace
            new(178, 355, 42, 60), // Two
            new(2, 293, 42, 60), // Three
            new(266, 107, 42, 60), // Four
            new(90, 107, 42, 60), // Five
            new(442, 408, 42, 60), // Six
            new(222, 355, 42, 60), // Seven
            new(46, 231, 42, 60), // Eight
            new(310, 107, 42, 60), // Nine
            new(134, 231, 42, 60), // Ten
            new(398, 222, 42, 60), // Jack
            new(222, 45, 42, 60), // Queen
            new(46, 45, 42, 60), // King
        },
        // Spades
        {
            new(266, 169, 42, 60), // Ace
            new(90, 169, 42, 60), // Two
            new(398, 284, 42, 60), // Three
            new(178, 45, 42, 60), // Four
            new(46, 293, 42, 60), // Five
            new(310, 169, 42, 60), // Six
            new(134, 169, 42, 60), // Seven
            new(2, 355, 42, 60), // Eight
            new(266, 355, 42, 60), // Nine
            new(90, 355, 42, 60), // Ten
            new(398, 408, 42, 60), // Jack
            new(178, 293, 42, 60), // Queen
            new(2, 107, 42, 60), // King
        }
    };
    public static readonly Rectangle CardBack = new(266, 293, 42, 60);
    public static readonly Rectangle PlaceholderEmpty = new(310, 355, 42, 60);
    public static readonly Rectangle PlaceholderRefresh = new(222, 293, 42, 60);
    public static readonly Rectangle[] PlaceholderHomes = [
        new(222, 231, 42, 60), // Hearts
        new(90, 293, 42, 60), // Diamonds
        new(354, 284, 42, 60), // Clubs
        new(178, 231, 42, 60), // Spades
    ];

    // UI

    public static readonly Rectangle LabelScaleEn = new(149, 417, 43, 26);
    public static readonly Rectangle LabelScaleRu = new(82, 417, 65, 26);

    public static readonly Rectangle[] ButtonMenu = [
        new(354, 127, 31, 31),
        new(398, 189, 31, 31),
        new(442, 313, 31, 31),
    ];

    public static readonly Rectangle[] ButtonClose = [
        new(241, 7, 36, 36),
        new(279, 7, 36, 36),
        new(317, 7, 36, 36),
    ];

    public static readonly Rectangle[] ButtonNewEn = [
        new(93, 445, 78, 26),
        new(2, 417, 78, 26),
        new(184, 473, 78, 26),
    ];

    public static readonly Rectangle[] ButtonNewRu = [
        new(2, 473, 89, 26),
        new(93, 473, 89, 26),
        new(2, 445, 89, 26),
    ];

    public static readonly Rectangle[] ButtonQuitEn = [
        new(232, 445, 42, 26),
        new(238, 417, 42, 26),
        new(194, 417, 42, 26),
    ];

    public static readonly Rectangle[] ButtonQuitRu = [
        new(2, 17, 57, 26),
        new(264, 473, 57, 26),
        new(173, 445, 57, 26),
    ];

    public static readonly Rectangle[,] OptionScale = new Rectangle[4, 4] {
        // 1x
        {
            new(354, 99, 31, 26),
            new(442, 201, 31, 26),
            new(354, 71, 31, 26),
            new(282, 417, 31, 26),
        },
        // 2x
        {
            new(431, 173, 31, 26),
            new(431, 117, 31, 26),
            new(276, 445, 31, 26),
            new(442, 285, 31, 26),
        },
        // 3x
        {
            new(420, 89, 31, 26),
            new(398, 161, 31, 26),
            new(387, 77, 31, 26),
            new(431, 145, 31, 26),
        },
        // 4x
        {
            new(442, 257, 31, 26),
            new(387, 105, 31, 26),
            new(442, 229, 31, 26),
            new(398, 133, 31, 26),
        },
    };

    public static readonly Rectangle[,] OptionLang = new Rectangle[2, 4] {
        // EN
        {
            new(458, 470, 43, 29),
            new(323, 470, 43, 29),
            new(61, 14, 43, 29),
            new(413, 470, 43, 29),
        },
        // RU
        {
            new(368, 470, 43, 29),
            new(106, 14, 43, 29),
            new(151, 14, 43, 29),
            new(196, 14, 43, 29),
        },
    };
}