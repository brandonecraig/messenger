# README

# Architecture / Technical Decisions

I wrote this API using Ruby and Rails. Rails allows for quick development and
ActiveRecord makes it easy to perform the required queries. For now I went with
sqlite as it would be the easiest to get set up on your end.

The message class contains the recipient username, the sender username, the body
of the message and timestamps.

At first I considered including a Users class. After considering the requirements
I decided to forgo users for now. All of the required functionality can be
accomplished without a Users class. Additionally, including a User class that
only included one field (username) would lead to an N+1 when trying to serialize
the usernames within the messages json payload and would require additional
logic to preload those usernames before returning the payload. For now that
doesn't seem necessary so I went with the simpler option of storing the
usernames as the sender and recipient on message.

1. A short text message can be sent from one user (the sender) to another (the
    recipient).

This is achieved through the MessagesController#create action. A request is made
with a recipient username, a sender username and the body of the message. The
text datatype allows messages up to 30,000 characters. If a longer length is
needed in the future one solution would be to split up the text into as many
message as needed.

2. Recent messages can be requested for a recipient from a specific sender -
with a limit of 100 messages or all messages in last 30 days.

The MessagesController#show action queries the database for the 100 most recent
messages that are less than 30 days old that were sent to the specified recipient by the
specified sender.

3. Recent messages can be requested from all senders - with a limit of 100
messages or all messages in last 30 days.

If no sender param is sent then MessagesController#show will return the 100 most
recent messages that are less than 30 days old that have been sent to the
recipient by any user.

4. Document your api like you would be presenting to a web team for
use.

## API Documentation:

### Get Messages Sent to a User

Endpoint: "/messages/:recipient"
Method: GET
Params:
recipient - String, required. This is the username of the user receiving the
message.
sender - String, optional. This is the username of the user sending the message.

If no sender provided, endpoint will return messages sent to recipient from all
users. Messages are limited to the most recent 100 that are less than a month
old.

### Create new message

Endpoint: "/messages/"
Method: POST
Params:
recipient - String, required. This is the username of the user receiving the
message.
sender - String, required. This is the username of the user sending the message.
body - String, required. This is the body of the message.


### Get full conversation between two users

Endpoint: "/chat"
Method: GET
Params:
recipient - String, required. This is username of one of the users in the
conversation.
sender - String, required. This is the username of the other user in the
conversation.

Messages are limited to the most recent 100 that are less than a month
old. You may arbitrarily choose you is the recipient and who is the sender.

5. Show us how you would test your api.

I included MessagesControllerSpec unit tests to cover all the required
  functionality. You can run the specs with this command:

  ```
     bundle exec rspec
  ```

Additionally I included a demo script to interact with the server using curl.
See more about that below.

6. Ensure we can start / invoke your api.

I use rvm to manage my ruby version. You can get rvm setup here:
https://rvm.io/rvm/install

```
   rvm install ruby-2.7.1
   rvm use ruby-2.7.1
   bundle install
   bundle exec rake db:create
   bundle exec rake db:migrate
   source .env
   bundle exec rails server
```

NOTE: The configuration in .env is to suppress the deprecation notices. I found
these noisy. In a professional situation I would address these deprecation
warnings but for the purposes of this assignment I didn't think it was a
productive use of my time.

You can invoke the API by making requests to localhost:3000.

7. Bonus Features

I thought it would be nice to have one more endpoint that returned the entire
  conversation between two users. ChatsController#show accomplishes this.

# Run the Demo

It's a good idea to clear out the database before running the demo.

```
   bundle exec rails console
   > Message.all.destroy_all
```

Next start the server.

```
   bundle exec rails server
```

And finally run the script:

```
   ./demo.sh
```

You may need to give yourself permission to run the script first:

```
   chmod +x demo.sh
```
