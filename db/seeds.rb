# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([ name: 'Chicago' ,  name: 'Copenhagen' ])
#   Mayor.create(name: 'Emanuel', city: cities.first)
	
		new_venue = Venue.new(venue_id: '121231', name: 'Paco Bar', web: 'wwww.pacomola.com', fb_page: 'wwww.facebook.com/pacomola', address: 'Castellana 123, Madrid', place_id:'145768288146',latitude: '40.482471', longitude: '-3.955078')
		new_venue.save
		offer = Offer.new(offer_id: 'asdfasdf',influence_1: '0.1', influence_2: '0.5',influence_3: '0.7',fb_post:'Hey man, wazzup?' ,offer_text: 'Hoy te damos copa gratis si tu influencia es >40%, al resto un descuento sorpresa!')
		new_venue.offers.push(offer)
		new_venue.save

		cupon1 = CuponTemplate.new(
			template_id:"1",
			cupon_text: "3 euros de descuento en tu proxima copa",
			valid_from: "Thu, 21 Mar 2013 09:17:57 -0700",
			valid_until: "Thu, 27 Mar 2013 09:17:57 -0700",
			used: false,
			kind: "SHARABLE",
			sharable_text: "Comparte con 3 amigos y recibe una copa gratis!",
			shared_count: 0,
			sharable_limit: 5,
			sharable_offer: "",
			sharable_from: "Thu, 21 Mar 2013 09:17:57 -0700",
			sharable_to:  "Thu, 27 Mar 2013 09:17:57 -0700"
			)

		cupon2 = CuponTemplate.new(
			template_id:"2",
			cupon_text: "5 euros de descuento en tu proxima copa",
			valid_from: "Thu, 21 Mar 2013 09:17:57 -0700",
			valid_until: "Thu, 27 Mar 2013 09:17:57 -0700",

			kind: "SHARABLE",
			sharable_text: "Comparte con 3 amigos y recibe una copa gratis!",
			shared_count: 0,
			sharable_limit: 5,
			sharable_offer: "",
			sharable_from: "Thu, 21 Mar 2013 09:17:57 -0700",
			sharable_to:  "Thu, 27 Mar 2013 09:17:57 -0700"
			)

		cupon3 = CuponTemplate.new(
			template_id:"3",
			cupon_text: "Tu proxima copa gratis ;)",
			valid_from: "Thu, 21 Mar 2013 09:17:57 -0700",
			valid_until: "Thu, 27 Mar 2013 09:17:57 -0700",
			kind: "SHARABLE",
			used: false,
			sharable_text: "Comparte con 3 amigos y recibe una copa gratis!",
			shared_count: 0,
			sharable_limit: 5,
			sharable_offer: "",
			sharable_from: "Thu, 21 Mar 2013 09:17:57 -0700",
			sharable_to:  "Thu, 27 Mar 2013 09:17:57 -0700"
			)

		offer.cupon_templates.push(cupon1)
		offer.cupon_templates.push(cupon2)
		offer.cupon_templates.push(cupon3)

		myCupon = Cupon.new(
			
			cupon_text: "Tu proxima copa gratis ;)",
			valid_from: "Thu, 21 Mar 2013 09:17:57 -0700",
			valid_until: "Thu, 27 Mar 2013 09:17:57 -0700",
			kind: "SHARABLE",
			used: false,
			sharable_text: "Comparte con 3 amigos y recibe una copa gratis!",
			shared_count: 0,
			sharable_limit: 5,
			sharable_offer: "",
			sharable_from: "Thu, 21 Mar 2013 09:17:57 -0700",
			sharable_to:  "Thu, 27 Mar 2013 09:17:57 -0700"
			)






