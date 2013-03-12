# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([ name: 'Chicago' ,  name: 'Copenhagen' ])
#   Mayor.create(name: 'Emanuel', city: cities.first)
	
		new_venue = Venue.create(venue_id: '121231', name: 'Paco Bar', web: 'wwww.pacomola.com', fb_page: 'wwww.facebook.com/pacomola', address: 'Castellana 123, Madrid', place_id:'145768288146',latitude: '40.482471', longitude: '-3.955078')
		offer = Offer.new(offer_id: 'asdfasdf',fb_post:'Hey man, wazzup?' ,offer_text: 'Hoy te damos copa gratis si tu influencia es >40%, al resto un descuento sorpresa!')
		new_venue.offers.push(offer)
		new_venue.save

