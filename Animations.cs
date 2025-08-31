using System.Collections.Generic;
using Microsoft.Xna.Framework;


namespace klondike;

abstract class Animation
{
    public bool Finished { get; protected set; } = false;

    public abstract void Update(float deltaTime);
    public abstract void Skip();
}

class AnimParallel : Animation
{
    readonly List<Animation> animations = [];

    public override void Update(float deltaTime)
    {
        if (Finished) return;

        bool allFinished = true;
        foreach (Animation anim in animations)
        {
            anim.Update(deltaTime);
            if (!anim.Finished) allFinished = false;
        }

        if (allFinished)
        {
            animations.Clear();
            Finished = true;
        }
    }

    public override void Skip()
    {
        foreach (Animation anim in animations)
        {
            anim.Skip();
        }
        animations.Clear();
        Finished = true;
    }

    public void Add(Animation newAnim)
    {
        animations.Add(newAnim);
        Finished = false;
    }
}

class AnimSequential : Animation
{
    readonly Queue<Animation> animations = new();
    Animation current = null;

    public override void Update(float deltaTime)
    {
        if (Finished) return;

        if (current == null || current.Finished)
        {
            try
            {
                current = animations.Dequeue();
            }
            catch
            {
                Finished = true;
                return;
            }
        }

        current.Update(deltaTime);
    }

    public override void Skip()
    {
        current?.Skip();
        foreach (Animation anim in animations)
        {
            anim.Skip();
        }
        animations.Clear();
        Finished = true;
    }

    public void Add(Animation newAnim)
    {
        animations.Enqueue(newAnim);
        Finished = false;
    }
}

class AnimCardMove(Card card, Vector2 target) : Animation
{
    private readonly Card card = card;
    private Vector2 target = target;

    const float LINEAR_SPEED = 100;

    public override void Update(float deltaTime)
    {
        if (Finished) return;
        float dp = LINEAR_SPEED * deltaTime;
        Vector2 dir = target - card.pos;
        if (dir.Length() < dp)
        {
            card.pos = target;
            Finished = true;
            return;
        }
        dir.Normalize();
        card.pos += dir * dp;
    }

    public override void Skip()
    {
        card.pos = target;
        Finished = true;
    }
}

static class Animations
{
    private static readonly AnimParallel animations = new();

    public static void Add(Animation newAnimation)
    {
        animations.Add(newAnimation);
    }

    public static void Update(float deltaTime)
    {
        animations.Update(deltaTime);
    }

    public static void SkipAll()
    {
        animations.Skip();
    }
}