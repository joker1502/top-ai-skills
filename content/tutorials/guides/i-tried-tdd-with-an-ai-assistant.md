---
title: "I Tried TDD With an AI Assistant and It Caught a Bug"
date: 2026-05-31
draft: false
tags:
  - AI Coding
  - TDD
  - Testing
description: "Test-driven development with AI sounds like extra work. I spent a weekend building an auth module test-first and found a security bug my normal workflow missed."
related_skills:
  - claude-code
  - github-copilot
category: "guides"
rating: 5
---

Test-driven development with AI sounds like extra work. I spent a weekend building an auth module test-first and found a security bug my normal workflow missed.

### Why I Went Down This Rabbit Hole

I was staring at a production log at 11 PM on a Tuesday. A user had somehow reset another account's password using a valid token that belonged to someone else. I had written that auth flow three months ago. I knew the code worked when I shipped it. I also knew exactly where the blind spot lived. I had written the happy path, patched the edge cases as they broke, and called it a day. That night, I promised myself I would never ship another authentication module without a safety net. The next morning, a colleague mentioned pairing test-driven development with an AI coding assistant. I rolled my eyes at first. Adding tests to an already slow process felt like putting training wheels on a rocket. I decided to try it anyway. I gave myself one weekend to build a full user authentication flow from scratch. Tests first. AI as the co-pilot. No shortcuts.

### Setup: How Long It Actually Took

I started with a fresh Node.js project using Express and Jest. I picked a mainstream AI coding assistant I already had installed. The environment took about forty minutes to configure. I installed the testing framework, set up the database connection, and wrote a basic configuration file. The real time sink was not the tools. It was the mindset shift. I had to force myself to open the test file before touching the application code. I mapped out three features: user registration, login with email and password, and password reset with a time-limited token. I blocked out Saturday morning for writing tests. I expected it to take two hours. It took four. I wrote assertions for missing fields, duplicate emails, invalid token formats, and expired links. I fed each failing test to the AI assistant. It generated implementation code. I pasted it in. The test passed. I repeated the loop. The rhythm felt unnatural at first. I kept wanting to write the function and then guess what to test. I had to physically close the source file until the test file was ready. The setup phase ended around 8 PM. I had a folder full of red tests and zero business logic.

### What I Built With It

The registration test came first. I wrote an assertion that expected a 200 status and a user record in the database. The AI generated a controller that hashed the password with bcrypt and saved the model. The test passed on the second run. Login followed the same pattern. I wrote a test for incorrect passwords, one for missing accounts, and one for successful JWT generation. The AI handled the comparisons and token signing without much fuss. Password reset is where things got interesting. I started with a test for generating a reset token. Then I wrote a test for applying that token. I wanted to verify that the token could only change the password for the account that requested it. I wrote the test to simulate User A requesting a reset, then tried to apply that same token to User B's account. I expected the test to pass immediately. It failed. The AI had generated a reset endpoint that only checked if the token existed and had not expired. It completely ignored the user ID binding. I stared at the terminal for a full minute. That exact oversight had caused my production incident months ago. I asked the AI to rewrite the reset logic. I told it to validate that the token's associated email matched the account receiving the update. The test turned green. I added rate limiting and token rotation. The pivot saved me from shipping a security hole.

Here is the test that exposed the flaw:

```javascript
test("reset token should not allow password change on mismatched account", async () => {
  const userA = await createTestUser("user@example.com");
  const userB = await createTestUser("other@example.com");
  const token = await requestResetPassword("user@example.com");

  const response = await applyResetToken(userB.id, token, "newPassword123");

  expect(response.status).toBe(403);
  expect(await verifyPassword(userB.id, "newPassword123")).toBe(false);
});
```

The AI initially produced a function that only verified the token string and expiration timestamp. I had to explicitly force the binding check into the implementation. Once the test passed, I felt a quiet sense of relief. I had caught the exact same vulnerability before it ever touched a staging server.

### What Surprised Me

I expected the AI to slow me down. I thought it would generate bloated code that I would spend hours untangling. The opposite happened. The test-first constraint forced the AI to stay focused. When I fed it a failing test, it only wrote enough logic to satisfy that specific condition. It stopped hallucinating extra middleware I did not ask for. It stopped adding unnecessary validation layers. I also noticed a shift in my own thinking. I stopped guessing what the code should do and started defining exactly what the system must refuse. The permission bug would have slipped through my normal workflow because I usually write the implementation first. I test what I already wrote. I unconsciously skip scenarios that feel unlikely. Writing the test first removed my own bias. The AI did not care about my assumptions. It just tried to make the assertion pass. When the assertion was strict, the code became strict. The entire process felt less like coding and more like contract negotiation. I drafted the terms. The AI filled in the details. If the terms were vague, the code broke. I learned to write sharper assertions. I started catching edge cases during the test drafting phase instead of during debugging. The psychological weight of shipping something untested disappeared. I had a green terminal. That was the only metric that mattered.

### Things That Annoyed Me

The friction was real. I spent twenty minutes fighting with the AI over database mocking. It kept trying to spin up an actual PostgreSQL container for every test run. I had to explicitly tell it to use an in-memory SQLite setup and mock the query builder. It also loved to overcomplicate simple assertions. I asked for a basic status code check. It generated a full response schema validator with custom error classes. I deleted half the output and rewrote it myself. The biggest annoyance was the false sense of completion. A green test suite does not mean the system works. It only means the code satisfies the tests I wrote. I still had to manually verify email delivery, token expiration timing, and password hashing performance. The AI also struggled with asynchronous cleanup. It kept leaving dangling promises in the teardown blocks. I had to manually add `afterAll` hooks to clear the test database. Another irritation was the repetitive boilerplate. Every test file required the same setup, mock factories, and token generators. I eventually wrote a helper module. The AI could not generate that module until I pasted in the repeated code and asked it to extract it. It learned the pattern only after I showed it the pattern. I also disliked the constant context switching. Writing a test, waiting for AI generation, pasting, running, reading the error, adjusting, repeating. It breaks flow if you are used to writing entire features in a single sitting. The discipline pays off. The process still feels like walking through wet cement.

### When I Use It vs When I Don't

I use this approach for anything that touches money, permissions, or external APIs. Authentication, payment routing, role-based access control, and webhook handlers get the full test-first treatment with AI. The upfront time investment pays for itself when the requirements change. I also use it when I am onboarding to a legacy codebase. Writing tests for unknown behavior forces me to understand the system before modifying it. I skip it for throwaway scripts, internal dashboards, and prototype features that will be deleted in two weeks. If the code will live for less than a month, the test suite costs more than the bug would. I also avoid it during intense debugging sessions. When a production fire needs a hotfix, I patch the issue, verify it manually, and write the test afterward. The test-first workflow requires a calm schedule and clear requirements. It fails under panic. It thrives under structure. I keep the discipline for the systems that matter. I let the rest run loose.
