
		
		new_venue = Venue.new(venue_id: '1', passcode: "2843",kind: '1',image_link: 'https://scontent-b-mad.xx.fbcdn.net/hphotos-frc1/310124_308194429206404_1364419021_n.jpg',name: 'DO EAT', web: '', fb_page: 'www.facebook.com/DoEatRestaurant', address: 'C/ Maria de Molina 18, Madrid', place_id:'289833507709163',latitude: '40.4377999243', longitude: '-3.68693916191')
		new_venue.save
		offer = Offer.new(offer_id: 'Fruta',influence_1: '0.1', influence_2: '0.5',influence_3: '0.7',fb_post:'Una excelente healthy food' ,offer_text: 'Ensalada gratis con 10% de influencia. Con mas de 0.5 te llevas postre tambien')
		new_venue.offers.push(offer)
		new_venue.save

		cupon1 = CuponTemplate.new(
			template_id:"1",
			cupon_text: "Ensalada gratis",
			valid_from: "Sat, 18 May 2013 09:17:57 -0700",
			valid_until: "Tue, 21 May 2014 09:17:57 -0700",
			used: false,
			kind: "SHARABLE",
			social_text: "Comparte con tres amigos y llevate un cupon por bebida y postre",
			social_count: 0,
			social_limit: 3,
			social_offer: "",
			social_from: "Sat, 18 May 2013 09:17:57 -0700",
			social_until:  "Tue, 21 May 2014 09:17:57 -0700"
			)

		cupon2 = CuponTemplate.new(
			template_id:"2",
			cupon_text: "Ensalda + Postre gratis",
			valid_from: "Sat, 18 May 2013 09:17:57 -0700",
			valid_until: "Tue, 21 May 2014 09:17:57 -0700",
			used: false,
			kind: "SHARABLE",
			social_text: "Comparte con tres amigos y llevate un cupon por bebida y postre",
			social_count: 0,
			social_limit: 3,
			social_offer: "",
			social_from: "Sat, 18 May 2013 09:17:57 -0700",
			social_until:  "Tue, 21 May 2014 09:17:57 -0700"
			)

		cupon3 = CuponTemplate.new(
			template_id:"3",
			cupon_text: "40% de descuento",
			valid_from: "Mon, 20 May 2013 09:17:57 -0700",
			valid_until: "Tue, 21 May 2014 09:17:57 -0700",
			kind: "SHARABLE",
			used: false,
			social_text: "Comparte con tres amigos y llevate un cupon por bebida y postre",
			social_count: 0,
			social_limit: 3,
			social_offer: "",
			social_from: "Sat, 18 May 2013 09:17:57 -0700",
			social_until:  "Tue, 21 May 2013 09:17:57 -0700"
			)

		offer.cupon_templates.push(cupon1)
		offer.cupon_templates.push(cupon2)
		offer.cupon_templates.push(cupon3)


##########################DO EAT##########################







		