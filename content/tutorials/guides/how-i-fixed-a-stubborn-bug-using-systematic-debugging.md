---
title: "How I Fixed a Stubborn Bug Using Systematic Debugging"
date: 2026-05-31
toc: true
draft: false
tags:
  - Coding
  - Debugging
  - Best Practices
description: "AI-generated code can hide bugs in unexpected places. I used a systematic debugging methodology to find a root cause that had stumped me for hours."
category: "guides"
rating: 5
---

AI-generated code can hide bugs in unexpected places. I used a systematic debugging methodology to find a root cause that had stumped me for hours.

### Why I Went Down This Rabbit Hole

The terminal blinked at 2:14 AM. I was staring at a JSON response that listed a customer order total as four hundred dollars instead of forty. The API was supposed to pull discount codes from a PostgreSQL table and apply them before returning the payload. I had generated the endpoint using an AI assistant three days prior. It worked perfectly in staging. It broke in production after we migrated the promo table. I started throwing print statements at the router. I changed variable names. I restarted the server. Nothing shifted the numbers. I realized I was debugging by accident, not by design.

I decided to stop guessing. I pulled up a methodology from a GitHub repository called obra/superpowers. It replaces random patching with a strict hypothesis framework. I needed to treat my code like a crime scene.

### Setup: How Long It Actually Took

I spent three hours chasing ghosts before I changed my approach. The first hour involved adding logging to every layer of the stack. I broke the authentication middleware because I accidentally overwrote a dependency. I reverted the commit. The second hour was spent rewriting the SQLAlchemy query based on a hunch. That query timed out and locked the development database. I had to kill the process and roll back again.

By the time I sat down to actually use the systematic debugging workflow, my eyes were burning. The method itself took forty-five minutes to run properly. Writing the initial hypotheses felt tedious. I had to pause my instinct to just type code. The framework forced me to document each assumption before touching a keyboard. That friction saved me from another wasted hour.

### What I Built With It

The project was a FastAPI endpoint that aggregates user orders. It should return a clean list of items, applied discounts, and final totals. The AI generated the initial route, model, and service layer. It produced a working prototype that passed basic unit tests. Production data exposed the flaw. The aggregation logic multiplied discount values across duplicate rows.

I fed the broken code into my debugging workflow. I asked the system to generate a test matrix instead of suggesting fixes. It returned a structured list of potential failure points. The first hypothesis blamed the frontend rounding logic. I ran a direct curl request to bypass the UI entirely. The raw JSON still showed inflated totals. I crossed that off.

The second hypothesis pointed to a race condition in the discount cache. I flushed Redis and hit the endpoint again. The numbers stayed wrong. That failure forced a pivot. I stopped looking at application state and started looking at data flow. I instructed the debugging assistant to trace the exact SQL emitted by the ORM. It suggested adding a query logger and running a single request.

The logs revealed a subtle join mismatch. The AI had written a left outer join on the promo table instead of an inner join. When a user had multiple expired promos in the database, the query returned duplicate order rows. The Python aggregation function then summed the discount multiple times. I swapped the join type and added a distinct filter. The endpoint returned correct values on the next test. I verified the fix against a dataset of ten thousand records. The totals matched the accounting system exactly.

Here is the exact snippet that caused the problem:

```python
# Broken version
orders = db.query(Order).outerjoin(Discount).filter(
    Order.user_id == user_id
).all()

# Fixed version
orders = db.query(Order).join(Discount).filter(
    Order.user_id == user_id,
    Discount.is_active == True
).distinct().all()
```

The difference was a single join method. The AI assistant had defaulted to the safer outer join. It ignored the business rule that only active discounts matter for calculation. The systematic approach caught it because I forced myself to test data shape before touching logic.

### What Surprised Me

The discipline of writing down hypotheses actually reduced my cognitive load. I stopped holding multiple variables in my head at once. The physical act of crossing out a proven wrong assumption gave me real momentum. I also noticed how much faster the AI worked when constrained to testing rather than fixing. It stopped guessing at syntax and focused on data validation.

The bad surprise was the initial resistance. My brain wanted to type print statements immediately. The framework demands patience. You have to trust the process when you are staring at a broken screen. That mental drag felt unnatural at first. It gets easier once you see the results.

### Things That Annoyed Me

The methodology assumes you have immediate access to accurate database schemas. My local environment was missing a recent migration. The debugging assistant kept referencing a discount_rules table that did not exist. I wasted twenty minutes tracing phantom columns. The framework does not account for schema drift. You have to verify your environment before the hypotheses matter.

I also dislike how much manual context pasting the workflow requires. You need to feed the exact traceback, the relevant route file, and the database logs into the prompt. The assistant does not pull context automatically. It becomes a copy-paste chore when you are dealing with a large codebase. I ended up writing a small shell script to bundle the logs. That workaround felt clunky.

### When I Use It vs When I Don't

I reach for this approach when the bug lives in the intersection of multiple systems. Database joins, async queues, and third-party API responses all create hidden failure paths. The hypothesis framework shines when random guessing fails. It forces isolation of variables. I skip it entirely for syntax errors or missing imports. A linter catches those problems instantly. I also avoid it for simple UI styling issues. The overhead does not justify the fix.
