---
layout: post
title: "PowerShell: the switch data-type"
date: 2015-05-18 00:45:18 +1000
comments: true
categories:
- PowerShell
---
The `switch` data type is used to control whether a switch (as in arguments or options passed to a function or command) is provided for the function/command or not. Suppose that there is a function called `Switch-Demo` that can accept `-Force` and `-Quiet` switches. These switches just work as toggles. What we care about them is whether they exist or not. There are no pieces of data accompanying them. The PowerShell `switch` data-type suits this purpose:

```powershell
function Switch-Demo {
    param(
        [switch]$Force,
        [switch]$Quiet
    )

    if($Force.IsPresent) {
        Write-Host "Forcefully doing the task"
    } else {
        Write-Host "Force is NOT present"
    }

    if($Quiet.IsPresent) {
        Write-Host "Quietly doing the task"
    } else {
        Write-Host "Quiet is NOT present"
    }
}

# invocation:
Switch-Demo -Quiet
```

In the invocation of the above example, the `Quiet` switch is present while the `Force` switch is not.

As shown above, the `.IsPresent` property of the `switch` variable can be used to check whether the particular switch has been passed to the function/command.

**Default values** for the parameters of type `switch` can be specified by Boolean values. To make a switch present by default the `[switch]::Present` constant can also be used, which is equivalent to `$true`. As of now I'm not aware of any `[switch]::` constants that is equivalent to `$false`. Example:

```powershell
function Switch-Demo {
    param(
        [switch]$Force=[switch]::Present,
        [switch]$Quiet=$false,
        [switch]$WhatIf=$true
    )

    # ...
}
```

This means that the invoker does not need to specify `-Force` switch (it is by default considered to be provided). What if the invoker doesn't like the `-Force` switch to be present? To override that the invoker can specify Boolean constants as values for the switch:

```powershell
Switch-Demo -Force:$false
```

I personally don't find this way of overriding switch values quite intuitive. I'd rather name `switch` variables in a way that their default value is `$false`, or when not possible provide another switch with a negative name compared to the other one that overrides its functionality. Example:

```powershell
function Switch-Demo {
    param(
        [switch]$Quiet=[switch]::Present,
        [switch]$Verbose
    )

    # Override the values
    if($Verbose.IsPresent){
        $Quiet = $false;
    }

    # Check the values
    if($Quiet.IsPresent){
        Write-Host "Quietly doing the job."
    } else {
        Write-Host "Verbosely doing the job."
    }
}

# invocations:
Switch-Demo -Quiet
Switch-Demo -Verbose
```
