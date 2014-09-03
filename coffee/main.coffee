console.log 'ajax'

$.ajax 'https://api.instagram.com/v1/users/self/feed?access_token=435677321.03fd3ce.41289f7b8ed14d9180438b99f8e38b77',
	type: 'GET'
	dataType: 'jsonp'
	jsonpCallback: 'callback'
	error: (jqXHR, textStatus, errorThrown) ->
		$('body').append "AJAX Error: #{textStatus}"
	success: (data, textStatus, jqXHR) ->
		feed = document.getElementById('instafeed')
		render_cards(image_loader(data, feed), feed)

# takes a messy json feed and returns concise card objects, while also loading images
image_loader = (data, feed) ->
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
	console.log(card_objects)
	card_objects

render_cards = (card_array, target_div) ->
	html = ""
	for card in card_array
		card_template = ""
		img = "<div class= 'image'>" + "<img src=" + card.img_url + "></div>"
		content = ""
		if card.likes?
			content = render_likes(card.likes.data)
		else
			content = "No one likes you"
		likes_bar = "<div class='likes'><div class='heart'> &nbsp </div>" + content + "</div>"

		if card.comments?
			content = render_comments(card.comments.data)
		else
			content = "<div class= 'no-friends'> No one found you interesting enough to talk to. </div>"
		comments_box = "<div class= 'comments'>" + content + "<input class= 'words' type='text' placeholder='Write a comment...'></div>"
		card_template = "<div class= 'card'>"+ img + likes_bar + comments_box + "</div>"
		html += card_template + "<br><br>"
	html = "<div class= cardbar>" + html + "</div>"
	target_div.innerHTML = html

render_comments = (comments) ->
	comment_html = ""
	for comment in comments
		comment_html += "<div class= 'single-comment'><img class= 'profile-pic' src='" + comment.from.profile_picture + "'>" + "<div class= 'highlighted-text'>" + comment.from.username + "</div>" + comment.text + "</div>"
	comment_html

render_likes = (likes) ->
	usernames = ""
	addendum = ""
	if likes.length > 3
		last_few = likes.slice(Math.max(likes.length - 3, 1))
		addendum = "and " + (likes.length-3) + " others"
	else
		last_few = likes
	for like in likes
		usernames += "<div class= 'highlighted-text'>" + like.username + ", </div> "
	addendum += " like this"
	usernames = "<div class= 'user-list'>" + usernames + addendum + "</div>"
	usernames

		




	