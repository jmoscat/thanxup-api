
		
		new_venue = Venue.new(venue_id: '1', passcode: "2843", telf: '+34 91 1866600',kind: '1',image_link: 'https://scontent-b-mad.xx.fbcdn.net/hphotos-frc1/310124_308194429206404_1364419021_n.jpg',name: 'DO EAT', web: '', fb_page: 'www.facebook.com/DoEatRestaurant', address: 'C/ Maria de Molina 18, Madrid', place_id:'289833507709163',latitude: '40.4377999243', longitude: '-3.68693916191')
		new_venue.save


		new_venue = Venue.new(venue_id: '3', passcode: "2843", telf: '+34 91 1866600',kind: '1',image_link: 'https://scontent-b-mad.xx.fbcdn.net/hphotos-frc1/310124_308194429206404_1364419021_n.jpg',name: 'ThanxUp bar', web: '', fb_page: 'www.facebook.com/thanxup', address: 'C/ Juan Sanchez 16, Madrid', place_id:'289833507709163',latitude: '40.474563', longitude: '-3.719200')
		new_venue.save

		offer = Offer.new(offer_id: 'Fruta',influence_1: '0.1', influence_2: '0.5',influence_3: '0.7',fb_post:'I love ThanxUp' ,offer_text: 'Haz tu primer checkin con ThanxUp y sube influencia')
		new_venue.offers.push(offer)
		new_venue.save

		cupon1 = CuponTemplate.new(template_id:"1", cupon_text: "Proximamente los mejores cupones de descuentos",valid_from: "Sat, 18 May 2013 09:17:57 -0700",valid_until: "Tue, 21 May 2014 09:17:57 -0700",used: false, kind: "SHARABLE", social_text: "WoW! Proximamente los mejores cupones de descuentos con tu influencia", social_count: 0, social_limit: 3, social_offer: "", social_from: "Sat, 18 May 2013 09:17:57 -0700", social_until:  "Tue, 21 May 2014 09:17:57 -0700")

		cupon2 = CuponTemplate.new( template_id:"2", cupon_text: "Proximamente los mejores cupones de descuentos", valid_from: "Sat, 18 May 2013 09:17:57 -0700", valid_until: "Tue, 21 May 2014 09:17:57 -0700", used: false, kind: "SHARABLE", social_text: "WoW! Proximamente los mejores cupones de descuentos con tu influencia", social_count: 0, social_limit: 3, social_offer: "", social_from: "Sat, 18 May 2013 09:17:57 -0700", social_until:  "Tue, 21 May 2014 09:17:57 -0700")

		cupon3 = CuponTemplate.new(template_id:"3", cupon_text: "WoW! Proximamente los mejores cupones de descuentos con tu influencia", valid_from: "Mon, 20 May 2013 09:17:57 -0700", valid_until: "Tue, 21 May 2014 09:17:57 -0700", kind: "SHARABLE", used: false, social_text: "Sube tu influencia y proximante te llevaras descuentos por compartir con amigos", social_count: 0, social_limit: 3, social_offer: "", social_from: "Sat, 18 May 2013 09:17:57 -0700", social_until:  "Tue, 21 May 2013 09:17:57 -0700")

		offer.cupon_templates.push(cupon1)
		offer.cupon_templates.push(cupon2)
		offer.cupon_templates.push(cupon3)


##########################DO EAT##########################


	new_venue = Venue.new(venue_id: '111111111', telf: '+34 910 00 00 00',passcode: "1",kind: '1',image_link: 'http://axcelonbp.com/wp-content/uploads/2013/01/Comingsoon.png',name: 'More coming soon...', web: 'www.thanxup.com', fb_page: 'www.facebook.com/thanxup', address: 'Everywhere...', place_id:'1111',latitude: '50.4377999243', longitude: '-8.68693916191')
	new_venue.save




		