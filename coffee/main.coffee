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
		img = "<div id= 'image'>" + "<img src=" + card.img_url + "></div>"
		content = ""
		if card.likes?
			content = "You have " + card.likes.count + " likes!"
		else
			content = "No one likes you"
		likes_bar = "<div id= 'likes'>" + content + "</div>"

		if card.comments?
			content = "You have some comments"
		else
			content = "No one found you interesting enough to talk to."
		comments_box = "<div id= 'comments'>" + content + "</div>"
		card_template = "<div id= 'card'>"+ img + likes_bar + comments_box + "</div>"
		html += card_template
		console.log card_template
	target_div.innerHTML = html



		




	