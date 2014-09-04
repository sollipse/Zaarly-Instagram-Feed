# https://api.instagram.com/v1/media/popular

load_feed = ->
	$.ajax 'https://api.instagram.com/v1/media/popular?access_token=435677321.03fd3ce.41289f7b8ed14d9180438b99f8e38b77',
		type: 'GET'
		dataType: 'jsonp'
		jsonpCallback: 'callback'
		error: (jqXHR, textStatus, errorThrown) ->
			$('body').append error_message_el("Couldn't contact the server. AJAX Error: #{textStatus}")
		success: (data, textStatus, jqXHR) ->
			feed = document.getElementById('instafeed')
			formatted_data = clean_response(data)
			feed.innerHTML = render_cards(formatted_data)
			console.log data

error_message_el = (message) ->
	$("<div class='error-message'>#{message}</div>")

# takes a messy json feed and returns concise card objects, while also loading images
clean_response = (data) ->
	#blank array to hold the json summary of our cards
	card_objects = []
	for post in data.data
  	#blank hash for recording card properties
		card_hash = {}
  	#loading individual images
		card_hash['img_url'] = post.images.standard_resolution.url
		card_hash['post_url'] = post.link
		if post.caption?
			card_hash['text'] = post.caption.text
		if post.comments.count > 0
			card_hash['comments'] = post.comments
		if post.likes.count > 0
			card_hash['likes'] = post.likes
		card_objects.push card_hash
	card_objects

render_cards = (card_array, target_div) ->
	html = ""
	for card in card_array
		html += render_single_card(card)

	# mock card creator for testing purposes. look below for input format.

	html = "<div class= cardbar>" + html + "</div>"
	html

render_single_card=(card)->
	card_template = ""
	img = "<div class= 'image'>" + "<img class='instagram-image' src=" + card.img_url + "></div>"
	content = ""
	if card.likes?
		content = render_likes(card.likes)
	else
		content = "<div class= 'user-list'>No one likes you</div>"
	likes_bar = "<div class='likes'><div class='heart'> &nbsp </div>" + content + "</div>"
	console.log card
	if card.comments?
		content = render_comments(card.comments.data)
	else
		content = "<div class= 'no-friends'> No one found you interesting enough to talk to. </div>"
	comments_box = "<div class= 'comments'>" + content + "<input class= 'words' type='text' placeholder='Write a comment...'></div>"
	card_template = "<div class= 'card'>"+ img + likes_bar + comments_box + "</div>"
	card_template = card_template + "<br><br>"
	card_template


render_comments = (comments) ->
	comment_html = ""
	for comment in comments
		comment_text = comment.text.replace /@\w+/g, (match) ->
			"<a href='https://instagram.com/#{match.substr(1, match.length)}' class='highlighted-text'>#{match}</a>"
		comment_html += "<div class= 'single-comment'><img class= 'profile-pic' src='" + comment.from.profile_picture + "'>" + "<div class='comment-text'><a href='https://instagram.com/#{comment.from.username}' class='highlighted-text-commenter'>" + comment.from.username + "</a>"  + comment_text + "</div></div>"
	console.log comment_html
	comment_html

render_likes = (likes) ->
	usernames = ""
	addendum = ""
	if likes.data.length > 3
		remaining = (likes.count - 3)
		last_few = likes.data.slice(Math.max(remaining, 1))
		addendum = "and " + (remaining) + " others like this."
	else
		console.log likes
		last_few = likes.data
		if last_few.length == 1
			addendum = " likes this."
		else
			addendum = " like this."
	for like in likes.data
		tail = ""
		head = ""
		if like == likes.data[likes.data.length - 1] || likes.data.length == 0
			if likes.data.length > 3
				tail = " "
			else if likes.data.length > 1
				head = " and "
		else
			if likes.data.length < 4 && like == likes.data[likes.data.length - 2]
				tail = ""
			else
				tail = ", "
		usernames += head + "<a href='https://instagram.com/#{like.username}' class='highlighted-text'>" + like.username + "</a>" + tail
	usernames = usernames + addendum
	usernames

mock_card= (image_url = null, username_hash_array={}, comment_hash_array = {}) ->
	card = {}
	if image_url?
		card['img_url'] = image_url
	else
		card['img_url'] = "http://i.imgur.com/DQpmnp6.png"
	
	if username_hash_array.length > 0
		card['likes'] = {}
		card.likes['count'] = username_hash_array.length
		card.likes['data'] = []
		for user in username_hash_array
			mock_user = {}
			mock_user['username'] = user.username
			card.likes.data.push(mock_user)
	if comment_hash_array.length > 0
		card['comments'] = {}
		card.comments['data'] = []
		for comment in comment_hash_array
			mock_comment = {}
			mock_comment['from'] = {}
			mock_comment.from['username'] = comment.username
			mock_comment['text'] = comment.text
			mock_comment.from['profile_picture'] = "http://www.phootoscelebrities.com/wp-content/uploads/2014/07/arnold-schwarzenegger-smile-photos.jpg"
			card.comments.data.push mock_comment
	card

# State
#body_content.append error_message_el("Couldn't connect to server, reload to try again.")


load_feed()

# feed = document.getElementById('instafeed')
# formatted_data = [
# 	mock_card()
# 	mock_card(null, [{username: "zk"}])
# 	mock_card(null, [{username: "zk"}, {username: "sollipse"}, {username: "greg"}], [{username: "sollipse", text: "omg are you serious"}])
# 	mock_card(null, [{username: "zk"}, {username: "sollipse"}, {username: "greg"}], [{username: "sollipse", text: ""}])
# 	mock_card(null, [{username: "zk"}, {username: "greg"}], [{username: "sollipse", text: "go away"}, {username: 'zk', text: 'bad post is bad'}])
# ]
# feed.innerHTML = render_cards(formatted_data)








		





	