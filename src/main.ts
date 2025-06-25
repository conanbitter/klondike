import { Vec2 } from "./geometry";

love.load = () => {
    const pos = new Vec2(2, 3);
    print(pos.x, pos.y);
}

love.draw = () => {
    love.graphics.print('Hello World');
};