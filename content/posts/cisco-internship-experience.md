---
title: Summer Internship at Cisco
description: Experience and Learnings
date: 2021-07-17
tags: []
---

Yesterday, I completed my software development summer internship at [Cisco](https://www.cisco.com/). The internship was sadly conducted virtually from home. Even so, it was exciting to start work after the lull in activity caused by the end of the semester. The tension of the first day was muted, as all I had to do was open the laptop screen like a thousand times before. Out of a sense of propriety, I made the effort of putting on jeans (after several weeks) instead of my usual sweatpants, but dropped the pretense the next day onwards. 

While I can’t reveal the exact details of my project, I will try to enlist some of the things that I learned in the internship.

### pdb - The Python Debugger

Multiple college seniors I know had previously recommended using a debugger while programming, but I lacked motivation to use it since I was getting by using print statements all over the code. After using [pdb](https://docs.python.org/3/library/pdb.html) in the intern, the print statement method of debugging seems crude. 

If we need to inspect the state of the variables at any point in the execution, we can insert a single line `import pdb; pdb.set_trace()` in the code. This will cause the interpreter to pause the flow of execution at that point while preserving all the objects that are created in the current frame until then. The `(n)ext` command is particularly useful, which can be used to execute the code line-by-line. Going back to the print statement method doesn’t make sense now :)

### Context managers

I had known that context managers were quite useful before, but I realized this fully when I felt the need to write one myself. Having multiple unhandled clients open to a particular server was becoming an issue. Using context managers to handle the connection objects proved to be a very clean and elegant solution, rather than closing connection objects every time they complete their function. 

### Router technologies

As a part of my project, I got to use networking tools like [YANG](http://www.yang-central.org/twiki/pub/Main/YangDocuments/rfc6020.html), [Netconf](https://datatracker.ietf.org/doc/html/rfc6241) and RPCs. Netconf is a protocol that is used to manipulate the configuration of routers. Netconf operations are carried out over an RPC layer that transfers data using XML. The configuration for the routers is modelled using the YANG modelling language. Router configuration is stored as a set of ‘YANG models’. I also got an experience of using Cisco’s [IOS XR](https://en.wikipedia.org/wiki/Cisco_IOS_XR) network operating system, which was quite interesting.

### Some Django

Until before this internship, I had mostly worked with Flask as the backend framework (a little bit of [Falcon](https://falconframework.org/) at my previous internship). I was introduced to Django in this internship, and it lived up to its reputation of being powerful as well as complicated. 

A great thing I found about Django was that it had built-in support for connecting databases. Earlier, I had used an ORM (SQLAlchemy) as abstractions over SQL. Django natively supports creating models for different databases like MySQL, PostgreSQL, etc and using them to run queries through an object-oriented interface. 

Another useful feature of Django is the django-admin commands functionality. It allows writing custom scripts in the `management/commands` directory. These scripts can be set up as cron jobs in the `settings.py` file. This is especially useful if we have to use database models and other functionalities available in the Django environment while running our scripts.

### Importance of documentation

I learned the importance of good documentation from the lack of it. As the project I was working on was relatively new, I faced difficulties in understanding the different moving parts of the code because of insufficient documentation. The time I spent trying to figure things out could have been saved and spent in actual development had there been good documentation. I realized that documentation makes asynchronous work possible. In an ideal situation, it should exist for all parts of the code and other guidelines, which can eliminate the need to wait for in-person knowledge transfer.

### Maintaining a work log

Through the six weeks, I tried to maintain a work log, where I noted down what all I had accomplished that day and what were the tasks for tomorrow. In addition to this, I also wrote down any important observations from working or having conversations with my mentor. This method helped to keep me on track with my work. I hope to apply this method in the future too.

## Final thoughts

The most obvious thing that I felt lacking in my internship experience was a feeling of community and togetherness. In virtual mode, the feeling of working in a ‘team’ becomes very weak especially in a large organization and among completely new people. This made me feel isolated while working on my project. While I don't mind working solo, I think a lot of learning was missed. In my previous internships, I got the chance to interact with full-time employees and co-interns in a casual environment outside of work. I sorely missed that feeling while working in this period. I guess it is just another misfortune of the times we are living in.

Anyways, I got to learn new things (and also got paid decently), for which I am grateful.

Peace!