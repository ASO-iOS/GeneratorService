//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import Foundation

struct VETypesOfAircraftAssets {
    static let name = "info.json"
    static let content = """
[
    {
        "name": "Amphibious",
        "description": "Amphibious aircraft, otherwise also popularly known as an amphibian, is a multipurpose aircraft which can work, take off and land both water and ground. They are used as both seaplanes or flying boats, or also airplanes. In this aircraft, the engine is either placed in front or even above the wing, that is most commonly found in floatplanes. On the other hand, modern and other amphibious aircraft have engine and propeller placed above the wings. The size of amphibians differs as per the purpose; there are military amphibians, leisure purpose seaplanes, and civil amphibious aircraft.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/CL-215T_43-21_%2829733827710%29.jpg/1920px-CL-215T_43-21_%2829733827710%29.jpg"
    },
    {
        "name": "Helicopters",
        "description": "Helicopter aircraft, also known as a chopper, is commonly known to most of us and belongs to rotorcrafts. Horizontally spinning rotors help and aid the helicopter to lift and thrust. These aircraft have the advantage of taking vertically, horizontally, and fly both backward and forward or laterally. Unlike the other fixed-wing aircraft, these benefit from taking off and land at several places and flying even in congested areas. The engine depends on the size, purpose, and function of the chopper. Today, the helicopter is mostly used for military purposes, cargo, construction, rescue, tourism, aerial observation, and the government. The size of the chopper hence mostly depends on the usage.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/LAPD_Bell_206_Jetranger.jpg/1920px-LAPD_Bell_206_Jetranger.jpg"
    },
    {
        "name": "Multi-Engine Piston",
        "description": "As the name suggests, Multiple or Multi-engine piston aircraft has more than one single engine, unlike the other categories and types of aircraft. These multi-engine pistons are known to have a second power source, which is greatly helpful during another engine’s failure. Due to this multiple power and engine facility, the aircraft quality, capacity, speed, and climb rate is much higher than the usual air crafts. In most cases, this kind of aircraft is used by air services for their services and duties.",
        "image_url": "https://www.aopa.org/-/media/Images/AOPA-Main/News-and-Media/Publications/Pilot-Magazine/2022/2205/2205p_randw/2205p_rw_commentary/2205p_rw_commentary_16x9.jpg"
    },
    {
        "name": "Biplanes",
        "description": "Biplanes come under the category of fixed-wing aircraft. In this category, two wings come one above each other on both sides. This kind of plane is among the first aircraft to discover fixed-wing planes. The biplanes have lower weight but with excellent stiffness and efficiency. The biplanes are fitted with reciprocating engines. Only two adults, in most cases, can do these. In most cases, biplanes are spotted and used for army and military purposes of specific countries. These aircraft were among the most commonly used ones during world war times.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Sopwith_Camel_-_Season_Premiere_Airshow_2018_%2842058141172%29.jpg/1920px-Sopwith_Camel_-_Season_Premiere_Airshow_2018_%2842058141172%29.jpg"
    },
    {
        "name": "Balloons",
        "description": "The balloon-type aircraft are standard aircrafts most of us are aware of and are mostly spotted during tourist activities. It comes under a kind of aircraft that floats in the sky and is much different from other airships and aircraft categories. While most confuse them with airships, the balloons are distinct in that they do not possess any engine and cannot change their direction, except for up and down. The balloon’s top is called an envelope, and the bottom part is a basket where people can sit. The most common ones in the category of balloons are hot air balloons.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Breitling_Orbiter_3_aloft.jpg/1024px-Breitling_Orbiter_3_aloft.jpg"
    },
    {
        "name": "Gliders",
        "description": "Gliders come again under the category of fixed-wing aircraft. The types of gliders aircraft are used through air reaction against lifting surfaces and mostly do not use any engine. Although small engines may be used as required (in cases like a motor glider), most glider aircraft are efficient for self-take without engines. A wheeled undercarriage helps in take-off or landing. In the past, gliders are used for military purposes and wars; however, nowadays, we even see them in tourist activities and entertainment or leisure. The most common types in this category include hand gliders and paragliders. Most gliders are small in size and can fit a maximum of two people.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/4/4c/Dg800.jpg"
    },    {
        "name": "Gyroplanes",
        "description": "Gyroplanes, also known as autogyro or gyrocopter, is a rotorcraft aircraft category that uses rotor machines to lift. They are similar to helicopters in appearance, although a bit narrow, and have an engine-driven propeller. The air flows help the gyroplanes lift upwards, and the rotor self-propels as per the way air flows through it. While gyroplanes or autogyros are mostly used for military and war purposes during the 20th century, nowadays, they are spotted in the Olympics and police departments at some states.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/AutoGyro_Calidus_-_Shuttleworth_Season_Premiere_2016_%2826422815634%29.jpg/1920px-AutoGyro_Calidus_-_Shuttleworth_Season_Premiere_2016_%2826422815634%29.jpg"
    },    {
        "name": "Parachutes",
        "description": "Parachutes are the most common types we often hear and see. They are slow-moving air flowing craft that helps move through, creating drag to land. They are made through lightweight yet stable and fitting fabric such as nylon or silk. Most parachutes may be in the shapes of round, dome, or inverted dome. Although most parachutes are spotted during leisure activities and entertainment, they are also used and deployed by state and operations during expeditions to ice areas such as polar ends. Only one or two maximum can fit in one parachute.",
        "image_url": "https://www.deccanherald.com/sites/dh/files/styles/article_detail/public/article_images/2016/03/20/535641.jpg?itok=dDZZDJYu"
    },    {
        "name": "Single Engine Piston Aircraft",
        "description": "Like the multi-engine piston plane we have seen earlier. This aircraft uses only one engine. These aircraft are used for shorter distance works and not for heavy works. They can access smaller runways, takes less space, and has lesser climb and speed. Most single-engine pistons can fit only four to six people, depending on the plane and size.",
        "image_url": "https://cdn.planeandpilotmag.com/2017/01/piper-m350-web.jpg"
    },    {
        "name": "Tricycle Gear Aircraft",
        "description": "The tricycle gear aircraft is a kind of plane that has tricycle fashion fixed landing gear. The arrangement has a nose wheel in the front and two more in the main wheels. These are lightweight and are known to have better visibility of the ground, and is very easy to take off and land. The aircraft also has significantly less drag and allows the application of a full brake. They are used for lighter and quick uses, given the advantages of easy runs.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/b/bf/Mooney.m20j.g-muni.arp.jpg"
    },    {
        "name": "Business Jets",
        "description": "Business or private jet aircraft are known to be among the luxurious or unique aircraft to transport and fly a small group of people, even individuals. While they are costly due to their design, plush appearance, and very sophisticated looks, the business jets are used by different classes of people – from government officials to armed forces for special operations to companies and private ownership. While the speed, engine, and other manufacturing are similar to airplanes, the size differs from lightweight or small jets to mid-sized ones to long business jets. The heavy and long jets can accommodate 16 to 18 people, whereas the mid-size (depending on the capacity) can accommodate up to 12 or 10 people. The smaller types of business aircraft are only for four to six individuals.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/0/0f/OO-FLN.JPG"
    },    {
        "name": "Taildraggers",
        "description": "Taildraggers, also known as tail-wheel type gear draggers, consists of two main wheels at the forward size and a small-sized wheel to skid near the tail area. These are the conventional aircraft variety which uses such gear draggers instead of the modern tricycle propeller aircraft. These are the much lighter size and weight aircraft and can even be operated in skis. However, they have very poor visibility on the ground and are difficult during heavy wind conditions.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/e/e5/Cessna150taildraggerC-GOCB02.jpg"
    },    {
        "name": "Tiltrotors",
        "description": "Tiltrotors use powered rotors for propulsion and to generate lift. These powered rotors, also called proprotors, are added to rotating shafts of a fixed-wing. These use transverse rotor design and combines the vertical lift capability of a helicopter. The rotors, similar to the chopper, helps lift this aircraft. However, the propulsion is much more efficient and can avoid retreating blade stall, commonly seen in choppers. The speed and range are heavier and higher than a normal helicopter and almost near a fixed-wing aircraft. The altitude capability of tiltrotors is higher than helicopters.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/US_Navy_061206-N-0458E-076_A_U.S._Marine_Corps_V-22_Osprey_helicopter_practices_touch_and_go_landings_on_the_flight_deck_of_the_multipurpose_amphibious_assault_ship_USS_Wasp_%28LHD_1%29.jpg/1920px-thumbnail.jpg"
    },    {
        "name": "Light-Sport Aircraft",
        "description": "The light-sport aircraft, also known as LSA, differs from country to country. However, they are into the new category of small and very lightweight aircraft. These are super simpler to fly. Although they may be a bit heavier than ultralight aircraft, they are sophisticated and looks grand. These are two-seater versions and are much more affordable too.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Light_Sport_Aircraft.jpg/1920px-Light_Sport_Aircraft.jpg"
    },    {
        "name": "Turboprops",
        "description": "As the name suggests, turboprops or turboprop aircraft have gas turbine engines connected to the gears to turn the propeller to move them through and around the air. They burn much lesser fuels and have lesser operating costs too. These types of turboprops are larger than piston aircraft and can carry more passengers. These also fly high and can go to an altitude of 35000 feet. However, they are slower in speed than jet planes. The turboprop size varies according to the need and can fit a small set of people or up to eight or ten at maximum.",
        "image_url": "https://www.airdatanews.com/wp-content/uploads/2022/05/IMG_ATR_render_View34Av.jpg"
    },    {
        "name": "Floatplanes",
        "description": "The floatplanes are similar to seaplanes, which floats on water through the floats mounted under the fuselage. These mounts are added instead of the undercarriage, where wheels are placed in other planes. These do not have landing gear, which makes it possible to land, in which case it becomes similar to amphibious aircraft (as seen earlier). Seaplanes or floatplanes are heavily used during world war times for military operations; however, they now are witnessed as more of a pleasure flight in many countries.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/f/fb/DeHavilland_Single_Otter_Harbour_Air.jpg"
    },    {
        "name": "Fighter jets",
        "description": "Fighter jets, also known as fighter or fighter aircraft, is military particular fixed-wing aircraft. They are designed only to use for combatting air to air fights against other aircraft. They have very high speed, manufactured for use against air attacks only. However, few fighters have a second capacity to use for ground attacks, too, in which case they are known as fighter bombers. There are several categories in the fighters: light fighter, heavy fighter, interceptor, night fighter, all-weather fighter, and more. With the help of technological advances and breakthroughs, today’s fighters have numerous other capacities and innovations such as data transmissions, sensors, secure cockpits, high bandwidth, and more.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/6/61/F-35A_flight_%28cropped%29.jpg"
    },    {
        "name": "Cargo planes",
          "description": "Cargo aircraft or cargo planes are also known as freight aircraft, airlifter, or cargo jets. These are the fixed-wing classification of aircraft known only for carriage or cargo instead of individual passengers. These cargos are specially built only for lifting carriages and do not have amenities for fitting people or passengers. They have wide doors and facilities to protect and provide shipment. Unlike usual passenger jets, the high-wings presence allows to the preservation and makes the cargo sit near the ground. The number of wheels is also more in cargo jets. These cargo aircraft can be used both for civil purposes as well as military usage.",
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/1/1a/An-124_ready.jpg"
    }
]
"""
}
