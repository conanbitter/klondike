using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;


namespace klondike;

class Animation
{
    public bool Finished { get; private set; } = false;

    private bool firstTime = true;

    protected virtual void OnUpdate(float deltaTime) { }
    protected virtual void OnSkip() { }
    protected virtual void OnStart() { }
    protected virtual void OnFinish() { }

    public void Update(float deltaTime)
    {
        if (firstTime)
        {
            OnStart();
            firstTime = false;
        }
        if (!Finished) OnUpdate(deltaTime);
    }

    public void Skip()
    {
        OnSkip();
        Finish();
    }

    protected void Finish()
    {
        OnFinish();
        Finished = true;
    }

    protected void Restart()
    {
        firstTime = true;
        Finished = false;
    }
}

class AnimParallel : Animation
{
    readonly List<Animation> animations = [];

    protected override void OnUpdate(float deltaTime)
    {
        bool allFinished = true;
        foreach (Animation anim in animations)
        {
            anim.Update(deltaTime);
            if (!anim.Finished) allFinished = false;
        }

        if (allFinished)
        {
            animations.Clear();
            Finish();
        }
    }

    protected override void OnSkip()
    {
        foreach (Animation anim in animations)
        {
            anim.Skip();
        }
        animations.Clear();
    }

    public void Add(Animation newAnim)
    {
        animations.Add(newAnim);
        Restart();
    }
}

class AnimSequential : Animation
{
    readonly Queue<Animation> animations = new();
    Animation current = null;

    protected override void OnStart()
    {
        try
        {
            current = animations.Dequeue();
        }
        catch
        {
            Finish();
            return;
        }
    }

    protected override void OnUpdate(float deltaTime)
    {
        if (current == null || current.Finished)
        {
            try
            {
                current = animations.Dequeue();
            }
            catch
            {
                Finish();
                return;
            }
        }

        current.Update(deltaTime);
    }

    protected override void OnSkip()
    {
        current?.Skip();
        foreach (Animation anim in animations)
        {
            anim.Skip();
        }
        animations.Clear();
    }

    public void Add(Animation newAnim)
    {
        animations.Enqueue(newAnim);
        Restart();
    }
}

class AnimCardMove(Card card, Vector2 target) : Animation
{
    private readonly Card card = card;
    private Vector2 target = target;

    const float LINEAR_SPEED = 300;

    protected override void OnStart()
    {
        card.layer = Cards.Layer.Foreground;
    }

    protected override void OnFinish()
    {
        card.layer = Cards.Layer.Background;
    }

    protected override void OnUpdate(float deltaTime)
    {
        float dp = LINEAR_SPEED * deltaTime;
        Vector2 dir = target - card.pos;
        if (dir.Length() < dp)
        {
            card.pos = target;
            Finish();
            return;
        }
        dir.Normalize();
        card.pos += dir * dp;
    }

    protected override void OnSkip()
    {
        card.pos = target;
    }
}

delegate float EasingFunction(float val);

public static class Easing
{
    public static float Linear(float val)
    {
        return val;
    }

    public static float EaseOutCubic(float val)
    {
        return 1.0f - (float)Math.Pow(1.0 - val, 3.0);
    }

    public static float EaseOutQuint(float val)
    {
        return 1.0f - (float)Math.Pow(1.0 - val, 5.0);
    }

    public static float EaseOutCirc(float val)
    {
        return (float)Math.Sqrt(1.0 - Math.Pow(val - 1.0, 2.0));
    }

    public static float EaseInOutCubic(float val)
    {
        return val < 0.5f ? 4.0f * val * val * val : 1.0f - (float)Math.Pow(-2.0 * val + 2.0, 3.0) / 2.0f;
    }

    public static float EaseInOutQuint(float val)
    {
        return val < 0.5f ? 16.0f * val * val * val * val * val : 1.0f - (float)Math.Pow(-2.0 * val + 2.0, 5.0) / 2.0f;
    }

    public static float EaseInCubic(float val)
    {
        return val * val * val;
    }

    private const float EOB_C1 = 1.70158f;
    private const float EOB_C3 = EOB_C1 + 1.0f;

    public static float EaseOutBack(float val)
    {
        return 1.0f + EOB_C3 * (float)Math.Pow(val - 1.0, 3.0) + EOB_C1 * (float)Math.Pow(val - 1.0, 2.0);
    }
}


class AnimCardMoveFixed(Card card, Vector2 target, float duration, EasingFunction easing) : Animation
{
    private readonly Card card = card;
    private Vector2 target = target;
    private Vector2 startPos;
    private readonly float duration = duration;
    private float currentTime = 0.0f;
    private readonly EasingFunction easing = easing;

    public void MoveTarget(Vector2 newTarget)
    {
        target = newTarget;
    }

    protected override void OnStart()
    {
        card.layer = Cards.Layer.Foreground;
        startPos = card.pos;
    }

    protected override void OnFinish()
    {
        card.layer = Cards.Layer.Background;
    }

    protected override void OnUpdate(float deltaTime)
    {
        currentTime += deltaTime;
        if (currentTime >= duration)
        {
            card.pos = target;
            Finish();
            return;
        }

        float time = easing(currentTime / duration);

        card.pos = startPos + (target - startPos) * time;
    }

    protected override void OnSkip()
    {
        card.pos = target;
    }
}

class AnimCardFlip(Card card) : Animation
{
    private readonly Card card = card;

    protected override void OnUpdate(float deltaTime)
    {
        card.flipped = false;
        Finish();
    }

    protected override void OnSkip()
    {
        card.flipped = false;
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