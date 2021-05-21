---
title: "Middle Click in X"
date: 2021-05-21T13:03:28+05:30
description: "Input devices and selections"
draft: false
---

A very useful and unique feature of the ThinkPad is the TrackPoint (red dot in the picture below), which is used to control the mouse pointer. It works through applying varying amounts of pressure in the direction of movement (more pressure, faster movement). [While it isn't popular](https://www.theverge.com/circuitbreaker/2020/6/30/21292182/thinkpad-trackpoint-mouse-nub-button-trackpad-challenges-design-user-input), it has won me over to the point that I find using the normal touchpad inconvenient. The biggest advantage for me is that I don't need to move my hand too far from the keyboard to scroll/click.

![trackpoint](/img/trackpoint.jpeg)

The TrackPoint and the middle button can be used simultaneously to scroll. _Keeping the middle button pressed_, we can scroll in the direction we want to using the TrackPoint. While convenient, this produces a weird behavior in the [X window system](https://en.wikipedia.org/wiki/X_Window_System). In X, the text selection from any window is pasted into any other window (or the same window) when the middle button is pressed. This results in pieces of previously-selected text getting pasted accidentally in awkward places while scrolling. For instance,

![mistake](/img/mistake.png)

Not good.

I tolerated this for a long time, even with unintended words appearing in committed code (aaargh!). Last week, when such a goof up happened in a presentation I gave to ~40 people, I had had it. This feature had now become a bug for me.

### Where does selected text go?

A way for inter-client communication in X is through selections. When text is selected in any window, it is stored in the [Xorg](https://wiki.x.org/wiki/) server and identified by an `atom` (a 'name'). While there can be an arbitrary number of selections, the important ones are the `PRIMARY` selection and the `clipboard` selection.

Each selection is owned by a client (a particular window). When the text in a particular selection is to be pasted in another window, it asks the server for that selection using the atom used to identified it.  The server then refers the request to the window that owns that selection. The window responds with the text and the it can then be pasted.

On selecting text in a window with a cursor, the ownership of `PRIMARY` selection is transferred to the current window, with its value as the selected text. Text is moved to the `clipboard` selection on an explicit copy instruction (`Ctrl+C` etc). When the middle button on the mouse is clicked, the `PRIMARY` selection is pasted in the current window. 

![middle-click-paste](/img/middle-click-paste.gif)

Unfortunately, this cannot be disabled globally.

### Mapping devices to the display

One way of working this problem out would be to nuke the middle click itself.

For a input device to interact with X, the physical device buttons are mapped to logical buttons. The logical buttons are provided by the server to the clients that need to use them (References: [1](https://who-t.blogspot.com/2009/06/button-mapping-in-x.html) [2](https://who-t.blogspot.com/2010/07/input-event-processing-in-x.html)). We can use the `xinput` tool to look at the devices and their mappings.

![](/img/xinput.png)

The master pointer and master keyboard are abstractions at the level of the X server. These have multiple slave devices. These slave devices are the interfaces provided by the device drivers (these are produced by listening to events in the files in `/dev/input`). The interface between the moving the physical mouse and the cursor on the screen is apparent here (the latter is done by X on the basis of events it receives from the device and the former can be done from any one of the TrackPoint, the USB mouse or the TouchPad).

The mappings of the buttons can be found using the `get-button-map` argument with the command.

```shell
$ xinput get-button-map 'TPPS/2 Elan TrackPoint'
1 2 3 4 5 6 7
```

Here, each of the integers correspond to events- clicking a physical button or the movement of the wheel in a particular direction. The `2` corresponds to the middle click. We can disable this by replacing it with `0`.

```shell
$ xinput set-button-map 'TPPS/2 Elan TrackPoint' 1 0 3 4 5 6 7
```

Another way would be to disable the middle click functionality at the level of the pointer. We can do this by adding the following line to the  `~/.Xmodmap` file.

```
pointer = 1 0 3 4 5 6 7
```

As this at the level of the server, it will disable the middle click for any device controlling the pointer.

After this, the middle click was disabled while retaining the scrolling behavior. No text was pasted on clicking the middle button!

### Yay(?)

Well, not quite.

There are some other useful behaviors of the middle click in the browser, like directly closing tabs and opening links in new tabs.

![](/img/tab-close.gif)

![](/img/new-tab-middle-click.gif)

I have unconsciously become habituated to these features. So removing the middle click functionality caused a lot of discomfort.

The answers that I found [here](https://unix.stackexchange.com/questions/24330/how-can-i-turn-off-middle-mouse-button-paste-functionality-in-all-programs) work in some programs, but cause issues while copying in others. I ended up keeping the middle click anyways.

Until I find a concrete solution to this, I guess I'll just have to be careful while scrolling :)
