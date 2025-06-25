export class Vec2 {
    x: number;
    y: number;

    constructor(x: number = 0, y: number = 0) {
        this.x = x;
        this.y = y;
    }

    distance2(other: Vec2) {
        return (this.x - other.x) * (this.x - other.x) + (this.y - other.y) * (this.y - other.y);
    }

    distance(other: Vec2) {
        return math.sqrt((this.x - other.x) * (this.x - other.x) + (this.y - other.y) * (this.y - other.y));
    }

    add(other: Vec2) {
        return new Vec2(this.x + other.x, this.y + other.y)
    }

    mul(scale: number) {
        return new Vec2(this.x * scale, this.y * scale)
    }

    div(scale: number) {
        return new Vec2(this.x / scale, this.y / scale)
    }

    direction(to: Vec2) {
        const distance = this.distance(to);
        return new Vec2((to.x - this.x) / distance, (to.y - this.y) / distance);
    }
}