echo "Sending message #1"

curl -H "Content-Type: application/json" -X POST -d '{"sender":"Brandon","recipient":"Guild", "body":"Hey Guild Education!"}' http://localhost:3000/messages

echo ""
echo "Sending message #2"
curl -H "Content-Type: application/json" -X POST -d '{"sender":"Guild","recipient":"Brandon", "body":"Hey Brandon!"}' http://localhost:3000/messages

echo ""
echo "Sending message #3"
curl -H "Content-Type: application/json" -X POST -d '{"sender":"Brandon","recipient":"Guild", "body":"Thanks for the opportunity to interview!"}' http://localhost:3000/messages

echo ""
echo "Sending message #4"
curl -H "Content-Type: application/json" -X POST -d '{"sender":"Guild","recipient":"Brandon", "body":"Good luck!"}' http://localhost:3000/messages

echo ""
echo ""
echo ""
echo ""
echo "Here are all the messages where Brandon is the sender and Guild is the recipient:"

curl -H "Content-Type: application/json" -X GET -d '{"sender":"Brandon"}' http://localhost:3000/messages/Guild

echo ""
echo ""
echo ""
echo ""
echo ""
echo "Here are all the messages where Brandon is the recipient and Guild is the sender:"

curl -H "Content-Type: application/json" -X GET -d '{"sender":"Guild"}' http://localhost:3000/messages/Brandon

echo ""
echo ""
echo ""
echo ""
echo ""
echo "As a bonus I added a chat endpoint that shows the entire conversation between two users:"

curl -H "Content-Type: application/json" -X GET -d '{"recipient":"Brandon", "sender":"Guild"}' http://localhost:3000/chat


echo ""
echo "You can also see all messages sent to a specific user. To demonstrate this lets send one more message:"
curl -H "Content-Type: application/json" -X POST -d '{"sender":"Doggo","recipient":"Brandon", "body":"Hey Brandon lets go for a walk"}' http://localhost:3000/messages

echo ""
echo "Here all the messages sent to Brandon"

curl -H "Content-Type: application/json" -X GET http://localhost:3000/messages/Brandon


echo ""
echo "The messenger api only returns the most recent 100 messages that are less than a month old."
