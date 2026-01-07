using System;
using System.Data;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;

namespace klondike;

delegate void AdvMouseHandler(Point pos);

static class AdvancedMouse
{
    private const double GRAB_DELAY = 0.2;
    private const double DBL_DELAY = 0.3;
    private const double MOVE_TOLERANCE = 2;

    enum MouseMode
    {
        Normal,
        MaybeGrab,
        Dragging,
    }

    private static double sinceMouseDown = GRAB_DELAY + 0.1;
    private static double sinceLastClick = DBL_DELAY + 0.1;
    private static Point lastMousePos = Point.Zero;
    private static Point lastDownPos = Point.Zero;
    private static Point lastClickPos = Point.Zero;
    private static MouseMode mode = MouseMode.Normal;
    private static Point scale = new(3);

    private static bool buttonWasPressed = false;

    public static event AdvMouseHandler OnGrab;
    public static event AdvMouseHandler OnDrag;
    public static event AdvMouseHandler OnDrop;
    public static event AdvMouseHandler OnClick;
    public static event AdvMouseHandler OnDblClick;

    private static void WaitExpaired()
    {
        if (mode == MouseMode.MaybeGrab)
        {
            mode = MouseMode.Dragging;
            OnGrab?.Invoke(lastDownPos / scale);
        }
    }

    public static void Update(double deltaTime)
    {
        MouseState state = Mouse.GetState();

        sinceLastClick += deltaTime;
        sinceMouseDown += deltaTime;

        if (mode == MouseMode.MaybeGrab && sinceMouseDown > GRAB_DELAY)
        {
            WaitExpaired();
        }

        if (state.LeftButton == ButtonState.Pressed && !buttonWasPressed)
        {
            buttonWasPressed = true;
            if (mode == MouseMode.Normal)
            {
                mode = MouseMode.MaybeGrab;
                lastDownPos = state.Position;
                sinceMouseDown = 0.0;
            }
        }
        if (state.LeftButton == ButtonState.Released && buttonWasPressed)
        {
            buttonWasPressed = false;
            if (mode == MouseMode.MaybeGrab)
            {
                mode = MouseMode.Normal;

                if (sinceLastClick < DBL_DELAY &&
                    Math.Abs(state.X - lastClickPos.X) < MOVE_TOLERANCE &&
                    Math.Abs(state.Y - lastClickPos.Y) < MOVE_TOLERANCE)
                {
                    sinceLastClick = DBL_DELAY + 0.1;
                    OnDblClick?.Invoke(state.Position / scale);
                }
                else
                {
                    sinceLastClick = 0.0;
                    lastClickPos = state.Position;
                    //OnClick?.Invoke(state.Position / scale);
                }
                OnClick?.Invoke(state.Position / scale);
            }
            else if (mode == MouseMode.Dragging)
            {
                mode = MouseMode.Normal;
                OnDrop?.Invoke(state.Position / scale);
            }
        }
        if (lastMousePos != state.Position)
        {
            if (mode == MouseMode.Dragging)
            {
                OnDrag?.Invoke(state.Position / scale);
            }
            else if (Math.Abs(state.X - lastDownPos.X) > MOVE_TOLERANCE || Math.Abs(state.Y - lastDownPos.Y) > MOVE_TOLERANCE)
            {
                WaitExpaired();
            }
            lastMousePos = state.Position;
        }
    }
}