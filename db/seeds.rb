		Cupon.delete_all
		VenueVisit.delete_all	
		Venue.delete_all
		Visit.delete_all
		Offer.delete_all
		CuponTemplate.delete_all
		Weekly.delete_all
		
		new_venue = Venue.new(venue_id: '121231', passcode: "123",kind: 'Copas',image_link: 'https://dl.dropboxusercontent.com/u/155213031/PACO.jpeg',name: 'Paco Bar', web: 'wwww.pacomola.com', fb_page: 'wwww.facebook.com/pacomola', address: 'Castellana 123, Madrid', place_id:'145768288146',latitude: '40.482471', longitude: '-3.955078')
		new_venue.save
		offer = Offer.new(offer_id: 'asdfasdf',influence_1: '0.1', influence_2: '0.5',influence_3: '0.7',fb_post:'Hey man, wazzup?' ,offer_text: 'Hoy te damos copa gratis si tu influencia es >40%, al resto un descuento sorpresa!')
		new_venue.offers.push(offer)
		new_venue.save


		new_venue = Venue.new(venue_id: '121232', passcode: "123",kind: 'Restaurant',image_link: 'https://dl.dropboxusercontent.com/u/155213031/PACO.jpeg',name: 'Tacos Bar', web: 'wwww.tacbar.com', fb_page: 'wwww.facebook.com/tacobar', address: 'Juan Sanchez 16', place_id:'145768288146',latitude: '41.482471', longitude: '-4.955078')
		new_venue.save
		offer = Offer.new(offer_id: 'asdfasdf',influence_1: '0.2', influence_2: '0.3',influence_3: '0.6',fb_post:'Acabo de hacer checkin con ThanxUp' ,offer_text: 'Hoy te damos copa gratis si tu influencia es >20%, al resto un descuento sorpresa!')
		new_venue.offers.push(offer)
		new_venue.save

		cupon1 = CuponTemplate.new(
			template_id:"1",
			cupon_text: "3 euros de descuentos en tus tacos",
			valid_from: "Sat, 18 May 2013 09:17:57 -0700",
			valid_until: "Tue, 21 May 2014 09:17:57 -0700",
			used: false,
			kind: "SHARABLE",
			social_text: "Comparte con 3 amigos y recibe una copa gratis!",
			social_count: 0,
			social_limit: 3,
			social_offer: "",
			social_from: "Sat, 18 May 2013 09:17:57 -0700",
			social_until:  "Tue, 21 May 2014 09:17:57 -0700"
			)

		cupon2 = CuponTemplate.new(
			template_id:"2",
			cupon_text: "5 euros de descuento en tus burritos",
			valid_from: "Sat, 18 May 2013 09:17:57 -0700",
			valid_until: "Tue, 21 May 2014 09:17:57 -0700",
			used: false,
			kind: "SHARABLE",
			social_text: "Comparte con 3 amigos y recibe una copa gratis!",
			social_count: 0,
			social_limit: 3,
			social_offer: "",
			social_from: "Sat, 18 May 2013 09:17:57 -0700",
			social_until:  "Tue, 21 May 2014 09:17:57 -0700"
			)

		cupon3 = CuponTemplate.new(
			template_id:"3",
			cupon_text: "100 tacos gratis, campeon ;)",
			valid_from: "Mon, 20 May 2013 09:17:57 -0700",
			valid_until: "Tue, 21 May 2014 09:17:57 -0700",
			kind: "SHARABLE",
			used: false,
			social_text: "Comparte con 3 amigos y recibe una copa gratis!",
			social_count: 0,
			social_limit: 3,
			social_offer: "",
			social_from: "Sat, 18 May 2013 09:17:57 -0700",
			social_until:  "Tue, 21 May 2013 09:17:57 -0700"
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
			social_text: "Comparte con 3 amigos y recibe una copa gratis!",
			social_count: 0,
			social_limit: 5,
			social_offer: "",
			social_from: "Sat, 18 May 2013 09:17:57 -0700",
			social_until:  "Thu, 27 Mar 2013 09:17:57 -0700"
			)






