# My New Blog!

I've got a lot to say, and now I have a place to say it!!!!!

Read all my amazing posts!!!!! You can load them into the app with: `rake load:blog`

Since I know you want to read them all, I designed my page to show EVERYTHING on the front page of the site!!!!!

I know it is a little slow (but totes worth it!!!!)... _Do you know how I can make it faster?_

# I'm feeling insecure...

Well, I got some requirements from marketing to make sure we distinguish between published and unpublished posts. I made some changes to the html and css.

But now security auditors are telling me I have some security vulnerabilities! They were able to use the strings below to hack my site!!!

What do I do to fix it???


XSS:
```
http://localhost:3000/posts?utf8=%E2%9C%93&search=archive&status=foo=%22bar%22%3E%3Cscript%3Ealert%28%22p0wned!!!%22%29%3C/script%3E%3Cp%20data-foo
```

SQL Injection:

```
foo%'); INSERT INTO posts (id,title,body,created_at,updated_at) VALUES (99,'hacked','hacked alright','2013-07-18','2013-07-18'); SELECT "posts".* FROM "posts" WHERE (title like 'hacked%
```

# My Fixes...

## XSS

Using the URL above, a JavaScript alert was being injected into the page. In this case, `search` is already being `strip`ped in the model, so we need to focus on `status`. One potential fix is to create a string that is either "published" or "unpublished" based on the value of `params[:status]`, but there's technically three conditions: published, unpublished, or all. No go.

So the other option, as suggested in [RailsCast 178](http://railscasts.com/episodes/178-seven-security-tips?view=asciicast), is to escape any data that can be potentially entered by the user, by wrapping it in the `h()` method. This isn't perfect, as the data still appears on the page, but at least the alert doesn't pop up!

## SQL Injection

Since our versions of Postgres and SQLite have apparently patched this bug, we couldn't quite play with injecting data. Oh well. I patched it anyway, by following the lead on the [Ruby on Rails Security Guide](http://guides.rubyonrails.org/security.html#sql-injection). Instead of directly placing the user input in the `where` method, I escaped it out, and added the regular expression `%` characters manually around the `search` term. That should fix it on computers running old, unpatched databases!

## Brakeman

For some reason, Brakeman did not pick up the XSS or SQL injection holes. But it did pick up on the fact that Git was tracking `config/initializers/secret_token.rb`, which is a good fix!
