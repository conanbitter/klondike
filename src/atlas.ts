import { Image, Quad } from "love.graphics";

const TEX_WIDTH = 512;
const TEX_HEIGHT = 512;

let texture: Image;

//#region "Cards"

export const CARDS = [
    // Hearts
    [
        love.graphics.newQuad(2, 45, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Ace
        love.graphics.newQuad(310, 293, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Two
        love.graphics.newQuad(134, 355, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Three
        love.graphics.newQuad(354, 160, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Four
        love.graphics.newQuad(222, 107, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Five
        love.graphics.newQuad(46, 107, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Six
        love.graphics.newQuad(354, 346, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Seven
        love.graphics.newQuad(134, 45, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Eight
        love.graphics.newQuad(2, 169, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Nine
        love.graphics.newQuad(266, 231, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Ten
        love.graphics.newQuad(90, 231, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Jack
        love.graphics.newQuad(398, 346, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Queen
        love.graphics.newQuad(178, 107, 42, 60, TEX_WIDTH, TEX_HEIGHT), // King
    ],
    // Diamonds
    [
        love.graphics.newQuad(442, 346, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Ace
        love.graphics.newQuad(222, 169, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Two
        love.graphics.newQuad(46, 169, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Three
        love.graphics.newQuad(354, 408, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Four
        love.graphics.newQuad(134, 107, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Five
        love.graphics.newQuad(2, 231, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Six
        love.graphics.newQuad(266, 45, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Seven
        love.graphics.newQuad(90, 45, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Eight
        love.graphics.newQuad(354, 222, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Nine
        love.graphics.newQuad(178, 169, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Ten
        love.graphics.newQuad(46, 355, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Jack
        love.graphics.newQuad(310, 231, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Queen
        love.graphics.newQuad(134, 293, 42, 60, TEX_WIDTH, TEX_HEIGHT), // King
    ],
    // Clubs
    [
        love.graphics.newQuad(310, 45, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Ace
        love.graphics.newQuad(178, 355, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Two
        love.graphics.newQuad(2, 293, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Three
        love.graphics.newQuad(266, 107, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Four
        love.graphics.newQuad(90, 107, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Five
        love.graphics.newQuad(442, 408, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Six
        love.graphics.newQuad(222, 355, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Seven
        love.graphics.newQuad(46, 231, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Eight
        love.graphics.newQuad(310, 107, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Nine
        love.graphics.newQuad(134, 231, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Ten
        love.graphics.newQuad(398, 222, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Jack
        love.graphics.newQuad(222, 45, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Queen
        love.graphics.newQuad(46, 45, 42, 60, TEX_WIDTH, TEX_HEIGHT), // King
    ],
    // Spades
    [
        love.graphics.newQuad(266, 169, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Ace
        love.graphics.newQuad(90, 169, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Two
        love.graphics.newQuad(398, 284, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Three
        love.graphics.newQuad(178, 45, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Four
        love.graphics.newQuad(46, 293, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Five
        love.graphics.newQuad(310, 169, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Six
        love.graphics.newQuad(134, 169, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Seven
        love.graphics.newQuad(2, 355, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Eight
        love.graphics.newQuad(266, 355, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Nine
        love.graphics.newQuad(90, 355, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Ten
        love.graphics.newQuad(398, 408, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Jack
        love.graphics.newQuad(178, 293, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Queen
        love.graphics.newQuad(2, 107, 42, 60, TEX_WIDTH, TEX_HEIGHT), // King
    ]
]

export const CARD_BACK = love.graphics.newQuad(266, 293, 42, 60, TEX_WIDTH, TEX_HEIGHT);

export const PLACEHOLDER_EMPTY = love.graphics.newQuad(310, 355, 42, 60, TEX_WIDTH, TEX_HEIGHT);

export const PLACEHOLDER_REFRESH = love.graphics.newQuad(222, 293, 42, 60, TEX_WIDTH, TEX_HEIGHT);

export const PLACEHOLDER_HOMES = [
    love.graphics.newQuad(222, 231, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Hearts
    love.graphics.newQuad(90, 293, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Diamonds
    love.graphics.newQuad(354, 284, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Clubs
    love.graphics.newQuad(178, 231, 42, 60, TEX_WIDTH, TEX_HEIGHT), // Spades
];

//#endregion

//#region UI

export const LABEL_SCALE_EN = love.graphics.newQuad(149, 417, 43, 26, TEX_WIDTH, TEX_HEIGHT);

export const LABEL_SCALE_RU = love.graphics.newQuad(82, 417, 65, 26, TEX_WIDTH, TEX_HEIGHT);

export const BUTTON_MENU = [
    love.graphics.newQuad(354, 127, 31, 31, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(398, 189, 31, 31, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(442, 313, 31, 31, TEX_WIDTH, TEX_HEIGHT),
]

export const BUTTON_CLOSE = [
    love.graphics.newQuad(241, 7, 36, 36, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(279, 7, 36, 36, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(317, 7, 36, 36, TEX_WIDTH, TEX_HEIGHT),
]

export const BUTTON_NEW_EN = [
    love.graphics.newQuad(93, 445, 78, 26, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(2, 417, 78, 26, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(184, 473, 78, 26, TEX_WIDTH, TEX_HEIGHT),
]

export const BUTTON_NEW_RU = [
    love.graphics.newQuad(2, 473, 89, 26, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(93, 473, 89, 26, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(2, 445, 89, 26, TEX_WIDTH, TEX_HEIGHT),
]

export const BUTTON_QUIT_EN = [
    love.graphics.newQuad(232, 445, 42, 26, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(238, 417, 42, 26, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(194, 417, 42, 26, TEX_WIDTH, TEX_HEIGHT),
]

export const BUTTON_QUIT_RU = [
    love.graphics.newQuad(2, 17, 57, 26, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(264, 473, 57, 26, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(173, 445, 57, 26, TEX_WIDTH, TEX_HEIGHT),
]

export const OPTION_SCALE = [
    // 1x
    [
        love.graphics.newQuad(354, 99, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(442, 201, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(354, 71, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(282, 417, 31, 26, TEX_WIDTH, TEX_HEIGHT),
    ],
    // 2x
    [

        love.graphics.newQuad(431, 173, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(431, 117, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(276, 445, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(442, 285, 31, 26, TEX_WIDTH, TEX_HEIGHT),
    ],
    // 3x
    [
        love.graphics.newQuad(420, 89, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(398, 161, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(387, 77, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(431, 145, 31, 26, TEX_WIDTH, TEX_HEIGHT),
    ],
    // 4x
    [
        love.graphics.newQuad(442, 257, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(387, 105, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(442, 229, 31, 26, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(398, 133, 31, 26, TEX_WIDTH, TEX_HEIGHT),
    ]
]

export const OPTION_LANG = [
    // EN
    [
        love.graphics.newQuad(458, 470, 43, 29, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(323, 470, 43, 29, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(61, 14, 43, 29, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(413, 470, 43, 29, TEX_WIDTH, TEX_HEIGHT),
    ],
    // RU
    [
        love.graphics.newQuad(368, 470, 43, 29, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(106, 14, 43, 29, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(151, 14, 43, 29, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(196, 14, 43, 29, TEX_WIDTH, TEX_HEIGHT),
    ]
]

//#endregion

export function InitAtlas() {
    texture = love.graphics.newImage("sprites.png")
}

export function Draw(sprite: Quad, x: number, y: number) {
    love.graphics.draw(texture, sprite, x, y)
}
