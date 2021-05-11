---
title: "Shifting to Hugo"
description: "Porting Github Pages blog from Jekyll to Hugo"
date: 2021-01-09
tags: [tech]
---

After having used Jekyll for a long time, I have shifted to Hugo for this GitHub pages blog.

## What is Hugo?

[Hugo](https://gohugo.io/), just like [Jekyll](https://jekyllrb.com/), is a static site generator. While Jekyll is written in Ruby, Hugo is written in Go. These generators source their content from markdown files. They use templating engines to generate the required HTML, CSS and JS files according to the logic described in the config file and templates. Jekyll uses the [Liquid](https://shopify.github.io/liquid/) templating language, while Hugo uses Go for templating.

## Why though?

The decision to shift to Hugo was a totally impulsive one. I was sitting at my laptop one day idly, after a series of exhausting online classes. There is something about being bored and idle that gives rise to restlessness. I had my blog open in one of the tabs on my browser and on a whim, decided to change it completely. I was bored with how it looked and more importantly, I needed something to do.

I had heard from some of my friends that Hugo was a good option, so I decided to look into it. The setup was way easier than expected. It literally only took 2 steps to get it running. I eventually selected the [hugo-ink](https://github.com/knadh/hugo-ink) theme and modified it to my requirements. Changing the markdown files took minimal effort that was easily automated with a Python script.

I am finding Hugo to be better than Jekyll because of the following reasons:

## Smooth local setup

Setting up Hugo locally is dead easy. As I am running Fedora, I installed it from source. I had a sample website up in no time. The CLI is quite easy to use as compared to Jekyll. It comes with [LiveReload](https://gohugo.io/getting-started/usage/#livereload) built-in. As Hugo builds the pages insanely fast, there is rarely any lag in the changes getting reflected. One of the major headaches I faced while managing the blog in Jekyll was the local setup. Hugo solved these by making the experience much more seamless.

## Inbuilt support for Disqus, Google Analytics

In the previous version of my blog, I had configured the Facebook comments plugin. It was quite buggy and took ages to load. I shifted to Disqus and it is working quite smoothly with a smaller render time. To add the Disqus comment section, I only had to add the `short name` to the `config.toml` file. The rest was taken care by Hugo.

## More and better themes to select from

I found more minimal and simple [themes for Hugo](https://themes.gohugo.io/) than I did for Jekyll. After some hunting, I found the Ink theme, which required very little modifications to suit my requirements. This theme also supported changing the theme of the blog (dark/light) which was a huge bonus.

## Easy addition of tags and sections

In my Jekyll blog, I had to do some hacks to get the functionality of having a separate section for a particular kind of blog posts, where I had to change the rendering logic use in the templates. In Hugo, I can simply create nested folders in the `content` folder and Hugo will organize the routes accordingly.

All in all, unless I find something better (looking at you, [Zola](https://www.getzola.org/)) and I am seized by a similar random impulse, Hugo is here to stay.
