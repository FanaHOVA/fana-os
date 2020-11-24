# fana-os
This is my operating system. High level:

- Knowledge management: Obsidian
- Reading: Pocket
- 

### Pocket

I use Pocket to store articles, read them, as well as highlighting them. In the PocketUtils class, you can find a simple exporter to Obsidian:

- Fetch all Pocket articles in your account
- Save them in a local Mongo instance (title, URL, tags etc)
- Based on what day I read the article, it adds an entry in the corresponding Obsidian daily notes doc. Here's an example:

```
**[The Opportunity and Risks for Consumer Startups in a Social Distancing World — A Framework for…](https://medium.com/@sarahtavel/the-opportunity-and-risks-for-consumer-startups-in-a-social-distancing-world-a-framework-for-15f65e2fbdff)**
*By Sarah Tavel*
Tags: 
- Some rocks (such as TV) are easier to fit in because they are porous rocks, making multi-tasking easier (like scanning Twitter during slow parts of a show).
- Water is different than rocks and sand. Water don’t require dominant attention and can permeate some rocks and all sand time.* For example, something like Discord is a perfect water for a gaming rock.
- Events that span bigger blocks of contiguous time (“Rocks”), micro events that take advantage of attention gaps between or during those blocks (“Sand”), and things that can overlay over the other two (“Water”).
```

To get the access token you can use the Sinatra server built in (Start it with `ruby oauth_server.rb`). In order to get highlights, you should use the consumer key obtained from the Pocket web app. To get that, use the Chrome dev tools and observe the XHR requests; they will include the `consumer_key` as a parameter. Then plug that into your `.env` file. 

## In the pipeline

### Remote db support

Right now I use a local Mongo to store data. Should move this to an hosted instance.

### Obsidian

I version control all of my Obsidian. I do this manually, but it should be automated with a script + scheduled. 
