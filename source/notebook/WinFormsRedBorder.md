---
layout: page
title: "Drawing a RedBorder around controls in Windows Forms"
comments: true
sharing: true
footer: true
---
```csharp
    private Form _parentForm;

    private ToolTip _errorToolTip;
    private ToolTip ErrorToolTip
    {
        get { return _errorToolTip ?? (_errorToolTip = new ToolTip()); }
    }

    private void SetError(Control control, string value)
    {
        // ....

        if (_parentForm == null)
        {
            _parentForm = control.FindForm();
            if (_parentForm != null)
                _parentForm.Paint += BorderPaintEventHandler;
    
        }
        ErrorToolTip.SetToolTip(control, String.IsNullOrWhiteSpace(value) ? null : value);
        if (_parentForm != null)
            _parentForm.Refresh();
        break;
        
        // ....
    }
    
    private void BorderPaintEventHandler(object sender, PaintEventArgs args)
    {
        if (_parentForm == null || _controls.Count == 0)
            return;

        foreach (var ctrl in _controls)
        {
            var bounds = ctrl.Bounds;
            var activeCountrolBounds = new Rectangle(bounds.Left - 1, bounds.Top - 1, bounds.Width + 1, bounds.Height + 1);
            ctrl.Parent.CreateGraphics().DrawRectangle(Pens.Red, activeCountrolBounds);
        }
    }

    protected override void Dispose(bool disposing)
    {
        if (disposing)
        {
            if (_errorToolTip != null)
                _errorToolTip.Dispose();

            if (_parentForm != null)
                _parentForm.Paint -= BorderPaintEventHandler;

            _controls.Clear();
        }

        base.Dispose(disposing);
    }
```