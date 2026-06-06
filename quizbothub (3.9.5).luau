local VERSION = "3.9.5" -- lowkirky enhanced by pigeonrobber, further enhanced

-- ===================== Key System =====================
-- return inside do..end at script level is a no-op in Luau.
-- Wrapping everything in main() so return actually stops execution.
-- ===================== Shared State (module-level upvalues) =====================
local ContextActionService
local HttpService
local SKIP_VOTES_NEEDED
local STREAK_BONUS_THRESHOLD
local StarterGui
local UserInputService
local answeredCorrectly
local awaitingAnswer
local blockedPlayers
local boothGame
local categories
local categoryManager
local difficultyOrder
local eliminatedPlayers
local endMessage
local kahootModeRules
local localPlayer
local maxCharactersInMessage
local mode
local outdated
local placeId
local playerStreaks
local playerTeams
local players
local pointManager
local question
local questionPoints
local quizCooldown
local quizModeRules
local quizRunning
local settings
local skipVotes
local submittedAnswer
local suddenDeathLives
local suddenDeathRules
local teamPoints
local teamRules
local textChatService
local userCooldowns
local userPoints
local whiteListEnabled
local whiteListedplayers
local SendChatMessage
local mainQuestionSent
local importantMessageSent
local messageBeforeFilter
local answeredByAltMessage
local messageFiltered
local antiFilteringDone
local lastMessageTime
local currentQuestion
local questionAnsweredBy
local votingActive
local voteData -- { options = {cat1,cat2,cat3}, votes = {[playerName]=1|2|3}, counts = {0,0,0} }

-- ===================== Quiz Questions =====================
local function loadQuizDefinitions(categoryManager)

do -- chunk 1: countries, science, history, food, trivia, language, capitals, geography, gaming, movies, roblox, english, animals, sports, minecraft, chess, WWII, WWI, luau, astronomy, memes, anime, scienceHard, math
local countriesEasy = categoryManager.New("Guess the country", "easy")
countriesEasy:Add("What country is this? 🇹🇷", {"Turkey", "Spain", "Greece", "Cyprus"})
countriesEasy:Add("What country is this? 🇪🇸", {"Spain", "Portugal", "Greece", "Mexico"})
countriesEasy:Add("What country is this? 🇵🇱", {"Poland", "Indonesia", "Austria", "Greenland"})
countriesEasy:Add("What country is this? 🇮🇳", {"India", "Pakistan", "Sri Lanka", "Afghanistan"})
countriesEasy:Add("What country is this? 🇳🇴", {"Norway", "Sweden", "Denmark", "Iceland"}, 2)

local countriesEasy2 = categoryManager.New("Guess the country", "easy")
countriesEasy2:Add("What country is this? 🇫🇷", {"France", "England", "Netherlands", "Russia"})
countriesEasy2:Add("What country is this? 🇬🇷", {"Greece", "Serbia", "Argentina", "Spain"})
countriesEasy2:Add("What country is this? 🇦🇷", {"Argentina", "Honduras", "Estonia", "Brazil"})
countriesEasy2:Add("What country is this? 🇻🇳", {"Vietnam", "China", "Japan", "Korea"})
countriesEasy2:Add("What country is this? 🇷🇸", {"Serbia", "Bosnia", "Croatia", "Slovakia"}, 2)

local countriesMedium = categoryManager.New("Guess the country", "medium")
countriesMedium:Add("What country is this? 🇲🇽", {"Mexico", "Netherlands", "Iran", "Spain"})
countriesMedium:Add("What country is this? 🇵🇹", {"Portugal", "Brazil", "Madrid", "Spain"})
countriesMedium:Add("What country is this? 🇲🇦", {"Morocco", "Vietnam", "China", "Israel"}, 2)
countriesMedium:Add("What country is this? 🇧🇪", {"Belgium", "Germany", "France", "Romania"})
countriesMedium:Add("What country is this? 🇮🇩", {"Indonesia", "Poland", "Peru", "Switzerland"})

local countriesHard = categoryManager.New("Guess the country", "hard")
countriesHard:Add("What country is this? 🇸🇮", {"Slovenia", "Slovakia", "Russia", "Serbia"})
countriesHard:Add("What country is this? 🇪🇷", {"Eritrea", "Ecuador", "El Salvador"})
countriesHard:Add("What country is this? 🇫🇮", {"Finland", "Sweden", "Falkland Islands"})
countriesHard:Add("What country is this? 🇿🇲", {"Zambia", "Zimbabwe", "Zaire"}, 2)
countriesHard:Add("What country is this? 🇸🇴", {"Somalia", "Solomon Islands", "Samoa"})

local science = categoryManager.New("Science", "medium")
science:Add("The standard unit of measurement used for measuring force is which of the following?", {"Newton", "Mile", "Watt", "Kilogram"})
science:Add("How long does it take the earth to do one full rotation of the sun?", {"365 days", "7 days", "30 days"})
science:Add("Oil, natural gas and coal are examples of …", {"Fossil fuels", "Renewable resources", "Biofuels", "Geothermal resources"}, 2)
science:Add("Why do our pupils constrict in bright light?", {"To let in less light", "To give our eyes more oxygen", "To change our vision to 3D"})
science:Add("What is cooling lava called?", {"Igneous rocks", "Magma", "Fossils"})

local science2 = categoryManager.New("Science", "medium")
science2:Add("What is faster, sound or light?", {"Light", "Sound", "They travel at the same speed", "They don't move"})
science2:Add("Which of these is NOT one of Newton's laws of motion?", {"Objects at rest stay in motion", "Force equals mass times acceleration", "Every action has an equal and opposite reaction", "An object in motion stays in motion"})
science2:Add("Who developed the theory of relativity?", {"Einstein", "Newton", "Galileo", "Darwin"})
science2:Add("Which of these is not a state of matter?", {"Energy", "Solid", "Liquid", "Gas"})
science2:Add("What is the powerhouse of the cell?", {"Mitochondria", "Nucleus", "Cytoplasm", "Nucleic membrane"}, 2)

local history = categoryManager.New("History", "medium")
history:Add("Which of these countries did the Soviet Union NEVER invade?", {"Sweden", "Afghanistan", "Finland", "Poland"})
history:Add("What was the main cause of the French Revolution in 1789?", {"The social and economic inequality of the Third Estate", "The invasion of Napoleon Bonaparte", "Disputes over territorial boundaries", "The spread of the Black Death"})
history:Add("What ancient civilization built the Machu Picchu complex?", {"Inca", "Aztec", "Maya", "Egypt"})
history:Add("What do people call the era before written records?", {"Prehistory", "Medieval Times", "Renaissance", "Industrial Age"})
history:Add("Which of these historical events happened first?", {"The American Revolution", "The French Revolution", "The Industrial Revolution", "The Russian Revolution"}, 2)

local history2 = categoryManager.New("History", "medium")
history2:Add("The disease that killed a third of Europe's population in the 14th century is known as:", {"Plague (Black Death)", "Spanish Flu", "Smallpox", "Malaria"})
history2:Add("Who discovered America in 1492?", {"Christopher Columbus", "Marco Polo", "Ferdinand Magellan", "Leif Erikson"})
history2:Add("Which country gifted the Statue of Liberty to the United States?", {"France", "Germany", "United Kingdom", "Spain"})
history2:Add("What was the name of the period of renewed interest in art and learning?", {"Renaissance", "Reformation", "Enlightenment", "Industrial Revolution"}, 2)
history2:Add("Which famous trade route connected Europe and Asia?", {"Silk Road", "Spice Route", "Amber Road", "Trans-Saharan Route"})

local foodAndDrink = categoryManager.New("Food and Drink", "medium")
foodAndDrink:Add("Which country is the largest producer of coffee in the world?", {"Brazil", "Vietnam", "Colombia", "Ethiopia"})
foodAndDrink:Add("What is the name of the Italian dessert made from layers of sponge cake soaked in coffee and mascarpone?", {"Tiramisu", "Maritozzo", "Cannoli", "Zabaglione"})
foodAndDrink:Add("What is the national dish of England?", {"Fish and Chips", "Shepherd's Pie", "Yorkshire Pudding", "Sunday Roast"})
foodAndDrink:Add("What is the name of the fermented milk drink popular in Central Asia and Eastern Europe?", {"Kefir", "Karin", "Kulmel", "Yogurt"})
foodAndDrink:Add("Which country does feta cheese come from?", {"Greece", "Switzerland", "Spain", "France"}, 2)

local trivia = categoryManager.New("Trivia", "medium")
trivia:Add("Which is NOT a Nobel Prize category?", {"Mathematics", "Physics", "Literature", "Chemistry"})
trivia:Add("Which musical instrument has 47 strings and seven pedals?", {"Harp", "Piano", "Guitar", "Violin"})
trivia:Add("What is the capital city of Japan?", {"Tokyo", "Beijing", "Seoul", "Bangkok"})
trivia:Add("Which country is the only one to have a non-rectangular flag?", {"Nepal", "Switzerland", "Japan", "Qatar"})
trivia:Add("'Bokmål' and 'Nynorsk' are the two official written forms of which language?", {"Norwegian", "Italian", "Danish", "Spanish"}, 2)

local trivia2 = categoryManager.New("Trivia", "medium")
trivia2:Add("Which animal is the national emblem of Australia?", {"Kangaroo", "Koala", "Emu", "Platypus"})
trivia2:Add("What does the Richter scale measure?", {"Earthquake intensity", "Wind Speed", "Temperature", "Tornado Strength"}, 2)
trivia2:Add("Which currency is used in Japan?", {"Yen", "Dollar", "Euro", "Pound"})
trivia2:Add("What is the hardest natural substance on Earth?", {"Diamond", "Gold", "Iron", "Platinum"})
trivia2:Add("In sport, what does the term PGA refer to?", {"Professional Golfers Association", "Par Golfing Average", "Playing Golf Average", "Part-Time Golfing Amateurs"})

local guessTheLanguage = categoryManager.New("Guess the language", "medium")
guessTheLanguage:Add("Je suis désolé", {"French", "Spanish", "Italian", "Portuguese"})
guessTheLanguage:Add("בוקר טוב", {"Hebrew", "Tamil", "Lao", "Mandarin"})
guessTheLanguage:Add("Guten Tag", {"German", "Tagalog", "Finnish", "Dutch"})
guessTheLanguage:Add("こんにちは", {"Japanese", "Chinese", "Turkish", "Arabic"}, 2)
guessTheLanguage:Add("नमस्ते", {"Hindi", "Indonesian", "Cantonese", "Nahuatl"})

local capitals = categoryManager.New("Capital Cities", "easy")
capitals:Add("What is the capital city of the USA?", {"Washington D.C.", "New York City", "Los Angeles", "Austin"})
capitals:Add("What is the capital city of Finland?", {"Helsinki", "Stockholm", "Dublin", "Reykjavik"}, 2)
capitals:Add("What is the capital city of Poland?", {"Warsaw", "Kiev", "Moscow", "Krakow"})
capitals:Add("What is the capital city of Germany?", {"Berlin", "Frankfurt", "Hamburg", "Dusseldorf"})
capitals:Add("What is the capital city of Canada?", {"Ottawa", "Toronto", "Vancouver", "Montreal"})

local capitalsHard = categoryManager.New("Capital Cities", "hard")
capitalsHard:Add("What is the capital of Belgium?", {"Brussels", "Liege", "Amsterdam"})
capitalsHard:Add("What is the capital of Somalia?", {"Mogadishu", "Garoowe", "Berbera"})
capitalsHard:Add("What is the capital city of Mongolia?", {"Ulaanbaatar", "Hanoi", "Seoul"})
capitalsHard:Add("What is the capital city of Australia?", {"Canberra", "Sydney", "Perth"})
capitalsHard:Add("What is the capital city of New Zealand?", {"Wellington", "Auckland", "Hamilton"})

local geography = categoryManager.New("Geography", "easy")
geography:Add("On which continent is the Sahara Desert located?", {"Africa", "Asia", "Europe", "South America"})
geography:Add("Which river flows through London?", {"River Thames", "River Severn", "River Trent", "The Nile"})
geography:Add("Which of these cities is NOT a national capital?", {"Sydney", "Oslo", "Wellington", "Bangkok"}, 2)
geography:Add("Which continent has the largest land area?", {"Asia", "Africa", "Europe", "South America"})
geography:Add("What is the smallest country in the world?", {"Vatican City", "Belgium", "Luxembourg", "Hungary"})

local geographyMedium = categoryManager.New("Geography", "medium")
geographyMedium:Add("Which island is the largest in the world?", {"Greenland", "Madagascar", "Borneo", "New Guinea"})
geographyMedium:Add("Which continent has the most countries?", {"Africa", "Europe", "Asia", "Australia"})
geographyMedium:Add("Which one of the following countries is further north?", {"Scotland", "The Netherlands", "Belgium", "Poland"})
geographyMedium:Add("What is the longest river in the world?", {"The Nile", "Amazon River", "Yangtze River", "Yellow River"})
geographyMedium:Add("Which ocean is the deepest?", {"Pacific Ocean", "Atlantic Ocean", "Indian Ocean", "Arctic Ocean"}, 2)

local geographyHard = categoryManager.New("Geography", "hard")
geographyHard:Add("Which country has the longest coastline?", {"Canada", "Chile", "Norway", "Australia"})
geographyHard:Add("Which continent is the only one without a desert?", {"Europe", "Asia", "North America", "Africa"})
geographyHard:Add("Which one of the following countries is not an enclave?", {"Italy", "Vatican City", "San Marino", "Lesotho"}, 2)
geographyHard:Add("Which is the northernmost capital city in the world?", {"Reykjavik, Iceland", "Oslo, Norway", "Helsinki, Finland", "Moscow, Russia"})
geographyHard:Add("Which city is the only one located on two continents?", {"Istanbul", "Cairo", "Moscow", "Panama City"})

local gaming = categoryManager.New("Gaming", "medium")
gaming:Add("What is the best-selling video game of all time?", {"Minecraft", "FIFA 18", "Call of Duty: Modern Warfare 3", "Tetris"})
gaming:Add("What was the first commercially successful video game?", {"Pong", "Donkey Kong Country", "Super Mario Bros", "Spacewar"})
gaming:Add("What is the name of the main character in the Legend of Zelda series?", {"Link", "Zelda", "Ganon", "Mario"})
gaming:Add("What video game did Mario first appear in?", {"Donkey Kong", "Super Mario Bros", "Marios Cement Factory", "Mario Bros"}, 2)
gaming:Add("What is the name of Valve's VR headset?", {"Valve Index", "Oculus Rift", "Meta Quest", "Steam VR"})

local gaming2 = categoryManager.New("Gaming", "medium")
gaming2:Add("Which company created the Mario franchise?", {"Nintendo", "Sony", "Microsoft", "Sega"})
gaming2:Add("What game developer created Half-Life, Portal, and Counter-Strike?", {"Valve", "Blizzard", "Bethesda", "Rockstar"})
gaming2:Add("What Nintendo console released in 2006 featured motion controls?", {"Wii", "Switch", "GameCube", "DS"})
gaming2:Add("What platform game series features a plumber who rescues a princess from a turtle-like villain?", {"Super Mario", "Sonic the Hedgehog", "Crash Bandicoot", "Cuphead"})
gaming2:Add("How many standalone Grand Theft Auto titles have been released?", {"7", "5", "8", "10"}, 2)

local movies = categoryManager.New("Movies", "medium")
movies:Add("Which actor played Jack Sparrow in the 'Pirates of the Caribbean' franchise?", {"Johnny Depp", "Orlando Bloom", "Keira Knightley", "Geoffrey Rush"})
movies:Add("What was the first movie in the Marvel Cinematic Universe?", {"Iron Man", "The Avengers", "Batman", "Spider-Man"}, 2)
movies:Add("Which movie is based on a novel by J.R.R. Tolkien?", {"The Lord of the Rings", "The Chronicles of Narnia", "The Hunger Games", "The Da Vinci Code"})
movies:Add("What is the name of the protagonist in The Matrix?", {"Neo", "Morpheus", "Trinity", "Cypher"})
movies:Add("In the movie 'Frozen', who is Olaf?", {"A snowman", "A ghost", "A knight", "A reindeer"})

local roblox = categoryManager.New("Roblox", "easy")
roblox:Add("What was the original name of Roblox?", {"DynaBlocks", "SuperBlocks", "XtraBlocks"})
roblox:Add("What was Roblox's removed virtual currency called?", {"Tix", "Builder Coins", "Ro-Points"})
roblox:Add("What program do you use to make games on Roblox?", {"Roblox Studio", "Roblox Player", "Roblox Create", "Roblox Creator"})
roblox:Add("Roblox's private servers were previously known as:", {"VIP servers", "Personal servers", "Exclusive servers"})
roblox:Add("Who won the RB Battles season 1 championship?", {"KreekCraft", "Tofuu", "Seedeng", "BriannaPlayz"}, 2)

local roblox2 = categoryManager.New("Roblox", "easy")
roblox2:Add("What is another name for the avatar shop?", {"Catalog", "Avatar Creator", "Avatar Editor"})
roblox2:Add("What programming language is used to create Roblox games?", {"Luau", "JavaScript", "Python", "PHP"}, 2)
roblox2:Add("What is the name of Roblox's annual developer conference?", {"RDC", "Robloxcon", "Robloxx", "Blockfest"})
roblox2:Add("What was the former name of Roblox Premium?", {"Builders Club", "Roblox Plus", "Roblox Pro", "VIP Club"})
roblox2:Add("What was the first Roblox game to reach 1B+ visits?", {"MeepCity", "Arsenal", "Build a Boat For Treasure", "Adopt Me"}, 2)

local english = categoryManager.New("English", "easy")
english:Add("Which of the following is a proper noun?", {"London", "City", "River", "Mountain"})
english:Add("What is the correct punctuation?", {"However, I don't agree with your opinion.", "However I, don't agree with your opinion.", "However I don't, agree.", "However; I don't agree."})
english:Add("Which word is an adjective?", {"Beautiful", "Run", "Quickly", "Table"})
english:Add("Which is the correct spelling?", {"Necessary", "Neccessary", "Nessessary", "Necessay"})
english:Add("What is the subject in: 'The cat chased the mouse across the yard'?", {"The cat", "The mouse", "The yard", "Chased"}, 2)

local animals = categoryManager.New("Animals", "easy")
animals:Add("What is the largest land animal?", {"Elephant", "Giraffe", "Whale", "Rhino"})
animals:Add("What is the name of a baby kangaroo?", {"Joey", "Cub", "Pup", "Kit"})
animals:Add("Capable of exceeding 186 mph, what is the fastest creature in the animal kingdom?", {"Peregrine falcon", "Cheetah", "Horse", "Lion"})
animals:Add("What is the only mammal that can fly?", {"Bat", "Penguin", "Pterodactyl", "Dragon"}, 2)
animals:Add("Which of these 'fish' is actually a fish?", {"Swordfish", "Starfish", "Crayfish", "Jellyfish"})

local sports = categoryManager.New("Sports", "easy")
sports:Add("In which sport might you perform a 'bicycle kick'?", {"Football (Soccer)", "Basketball", "Rugby", "Tennis"})
sports:Add("Which country is famous for inventing sumo wrestling?", {"Japan", "China", "India", "Thailand"})
sports:Add("What animal is used in the sport of polo?", {"Horse", "Camel", "Elephant", "Yak"})
sports:Add("What sport is also known as table tennis?", {"Ping Pong", "Badminton", "Squash", "Tennis"})
sports:Add("Which sport uses the terms 'strike' and 'spare'?", {"Bowling", "Baseball", "Cricket", "Golf"}, 2)

local minecraft = categoryManager.New("Minecraft", "easy")
minecraft:Add("What is the name of the green creature that explodes?", {"Creeper", "Zombie", "Skeleton", "Slime"})
minecraft:Add("Which tool is best for digging stone and bricks?", {"Pickaxe", "Shovel", "Axe", "Drill"})
minecraft:Add("What is the name of the dimension where you fight the Ender Dragon?", {"The End", "The Nether", "The Overworld", "The Void"}, 2)
minecraft:Add("What resource do you need to trade with villagers?", {"Emerald", "Apple", "Gold", "Iron"})
minecraft:Add("What block can you use to make a portal to the Nether?", {"Obsidian", "Netherrack", "Cobblestone", "Bedrock"})

local chess = categoryManager.New("Chess", "medium")
chess:Add("What piece can only move diagonally?", {"Bishop", "Knight", "Queen"})
chess:Add("What is the term for when a king is in check and cannot escape?", {"Checkmate", "Stalemate", "En passant", "Castling"})
chess:Add("What chess strategy involves sacrificing a piece to gain an advantage?", {"Gambit", "Fork", "Pin", "Skewer"})
chess:Add("What is the special move where a king and a rook swap places?", {"Castling", "Promotion", "Capture", "Fork"})
chess:Add("Which piece is involved in 'en passant'?", {"Pawn", "Queen", "Bishop", "Knight"}, 2)


local WWII = categoryManager.New("WWII", "hard")
WWII:Add("Which countries formed the Axis powers in WWII?", {"Germany, Italy and Japan", "France, Britain and Russia", "China, India and Australia", "Canada, Mexico and Brazil"})
WWII:Add("Which country was attacked by Japan in 1941, prompting its entry into WWII?", {"USA", "China", "India", "Australia"})
WWII:Add("Which two countries were first to declare war on Germany?", {"Britain and France", "Italy and Greece", "Norway and Denmark", "Poland and Russia"})
WWII:Add("What was the name of the Allied invasion of Normandy in 1944?", {"Operation Overlord", "Operation Barbarossa", "Operation Torch", "Operation Garden"}, 2)
WWII:Add("What was the name of the British code-breaking machine used to crack German ciphers?", {"Bombe", "Turing", "Lorenz", "Enigma"})

local WWI = categoryManager.New("WWI", "hard")
WWI:Add("Which country made the first declaration of war in WWI?", {"Austria-Hungary", "Serbia", "Russia", "Germany"})
WWI:Add("What British passenger ship was sunk by a German submarine in 1915?", {"Lusitania", "Titanic", "Britannia", "Olympic"})
WWI:Add("What was the nickname for warfare involving digging trenches?", {"Trench warfare", "Guerrilla warfare", "Dirt warfare", "Siege warfare"})
WWI:Add("What caused Great Britain to join World War I?", {"German troops marching through Belgium", "German bombing raids on London", "German use of illegal chemicals", "Germans sinking British civilian ships"})
WWI:Add("What was the name of the alliance between Germany, Austria-Hungary and Italy?", {"Triple Alliance", "The Axis Powers", "The Triple Entente", "The League of Nations"}, 2)

local luau = categoryManager.New("Luau", "hard")
luau:Add("What is the keyword for defining a function in Luau?", {"function", "def", "local", "sub"})
luau:Add("What is the syntax for creating a comment in Luau?", {"-- comment", "// comment", "# comment", "' comment"}, 2)
luau:Add("What is the data type for storing multiple values in Luau?", {"table", "array", "list", "set"})
luau:Add("How do you declare a table in Luau?", {"local table = {}", "local table = []", "local table = table.new()", "local table = ()"})
luau:Add("What is the symbol for concatenating strings in Luau?", {"..", "+", "&", "%"}, 2)

local astronomy = categoryManager.New("Astronomy", "medium")
astronomy:Add("What dwarf planet was once considered a ninth planet in our solar system?", {"Pluto", "Ceres", "Eris", "Haumea"})
astronomy:Add("What theory describes how the universe began from a single point?", {"The Big Bang theory", "The Steady State theory", "The Inflationary theory", "The String theory"})
astronomy:Add("What is the name of the largest planet in our solar system?", {"Jupiter", "Saturn", "Earth", "Neptune"})
astronomy:Add("What is the term for a group of stars forming a recognizable pattern?", {"A constellation", "A nebula", "A cluster", "A galaxy"})
astronomy:Add("What is the largest moon in our solar system?", {"Ganymede", "Titan", "Io", "Europa"}, 2)

local memes = categoryManager.New("Memes", "easy")
memes:Add("Which meme features a dog sitting in a burning room?", {"This is fine", "Doge", "Grumpy Cat", "Bad Luck Brian"})
memes:Add("What is the name of the frog character associated with 'feels good man'?", {"Pepe", "Kermit", "Frogger", "Freddy"}, 2)
memes:Add("What is the term for a meme that looks low-quality and pixelated?", {"Deep fried", "Dank", "Cringe", "Ironic"})
memes:Add("Which animal is associated with the 'Doge' meme?", {"Shiba Inu", "Grumpy Cat", "Keyboard Cat", "Nyan Cat"})
memes:Add("What is the name of the meme featuring a man's head in a toilet bowl?", {"Skibidi Toilet", "TF2 Guy", "Fanum Tax", "Smurf Cat"})

local anime = categoryManager.New("Anime", "easy")
anime:Add("What is the name of the main character in Naruto?", {"Naruto Uzumaki", "Naruto Uchiha", "Kakashi Naruto", "Itachi Uchiha"})
anime:Add("What is the name of the pirate crew that Monkey D. Luffy leads in One Piece?", {"Straw Hat Pirates", "Blackbeard Pirates", "Red Hair Pirates", "Whitebeard Pirates"})
anime:Add("What is the name of the powerful notebook that can kill anyone whose name is written in it?", {"Death Note", "Kira Note", "Shinigami Note", "Life Note"})
anime:Add("In Death Note, how does Light Yagami first discover the notebook?", {"He sees it fall from the sky", "He receives it as a gift", "It is delivered in a box", "He finds it on the subway"}, 2)
anime:Add("What is the name of the main character in the Pokémon series?", {"Ash Ketchum", "Naruto Uzumaki", "Gary Oak", "Pikachu"})

local scienceHard = categoryManager.New("Science", "hard")
scienceHard:Add("What is the name of the largest bone in the human body?", {"Femur", "Humerus", "Tibia", "Pelvis"})
scienceHard:Add("Which of these particles is its own antiparticle?", {"Photon", "Proton", "Electron", "Neutron"})
scienceHard:Add("What is Rayleigh scattering?", {"Light scattered by small particles in a medium", "Diffraction of light around edges", "Refraction through a prism", "Dispersion through water"}, 2)
scienceHard:Add("What branch of mathematics deals with abstract entities like numbers and functions?", {"Algebra", "Geometry", "Calculus", "Logic"})
scienceHard:Add("What unit measures electric potential difference?", {"Volt", "Ampere", "Ohm", "Watt"})

local mathCategory = categoryManager.New("Math", "easy")
mathCategory:Add("What is the value of PI (rounded to two decimal places)?", {"3.14", "3.15", "3.16", "3.17"})
mathCategory:Add("The property that states a + b = b + a is called:", {"Commutative property", "Associative property", "Distributive property", "Identity property"}, 2)
mathCategory:Add("What is the formula for the area of a circle?", {"pi * r^2", "2 * pi * r", "pi * d", "pi * r"})
mathCategory:Add("What branch of mathematics studies shapes and angles?", {"Geometry", "Algebra", "Calculus", "Arithmetic"})
mathCategory:Add("What is the value of x in the equation 2x + 5 = 13?", {"4", "3", "5", "6"})

local mathHard = categoryManager.New("Math", "hard")
mathHard:Add("What theorem states that a² + b² = c² for a right triangle?", {"Pythagorean theorem", "Fermat's last theorem", "Binomial theorem", "Euclid's theorem"})
mathHard:Add("What is the derivative of e^x?", {"e^x", "x*e^(x-1)", "ln(x)", "1/e^x"})
mathHard:Add("What constant is approximately equal to 2.71828?", {"Euler's number", "The golden ratio", "PI", "Planck's constant"})
mathHard:Add("What sequence starts with 1, 1, 2, 3, 5, 8...?", {"Fibonacci Sequence", "Arithmetic Sequence", "Geometric Sequence", "Harmonic Sequence"}, 2)
mathHard:Add("What branch of mathematics deals with patterns and sequences?", {"Combinatorics", "Algebra", "Calculus", "Geometry"})
end -- chunk 1

do -- chunk 2: coldWar, chemistry, biology, sayings, internetSlang, guessTheMovie, guessTheBook, music, brainrot, gamerWords, streaming, computerHardware, ancientCivilizations, worldRecords, mythology, space, popCulture, tech, trueOrFalse, guessTheYear, holidays
local coldWar = categoryManager.New("Cold War", "hard")
coldWar:Add("In 1946 Winston Churchill popularized what term to describe Soviet relations with Western powers?", {"Iron curtain", "Mutually assured destruction", "Quagmire", "Danger to society"})
coldWar:Add("What was the name of the Soviet intelligence agency?", {"KGB", "ICBM", "SALT", "DMZ"})
coldWar:Add("Which DEFCON rating is used when a nuclear attack is imminent?", {"DEFCON 1", "DEFCON 3", "DEFCON 5"})
coldWar:Add("In 1966, which country withdrew its military from NATO?", {"France", "United States", "Poland", "West Germany"})
coldWar:Add("The USSR's 10-year invasion of what country began in 1979?", {"Afghanistan", "Poland", "Czechoslovakia", "Ukraine"}, 2)

local chemistry = categoryManager.New("Chemistry", "hard")
chemistry:Add("What is the chemical formula of water?", {"H2O", "CO2", "O2", "2HO"})
chemistry:Add("What is the process of converting a solid into a gas without passing through liquid called?", {"Sublimation", "Evaporation", "Condensation", "Deposition"})
chemistry:Add("What is the name of the element with the symbol K?", {"Potassium", "Calcium", "Krypton", "Kalium"})
chemistry:Add("What process separates a mixture of liquids based on their boiling points?", {"Distillation", "Filtration", "Crystallization", "Chromatography"})
chemistry:Add("What is the name of the organic compound with the general formula CnH2n+2?", {"Alkane", "Alkene", "Alkyne", "Ammonia"}, 2)

local biology = categoryManager.New("Biology", "medium")
biology:Add("What is the process by which plants make their own food?", {"Photosynthesis", "Respiration", "Transpiration", "Fermentation"})
biology:Add("What is the smallest unit of life?", {"Cell", "Atom", "Molecule", "Organ"})
biology:Add("What is the main function of red blood cells?", {"Oxygen transport", "Fighting infections", "Blood clotting", "Producing antibodies"})
biology:Add("What are the main building blocks of proteins?", {"Amino acids", "Fatty acids", "Nucleic acids", "Glucose"}, 2)
biology:Add("What molecule carries genetic information in most living organisms?", {"DNA", "Cell", "ATP", "ADP"})

local sayings = categoryManager.New("Sayings and Idioms", "easy")
sayings:Add("Which idiom means to reveal a secret?", {"Let the cat out of the bag", "Paint the town red", "Beat around the bush", "Bite the bullet"})
sayings:Add("What does 'a piece of cake' refer to?", {"Something very easy", "A dessert", "A difficult task", "A small portion"})
sayings:Add("Which idiom means to be in trouble?", {"In hot water", "On cloud nine", "Under the weather", "Out of the blue"})
sayings:Add("What does 'hold your horses' mean?", {"Be patient", "Ride horses", "Work hard", "Go faster"})
sayings:Add("What does 'break a leg' mean?", {"Good luck", "Actually break a leg", "Run away", "Take a break"}, 2)

local internetSlang = categoryManager.New("Internet Slang", "easy")
internetSlang:Add("What does 'LOL' stand for?", {"Laugh Out Loud", "Lots Of Love", "Living On Land", "Look Out Left"})
internetSlang:Add("What does 'FOMO' stand for?", {"Fear Of Missing Out", "Friends Of My Office", "Fond Of Moving On", "Full Of Many Options"})
internetSlang:Add("What does 'IMO' stand for?", {"In My Opinion", "Internet Mail Order", "It's Monday Obviously", "I Mean Okay"})
internetSlang:Add("What is the meaning of 'SMH'?", {"Shaking My Head", "So Much Hate", "Send More Help", "Smashing My Head"})
internetSlang:Add("What does 'IIRC' stand for?", {"If I Recall Correctly", "It Is Really Cool", "I'm Incredibly Rich Child", "Interesting Info Requires Consideration"}, 2)

local internetSlang2 = categoryManager.New("Internet Slang", "medium")
internetSlang2:Add("What does 'FTFY' mean?", {"Fixed That For You", "For The Following Year", "Forget That Find Yourself", "Faster Than Fifty Yaks"})
internetSlang2:Add("What is the meaning of 'AMA'?", {"Ask Me Anything", "Always Making Assumptions", "Another Missed Appointment", "Awesome Meme Alert"})
internetSlang2:Add("What does 'YOLO' stand for?", {"You Only Live Once", "Your Own Life Obligations", "Yesterday's Old Leftover Onions", "Yelling Out Loud Often"})
internetSlang2:Add("What does 'OMW' stand for?", {"On My Way", "Oh My Word", "Only Men Welcome", "Official Meme Website"})
internetSlang2:Add("What is the meaning of 'ITT'?", {"In This Thread", "I'll Tell Them", "I Think That", "I Talked To"}, 2)

local guessTheMovie = categoryManager.New("Guess the Movie", "easy")
guessTheMovie:Add("Which movie features a young wizard attending Hogwarts?", {"Harry Potter and the Philosopher's Stone", "The Lord of the Rings", "The Chronicles of Narnia", "The Wizard of Oz"})
guessTheMovie:Add("What movie tells the story of a clownfish searching for his son?", {"Finding Nemo", "Shark Tale", "The Little Mermaid", "Free Billy"})
guessTheMovie:Add("Which sci-fi film features blue-skinned aliens called the Na'vi?", {"Avatar", "Star Wars", "Alien", "District 9"})
guessTheMovie:Add("In what movie does Tom Hanks play a man stranded on an island with a volleyball?", {"Cast Away", "The Terminal", "Forrest Gump", "Saving Private Ryan"}, 2)
guessTheMovie:Add("What movie tells the story of toys that come to life when humans aren't around?", {"Toy Story", "The Lego Movie", "Small Soldiers", "Wreck-It Ralph"})

local guessTheBook = categoryManager.New("Guess the Book", "medium")
guessTheBook:Add("In which book does a girl named Alice fall down a rabbit hole?", {"Alice in Wonderland", "The Wonderful Wizard of Oz", "Peter Pan", "The Secret Garden"})
guessTheBook:Add("Which book tells the story of a character named Bilbo Baggins?", {"The Hobbit", "The Lord of the Rings", "The Silmarillion", "Eragon"})
guessTheBook:Add("Which book features a dystopian society where books are burned?", {"Fahrenheit 451", "Brave New World", "Lord of the Flies", "Slaughterhouse-Five"}, 2)
guessTheBook:Add("Which book tells the story of a boy named Charlie who wins a golden ticket?", {"Charlie and the Chocolate Factory", "Charlie and the Giant Peach", "Wonka's Chocolate Factory", "The BFG"})
guessTheBook:Add("Which book tells the story of a boy who never grows up and lives in Neverland?", {"Peter Pan", "The Wonderful Wizard of Oz", "Alice in Wonderland", "The Chronicles of Narnia"})

local music = categoryManager.New("Music", "medium")
music:Add("Which band released the album 'The Dark Side of the Moon'?", {"Pink Floyd", "The Beatles", "Led Zeppelin", "The Rolling Stones"})
music:Add("What do you call the words of a song?", {"Lyrics", "Melody", "Harmony", "Rhythm"})
music:Add("Which of these is not a wind instrument?", {"Violin", "Flute", "Clarinet", "Saxophone"})
music:Add("What is the national anthem of the United States called?", {"The Star Spangled Banner", "God Save the Queen", "La Marseillaise", "O Canada"})
music:Add("Which of these is not a type of guitar?", {"Cello", "Acoustic", "Electric", "Bass"}, 2)

local brainrot = categoryManager.New("Brainrot", "easy")
brainrot:Add("What are those strange little men stuck in toilets called?", {"Skibidi", "Toilet snakes", "Plumbing gnomes", "Bowl boys"})
brainrot:Add("What is it called when someone talks at length in an irritating manner?", {"Yapping", "Woofing", "Ranting", "Monologuing"})
brainrot:Add("Which term describes someone who's a lone wolf — perhaps even better than an alpha?", {"Sigma", "Omega", "Beta", "Zeta"})
brainrot:Add("In which U.S. state are wild, strange things most likely to happen, according to the internet?", {"Only in Ohio", "Only in Alaska", "Only in Florida", "Only in Mississippi"})
brainrot:Add("What is the name of the purple McDonald's drink?", {"Grimace Shake", "Sussy Punch", "Blueberry McFlurry", "Expired Shake"}, 2)

local brainrot2 = categoryManager.New("Brainrot", "easy")
brainrot2:Add("What does it mean to be 'cooked'?", {"In a really bad position", "Extremely hungry", "Feeling very tired", "Excited or thrilled"})
brainrot2:Add("Fill in the blank: 'Erm, what the ___'?", {"sigma", "dog", "heck", "alpha"})
brainrot2:Add("What is the term for excessively praising or complimenting someone?", {"Glazing", "Rizzing", "Gassing", "Fawning"})
brainrot2:Add("Who is the main enemy of Skibidi Toilet?", {"Cameraman", "Janitor", "Skibidi Sink", "G-Man"}, 2)
brainrot2:Add("Finish the quote: 'Just put the ___ in the bag.'", {"Fries", "Money", "Skibidi", "Rizz"})

local gamerWords = categoryManager.New("Gamer Words", "easy")
gamerWords:Add("What does 'GG' mean?", {"Good Game", "Get Good", "Great Goal", "Gamer Girl"})
gamerWords:Add("Which phrase tells players to take a real-world break?", {"Touch Grass", "Eat a Salad", "Get Off", "Chillax"})
gamerWords:Add("A 'Noob' is a:", {"New Player", "Night Ops Bot", "Cheater", "Nintendo Spectator"})
gamerWords:Add("'OP' stands for:", {"Overpowered", "Original Poster", "Online Player", "Open Party"})
gamerWords:Add("If someone is 'Buffing' a character, they are:", {"Powering it up", "Working out", "Cleaning gear", "Dealing damage"}, 2)

local gamerWords2 = categoryManager.New("Gamer Words", "easy")
gamerWords2:Add("When devs weaken a strong weapon, they ___ it:", {"Nerf", "Buff", "Patch", "Hotfix"})
gamerWords2:Add("'Camping' in shooters means:", {"Staying in one spot", "Cheating", "Co-op mode", "Building camps"})
gamerWords2:Add("A 'Clutch' is a:", {"Last-second win", "Car part", "Team carry", "Controller glitch"})
gamerWords2:Add("If a player is trying to beat a game as fast as possible, they are attempting a:", {"Speedrun", "Speed Challenge", "Time Trial", "Time attack"})
gamerWords2:Add("What is the act of pulling enemies to fight them individually called?", {"Kiting", "Buffing", "Turtling", "Zerging"}, 2)

local streaming = categoryManager.New("Streaming Culture", "medium")
streaming:Add("'IRL' stands for:", {"In Real Life", "Internet Rules List", "Item Reward Level", "Instant Raid Loot"})
streaming:Add("The 'PogChamp' emote expresses:", {"Excitement", "Disappointment", "Anger", "Sadness"})
streaming:Add("A viewer who watches silently without chatting is called a:", {"Lurker", "NPC", "Nonchatter", "Sneaker"})
streaming:Add("You can Cheer to streamers using which currency?", {"Bits", "Coins", "Credits", "Super Chats"})
streaming:Add("What is the term for when a streamer sends their viewers to another live stream?", {"Raid", "Swap", "Relay", "Transfer"}, 2)

local computerHardware = categoryManager.New("Computer Hardware", "medium")
computerHardware:Add("What component is considered the 'brain' of a computer?", {"CPU", "RAM", "GPU", "HDD"})
computerHardware:Add("What does GPU stand for?", {"Graphics Processing Unit", "General Processing Unit", "Gaming Performance Unit", "Global Processing Unit"})
computerHardware:Add("What unit is computer memory (RAM) typically measured in?", {"Gigabytes", "Volts", "Hertz", "Watts"})
computerHardware:Add("What is the standard port for connecting a monitor?", {"HDMI", "USB", "Ethernet", "PS/2"})
computerHardware:Add("Which type of memory loses all its data when the computer is turned off?", {"RAM", "HDD", "SSD", "ROM"}, 2)

local ancientCivilizations = categoryManager.New("Ancient Civilizations", "medium")
ancientCivilizations:Add("Which ancient civilization had gladiator fights?", {"Romans", "Greeks", "Egyptians", "Chinese"})
ancientCivilizations:Add("Which ancient civilization built the pyramids of Giza?", {"Egypt", "Inca", "Rome", "Greece"})
ancientCivilizations:Add("What was the capital of the Roman Empire?", {"Rome", "Athens", "Alexandria", "Constantinople"})
ancientCivilizations:Add("Which civilization invented democracy?", {"Ancient Greece", "Rome", "Egypt", "Persia"}, 2)
ancientCivilizations:Add("Which ancient civilization invented paper?", {"Chinese", "Egyptians", "Greeks", "Persians"})

local worldRecords = categoryManager.New("World Records", "easy")
worldRecords:Add("What is the fastest land animal?", {"Cheetah", "Lion", "Horse", "Antelope"})
worldRecords:Add("Which book holds the record for being the most sold and translated in history?", {"The Bible", "The Lord of the Rings", "Harry Potter", "The Quran"})
worldRecords:Add("Which is the largest country by land area?", {"Russia", "China", "United States", "Canada"})
worldRecords:Add("Which is the highest mountain in the world?", {"Mount Everest", "K2", "Mount Kilimanjaro", "Mount Fuji"})
worldRecords:Add("What is the longest word in a major English dictionary?", {"Pneumonoultramicroscopicsilicovolcanoconiosis", "Supercalifragilisticexpialidocious", "Hippopotomonstrosesquippedaliophobia", "Floccinaucinihilipilification"}, 2)

local mythologyEasy2 = categoryManager.New("Mythology", "easy")
mythologyEasy2:Add("In Greek mythology, who is the king of the gods?", {"Zeus", "Poseidon", "Hades", "Apollo"})
mythologyEasy2:Add("What is the name of the winged horse in Greek mythology?", {"Pegasus", "Cerberus", "Hydra", "Minotaur"})
mythologyEasy2:Add("In Norse mythology, what is the name of the world tree?", {"Yggdrasil", "Valhalla", "Mjolnir", "Asgard"})
mythologyEasy2:Add("Who is the Roman god of war?", {"Mars", "Mercury", "Jupiter", "Neptune"})
mythologyEasy2:Add("In Egyptian mythology, who is the god of the dead?", {"Anubis", "Ra", "Osiris", "Horus"}, 2)

local mythologyHard2 = categoryManager.New("Mythology", "hard")
mythologyHard2:Add("In Greek mythology, who was punished by being forced to roll a boulder uphill for eternity?", {"Sisyphus", "Tantalus", "Prometheus", "Ixion"})
mythologyHard2:Add("What is the name of the river in the underworld that causes forgetfulness when drunk?", {"Lethe", "Styx", "Acheron", "Phlegethon"})
mythologyHard2:Add("In Norse mythology, what is the name of the final battle at the end of the world?", {"Ragnarok", "Valhalla", "Fimbulwinter", "Bifrost"})
mythologyHard2:Add("Who was the first woman in Greek mythology, created by the gods?", {"Pandora", "Aphrodite", "Athena", "Persephone"})
mythologyHard2:Add("In Hindu mythology, what is the name of the god of destruction?", {"Shiva", "Vishnu", "Brahma", "Indra"}, 2)


local spaceHard2 = categoryManager.New("Space", "hard")
spaceHard2:Add("What is the name of the closest star to Earth (besides the Sun)?", {"Proxima Centauri", "Alpha Centauri A", "Barnard's Star", "Sirius"})
spaceHard2:Add("How many moons does Mars have?", {"2", "0", "1", "4"})
spaceHard2:Add("What is the approximate age of the universe?", {"13.8 billion years", "4.5 billion years", "100 billion years", "6,000 years"})
spaceHard2:Add("What is the name of the imaginary boundary around a black hole beyond which nothing can escape?", {"Event horizon", "Singularity", "Photon sphere", "Accretion disk"})
spaceHard2:Add("Which planet in our solar system has the most moons?", {"Saturn", "Jupiter", "Uranus", "Neptune"}, 2)

local spaceEasy2 = categoryManager.New("Space", "easy")
spaceEasy2:Add("What is the name of our galaxy?", {"Milky Way", "Andromeda", "Triangulum", "Centaurus A"})
spaceEasy2:Add("How many planets are in our solar system?", {"8", "9", "7", "10"})
spaceEasy2:Add("What is the largest planet in our solar system?", {"Jupiter", "Saturn", "Neptune", "Mars"})
spaceEasy2:Add("What is the name of the first human to walk on the Moon?", {"Neil Armstrong", "Buzz Aldrin", "Yuri Gagarin", "John Glenn"})
spaceEasy2:Add("What do you call a massive explosion that occurs when a star dies?", {"Supernova", "Black hole", "Nebula", "Quasar"}, 2)

local popCulture = categoryManager.New("Pop Culture", "easy")
popCulture:Add("What social media platform is known for short videos and the 'For You Page'?", {"TikTok", "Instagram", "Snapchat", "YouTube"})
popCulture:Add("What game features players dropping onto an island and fighting to be the last one standing?", {"Fortnite", "Minecraft", "Among Us", "Roblox"})
popCulture:Add("What is the name of the AI chatbot developed by OpenAI?", {"ChatGPT", "Gemini", "Copilot", "Claude"})
popCulture:Add("What streaming platform is known for shows like Stranger Things and Squid Game?", {"Netflix", "Disney+", "HBO Max", "Hulu"})
popCulture:Add("What is the name of Elon Musk's rocket company?", {"SpaceX", "Blue Origin", "Virgin Galactic", "Rocket Lab"}, 2)

local popCultureMedium = categoryManager.New("Pop Culture", "medium")
popCultureMedium:Add("Which YouTuber was the most subscribed individual creator for several years?", {"PewDiePie", "MrBeast", "Markiplier", "Jacksepticeye"})
popCultureMedium:Add("What is the name of the viral dance associated with Gangnam Style?", {"Horse dance", "Shuffle", "Floss", "Woah"})
popCultureMedium:Add("What is the name of the app where users can send disappearing photos?", {"Snapchat", "Instagram", "BeReal", "TikTok"})
popCultureMedium:Add("Which company makes the iPhone?", {"Apple", "Samsung", "Google", "Microsoft"})
popCultureMedium:Add("What is the best-selling gaming console of all time?", {"PlayStation 2", "Nintendo DS", "Game Boy", "PlayStation 4"}, 2)

local tech = categoryManager.New("Technology", "medium")
tech:Add("What does 'AI' stand for?", {"Artificial Intelligence", "Automated Interface", "Advanced Input", "Automated Intelligence"})
tech:Add("What programming language was originally created for web browsers?", {"JavaScript", "Python", "Java", "C++"})
tech:Add("What does 'HTML' stand for?", {"HyperText Markup Language", "High Tech Machine Learning", "HyperText Machine Link", "High Text Markup Language"})
tech:Add("What company developed the Android operating system?", {"Google", "Apple", "Microsoft", "Samsung"})
tech:Add("What does 'URL' stand for?", {"Uniform Resource Locator", "Universal Request Link", "Unified Resource Location", "Uniform Remote Link"}, 2)

local techHard = categoryManager.New("Technology", "hard")
techHard:Add("What does 'TCP' stand for in networking?", {"Transmission Control Protocol", "Transfer Communication Protocol", "Trusted Connection Point", "Terminal Control Package"})
techHard:Add("What is the base of the binary number system?", {"2", "8", "10", "16"})
techHard:Add("What does 'RAM' stand for?", {"Random Access Memory", "Read-only Accessible Memory", "Rapid Access Module", "Remote Access Memory"})
techHard:Add("Which sorting algorithm has an average time complexity of O(n log n)?", {"Merge Sort", "Bubble Sort", "Insertion Sort", "Selection Sort"})
techHard:Add("What does 'DNS' stand for?", {"Domain Name System", "Data Network Server", "Dynamic Naming Service", "Distributed Network System"}, 2)

local trueOrFalse = categoryManager.New("True or False", "easy")
trueOrFalse:Add("True or False: Humans have more than 200 bones in their body.", {"True (206 bones)", "False"})
trueOrFalse:Add("True or False: Lightning never strikes the same place twice.", {"False", "True"})
trueOrFalse:Add("True or False: Bats are blind.", {"False (they can see)", "True (they are blind)"})
trueOrFalse:Add("True or False: The Great Wall of China is visible from space with the naked eye.", {"False", "True"}, 2)
trueOrFalse:Add("True or False: A day on Venus is longer than a year on Venus.", {"True", "False"})

local guessTheYear = categoryManager.New("Guess the Year", "medium")
guessTheYear:Add("In what year did the Titanic sink?", {"1912", "1905", "1920", "1898"})
guessTheYear:Add("In what year did World War II end?", {"1945", "1943", "1947", "1941"})
guessTheYear:Add("In what year did the first iPhone launch?", {"2007", "2005", "2009", "2003"})
guessTheYear:Add("In what year did the Berlin Wall fall?", {"1989", "1991", "1985", "1979"})
guessTheYear:Add("In what year did humans first land on the Moon?", {"1969", "1965", "1972", "1971"}, 2)

local holidays = categoryManager.New("Holidays", "easy")
holidays:Add("What holiday is celebrated on October 31st?", {"Halloween", "Christmas", "Easter", "Thanksgiving"})
holidays:Add("On what date is Christmas celebrated?", {"December 25th", "December 24th", "January 1st", "December 31st"})
holidays:Add("What holiday involves giving thanks and eating turkey in the USA?", {"Thanksgiving", "Christmas", "Labor Day", "Independence Day"})
holidays:Add("What holiday features fireworks and Independence celebrations in the USA?", {"Fourth of July", "Memorial Day", "Veterans Day", "Labor Day"})
holidays:Add("What holiday do people celebrate the new year?", {"New Year's Eve / Day", "Christmas", "Thanksgiving", "Easter"}, 2)
end -- chunk 2

do -- chunk 3: carsMedium2, fastMath, basketball, soccer, flags, famousPeople, emojiQuiz, musicHard, JS, python, html, robloxScripting, amongUs, minecraft hard/medium, fortnite, gta, cod, scienceEasy, historyHard, triviaHard, foodHard, geographyHard2
local carsMedium2 = categoryManager.New("Cars", "medium")
carsMedium2:Add("Which country invented the automobile?", {"Germany", "USA", "France", "UK"})
carsMedium2:Add("What does 'EV' stand for in the automotive industry?", {"Electric Vehicle", "Enhanced Velocity", "Engine Variant", "Extreme Version"})
carsMedium2:Add("What company makes the Mustang?", {"Ford", "Chevrolet", "Dodge", "Tesla"})
carsMedium2:Add("What is the fastest production car in the world as of 2024?", {"Bugatti Chiron Super Sport", "Koenigsegg Jesko", "Hennessey Venom F5", "SSC Tuatara"}, 2)
carsMedium2:Add("What does 'RPM' stand for in cars?", {"Revolutions Per Minute", "Rotations Per Motor", "Rapid Power Mode", "Rear Power Module"})

local fastMath = categoryManager.New("Fast Math", "easy")
fastMath:Add("What is 12 x 12?", {"144", "124", "132", "148"})
fastMath:Add("What is 15% of 200?", {"30", "25", "35", "20"})
fastMath:Add("What is the square root of 144?", {"12", "14", "11", "13"})
fastMath:Add("What is 7 to the power of 3?", {"343", "217", "441", "147"})
fastMath:Add("What is 1000 divided by 8?", {"125", "120", "130", "115"}, 2)

local basketball = categoryManager.New("Basketball", "medium")
basketball:Add("How many players are on each side during an NBA game?", {"5", "6", "4", "7"})
basketball:Add("How many points does a regular field goal score?", {"2", "1", "3", "4"})
basketball:Add("Which team has won the most NBA championships?", {"Boston Celtics", "Los Angeles Lakers", "Chicago Bulls", "Golden State Warriors"})
basketball:Add("How long is a quarter in an NBA game?", {"12 minutes", "10 minutes", "15 minutes", "8 minutes"})
basketball:Add("What is the term for when a player scores 10+ in three different statistics?", {"Triple-double", "Hat trick", "Grand slam", "Full house"}, 2)

local soccer = categoryManager.New("Football (Soccer)", "medium")
soccer:Add("How many players are on the field per team in a standard soccer match?", {"11", "10", "12", "9"})
soccer:Add("How long is a standard soccer match?", {"90 minutes", "80 minutes", "60 minutes", "120 minutes"})
soccer:Add("Which country has won the most FIFA World Cups?", {"Brazil", "Germany", "Argentina", "Italy"})
soccer:Add("What is the term for scoring three goals in one match?", {"Hat trick", "Triple", "Hat-trick", "Treble"})
soccer:Add("Which trophy is awarded to the winner of the Champions League?", {"The UEFA Champions League trophy", "The World Cup", "The Premier League trophy", "The FA Cup"}, 2)

local flagsHard = categoryManager.New("Guess the Flag", "hard")
flagsHard:Add("What country does this flag belong to? 🇮🇸", {"Iceland", "Ireland", "Greenland", "Norway"})
flagsHard:Add("What country does this flag belong to? 🇸🇬", {"Singapore", "Malaysia", "Indonesia", "Brunei"})
flagsHard:Add("What country does this flag belong to? 🇳🇿", {"New Zealand", "Australia", "Fiji", "Samoa"})
flagsHard:Add("What country does this flag belong to? 🇨🇭", {"Switzerland", "Austria", "Sweden", "Slovakia"})
flagsHard:Add("What country does this flag belong to? 🇧🇩", {"Bangladesh", "Pakistan", "Indonesia", "Malaysia"}, 2)

local flagsEasy = categoryManager.New("Guess the Flag", "easy")
flagsEasy:Add("What country does this flag belong to? 🇺🇸", {"USA", "UK", "Australia", "Canada"})
flagsEasy:Add("What country does this flag belong to? 🇯🇵", {"Japan", "China", "South Korea", "Vietnam"})
flagsEasy:Add("What country does this flag belong to? 🇧🇷", {"Brazil", "Argentina", "Mexico", "Portugal"})
flagsEasy:Add("What country does this flag belong to? 🇨🇦", {"Canada", "USA", "Australia", "UK"})
flagsEasy:Add("What country does this flag belong to? 🇩🇪", {"Germany", "Austria", "Belgium", "Switzerland"})

local famousPeople = categoryManager.New("Famous People", "medium")
famousPeople:Add("Who painted the Mona Lisa?", {"Leonardo da Vinci", "Michelangelo", "Raphael", "Donatello"})
famousPeople:Add("Who wrote the play 'Romeo and Juliet'?", {"William Shakespeare", "Charles Dickens", "Mark Twain", "Leo Tolstoy"})
famousPeople:Add("Who was the first President of the United States?", {"George Washington", "Abraham Lincoln", "Thomas Jefferson", "John Adams"})
famousPeople:Add("Who developed the first successful light bulb?", {"Thomas Edison", "Nikola Tesla", "Alexander Graham Bell", "Benjamin Franklin"})
famousPeople:Add("Who is known as the 'Father of Modern Physics'?", {"Albert Einstein", "Isaac Newton", "Stephen Hawking", "Richard Feynman"}, 2)

local emojiQuiz = categoryManager.New("Emoji Quiz", "easy")
emojiQuiz:Add("What movie does this represent? 🦁👑", {"The Lion King", "Shrek", "Frozen", "Moana"})
emojiQuiz:Add("What does this emoji combination represent? 🕷️🕸️👨", {"Spider-Man", "Batman", "Tarzan", "The Fly"})
emojiQuiz:Add("What game does this represent? 🍄🏃👾", {"Super Mario", "Pac-Man", "Tetris", "Donkey Kong"})
emojiQuiz:Add("What does this represent? 🧊❄️👸", {"Frozen", "Snow White", "Cinderella", "Brave"})
emojiQuiz:Add("What food does this emoji represent? 🥑", {"Avocado", "Pear", "Kiwi", "Lime"}, 2)

local musicHard = categoryManager.New("Music", "hard")
musicHard:Add("What note is at 440Hz in standard tuning?", {"A4", "C4", "G4", "E4"})
musicHard:Add("How many semitones are in an octave?", {"12", "8", "10", "16"})
musicHard:Add("What is the time signature of a waltz?", {"3/4", "4/4", "6/8", "2/4"})
musicHard:Add("What is the term for a gradual increase in tempo?", {"Accelerando", "Ritardando", "Fortissimo", "Pianissimo"})
musicHard:Add("What is the name of the musical symbol that indicates the pitch of notes on a staff?", {"Clef", "Sharp", "Flat", "Rest"}, 2)

-- ===================== NEW CATEGORIES =====================

-- JavaScript
local jsEasy = categoryManager.New("JavaScript", "easy")
jsEasy:Add("Which keyword declares a variable that cannot be reassigned?", {"const", "let", "var", "static"})
jsEasy:Add("What does 'typeof null' return in JavaScript?", {"object", "null", "undefined", "string"})
jsEasy:Add("Which method adds an element to the end of an array?", {"push()", "pop()", "shift()", "splice()"})
jsEasy:Add("What symbol is used for single-line comments in JavaScript?", {"//", "--", "#", "/**"})
jsEasy:Add("What does 'DOM' stand for?", {"Document Object Model", "Data Object Map", "Direct Object Method", "Dynamic Output Module"}, 2)

local jsMedium = categoryManager.New("JavaScript", "medium")
jsMedium:Add("What does '===' check compared to '=='?", {"Value AND type", "Only value", "Only type", "Reference equality"})
jsMedium:Add("What is the output of: typeof function(){}?", {"function", "object", "undefined", "callable"})
jsMedium:Add("Which array method returns a new array with elements that pass a test?", {"filter()", "map()", "find()", "reduce()"})
jsMedium:Add("What is a closure in JavaScript?", {"A function with access to its outer scope", "A sealed object", "A loop that exits early", "A blocked promise"})
jsMedium:Add("What does 'NaN' stand for?", {"Not a Number", "Null and Nothing", "New Assigned Null", "Not Assigned Node"}, 2)

local jsHard = categoryManager.New("JavaScript", "hard")
jsHard:Add("What is the event loop used for in JavaScript?", {"Handling async operations in a single thread", "Looping through DOM nodes", "Managing memory allocation", "Running multiple threads"})
jsHard:Add("What does the 'prototype' property do?", {"Enables inheritance between objects", "Stores private variables", "Declares class types", "Prevents mutation"})
jsHard:Add("What is a Promise in JavaScript?", {"An object representing eventual completion of async work", "A guaranteed synchronous return", "A type of loop", "A reserved keyword"})
jsHard:Add("What does 'use strict' do?", {"Enables strict mode to catch common errors", "Locks variable types", "Prevents DOM access", "Disables eval()"}, 2)
jsHard:Add("What is the difference between 'call' and 'apply'?", {"call takes args individually, apply takes an array", "apply takes args individually, call takes an array", "They are identical", "call is async, apply is sync"})

-- Python
local pythonEasy = categoryManager.New("Python", "easy")
pythonEasy:Add("What keyword is used to define a function in Python?", {"def", "func", "function", "define"})
pythonEasy:Add("Which of these is a valid Python comment?", {"# This is a comment", "// This is a comment", "-- comment", "/* comment */"})
pythonEasy:Add("What does 'len()' do in Python?", {"Returns the length of an object", "Logs a value", "Loops through a list", "Converts to integer"})
pythonEasy:Add("What is the output of: print(2 ** 3)?", {"8", "6", "9", "5"})
pythonEasy:Add("Which data type is immutable in Python?", {"Tuple", "List", "Dictionary", "Set"}, 2)

local pythonMedium = categoryManager.New("Python", "medium")
pythonMedium:Add("What does 'self' refer to in a Python class?", {"The current instance of the class", "The parent class", "A global variable", "The class itself"})
pythonMedium:Add("What is a list comprehension?", {"A concise way to create lists using a loop expression", "A type of sorted list", "A class for managing lists", "A built-in function"})
pythonMedium:Add("What module is used to work with regular expressions in Python?", {"re", "regex", "rx", "match"})
pythonMedium:Add("What is the difference between a list and a tuple?", {"Lists are mutable, tuples are not", "Tuples are mutable, lists are not", "They are identical", "Lists use (), tuples use []"})
pythonMedium:Add("What does 'pass' do in Python?", {"Nothing - it's a placeholder", "Skips the current loop iteration", "Exits the function", "Passes a value by reference"}, 2)

local pythonHard = categoryManager.New("Python", "hard")
pythonHard:Add("What is a decorator in Python?", {"A function that wraps another function to extend its behavior", "A class attribute", "A type hint", "A syntax for list creation"})
pythonHard:Add("What is the GIL in Python?", {"Global Interpreter Lock that allows only one thread at a time", "Global Integer List", "A memory manager", "A garbage collector"})
pythonHard:Add("What does 'yield' do in a Python function?", {"Makes it a generator that lazily produces values", "Returns and exits immediately", "Pauses the program", "Raises an exception"})
pythonHard:Add("What is the time complexity of Python dict lookup on average?", {"O(1)", "O(n)", "O(log n)", "O(n^2)"}, 2)
pythonHard:Add("What does __dunder__ mean in Python?", {"Double underscore, marks special/magic methods", "A debug utility", "A deprecated syntax", "A type of decorator"})

-- HTML & CSS
local htmlEasy = categoryManager.New("HTML and CSS", "easy")
htmlEasy:Add("What does HTML stand for?", {"HyperText Markup Language", "High Transfer Markup Language", "HyperText Machine Language", "HyperTransfer Markup Logic"})
htmlEasy:Add("Which HTML tag is used for the largest heading?", {"h1", "h6", "head", "title"})
htmlEasy:Add("What does CSS stand for?", {"Cascading Style Sheets", "Creative Style System", "Computer Style Sheets", "Cascading Script Syntax"})
htmlEasy:Add("Which HTML tag creates a hyperlink?", {"a", "link", "href", "url"})
htmlEasy:Add("Which CSS property changes the text color?", {"color", "font-color", "text-color", "foreground"}, 2)

local htmlMedium = categoryManager.New("HTML and CSS", "medium")
htmlMedium:Add("What does the CSS 'box model' consist of?", {"Content, padding, border, margin", "Width, height, color, font", "Display, position, float, clear", "Flex, grid, block, inline"})
htmlMedium:Add("Which CSS property controls the stacking order of elements?", {"z-index", "stack-order", "layer", "depth"})
htmlMedium:Add("What is the default display value of a div?", {"block", "inline", "flex", "inline-block"})
htmlMedium:Add("Which HTML attribute specifies an alternate text for an image?", {"alt", "title", "desc", "label"})
htmlMedium:Add("What CSS unit is relative to the font size of the root element?", {"rem", "em", "px", "vh"}, 2)

-- Roblox Studio / Scripting (hard)
local robloxScripting = categoryManager.New("Roblox Scripting", "hard")
robloxScripting:Add("What service handles player data persistence in Roblox?", {"DataStoreService", "PlayerService", "SaveService", "StorageService"})
robloxScripting:Add("What is the difference between a Script and a LocalScript?", {"Scripts run on server, LocalScripts on client", "LocalScripts run on server, Scripts on client", "Both run on server", "Both run on client"})
robloxScripting:Add("What does 'workspace:WaitForChild()' do?", {"Yields until a child with that name exists", "Returns nil if not found", "Errors immediately if not found", "Searches all descendants"})
robloxScripting:Add("What event fires when a player joins the game?", {"Players.PlayerAdded", "Players.PlayerJoined", "game.PlayerAdded", "workspace.PlayerAdded"})
robloxScripting:Add("What does 'pcall' do in Luau?", {"Calls a function in protected mode, catching errors", "Prints to output", "Pauses execution", "Creates a coroutine"}, 2)

-- Among Us
local amongUs = categoryManager.New("Among Us", "easy")
amongUs:Add("What is the goal of the Impostors in Among Us?", {"Eliminate Crewmates without being voted out", "Complete tasks", "Fix the reactor", "Escape the ship"})
amongUs:Add("What happens when an emergency meeting is called?", {"All players discuss and vote to eject someone", "The game pauses", "Impostors are revealed", "The map resets"})
amongUs:Add("What color was the first default character in Among Us?", {"Red", "Blue", "White", "Green"})
amongUs:Add("What task involves matching wires in Among Us?", {"Fix Wiring", "Reactor", "O2", "Navigation"})
amongUs:Add("What does 'venting' mean in Among Us?", {"Moving through air vents as Impostor", "Complaining in chat", "Reporting a body", "Completing a task"}, 2)

-- Minecraft Hard
local minecraftHard = categoryManager.New("Minecraft", "hard")
minecraftHard:Add("What is the max enchantment level for Sharpness?", {"5", "3", "10", "7"})
minecraftHard:Add("What mob drops a music disc called '13'?", {"Creeper killed by skeleton", "Any creeper", "Skeleton", "Zombie"})
minecraftHard:Add("What is the rarest ore in Minecraft as of 1.17+?", {"Ancient Debris", "Diamond", "Emerald", "Amethyst"})
minecraftHard:Add("What biome is required to find a woodland mansion?", {"Dark Forest", "Taiga", "Jungle", "Savanna"})
minecraftHard:Add("How many blocks tall is the Nether?", {"128", "256", "64", "512"}, 2)

-- Minecraft Medium
local minecraftMedium = categoryManager.New("Minecraft", "medium")
minecraftMedium:Add("What item do you need to tame a wolf?", {"Bone", "Meat", "Fish", "Lead"})
minecraftMedium:Add("What is the name of the currency used to trade with villagers?", {"Emerald", "Gold", "Diamond", "Iron"})
minecraftMedium:Add("What structure contains the End Portal?", {"Stronghold", "Fortress", "Temple", "Monument"})
minecraftMedium:Add("How do you breed cows in Minecraft?", {"Feed two cows wheat", "Feed two cows seeds", "Feed two cows carrots", "Breed them with hay bales"})
minecraftMedium:Add("What potion ingredient makes a potion of Night Vision?", {"Golden Carrot", "Blaze Powder", "Sugar", "Spider Eye"}, 2)

-- Fortnite
local fortnite = categoryManager.New("Fortnite", "easy")
fortnite:Add("What is the name of the battle royale island players drop onto?", {"The Island", "Apollo", "Battle Royale Map", "Drop Zone"})
fortnite:Add("What material is NOT used for building in Fortnite?", {"Stone Brick", "Wood", "Stone", "Metal"})
fortnite:Add("What is the rarest weapon rarity in Fortnite?", {"Mythic", "Legendary", "Epic", "Exotic"})
fortnite:Add("What does the storm do to players caught inside it?", {"Deals damage over time", "Instantly eliminates them", "Slows them down", "Removes their inventory"})
fortnite:Add("What is 'The Bus' that players jump from called?", {"Battle Bus", "Storm Bus", "Drop Bus", "Launch Bus"}, 2)

-- GTA
local gta = categoryManager.New("GTA", "medium")
gta:Add("What city is GTA V set in?", {"Los Santos", "Vice City", "Liberty City", "San Fierro"})
gta:Add("What are the three protagonists of GTA V?", {"Michael, Trevor, Franklin", "Niko, Roman, Packie", "CJ, Sweet, Ryder", "Tommy, Lance, Sonny"})
gta:Add("What does GTA stand for?", {"Grand Theft Auto", "Grand Theft Autos", "Great Theft Action", "General Traffic Authority"})
gta:Add("What is the in-game internet called in GTA V?", {"Eyefind", "LifeInvader", "Bleeter", "Rockstar Social Club"}, 2)
gta:Add("Which GTA game is set in Miami in the 1980s?", {"GTA Vice City", "GTA San Andreas", "GTA III", "GTA IV"})

-- Call of Duty
local cod = categoryManager.New("Call of Duty", "medium")
cod:Add("What is the name of the iconic CoD zombie map set in a Nazi facility?", {"Nacht der Untoten", "Kino der Toten", "Der Riese", "Mob of the Dead"})
cod:Add("In which CoD game did the 'No Russian' mission appear?", {"Modern Warfare 2", "Black Ops", "Ghosts", "Modern Warfare 3"})
cod:Add("What is the name of CoD's battle royale mode?", {"Warzone", "Blackout", "Ground War", "DMZ"})
cod:Add("Which operator says 'I will not be the last' in Modern Warfare?", {"Captain Price", "Ghost", "Soap", "Gaz"})
cod:Add("What does 'UAV' stand for in CoD?", {"Unmanned Aerial Vehicle", "Universal Assault Vehicle", "Uplink Aerial View", "Unified Air Vector"}, 2)

-- Science Easy
local scienceEasy = categoryManager.New("Science", "easy")
scienceEasy:Add("What planet is known as the Red Planet?", {"Mars", "Venus", "Jupiter", "Saturn"})
scienceEasy:Add("What is H2O more commonly known as?", {"Water", "Hydrogen", "Oxygen", "Salt"})
scienceEasy:Add("How many legs does a spider have?", {"8", "6", "10", "12"})
scienceEasy:Add("What force keeps us on the ground?", {"Gravity", "Magnetism", "Friction", "Air pressure"})
scienceEasy:Add("What is the centre of an atom called?", {"Nucleus", "Electron", "Proton", "Core"}, 2)

-- History Hard
local historyHard = categoryManager.New("History", "hard")
historyHard:Add("What year did the Roman Empire fall in the West?", {"476 AD", "410 AD", "395 AD", "500 AD"})
historyHard:Add("Who was the first emperor of China?", {"Qin Shi Huang", "Wu Zetian", "Kublai Khan", "Sun Yat-sen"})
historyHard:Add("Which treaty ended World War I?", {"Treaty of Versailles", "Treaty of Paris", "Treaty of Westphalia", "Treaty of Utrecht"})
historyHard:Add("What was the name of the ship that brought the Pilgrims to America in 1620?", {"Mayflower", "Santa Maria", "Endeavour", "Pinta"})
historyHard:Add("Which country was NOT part of the Allied Powers in WWI?", {"Ottoman Empire", "France", "Russia", "UK"}, 2)

-- Trivia Hard
local triviaHard = categoryManager.New("Trivia", "hard")
triviaHard:Add("How many bones are in the adult human body?", {"206", "208", "198", "212"})
triviaHard:Add("What is the only number that is twice the sum of its digits?", {"18", "12", "24", "36"})
triviaHard:Add("What language has the most native speakers in the world?", {"Mandarin Chinese", "English", "Spanish", "Hindi"})
triviaHard:Add("What is the longest bone in the human body?", {"Femur", "Tibia", "Humerus", "Fibula"})
triviaHard:Add("What is the chemical symbol for gold?", {"Au", "Go", "Gd", "Ag"}, 2)

-- Food and Drink Hard
local foodHard = categoryManager.New("Food and Drink", "hard")
foodHard:Add("What is 'umami' often described as?", {"Savory or meaty taste", "Sweet and sour", "Bitter and sharp", "Salty and cold"})
foodHard:Add("Which country does Worcestershire sauce originate from?", {"England", "France", "Germany", "USA"})
foodHard:Add("What is the main ingredient in traditional miso soup?", {"Fermented soybean paste", "Fish stock", "Seaweed extract", "Rice wine"})
foodHard:Add("What grain is used to make traditional Japanese sake?", {"Rice", "Barley", "Wheat", "Corn"})
foodHard:Add("What is the Scoville scale used to measure?", {"Chili pepper heat", "Wine acidity", "Cheese age", "Bread density"}, 2)

-- Geography Hard 2
local geographyHard2 = categoryManager.New("Geography", "hard")
geographyHard2:Add("What is the deepest lake in the world?", {"Lake Baikal", "Lake Superior", "Lake Tanganyika", "Caspian Sea"})
geographyHard2:Add("Which country has the most natural lakes?", {"Canada", "Russia", "Finland", "USA"})
geographyHard2:Add("What is the name of the tectonic plate that covers most of the Pacific Ocean?", {"Pacific Plate", "Indo-Australian Plate", "Nazca Plate", "Philippine Plate"})
geographyHard2:Add("Which African country has the most pyramids?", {"Sudan", "Egypt", "Libya", "Ethiopia"})
geographyHard2:Add("What is the largest desert in the world by area?", {"Antarctic Desert", "Sahara", "Arabian Desert", "Gobi"}, 2)
end -- chunk 3

-- ===================== NEW CATEGORIES BATCH 2 =====================
do -- chunk 4: carsEasy, carsMedium, space, musicEasy, internet/tech, mythology, humanBody, moviesHard, brainteasers, holidaysMedium, languages, popularGames, steam, lego, screens, hardwareEvo, pokemon, robloxGames, socialMedia, marvel, olympics
-- Cars
local carsEasy = categoryManager.New("Cars", "easy")
carsEasy:Add("What country is BMW from?", {"Germany", "Italy", "Japan", "USA"})
carsEasy:Add("What does SUV stand for?", {"Sport Utility Vehicle", "Super Urban Vehicle", "Standard Utility Van", "Sport Urban Van"})
carsEasy:Add("Which car brand has a prancing horse logo?", {"Ferrari", "Lamborghini", "Porsche", "Maserati"})
carsEasy:Add("What is the best-selling car of all time?", {"Toyota Corolla", "Ford F-150", "Honda Civic", "Volkswagen Golf"})
carsEasy:Add("What does 'EV' stand for in the car industry?", {"Electric Vehicle", "Engine Variant", "Extended Version", "Economy Vehicle"}, 2)

local carsMedium = categoryManager.New("Cars", "medium")
carsMedium:Add("What car company makes the 'Mustang'?", {"Ford", "Chevrolet", "Dodge", "Pontiac"})
carsMedium:Add("Which country invented the first gasoline-powered car?", {"Germany", "USA", "France", "UK"})
carsMedium:Add("What does 'RPM' stand for?", {"Revolutions Per Minute", "Rotations Per Mile", "Rate Per Minute", "Revolutions Per Mile"})
carsMedium:Add("What is the fastest production car in the world as of 2023?", {"Bugatti Chiron Super Sport", "Koenigsegg Jesko", "Rimac Nevera", "SSC Tuatara"}, 2)
carsMedium:Add("Which brand makes the 'Aventador'?", {"Lamborghini", "Ferrari", "McLaren", "Bugatti"})

-- Space
local spaceEasy = categoryManager.New("Space", "easy")
spaceEasy:Add("What is the closest star to Earth?", {"The Sun", "Proxima Centauri", "Sirius", "Betelgeuse"})
spaceEasy:Add("How many planets are in our solar system?", {"8", "9", "7", "10"})
spaceEasy:Add("What planet is known for its rings?", {"Saturn", "Jupiter", "Uranus", "Neptune"})
spaceEasy:Add("Who was the first human to walk on the Moon?", {"Neil Armstrong", "Buzz Aldrin", "Yuri Gagarin", "Alan Shepard"})
spaceEasy:Add("What is the name of NASA's most famous space telescope?", {"Hubble", "James Webb", "Spitzer", "Kepler"}, 2)

local spaceHard = categoryManager.New("Space", "hard")
spaceHard:Add("What is the name of the boundary around a black hole beyond which nothing can escape?", {"Event horizon", "Photon sphere", "Schwarzschild radius", "Singularity"})
spaceHard:Add("How long does light from the Sun take to reach Earth?", {"8 minutes", "1 minute", "30 seconds", "1 hour"})
spaceHard:Add("What is the largest volcano in the solar system?", {"Olympus Mons", "Mauna Kea", "Maxwell Montes", "Skadi Mons"})
spaceHard:Add("What year did the first artificial satellite, Sputnik 1, launch?", {"1957", "1961", "1969", "1953"}, 2)
spaceHard:Add("What is the term for a neutron star that emits beams of radiation?", {"Pulsar", "Quasar", "Magnetar", "Blazar"})

-- Music Easy
local musicEasy = categoryManager.New("Music", "easy")
musicEasy:Add("How many strings does a standard guitar have?", {"6", "4", "8", "5"})
musicEasy:Add("What genre is Eminem known for?", {"Hip-hop/Rap", "Rock", "Pop", "R&B"})
musicEasy:Add("Which band sang 'Bohemian Rhapsody'?", {"Queen", "The Beatles", "Led Zeppelin", "Pink Floyd"})
musicEasy:Add("What instrument does a pianist play?", {"Piano", "Violin", "Flute", "Drums"})
musicEasy:Add("Which artist is known as the 'King of Pop'?", {"Michael Jackson", "Elvis Presley", "Prince", "David Bowie"}, 2)

-- Internet & Tech
local techEasy = categoryManager.New("Internet and Tech", "easy")
techEasy:Add("What does 'URL' stand for?", {"Uniform Resource Locator", "Universal Reference Link", "Unified Resource Library", "Unique Routing Label"})
techEasy:Add("What company makes the iPhone?", {"Apple", "Samsung", "Google", "Sony"})
techEasy:Add("What does 'GPS' stand for?", {"Global Positioning System", "General Positioning Satellite", "Ground Positioning System", "Global Proximity Sensor"})
techEasy:Add("What is the most visited website in the world?", {"Google", "YouTube", "Facebook", "Wikipedia"})
techEasy:Add("What does 'CPU' stand for?", {"Central Processing Unit", "Core Processing Unit", "Central Program Utility", "Computer Processing Unit"}, 2)

local techMedium = categoryManager.New("Internet and Tech", "medium")
techMedium:Add("What programming language was the first to be widely used?", {"FORTRAN", "C", "Python", "COBOL"})
techMedium:Add("What does 'HTTP' stand for?", {"HyperText Transfer Protocol", "High Transfer Text Protocol", "HyperText Transport Program", "Hybrid Text Transfer Protocol"})
techMedium:Add("What year was the first iPhone released?", {"2007", "2005", "2009", "2010"})
techMedium:Add("What is the binary representation of the number 5?", {"101", "110", "011", "100"}, 2)
techMedium:Add("Which company developed the Android operating system?", {"Google", "Apple", "Microsoft", "Samsung"})

-- Mythology
local mythologyEasy = categoryManager.New("Mythology", "easy")
mythologyEasy:Add("Who is the Greek god of the sea?", {"Poseidon", "Zeus", "Hades", "Apollo"})
mythologyEasy:Add("What is the name of Thor's hammer?", {"Mjolnir", "Gungnir", "Excalibur", "Durandal"})
mythologyEasy:Add("Who is the Roman equivalent of the Greek god Zeus?", {"Jupiter", "Mars", "Mercury", "Neptune"})
mythologyEasy:Add("In Greek mythology, who flew too close to the sun?", {"Icarus", "Daedalus", "Perseus", "Theseus"})
mythologyEasy:Add("What creature has the body of a lion and the head of a human?", {"Sphinx", "Minotaur", "Centaur", "Griffin"}, 2)

local mythologyHard = categoryManager.New("Mythology", "hard")
mythologyHard:Add("In Norse mythology, what is the name of the world tree?", {"Yggdrasil", "Asgard", "Midgard", "Bifrost"})
mythologyHard:Add("Who was the Egyptian god of the dead?", {"Osiris", "Ra", "Anubis", "Horus"})
mythologyHard:Add("In Greek mythology, how many labours did Hercules complete?", {"12", "10", "7", "9"})
mythologyHard:Add("What is the name of the river in the Greek underworld that causes forgetfulness?", {"Lethe", "Styx", "Acheron", "Phlegethon"}, 2)
mythologyHard:Add("Who was the Greek god of fire and the forge?", {"Hephaestus", "Ares", "Prometheus", "Vulcan"})

-- Human Body
local bodyEasy = categoryManager.New("Human Body", "easy")
bodyEasy:Add("How many chambers does the human heart have?", {"4", "2", "3", "6"})
bodyEasy:Add("What is the largest organ in the human body?", {"Skin", "Liver", "Brain", "Lungs"})
bodyEasy:Add("How many teeth does an adult human have?", {"32", "28", "30", "36"})
bodyEasy:Add("What organ filters blood in the human body?", {"Kidneys", "Liver", "Spleen", "Pancreas"})
bodyEasy:Add("What is the hardest substance in the human body?", {"Tooth enamel", "Bone", "Cartilage", "Fingernails"}, 2)

-- Movies Hard
local moviesHard = categoryManager.New("Movies", "hard")
moviesHard:Add("Who directed the movie 'Pulp Fiction'?", {"Quentin Tarantino", "Martin Scorsese", "Steven Spielberg", "Christopher Nolan"})
moviesHard:Add("What was the first feature-length animated movie ever released?", {"Snow White and the Seven Dwarfs", "Fantasia", "Pinocchio", "Bambi"})
moviesHard:Add("Which film has the most Oscar wins ever (11 wins)?", {"Ben-Hur, Titanic, Return of the King", "Avatar", "Gone with the Wind", "Schindler's List"})
moviesHard:Add("In which movie does the line 'I am your father' appear?", {"The Empire Strikes Back", "A New Hope", "Return of the Jedi", "Revenge of the Sith"}, 2)
moviesHard:Add("Who played Iron Man in the Marvel Cinematic Universe?", {"Robert Downey Jr.", "Chris Evans", "Chris Hemsworth", "Mark Ruffalo"})

-- Brainteasers
local brainteasers = categoryManager.New("Brainteasers", "hard")
brainteasers:Add("What has hands but cannot clap?", {"A clock", "A statue", "A glove", "A tree"})
brainteasers:Add("I speak without a mouth and hear without ears. What am I?", {"An echo", "A shadow", "The wind", "A mirror"})
brainteasers:Add("The more you take, the more you leave behind. What am I?", {"Footsteps", "Time", "Memories", "Breath"})
brainteasers:Add("What gets wetter the more it dries?", {"A towel", "A sponge", "A cloud", "Sand"}, 2)
brainteasers:Add("I have cities but no houses, mountains but no trees, water but no fish. What am I?", {"A map", "A painting", "A globe", "A dream"})

-- Holidays
local holidaysMedium = categoryManager.New("Holidays", "medium")
holidaysMedium:Add("What holiday involves trick-or-treating?", {"Halloween", "Easter", "Thanksgiving", "Bonfire Night"})
holidaysMedium:Add("What do people traditionally count down to on New Year's Eve?", {"Midnight", "Noon", "Sunrise", "Sunset"})
holidaysMedium:Add("What is the name of the Jewish festival of lights?", {"Hanukkah", "Passover", "Rosh Hashanah", "Yom Kippur"})
holidaysMedium:Add("Which holiday celebrates love and is on February 14th?", {"Valentine's Day", "Mother's Day", "Anniversary Day", "Friendship Day"}, 2)
holidaysMedium:Add("What does 'Diwali' celebrate?", {"Festival of Lights (Hindu new year)", "Harvest festival", "Day of the Dead", "Spring equinox"}, 2)

-- Languages
local languages = categoryManager.New("Languages", "medium")
languages:Add("How many official languages does the United Nations have?", {"6", "4", "8", "10"})
languages:Add("What is the most spoken native language in the world?", {"Mandarin Chinese", "English", "Spanish", "Hindi"})
languages:Add("Which language has the most words?", {"English", "German", "French", "Japanese"})
languages:Add("What is the official language of Brazil?", {"Portuguese", "Spanish", "French", "English"}, 2)
languages:Add("How do you say 'thank you' in Japanese?", {"Arigatou", "Konnichiwa", "Sayonara", "Sumimasen"})

-- ===================== NEW CATEGORIES BATCH 3 =====================

-- Popular Games (easy)
local popularGamesEasy = categoryManager.New("Popular Games", "easy")
popularGamesEasy:Add("What game has players building and surviving in a blocky world?", {"Minecraft", "Roblox", "Terraria", "Fortnite"})
popularGamesEasy:Add("In which game do players drop onto an island and try to be the last one standing?", {"Fortnite", "Apex Legends", "Warzone", "PUBG"})
popularGamesEasy:Add("What game features a colorful cast of heroes with abilities called 'ultimates'?", {"Overwatch", "Valorant", "Paladins", "Team Fortress 2"})
popularGamesEasy:Add("In what game do you collect creatures and battle with them?", {"Pokémon", "Digimon", "Monster Hunter", "Dragon Quest"})
popularGamesEasy:Add("What is the name of the open-world Rockstar game set in the Wild West?", {"Red Dead Redemption", "GTA V", "Bully", "L.A. Noire"}, 2)

-- Popular Games (medium)
local popularGamesMedium = categoryManager.New("Popular Games", "medium")
popularGamesMedium:Add("What game introduced the Battle Royale genre to mainstream audiences on PC?", {"PUBG", "Fortnite", "H1Z1", "Apex Legends"})
popularGamesMedium:Add("Which game is set in the fictional country of Hyrule?", {"The Legend of Zelda", "Dark Souls", "Elden Ring", "Fable"})
popularGamesMedium:Add("What game lets you play as a Spartan super-soldier fighting aliens?", {"Halo", "Destiny", "Mass Effect", "Gears of War"})
popularGamesMedium:Add("In Among Us, how many Impostors are there in a standard 10-player game?", {"1 or 2", "Always 1", "Always 2", "Always 3"})
popularGamesMedium:Add("What is the name of the open world RPG by CD Projekt Red set in a dystopian city?", {"Cyberpunk 2077", "The Witcher 3", "Deus Ex", "Fallout 4"}, 2)

-- Popular Games (hard)
local popularGamesHard = categoryManager.New("Popular Games", "hard")
popularGamesHard:Add("What year was the original Dark Souls released?", {"2011", "2009", "2013", "2015"})
popularGamesHard:Add("What is the name of the in-game currency in The Elder Scrolls series?", {"Septims", "Rupees", "Gil", "Caps"})
popularGamesHard:Add("Which studio developed the game 'Hollow Knight'?", {"Team Cherry", "Moon Studios", "Supergiant Games", "Motion Twin"})
popularGamesHard:Add("In Terraria, what is the final boss of the game?", {"Moon Lord", "Wall of Flesh", "Duke Fishron", "Plantera"})
popularGamesHard:Add("What engine does Valve's game Portal run on?", {"Source", "Unreal Engine 3", "id Tech 4", "CryEngine"}, 2)

-- Steam (easy)
local steamEasy = categoryManager.New("Steam", "easy")
steamEasy:Add("What company owns the Steam platform?", {"Valve", "Microsoft", "EA", "Ubisoft"})
steamEasy:Add("What is the name of Steam's annual sale that happens in summer?", {"Steam Summer Sale", "Steam Fest", "Steam Deals", "Steam Bargain Week"})
steamEasy:Add("What does it mean when a game is 'Overwhelmingly Positive' on Steam?", {"It has very high user review scores", "It sold over 1 million copies", "It was featured by Valve", "It has no bugs"})
steamEasy:Add("What is Steam's digital points currency called?", {"Steam Points", "Steam Coins", "Valve Credits", "Steam Tokens"})
steamEasy:Add("What feature lets you stream your Steam games to another device?", {"Steam Link", "Steam Remote", "Steam Cast", "Steam Share"}, 2)

-- Steam (medium)
local steamMedium = categoryManager.New("Steam", "medium")
steamMedium:Add("What is the name of Steam's discussion and community hub for each game?", {"Steam Community Hub", "Steam Forums", "Steam Boards", "Steam Talk"})
steamMedium:Add("What is a 'Steam Trading Card'?", {"A collectible card dropped by playing games", "A card you send to friends", "A discount voucher", "A physical card you buy"})
steamMedium:Add("What is the Steam Achievement system used for?", {"Tracking in-game milestones and goals", "Unlocking free games", "Earning real money", "Competing in tournaments"})
steamMedium:Add("What year did Steam first launch?", {"2003", "2001", "2005", "2007"})
steamMedium:Add("What is 'Steam Early Access'?", {"Buying and playing a game before its full release", "A beta test only for Valve employees", "A free trial of any game", "A VIP subscription service"}, 2)

-- Steam (hard)
local steamHard = categoryManager.New("Steam", "hard")
steamHard:Add("What is Steam's content rating system for adult games called?", {"Adult Only Content / Steam Adults", "Steam Mature Filter", "Steam 18+", "Steam NSFW Gate"})
steamHard:Add("What is the name of Valve's marketplace where players can buy and sell in-game items?", {"Steam Community Market", "Steam Item Exchange", "Valve Marketplace", "Steam Trade Hub"})
steamHard:Add("Which Valve game popularised the concept of item drops and crafting on Steam?", {"Team Fortress 2", "Counter-Strike: GO", "Dota 2", "Left 4 Dead"})
steamHard:Add("What does 'Greenlight' refer to in Steam's history?", {"A former system where the community voted to approve indie games", "An old sales event", "A Valve internal testing program", "Steam's first launcher name"})
steamHard:Add("What is the Steam Deck?", {"A handheld gaming PC by Valve that runs Steam", "A Valve console for TVs", "A Steam-branded controller", "A VR headset by Valve"}, 2)

-- LEGO (easy)
local legoEasy = categoryManager.New("LEGO", "easy")
legoEasy:Add("What country is LEGO originally from?", {"Denmark", "Germany", "Sweden", "Netherlands"})
legoEasy:Add("What does the name LEGO come from?", {"'leg godt' meaning 'play well' in Danish", "The founder's last name", "An acronym for building materials", "A Latin word for blocks"})
legoEasy:Add("What is the name of LEGO's city-themed product line?", {"LEGO City", "LEGO Town", "LEGO Metro", "LEGO World"})
legoEasy:Add("What popular LEGO theme features wizards, dragons and kingdoms?", {"LEGO Castle", "LEGO Fantasy", "LEGO Kingdom", "LEGO Legends"})
legoEasy:Add("Which LEGO theme is set in space and features futuristic vehicles?", {"LEGO Space / Classic Space", "LEGO Galaxy", "LEGO Cosmos", "LEGO Starforce"}, 2)

-- LEGO (medium)
local legoMedium = categoryManager.New("LEGO", "medium")
legoMedium:Add("What year was LEGO founded?", {"1932", "1945", "1958", "1920"})
legoMedium:Add("What is the name of LEGO's robotic building and programming theme?", {"LEGO Mindstorms", "LEGO Technic Pro", "LEGO Robotics", "LEGO Code"})
legoMedium:Add("What is LEGO Technic focused on?", {"Complex mechanical and engineering builds", "City scenes", "Fantasy worlds", "Minifigure collecting"})
legoMedium:Add("Which LEGO theme is based on a popular Nickelodeon cartoon?", {"LEGO Ninjago", "LEGO Heroes", "LEGO Warriors", "LEGO Blaze"})
legoMedium:Add("What is the name of the small LEGO figures included in most sets?", {"Minifigures", "Microfigs", "Brickmen", "Legomen"}, 2)

-- LEGO (hard)
local legoHard = categoryManager.New("LEGO", "hard")
legoHard:Add("How many standard LEGO brick combinations are possible with just 6 standard 2x4 bricks?", {"915 million", "12 million", "6 billion", "100 thousand"})
legoHard:Add("What is the name of LEGO's adult-focused premium line of complex sets?", {"LEGO Icons / Creator Expert", "LEGO Pro", "LEGO Master", "LEGO Elite"})
legoHard:Add("What material are standard LEGO bricks made from?", {"ABS plastic", "Polypropylene", "Nylon", "PVC"})
legoHard:Add("Which LEGO theme was controversially discontinued after pressure about stereotyping?", {"LEGO Belville (later Friends predecessor)", "LEGO Pirates", "LEGO Western", "LEGO Aquazone"}, 2)
legoHard:Add("What is the brick tolerance (precision) of a LEGO brick in manufacturing?", {"2 micrometres", "0.5 millimetres", "10 micrometres", "1 millimetre"})

-- Screens and Displays (easy)
local screensEasy = categoryManager.New("Screens and Displays", "easy")
screensEasy:Add("What does LED stand for?", {"Light Emitting Diode", "Liquid Electronic Display", "Low Energy Display", "Layered Emission Device"})
screensEasy:Add("What does Hz (Hertz) measure on a monitor?", {"Refresh rate — how many times per second the image updates", "Screen brightness", "Pixel density", "Response time"})
screensEasy:Add("What is 4K resolution approximately equal to?", {"3840 x 2160 pixels", "1920 x 1080 pixels", "2560 x 1440 pixels", "7680 x 4320 pixels"})
screensEasy:Add("What does HDMI stand for?", {"High-Definition Multimedia Interface", "High Display Media Input", "Hybrid Digital Media Interface", "High-Definition Monitor Input"})
screensEasy:Add("What panel type is known for the most accurate colours, popular with designers?", {"IPS", "TN", "VA", "OLED"}, 2)

-- Screens and Displays (medium)
local screensMedium = categoryManager.New("Screens and Displays", "medium")
screensMedium:Add("What does OLED stand for?", {"Organic Light Emitting Diode", "Optical LED", "Omni Layer Emitting Display", "Outer Light Emitting Device"})
screensMedium:Add("What is the main advantage of a TN panel over IPS?", {"Faster response times", "Better colour accuracy", "Wider viewing angles", "Higher brightness"})
screensMedium:Add("What does 'response time' measure on a gaming monitor?", {"How fast a pixel changes colour, measured in milliseconds", "How fast the GPU renders frames", "The delay between input and screen update", "The brightness adjustment speed"})
screensMedium:Add("What is 'screen tearing'?", {"When frames from different render cycles appear on screen at once", "A physical crack in the display", "Pixels displaying the wrong colour", "A flicker caused by low brightness"})
screensMedium:Add("What technology eliminates screen tearing by syncing the monitor to the GPU's frame rate?", {"G-Sync / FreeSync (Adaptive Sync)", "VSync only", "HDR", "Anti-aliasing"}, 2)

-- Screens and Displays (hard)
local screensHard = categoryManager.New("Screens and Displays", "hard")
screensHard:Add("What does PPI stand for in display specs?", {"Pixels Per Inch", "Peak Picture Intensity", "Panel Pixel Index", "Pixel Pitch Index"})
screensHard:Add("What is 'burn-in' associated with?", {"OLED displays where static images leave a permanent ghost", "LCD panels overheating", "High brightness causing screen yellowing", "TN panels degrading colour"})
screensHard:Add("What does HDR stand for in displays?", {"High Dynamic Range", "High Definition Resolution", "Hybrid Display Rendering", "High Density Refresh"})
screensHard:Add("What is the difference between 144Hz and 240Hz monitors in terms of frame time?", {"144Hz = ~6.9ms per frame, 240Hz = ~4.2ms per frame", "They are essentially identical", "144Hz = 10ms, 240Hz = 8ms", "240Hz doubles the resolution"}, 2)
screensHard:Add("What display technology does the Apple Pro Display XDR use?", {"IPS LCD with local dimming", "OLED", "Mini-LED", "Micro-LED"})

-- Hardware Evolution (easy)
local hardwareEvoEasy = categoryManager.New("Hardware Evolution", "easy")
hardwareEvoEasy:Add("What was the name of the first widely-used personal computer from Apple?", {"Apple II", "Apple I", "Macintosh", "Apple Lisa"})
hardwareEvoEasy:Add("What does CPU stand for?", {"Central Processing Unit", "Core Processing Unit", "Computer Power Unit", "Central Program Utility"})
hardwareEvoEasy:Add("What replaced floppy disks as the main portable storage medium?", {"CD-ROMs", "Hard drives", "USB flash drives", "Zip disks"})
hardwareEvoEasy:Add("What does RAM stand for?", {"Random Access Memory", "Read Access Memory", "Rapid Access Module", "Remote Access Memory"})
hardwareEvoEasy:Add("What company produced the first commercially successful hard disk drive in 1956?", {"IBM", "Seagate", "Western Digital", "Hitachi"}, 2)

-- Hardware Evolution (medium)
local hardwareEvoMedium = categoryManager.New("Hardware Evolution", "medium")
hardwareEvoMedium:Add("What was Moore's Law?", {"The observation that transistor count doubles roughly every 2 years", "A law requiring computer parts to be standardised", "The rule that CPU speeds double every year", "A prediction that storage costs halve every 5 years"})
hardwareEvoMedium:Add("What replaced CRT monitors as the dominant display technology?", {"LCD (Liquid Crystal Display)", "OLED", "Plasma", "LED"})
hardwareEvoMedium:Add("What storage technology largely replaced mechanical hard drives in laptops during the 2010s?", {"SSD (Solid State Drive)", "Hybrid drives", "eMMC storage", "NVMe cards"})
hardwareEvoMedium:Add("What was the significance of the Intel 4004, released in 1971?", {"It was the first commercially available microprocessor", "It was the first 64-bit CPU", "It introduced multi-core processing", "It was the first CPU to exceed 1GHz"})
hardwareEvoMedium:Add("What interface replaced PCI for connecting graphics cards in the mid-2000s?", {"PCIe (PCI Express)", "AGP", "ISA", "SATA"}, 2)

-- Hardware Evolution (hard)
local hardwareEvoHard = categoryManager.New("Hardware Evolution", "hard")
hardwareEvoHard:Add("What was the clock speed of the original IBM PC's Intel 8088 processor in 1981?", {"4.77 MHz", "1 MHz", "16 MHz", "33 MHz"})
hardwareEvoHard:Add("What year did USB (Universal Serial Bus) version 1.0 first launch?", {"1996", "1992", "2000", "1998"})
hardwareEvoHard:Add("What is the difference between DDR4 and DDR5 RAM?", {"DDR5 has higher bandwidth, lower voltage, and on-die ECC", "DDR5 is physically smaller", "DDR4 is faster in latency", "They are pin-compatible"})
hardwareEvoHard:Add("What was the name of IBM's early magnetic storage used before hard drives, which could hold around 80KB?", {"Floppy disk (8-inch)", "Punched card", "Magnetic drum", "Paper tape"}, 2)
hardwareEvoHard:Add("What node size (in nanometres) did TSMC's most advanced process reach by 2023?", {"3nm", "5nm", "7nm", "2nm"})

-- ===================== NEW CATEGORIES BATCH 4 =====================

-- Pokémon (easy)
local pokemonEasy = categoryManager.New("Pokemon", "easy")
pokemonEasy:Add("What type is Pikachu?", {"Electric", "Fire", "Water", "Normal"})
pokemonEasy:Add("What is the first Pokémon in the National Pokédex?", {"Bulbasaur", "Charmander", "Squirtle", "Caterpie"})
pokemonEasy:Add("What do you throw to catch a Pokémon?", {"Poké Ball", "Monster Ball", "Capture Ball", "Trainer Ball"})
pokemonEasy:Add("What is the name of Ash's first Pokémon?", {"Pikachu", "Bulbasaur", "Charizard", "Squirtle"})
pokemonEasy:Add("How many original starter Pokémon were there in Generation 1?", {"3", "2", "4", "6"}, 2)

-- Pokémon (medium)
local pokemonMedium = categoryManager.New("Pokemon", "medium")
pokemonMedium:Add("What type is super effective against Water?", {"Electric", "Fire", "Ice", "Grass"})
pokemonMedium:Add("What is the evolved form of Magikarp?", {"Gyarados", "Lapras", "Vaporeon", "Dragonair"})
pokemonMedium:Add("Which Pokémon game introduced breeding?", {"Gold and Silver", "Red and Blue", "Ruby and Sapphire", "Diamond and Pearl"})
pokemonMedium:Add("What is the name of the villainous team in Pokémon Red and Blue?", {"Team Rocket", "Team Magma", "Team Galactic", "Team Skull"})
pokemonMedium:Add("What two types make up Charizard?", {"Fire and Flying", "Fire and Dragon", "Fire and Normal", "Dragon and Flying"}, 2)

-- Pokémon (hard)
local pokemonHard = categoryManager.New("Pokemon", "hard")
pokemonHard:Add("What is the only Pokémon with the Pure Flying type?", {"Tornadus", "Pidgey", "Flygon", "Hawlucha"})
pokemonHard:Add("How many Pokémon were in the original Generation 1 Pokédex?", {"151", "150", "152", "149"})
pokemonHard:Add("What is the base stat total of a standard (non-mega, non-primal) Mewtwo?", {"680", "600", "720", "660"})
pokemonHard:Add("What is the base stat total of Arceus?", {"720", "680", "700", "750"}, 2)
pokemonHard:Add("Which Pokémon has the highest base Speed stat in the main series games?", {"Regieleki", "Deoxys-Speed", "Ninjask", "Electrode"})

-- Roblox Games (easy)
local robloxGamesEasy = categoryManager.New("Roblox Games", "easy")
robloxGamesEasy:Add("What Roblox game has you adopting and raising virtual pets?", {"Adopt Me!", "Pet Simulator", "Animal Crossing RB", "Pets World"})
robloxGamesEasy:Add("In Blox Fruits, what are the main collectible power-ups called?", {"Devil Fruits / Blox Fruits", "Magic Orbs", "Power Stones", "Skill Gems"})
robloxGamesEasy:Add("What is the goal in Tower of Hell?", {"Climb to the top of an obby tower without checkpoints", "Defend your tower from enemies", "Build the tallest tower", "Escape a falling tower"})
robloxGamesEasy:Add("What game on Roblox involves buying and selling virtual items to get rich?", {"Islands / Skyblock", "Work at a Pizza Place", "Retail Tycoon", "Shop Simulator"})
robloxGamesEasy:Add("Which Roblox game has you surviving waves of zombies with other players?", {"Zombie Attack", "Arsenal", "Survive the Disaster", "Piggy"}, 2)

-- Roblox Games (medium)
local robloxGamesMedium = categoryManager.New("Roblox Games", "medium")
robloxGamesMedium:Add("What Roblox game is a murder mystery where one player is the murderer?", {"Murder Mystery 2", "Guilty Party", "Killer Hunt", "Among Us RB"})
robloxGamesMedium:Add("In Arsenal, what do you need to do to win a round?", {"Get a kill with every weapon including the knife last", "Have the most kills", "Be the last player alive", "Reach 50 kills first"})
robloxGamesMedium:Add("What is the Roblox obstacle course genre commonly called?", {"Obby", "Parkour", "Challenge Map", "Run Game"})
robloxGamesMedium:Add("What Roblox game is based on the Piggy book series and involves escaping a pig?", {"Piggy", "Bacon Hunt", "Escape Simulator", "Granny RB"})
robloxGamesMedium:Add("What is the name of the Roblox battle royale game inspired by Kaiju films?", {"Kaiju Universe", "Monster Royale", "Giant Battles", "Titan Wars"}, 2)

-- Roblox Games (hard)
local robloxGamesHard = categoryManager.New("Roblox Games", "hard")
robloxGamesHard:Add("What was the first Roblox game to reach 1 billion visits?", {"MeepCity", "Adopt Me!", "Work at a Pizza Place", "Natural Disaster Survival"})
robloxGamesHard:Add("In Jailbreak, what are the two teams players can choose?", {"Criminals and Police", "Robbers and Guards", "Inmates and Officers", "Fugitives and Cops"})
robloxGamesHard:Add("What is the name of the developer of Adopt Me!?", {"Uplift Games", "Badimo", "Minitoon", "Nefty"})
robloxGamesHard:Add("Who developed Jailbreak on Roblox?", {"Badimo (asimo3089 and badcc)", "Uplift Games", "Minitoon", "StyLiS Studios"}, 2)
robloxGamesHard:Add("What Roblox FPS game is developed by StyLiS Studios?", {"Phantom Forces", "Arsenal", "Counter Blox", "Frontlines"})

-- Social Media (easy)
local socialMediaEasy = categoryManager.New("Social Media", "easy")
socialMediaEasy:Add("What social media platform is known for short videos up to 60 seconds?", {"TikTok", "Snapchat", "Instagram", "Twitter"})
socialMediaEasy:Add("What is the name of a post shared on Twitter / X?", {"Tweet", "Post", "Snap", "Story"})
socialMediaEasy:Add("What does 'DM' stand for on social media?", {"Direct Message", "Daily Message", "Digital Media", "Display Mode"})
socialMediaEasy:Add("Which platform lets you share photos and reels with followers?", {"Instagram", "LinkedIn", "Pinterest", "Reddit"})
socialMediaEasy:Add("What colour is the YouTube logo?", {"Red and white", "Blue and white", "Black and red", "Red and black"}, 2)

-- Social Media (medium)
local socialMediaMedium = categoryManager.New("Social Media", "medium")
socialMediaMedium:Add("What year was Instagram launched?", {"2010", "2012", "2008", "2014"})
socialMediaMedium:Add("What platform is primarily used for professional networking?", {"LinkedIn", "Twitter", "Facebook", "Reddit"})
socialMediaMedium:Add("What does the Snapchat 'streak' feature track?", {"Consecutive days two users have snapped each other", "How many snaps you've sent total", "Daily active logins", "Messages sent in 24 hours"})
socialMediaMedium:Add("What is a 'ratio' on Twitter / X?", {"When replies outnumber likes, indicating backlash", "When retweets outnumber replies", "A metric for follower growth", "A feature to compare two accounts"})
socialMediaMedium:Add("What does 'going viral' mean on social media?", {"Content spreading rapidly to a very large audience", "Getting verified", "Reaching 1 million followers", "Trending in a specific country"}, 2)

-- Social Media (hard)
local socialMediaHard = categoryManager.New("Social Media", "hard")
socialMediaHard:Add("What year was Twitter (now X) founded?", {"2006", "2004", "2008", "2010"})
socialMediaHard:Add("Who co-founded Facebook alongside Mark Zuckerberg?", {"Eduardo Saverin, Andrew McCollum, Dustin Moskovitz, Chris Hughes", "Jack Dorsey and Evan Spiegel", "Larry Page and Sergey Brin", "Reid Hoffman and Peter Thiel"})
socialMediaHard:Add("What is the character limit for a standard post on Twitter / X?", {"280", "140", "300", "500"})
socialMediaHard:Add("What company owns Instagram and WhatsApp?", {"Meta (formerly Facebook)", "Google", "ByteDance", "Snap Inc."}, 2)
socialMediaHard:Add("What algorithm-driven feed feature did Facebook introduce in 2006 that caused major controversy?", {"News Feed", "Stories", "Reels", "Timeline"})

-- Marvel (easy)
local marvelEasy = categoryManager.New("Marvel", "easy")
marvelEasy:Add("What is the real name of Iron Man?", {"Tony Stark", "Steve Rogers", "Bruce Banner", "Peter Parker"})
marvelEasy:Add("What is the name of Thor's hammer?", {"Mjolnir", "Gungnir", "Stormbreaker", "Excalibur"})
marvelEasy:Add("What colour is the Hulk?", {"Green", "Grey", "Blue", "Purple"})
marvelEasy:Add("What is the name of Spider-Man's alter ego?", {"Peter Parker", "Miles Morales", "Ben Parker", "Flash Thompson"})
marvelEasy:Add("What stone gives Thanos the power to control minds in Avengers: Infinity War?", {"Mind Stone", "Soul Stone", "Reality Stone", "Power Stone"}, 2)

-- Marvel (medium)
local marvelMedium = categoryManager.New("Marvel", "medium")
marvelMedium:Add("What is the name of the fictional metal that Captain America's shield is made of?", {"Vibranium", "Adamantium", "Titanium", "Carbonadium"})
marvelMedium:Add("Which MCU film was the first to feature Black Panther?", {"Captain America: Civil War", "Black Panther", "Avengers: Infinity War", "Avengers: Age of Ultron"})
marvelMedium:Add("What is the name of Thor's home world?", {"Asgard", "Midgard", "Jotunheim", "Valhalla"})
marvelMedium:Add("What organisation does Nick Fury lead?", {"S.H.I.E.L.D.", "Hydra", "The Ten Rings", "Wakanda Intelligence"})
marvelMedium:Add("What is the real name of the villain Thanos is from?", {"Titan", "Xandar", "Sakaar", "Ego"}, 2)

-- Marvel (hard)
local marvelHard = categoryManager.New("Marvel", "hard")
marvelHard:Add("What year did the first Iron Man MCU film release?", {"2008", "2010", "2006", "2012"})
marvelHard:Add("Which Infinity Stone was hidden on Vormir?", {"Soul Stone", "Mind Stone", "Time Stone", "Space Stone"})
marvelHard:Add("What is the name of the organisation that was secretly infiltrating S.H.I.E.L.D.?", {"Hydra", "A.I.M.", "The Ten Rings", "Roxxon"})
marvelHard:Add("Which mutant's skeleton is coated in adamantium in the X-Men series?", {"Wolverine", "Magneto", "Colossus", "Cable"}, 2)
marvelHard:Add("What is the real name of the character known as War Machine?", {"James Rhodes", "Sam Wilson", "Bucky Barnes", "Scott Lang"})

-- Olympic Games (easy)
local olympicsEasy = categoryManager.New("Olympic Games", "easy")
olympicsEasy:Add("How many rings are on the Olympic flag?", {"5", "4", "6", "7"})
olympicsEasy:Add("How often are the Summer Olympic Games held?", {"Every 4 years", "Every 2 years", "Every 3 years", "Every 5 years"})
olympicsEasy:Add("What is the highest medal awarded at the Olympics?", {"Gold", "Platinum", "Silver", "Diamond"})
olympicsEasy:Add("What city hosted the first modern Olympic Games in 1896?", {"Athens", "Paris", "London", "Rome"})
olympicsEasy:Add("What do athletes carry during the Olympic opening ceremony?", {"Their country's flag", "A torch", "A banner", "A trophy"}, 2)

-- Olympic Games (medium)
local olympicsMedium = categoryManager.New("Olympic Games", "medium")
olympicsMedium:Add("What country has won the most Olympic gold medals in history?", {"USA", "Russia / Soviet Union", "China", "Germany"})
olympicsMedium:Add("What year did the Olympic Games return to Athens for the Summer Olympics?", {"2004", "1996", "2000", "2008"})
olympicsMedium:Add("Which sport was added to the Olympics for the first time at Tokyo 2020?", {"Skateboarding", "Surfing", "Sport Climbing", "All of these"})
olympicsMedium:Add("Where does the Olympic torch lighting ceremony take place before every Games?", {"Olympia, Greece", "Athens", "Mount Olympus", "Rome"})
olympicsMedium:Add("Who lit the Olympic cauldron at the 1996 Atlanta Games in a surprise appearance?", {"Muhammad Ali", "Michael Jordan", "Carl Lewis", "Jesse Owens"}, 2)

-- Olympic Games (hard)
local olympicsHard = categoryManager.New("Olympic Games", "hard")
olympicsHard:Add("Which country boycotted the 1980 Moscow Olympics?", {"USA and about 65 other nations", "Only the USA", "China and Japan", "West Germany only"})
olympicsHard:Add("Who holds the record for the most Olympic gold medals ever?", {"Michael Phelps", "Usain Bolt", "Larisa Latynina", "Carl Lewis"})
olympicsHard:Add("What year were women first allowed to compete in the Olympic Games?", {"1900", "1896", "1912", "1924"})
olympicsHard:Add("What is the Olympic motto in Latin?", {"Citius, Altius, Fortius", "Faster, Higher, Stronger", "Pro Patria et Gloria", "Mens Sana in Corpore Sano"}, 2)
olympicsHard:Add("In what city will the 2028 Summer Olympics be held?", {"Los Angeles", "Brisbane", "Paris", "Tokyo"})
end -- chunk 4

-- ===================== NEW CATEGORIES BATCH 5 =====================
do -- chunk 5

-- DC Comics
local dcEasy = categoryManager.New("DC Comics", "easy")
dcEasy:Add("What is Batman's real name?", {"Bruce Wayne", "Clark Kent", "Barry Allen", "Hal Jordan"})
dcEasy:Add("What city does Superman protect?", {"Metropolis", "Gotham", "Central City", "Star City"})
dcEasy:Add("What is Wonder Woman's home island called?", {"Themyscira", "Asgard", "Elysium", "Olympus"})
dcEasy:Add("What is the name of Batman's butler?", {"Alfred", "James", "Edward", "Winston"})
dcEasy:Add("What planet is Superman from?", {"Krypton", "Oa", "Tamaran", "Apokolips"})

local dcMedium = categoryManager.New("DC Comics", "medium")
dcMedium:Add("What is The Flash's real name (Barry Allen's predecessor)?", {"Jay Garrick", "Wally West", "Bart Allen", "Jesse Quick"})
dcMedium:Add("What substance is Superman's main weakness?", {"Kryptonite", "Magic", "Red Sun radiation", "Gold"})
dcMedium:Add("Who is the main villain of Aquaman?", {"Ocean Master", "Black Manta", "The Trench", "Mera"})
dcMedium:Add("What is the Green Lantern's power source?", {"Willpower", "Fear", "Hope", "Love"}, 2)
dcMedium:Add("What team do Batman, Superman and Wonder Woman belong to?", {"Justice League", "Avengers", "Teen Titans", "Suicide Squad"})

local dcHard = categoryManager.New("DC Comics", "hard")
dcHard:Add("What is the real name of the original Green Lantern (Golden Age)?", {"Alan Scott", "Hal Jordan", "John Stewart", "Kyle Rayner"})
dcHard:Add("Which villain created the Anti-Life Equation?", {"Darkseid", "Brainiac", "Lex Luthor", "Sinestro"})
dcHard:Add("Who was the first Robin?", {"Dick Grayson", "Jason Todd", "Tim Drake", "Damian Wayne"})
dcHard:Add("What does STAR Labs stand for?", {"Scientific and Technological Advanced Research", "Space Technology and Research", "Super Tactical Armed Response", "Science Technology and Robotics"}, 2)
dcHard:Add("What is the name of the Speed Force entity that Barry Allen becomes?", {"The Flash", "Reverse-Flash", "Black Flash", "Zoom"})

-- Harry Potter
local hpEasy = categoryManager.New("Harry Potter", "easy")
hpEasy:Add("What school does Harry Potter attend?", {"Hogwarts", "Durmstrang", "Beauxbatons", "Ilvermorny"})
hpEasy:Add("What is Harry Potter's owl called?", {"Hedwig", "Errol", "Pigwidgeon", "Fawkes"})
hpEasy:Add("What house is Harry Potter sorted into?", {"Gryffindor", "Slytherin", "Ravenclaw", "Hufflepuff"})
hpEasy:Add("What sport do wizards play on broomsticks?", {"Quidditch", "Bludgeball", "Seekball", "Broomball"})
hpEasy:Add("What is Voldemort's real name?", {"Tom Riddle", "Marvolo Gaunt", "Salazar Slytherin", "Gellert Grindelwald"})

local hpMedium = categoryManager.New("Harry Potter", "medium")
hpMedium:Add("What charm produces a protective Patronus?", {"Expecto Patronum", "Expelliarmus", "Lumos", "Protego"})
hpMedium:Add("Who is the Half-Blood Prince?", {"Severus Snape", "Tom Riddle", "Albus Dumbledore", "Sirius Black"})
hpMedium:Add("What is the name of the wizarding bank?", {"Gringotts", "Galleon Bank", "Vault and Wand", "Nimbus Trust"})
hpMedium:Add("How many Horcruxes did Voldemort make?", {"7", "6", "8", "5"}, 2)
hpMedium:Add("What magical creature guards Azkaban prison?", {"Dementors", "Boggarts", "Inferi", "Acromantulas"})

local hpHard = categoryManager.New("Harry Potter", "hard")
hpHard:Add("What is the incantation for the Killing Curse?", {"Avada Kedavra", "Crucio", "Imperio", "Sectumsempra"})
hpHard:Add("Which Hogwarts founder's symbol is the eagle?", {"Rowena Ravenclaw", "Helga Hufflepuff", "Godric Gryffindor", "Salazar Slytherin"})
hpHard:Add("In which vault is the Philosopher's Stone kept at Gringotts?", {"Vault 713", "Vault 317", "Vault 7", "Vault 131"})
hpHard:Add("What is Dumbledore's full name?", {"Albus Percival Wulfric Brian Dumbledore", "Albus Reginald Brian Dumbledore", "Albus Percival Merlin Dumbledore", "Albus Godric Brian Dumbledore"}, 2)
hpHard:Add("What spell did Snape make with Narcissa Malfoy in book 6, binding him to protect Draco?", {"Unbreakable Vow", "Fidelius Charm", "Sectumsempra", "Priori Incantatem"})

-- Star Wars
local swEasy = categoryManager.New("Star Wars", "easy")
swEasy:Add("What is the name of Han Solo's ship?", {"Millennium Falcon", "Star Destroyer", "X-Wing", "TIE Fighter"})
swEasy:Add("Who is Luke Skywalker's father?", {"Darth Vader", "Obi-Wan Kenobi", "Palpatine", "Yoda"})
swEasy:Add("What is the name of the forest moon in Return of the Jedi?", {"Endor", "Dagobah", "Yavin", "Hoth"})
swEasy:Add("What colour is Darth Vader's lightsaber?", {"Red", "Blue", "Green", "Purple"})
swEasy:Add("What colour is Yoda's lightsaber?", {"Green", "Blue", "Purple", "Yellow"})

local swMedium = categoryManager.New("Star Wars", "medium")
swMedium:Add("What planet is Luke Skywalker from?", {"Tatooine", "Alderaan", "Naboo", "Coruscant"})
swMedium:Add("What is the Clone Army created from?", {"Jango Fett's DNA", "Han Solo's DNA", "Palpatine's DNA", "Count Dooku's DNA"})
swMedium:Add("What organization do the Jedi serve?", {"Galactic Republic", "Galactic Empire", "Rebel Alliance", "First Order"})
swMedium:Add("Who trained Obi-Wan Kenobi?", {"Qui-Gon Jinn", "Yoda", "Mace Windu", "Count Dooku"})
swMedium:Add("What order wiped out the Jedi?", {"Order 66", "Order 99", "Order 13", "Order 33"})

local swHard = categoryManager.New("Star Wars", "hard")
swHard:Add("What is the Sith Rule of Two?", {"One master and one apprentice", "Two Sith lords per galaxy", "Two lightsabers per Sith", "Sith travel in pairs always"})
swHard:Add("What planet is Emperor Palpatine from?", {"Naboo", "Coruscant", "Mustafar", "Exegol"})
swHard:Add("What is the name of Boba Fett's ship?", {"Slave I / Firespray", "Millennium Falcon", "Razor Crest", "Havoc Marauder"})
swHard:Add("Which midi-chlorian count was higher than any Jedi on record?", {"Anakin Skywalker", "Yoda", "Obi-Wan Kenobi", "Mace Windu"}, 2)
swHard:Add("What is the name of the Mandalorian's ship?", {"Razor Crest", "Slave I", "Gauntlet", "Marauder"})

-- Geography (Hard 3)
local geographyHard3 = categoryManager.New("Geography", "hard")
geographyHard3:Add("What is the smallest country in the world by area?", {"Vatican City", "Monaco", "San Marino", "Liechtenstein"})
geographyHard3:Add("What country has the most time zones?", {"France", "Russia", "USA", "China"})
geographyHard3:Add("What is the highest mountain in Africa?", {"Mount Kilimanjaro", "Mount Kenya", "Rwenzori", "Mount Meru"})
geographyHard3:Add("What is the longest river in the world?", {"Nile", "Amazon", "Yangtze", "Mississippi"})
geographyHard3:Add("Which ocean is the largest?", {"Pacific", "Atlantic", "Indian", "Arctic"})

-- Science (Hard 2)
local scienceHard2 = categoryManager.New("Science", "hard")
scienceHard2:Add("What particle has no electric charge in an atom's nucleus?", {"Neutron", "Proton", "Electron", "Positron"})
scienceHard2:Add("What law states that energy cannot be created or destroyed?", {"Conservation of Energy", "Newton's First Law", "Boyle's Law", "Ohm's Law"})
scienceHard2:Add("What is the powerhouse of the cell?", {"Mitochondria", "Nucleus", "Ribosome", "Golgi Apparatus"})
scienceHard2:Add("What is the most abundant gas in Earth's atmosphere?", {"Nitrogen", "Oxygen", "Carbon Dioxide", "Argon"})
scienceHard2:Add("What is the speed of light in a vacuum (approx km/s)?", {"299,792", "300,500", "186,000", "150,000"}, 2)

-- Music (Easy 2)
local musicEasy2 = categoryManager.New("Music", "easy")
musicEasy2:Add("Which band sang 'Bohemian Rhapsody'?", {"Queen", "The Beatles", "Led Zeppelin", "Pink Floyd"})
musicEasy2:Add("What instrument has 88 keys?", {"Piano", "Organ", "Accordion", "Synthesizer"})
musicEasy2:Add("Who is known as the 'King of Pop'?", {"Michael Jackson", "Elvis Presley", "Prince", "Justin Timberlake"})
musicEasy2:Add("What does BPM stand for in music?", {"Beats Per Minute", "Bass Per Measure", "Bars Per Minute", "Beat Pattern Metric"})
musicEasy2:Add("How many strings does a standard guitar have?", {"6", "4", "7", "12"})

-- Animals (Medium)
local animalsMedium = categoryManager.New("Animals", "medium")
animalsMedium:Add("What is a group of wolves called?", {"Pack", "Herd", "Pride", "Colony"})
animalsMedium:Add("What is the fastest land animal?", {"Cheetah", "Greyhound", "Peregrine Falcon", "Pronghorn"})
animalsMedium:Add("How many hearts does an octopus have?", {"3", "1", "2", "4"})
animalsMedium:Add("What animal has the longest lifespan?", {"Greenland Shark", "Tortoise", "Bowhead Whale", "Koi Fish"}, 2)
animalsMedium:Add("What is the only mammal capable of sustained flight?", {"Bat", "Flying Squirrel", "Sugar Glider", "Colugo"})

-- Animals (Hard)
local animalsHard = categoryManager.New("Animals", "hard")
animalsHard:Add("What is the binomial name for humans?", {"Homo sapiens", "Homo erectus", "Pan troglodytes", "Homo habilis"})
animalsHard:Add("What is the gestation period of an elephant in months?", {"22", "12", "18", "9"}, 2)
animalsHard:Add("What is a group of flamingos called?", {"Flamboyance", "Flock", "Colony", "Stand"})
animalsHard:Add("Which bird has the longest wingspan?", {"Wandering Albatross", "California Condor", "Andean Condor", "Marabou Stork"})
animalsHard:Add("What is the only venomous primate?", {"Slow Loris", "Aye-Aye", "Tarsier", "Pygmy Marmoset"})

-- History (Easy)
local historyEasy = categoryManager.New("History", "easy")
historyEasy:Add("Who was the first President of the United States?", {"George Washington", "Abraham Lincoln", "Thomas Jefferson", "John Adams"})
historyEasy:Add("In what year did World War II end?", {"1945", "1944", "1918", "1939"})
historyEasy:Add("Who invented the telephone?", {"Alexander Graham Bell", "Thomas Edison", "Nikola Tesla", "Guglielmo Marconi"})
historyEasy:Add("What ancient wonder was located in Alexandria?", {"The Lighthouse", "The Colossus", "The Hanging Gardens", "The Mausoleum"})
historyEasy:Add("Who was the first human to walk on the Moon?", {"Neil Armstrong", "Buzz Aldrin", "Yuri Gagarin", "Michael Collins"})

-- Space (Medium)
local spaceMedium = categoryManager.New("Space", "medium")
spaceMedium:Add("How many moons does Mars have?", {"2", "0", "1", "4"})
spaceMedium:Add("What is the name of NASA's telescope launched in 1990?", {"Hubble", "James Webb", "Spitzer", "Kepler"})
spaceMedium:Add("What planet has the Great Red Spot?", {"Jupiter", "Saturn", "Neptune", "Mars"})
spaceMedium:Add("What is the term for the point in orbit farthest from Earth?", {"Apogee", "Perigee", "Aphelion", "Perihelion"})
spaceMedium:Add("How long does light from the Sun take to reach Earth (minutes)?", {"8", "4", "16", "1"}, 2)

-- Food and Drink (Easy)
local foodEasy = categoryManager.New("Food and Drink", "easy")
foodEasy:Add("What fruit is known as the 'king of fruits' in Southeast Asia?", {"Durian", "Mango", "Jackfruit", "Papaya"})
foodEasy:Add("What country is sushi originally from?", {"Japan", "China", "Korea", "Thailand"})
foodEasy:Add("What is the main ingredient in guacamole?", {"Avocado", "Tomato", "Onion", "Lime"})
foodEasy:Add("What gas makes fizzy drinks bubbly?", {"Carbon Dioxide", "Oxygen", "Nitrogen", "Helium"})
foodEasy:Add("What type of pastry is used in a croissant?", {"Laminated dough", "Choux pastry", "Shortcrust pastry", "Filo pastry"})

-- Math (Medium)
local mathMedium = categoryManager.New("Math", "medium")
mathMedium:Add("What is the value of Pi to 2 decimal places?", {"3.14", "3.12", "3.16", "3.41"})
mathMedium:Add("What is 15% of 200?", {"30", "25", "35", "20"})
mathMedium:Add("What shape has exactly 8 sides?", {"Octagon", "Hexagon", "Heptagon", "Nonagon"})
mathMedium:Add("What is the square root of 144?", {"12", "11", "13", "14"}, 2)
mathMedium:Add("What is 7 squared?", {"49", "42", "56", "64"})

-- Guess the Flag (Medium)
local flagsMedium = categoryManager.New("Guess the Flag", "medium")
flagsMedium:Add("Which country's flag features a maple leaf?", {"Canada", "Australia", "New Zealand", "Ireland"})
flagsMedium:Add("What country has a dragon on its flag?", {"Wales", "China", "Bhutan", "Hungary"}, 2)
flagsMedium:Add("Which flag is known as the 'Union Jack'?", {"United Kingdom", "Australia", "New Zealand", "Canada"})
flagsMedium:Add("What color is the star on the Chinese flag?", {"Yellow", "Red", "White", "Gold"})
flagsMedium:Add("Which country has the only non-rectangular national flag?", {"Nepal", "Switzerland", "Vatican City", "Sri Lanka"})

-- Internet Slang (Hard)
local internetSlangHard = categoryManager.New("Internet Slang", "hard")
internetSlangHard:Add("What does 'IYKYK' mean?", {"If You Know You Know", "In Your Kind Yours Kindly", "I Yield Knowing Your Knowledge", "It's Your Kind Your Kindness"})
internetSlangHard:Add("What does 'ratio' mean on Twitter/X?", {"Reply count exceeds likes meaning bad take", "Likes beat retweets", "Getting blocked by many people", "Being heavily quote tweeted"})
internetSlangHard:Add("What is 'enshittification'?", {"Platform declining quality to extract more value", "Making an app uglier on purpose", "Banning users for spam", "Adding too many ads"})
internetSlangHard:Add("What does 'based' mean in internet slang?", {"Confident and unapologetic in your opinion", "Cringe or embarrassing", "Very funny", "Lying online"}, 2)
internetSlangHard:Add("What platform did 'NPC' live streamer trend originate on?", {"TikTok", "Twitch", "YouTube", "Instagram"})

-- Anime (Medium)
local animeMedium = categoryManager.New("Anime", "medium")
animeMedium:Add("What is the name of the giant humanoid creatures in Attack on Titan?", {"Titans", "Colossi", "Giants", "Shifters"})
animeMedium:Add("In Naruto, what is the nine-tailed fox called?", {"Kurama", "Gyuki", "Matatabi", "Shukaku"})
animeMedium:Add("What is the protagonist's name in Death Note?", {"Light Yagami", "L Lawliet", "Ryuk", "Near"})
animeMedium:Add("What show features a boy who wants to be a Hero but is born without powers?", {"My Hero Academia", "One Punch Man", "Bleach", "Black Clover"})
animeMedium:Add("What is the main power system in Jujutsu Kaisen called?", {"Cursed Energy", "Chakra", "Nen", "Reiatsu"}, 2)

-- Anime (Hard)
local animeHard = categoryManager.New("Anime", "hard")
animeHard:Add("What year did the first episode of Dragon Ball Z air?", {"1989", "1986", "1992", "1984"})
animeHard:Add("What is the name of the author of Fullmetal Alchemist?", {"Hiromu Arakawa", "Eiichiro Oda", "Masashi Kishimoto", "Tite Kubo"})
animeHard:Add("In One Piece, what is the name of the sea where the story begins?", {"East Blue", "West Blue", "North Blue", "Grand Line"})
animeHard:Add("What does 'Shonen' mean in anime context?", {"Young boy / aimed at teen boys", "Action genre", "Fantasy genre", "Young girl"}, 2)
animeHard:Add("In Hunter x Hunter, what are the 4 types of Nen called?", {"Ten, Zetsu, Ren, Hatsu", "Ten, Zetsu, Ken, Gyo", "Nen, Chi, Ki, Aura", "Hatsu, Ken, Gyo, Shu"})

end -- chunk 5

-- ===================== NEW CATEGORIES BATCH 6 =====================
do -- chunk 6

-- Operating Systems
local osEasy = categoryManager.New("Operating Systems", "easy")
osEasy:Add("What operating system does Apple use on its Mac computers?", {"macOS", "Windows", "Linux", "ChromeOS"})
osEasy:Add("What is the most popular desktop operating system in the world?", {"Windows", "macOS", "Linux", "ChromeOS"})
osEasy:Add("What mobile operating system is developed by Google?", {"Android", "iOS", "HarmonyOS", "KaiOS"})
osEasy:Add("What does OS stand for?", {"Operating System", "Open Software", "Output Service", "Optical Setup"})
osEasy:Add("What OS is the iPhone built on?", {"iOS", "Android", "Windows Mobile", "Symbian"})

local osMedium = categoryManager.New("Operating Systems", "medium")
osMedium:Add("Which Linux distribution is known for being beginner-friendly and Ubuntu-based?", {"Linux Mint", "Arch Linux", "Gentoo", "Fedora"})
osMedium:Add("What is the name of Windows' built-in package manager introduced in Windows 10?", {"winget", "apt", "brew", "choco"})
osMedium:Add("What year was Windows 95 released?", {"1995", "1993", "1997", "1991"})
osMedium:Add("What is the name of macOS's virtual desktop feature?", {"Spaces", "Mission Control", "Expose", "Launchpad"}, 2)
osMedium:Add("What is the default shell on most Linux distributions?", {"bash", "zsh", "fish", "sh"})

local osHard = categoryManager.New("Operating Systems", "hard")
osHard:Add("What is the name of the Windows NT kernel file?", {"ntoskrnl.exe", "kernel32.dll", "winboot.sys", "hal.dll"})
osHard:Add("What Linux command shows running processes in real time?", {"top", "ps", "ls", "htop"}, 2)
osHard:Add("What does POSIX stand for?", {"Portable Operating System Interface", "Portable Open Software Index", "Primary OS Interface Exchange", "Parallel Open System Interface"})
osHard:Add("What file system does macOS use by default since High Sierra?", {"APFS", "HFS+", "ext4", "NTFS"})
osHard:Add("What year was the Linux kernel first released by Linus Torvalds?", {"1991", "1989", "1994", "1987"})

-- Cars (Hard 2 - more specific)
local carsHard2 = categoryManager.New("Cars", "hard")
carsHard2:Add("What does the 'M' stand for in BMW M Series?", {"Motorsport", "Munich", "Modern", "Mechanical"})
carsHard2:Add("What is the displacement of a standard Dodge Viper V10 engine in litres?", {"8.4", "6.2", "7.0", "5.9"}, 2)
carsHard2:Add("What country manufactures Koenigsegg cars?", {"Sweden", "Italy", "Germany", "Denmark"})
carsHard2:Add("What does 'VTEC' stand for in Honda engines?", {"Variable Valve Timing and Lift Electronic Control", "Variable Turbo Engine Control", "Valve Timing Electronic Circuit", "Variable Tech Engine Controller"})
carsHard2:Add("What is the name of Ferrari's naturally aspirated V12 flagship model (2022)?", {"812 Superfast / Competizione", "SF90 Stradale", "Roma", "Purosangue"})

-- Cooking and Recipes
local cookingEasy = categoryManager.New("Cooking", "easy")
cookingEasy:Add("What temperature in Celsius is water considered boiling?", {"100", "90", "80", "120"})
cookingEasy:Add("What herb is pesto sauce primarily made from?", {"Basil", "Parsley", "Oregano", "Thyme"})
cookingEasy:Add("What does 'al dente' mean when cooking pasta?", {"Firm to the bite", "Fully soft", "Slightly raw", "Overcooked"})
cookingEasy:Add("What tool is used to zest a lemon?", {"Grater / Zester", "Peeler", "Knife", "Mandoline"})
cookingEasy:Add("What is the French term for a mixture of flour and butter used to thicken sauces?", {"Roux", "Bechamel", "Mirepoix", "Fond"})

local cookingMedium = categoryManager.New("Cooking", "medium")
cookingMedium:Add("What is the Maillard reaction?", {"Browning of food from heat and amino acids", "Caramelisation of sugar", "Emulsification of fat", "Fermentation of yeast"})
cookingMedium:Add("What cut of beef is used in a traditional beef Wellington?", {"Tenderloin / Fillet", "Ribeye", "Sirloin", "Brisket"})
cookingMedium:Add("What does 'sauté' mean?", {"Cook quickly in a small amount of fat", "Boil in water", "Bake in an oven", "Steam over water"})
cookingMedium:Add("What is the name of the Japanese cooking technique using a very hot iron plate?", {"Teppanyaki", "Teriyaki", "Yakitori", "Hibachi"}, 2)
cookingMedium:Add("What country does the dish 'Moussaka' originate from?", {"Greece", "Turkey", "Lebanon", "Egypt"})

-- Psychology
local psychEasy = categoryManager.New("Psychology", "easy")
psychEasy:Add("Who is considered the father of modern psychology?", {"Wilhelm Wundt", "Sigmund Freud", "Carl Jung", "William James"})
psychEasy:Add("What is the fear of spiders called?", {"Arachnophobia", "Claustrophobia", "Acrophobia", "Entomophobia"})
psychEasy:Add("What does IQ stand for?", {"Intelligence Quotient", "Intellectual Quality", "Intelligence Query", "Index of Quotient"})
psychEasy:Add("What is the term for seeing a face in random objects like clouds?", {"Pareidolia", "Apophenia", "Synesthesia", "Prosopagnosia"})
psychEasy:Add("What is Maslow famous for?", {"Hierarchy of Needs", "Classical Conditioning", "Cognitive Dissonance", "Operant Conditioning"})

local psychHard = categoryManager.New("Psychology", "hard")
psychHard:Add("What experiment showed people obey authority even to harmful ends?", {"Milgram Experiment", "Stanford Prison Experiment", "Asch Conformity", "Bobo Doll Experiment"})
psychHard:Add("What does 'cognitive dissonance' describe?", {"Discomfort from conflicting beliefs", "Memory loss after trauma", "Inability to focus", "Fear of social situations"})
psychHard:Add("What is the name of Pavlov's famous conditioning experiment subject?", {"A dog", "A cat", "A rat", "A child"})
psychHard:Add("What is the 'Dunning-Kruger Effect'?", {"Unskilled people overestimate their competence", "Experts underestimate others", "Smart people become lazy", "Bias towards familiar information"}, 2)
psychHard:Add("What term describes the tendency to seek information confirming your existing beliefs?", {"Confirmation Bias", "Anchoring Bias", "Halo Effect", "Sunk Cost Fallacy"})

-- Aviation
local aviationEasy = categoryManager.New("Aviation", "easy")
aviationEasy:Add("What does ATC stand for in aviation?", {"Air Traffic Control", "Automated Take-off Command", "Aircraft Thrust Calculator", "Airspace Traffic Center"})
aviationEasy:Add("What is the front of a plane called?", {"Nose", "Bow", "Stem", "Front"})
aviationEasy:Add("Who made the first powered airplane flight?", {"Wright Brothers", "Louis Bleriot", "Charles Lindbergh", "Amelia Earhart"})
aviationEasy:Add("What is the black box on a plane actually used for?", {"Flight data and voice recording", "Navigation", "Engine monitoring", "Weather tracking"})
aviationEasy:Add("What does ICAO stand for?", {"International Civil Aviation Organization", "International Control of Airspace Operations", "Inter-Country Air Operations", "International Commercial Aviation Office"})

local aviationHard = categoryManager.New("Aviation", "hard")
aviationHard:Add("What is the name of the speed of sound?", {"Mach 1", "Speed 1", "Sonic 1", "Apex 1"})
aviationHard:Add("What does 'V1' refer to in takeoff?", {"Decision speed - can no longer abort", "Rotation speed", "Liftoff speed", "Maximum takeoff speed"})
aviationHard:Add("What altitude is typically considered the boundary of space (Karman line)?", {"100km", "80km", "120km", "50km"})
aviationHard:Add("What is a 'coffin corner' in aviation?", {"Speed range where stall and overspeed nearly overlap", "The final approach path", "An aerobatic maneuver", "The tail section blind spot"}, 2)
aviationHard:Add("What is the ICAO code for London Heathrow Airport?", {"EGLL", "EGKK", "EGLC", "EGSS"})

-- Flags of the World (Easy - countries)
local flagsWorld = categoryManager.New("Flags of the World", "easy")
flagsWorld:Add("What color is the background of the Japanese flag?", {"White", "Red", "Blue", "Black"})
flagsWorld:Add("How many stripes are on the American flag?", {"13", "50", "10", "15"})
flagsWorld:Add("What is on the flag of Canada?", {"Maple leaf", "Eagle", "Dragon", "Sun"})
flagsWorld:Add("What colors are on the flag of Italy?", {"Green, white and red", "Red, white and blue", "Green, yellow and red", "Blue, white and red"})
flagsWorld:Add("What is in the top-left corner of the Australian flag?", {"Union Jack", "Federation Star", "Southern Cross", "Kangaroo"})

-- Crime and Law
local crimeEasy = categoryManager.New("Crime and Law", "easy")
crimeEasy:Add("What does 'innocent until proven guilty' describe?", {"Presumption of innocence", "The burden of proof", "Double jeopardy", "Habeas corpus"})
crimeEasy:Add("What is the term for killing someone unlawfully with intent?", {"Murder", "Manslaughter", "Homicide", "Assault"})
crimeEasy:Add("What does a judge wear in a British court?", {"A wig and gown", "A black robe only", "A suit", "A hood"})
crimeEasy:Add("What does 'Miranda Rights' refer to in US law?", {"Rights read when arrested", "Rights in court", "The right to a lawyer", "The right to remain silent only"})
crimeEasy:Add("What is 'perjury'?", {"Lying under oath", "Bribing a judge", "Stealing evidence", "Threatening a witness"})

local crimeHard = categoryManager.New("Crime and Law", "hard")
crimeHard:Add("What Latin term means 'the body of the crime' (physical evidence)?", {"Corpus delicti", "Habeas corpus", "Mens rea", "Actus reus"})
crimeHard:Add("What is 'mens rea'?", {"Criminal intent / guilty mind", "The physical act of a crime", "Evidence at the scene", "The victim's testimony"})
crimeHard:Add("What does 'double jeopardy' prevent?", {"Being tried twice for the same crime", "A mistrial being called", "Evidence being used twice", "Appealing a verdict"})
crimeHard:Add("What is the term for a court order to produce a person before a judge?", {"Habeas corpus", "Subpoena", "Injunction", "Affidavit"}, 2)
crimeHard:Add("What percentage of the jury must agree for a unanimous verdict in the US?", {"100%", "75%", "66%", "90%"})

-- Weather and Climate
local weatherEasy = categoryManager.New("Weather", "easy")
weatherEasy:Add("What instrument measures air pressure?", {"Barometer", "Thermometer", "Hygrometer", "Anemometer"})
weatherEasy:Add("What scale is used to measure hurricane intensity?", {"Saffir-Simpson", "Fujita", "Beaufort", "Richter"})
weatherEasy:Add("What is the name of a rotating column of air in contact with the ground?", {"Tornado", "Hurricane", "Cyclone", "Waterspout"})
weatherEasy:Add("What causes a rainbow?", {"Light refraction through water droplets", "Sunlight reflecting off clouds", "Light bending around mountains", "Static electricity in clouds"})
weatherEasy:Add("What is the term for water falling from clouds?", {"Precipitation", "Condensation", "Evaporation", "Transpiration"})

local weatherHard = categoryManager.New("Weather", "hard")
weatherHard:Add("What is the name of the global weather pattern caused by Pacific Ocean temperature changes?", {"El Nino / La Nina", "The Jet Stream", "The Hadley Cell", "Monsoon Cycle"})
weatherHard:Add("What does a hygrometer measure?", {"Humidity", "Wind speed", "Air pressure", "Rainfall"})
weatherHard:Add("What is the Coriolis effect?", {"Earth's rotation deflecting moving air and water", "Air pressure at high altitude", "Ocean current temperature shifts", "Wind speed increase near the equator"}, 2)
weatherHard:Add("What is a 'derecho'?", {"Fast-moving band of severe thunderstorms", "A tropical depression", "A coastal fog event", "A high altitude wind"})
weatherHard:Add("At what wind speed (mph) is a storm classified as a hurricane?", {"74", "64", "55", "80"})

-- Space (Hard 2)
local spaceHard3 = categoryManager.New("Space", "hard")
spaceHard3:Add("What is the name of the force that holds galaxies together but cannot be seen?", {"Dark matter", "Dark energy", "Gravity waves", "Quantum foam"})
spaceHard3:Add("How many light years away is the Andromeda Galaxy (approximately)?", {"2.5 million", "1 million", "10 million", "500,000"})
spaceHard3:Add("What is the Chandrasekhar limit?", {"Maximum mass of a white dwarf star", "Minimum size of a black hole", "Speed needed to escape a neutron star", "Energy output of a supernova"}, 2)
spaceHard3:Add("What planet rotates on its side with an axial tilt of 98 degrees?", {"Uranus", "Neptune", "Saturn", "Venus"})
spaceHard3:Add("What is the name of the boundary around a black hole beyond which nothing escapes?", {"Event horizon", "Schwarzschild radius", "Singularity", "Accretion disc"})

-- Music Theory
local musicTheory = categoryManager.New("Music Theory", "medium")
musicTheory:Add("How many semitones are in an octave?", {"12", "8", "10", "16"})
musicTheory:Add("What does 'forte' mean in music?", {"Loud", "Soft", "Fast", "Slow"})
musicTheory:Add("What is the time signature of a waltz?", {"3/4", "4/4", "6/8", "2/4"})
musicTheory:Add("What note value gets one beat in 4/4 time?", {"Quarter note", "Half note", "Whole note", "Eighth note"})
musicTheory:Add("What does 'legato' mean?", {"Smooth and connected", "Short and detached", "Loud and forceful", "Getting faster"}, 2)

local musicTheoryHard = categoryManager.New("Music Theory", "hard")
musicTheoryHard:Add("What is the interval between C and G called?", {"Perfect fifth", "Major third", "Minor seventh", "Perfect fourth"})
musicTheoryHard:Add("How many sharps are in the key of E major?", {"4", "3", "5", "2"})
musicTheoryHard:Add("What is an 'enharmonic equivalent'?", {"Same pitch with different names", "Two notes played together", "A chord inversion", "A scale with flat notes"}, 2)
musicTheoryHard:Add("What does 'rubato' mean?", {"Flexible tempo / expressive timing", "Very slow tempo", "Getting louder", "Repeat from the beginning"})
musicTheoryHard:Add("What is a 'tritone'?", {"An interval of 3 whole tones", "A chord with three notes", "A triple time signature", "Three simultaneous melodies"})

-- Philosophy
local philoEasy = categoryManager.New("Philosophy", "easy")
philoEasy:Add("Who said 'I think therefore I am'?", {"Rene Descartes", "Plato", "Aristotle", "Immanuel Kant"})
philoEasy:Add("What is Plato's allegory describing prisoners who only see shadows on a cave wall?", {"Allegory of the Cave", "The Ship of Theseus", "Plato's Republic", "The Divided Line"})
philoEasy:Add("What branch of philosophy deals with right and wrong?", {"Ethics", "Metaphysics", "Epistemology", "Aesthetics"})
philoEasy:Add("Who was Socrates' most famous student?", {"Plato", "Aristotle", "Pythagoras", "Epicurus"})
philoEasy:Add("What thought experiment asks if a ship with all replaced parts is still the same ship?", {"Ship of Theseus", "Schrodinger's Ship", "Plato's Boat", "Russell's Ship"})

local philoHard = categoryManager.New("Philosophy", "hard")
philoHard:Add("What is Kant's 'Categorical Imperative'?", {"Act only as you would will to be universal law", "Do what creates most happiness", "Follow nature's law", "Act based on self-interest"})
philoHard:Add("What does 'solipsism' mean?", {"Only one's own mind is certain to exist", "Nothing is real", "All knowledge comes from experience", "The world is an illusion"})
philoHard:Add("Who wrote 'Thus Spoke Zarathustra'?", {"Friedrich Nietzsche", "Arthur Schopenhauer", "Soren Kierkegaard", "Georg Hegel"})
philoHard:Add("What is the 'Trolley Problem' designed to test?", {"Moral decision-making under conflict", "Logical reasoning speed", "Emotional intelligence", "Risk assessment"}, 2)
philoHard:Add("What is 'Occam's Razor'?", {"The simplest explanation is usually correct", "Everything is predetermined", "Reality is subjective", "The ends justify the means"})

-- DIY and Tools
local diyEasy = categoryManager.New("DIY and Tools", "easy")
diyEasy:Add("What tool is used to drive screws?", {"Screwdriver", "Wrench", "Hammer", "Chisel"})
diyEasy:Add("What does a spirit level measure?", {"Whether a surface is perfectly horizontal", "Air pressure", "Structural strength", "Wall thickness"})
diyEasy:Add("What type of drill bit is used for wood?", {"Spade / Wood bit", "Masonry bit", "Metal drill bit", "Diamond bit"})
diyEasy:Add("What does PVC stand for in plumbing?", {"Polyvinyl Chloride", "Pressurised Valve Connector", "Plastic Ventilation Conduit", "Poly Valve Circuit"})
diyEasy:Add("What is the purpose of sandpaper grit numbers?", {"Higher number = finer / smoother", "Higher number = rougher", "The grit area in mm", "The sandpaper thickness"})

-- Video Game History
local vgHistoryEasy = categoryManager.New("Video Game History", "easy")
vgHistoryEasy:Add("What was the first commercially successful arcade game?", {"Pong", "Space Invaders", "Pac-Man", "Donkey Kong"})
vgHistoryEasy:Add("What console did Nintendo release in 1985 in the US?", {"NES", "SNES", "Game Boy", "N64"})
vgHistoryEasy:Add("What game featured the first video game plumber, Mario?", {"Donkey Kong", "Super Mario Bros", "Mario Bros", "Jumpman"})
vgHistoryEasy:Add("What year was the original PlayStation released in Japan?", {"1994", "1996", "1992", "1998"})
vgHistoryEasy:Add("What was the best-selling console of all time as of 2024?", {"PlayStation 2", "Nintendo DS", "Game Boy", "PlayStation 4"})

local vgHistoryHard = categoryManager.New("Video Game History", "hard")
vgHistoryHard:Add("What was the name of the first commercially sold video game console?", {"Magnavox Odyssey", "Atari 2600", "Fairchild Channel F", "Coleco Telstar"})
vgHistoryHard:Add("What year did id Software release the original Doom?", {"1993", "1992", "1994", "1991"})
vgHistoryHard:Add("Who is known as the 'father of video games'?", {"Ralph Baer", "Nolan Bushnell", "Shigeru Miyamoto", "Will Wright"})
vgHistoryHard:Add("What game popularised the battle royale genre on PC?", {"PUBG", "Fortnite", "H1Z1", "DayZ"}, 2)
vgHistoryHard:Add("What 1980s game caused a congressional hearing on video game violence?", {"Mortal Kombat", "Night Trap", "Doom", "Carmageddon"})

-- Bodily Functions / Health
local healthEasy = categoryManager.New("Health and Body", "easy")
healthEasy:Add("How many bones are in the adult human body?", {"206", "212", "198", "220"})
healthEasy:Add("What is the normal human body temperature in Celsius?", {"37", "36", "38", "35"})
healthEasy:Add("What organ pumps blood around the body?", {"Heart", "Liver", "Kidney", "Lung"})
healthEasy:Add("What vitamin do we get from sunlight?", {"Vitamin D", "Vitamin C", "Vitamin A", "Vitamin B12"})
healthEasy:Add("What is the largest organ of the human body?", {"Skin", "Liver", "Brain", "Intestine"})

local healthHard = categoryManager.New("Health and Body", "hard")
healthHard:Add("What is the medical term for high blood pressure?", {"Hypertension", "Hypotension", "Tachycardia", "Arrhythmia"})
healthHard:Add("What part of the brain controls balance and coordination?", {"Cerebellum", "Cerebrum", "Medulla", "Hippocampus"})
healthHard:Add("What is the name of the protein that carries oxygen in red blood cells?", {"Haemoglobin", "Myoglobin", "Albumin", "Fibrinogen"})
healthHard:Add("How many chambers does the human heart have?", {"4", "2", "3", "6"}, 2)
healthHard:Add("What is the role of the lymphatic system?", {"Immune defence and fluid balance", "Carry blood", "Digest food", "Filter toxins only"})

-- Cryptocurrency and Blockchain
local cryptoEasy = categoryManager.New("Crypto and Blockchain", "easy")
cryptoEasy:Add("Who created Bitcoin?", {"Satoshi Nakamoto", "Vitalik Buterin", "Charlie Lee", "Roger Ver"})
cryptoEasy:Add("What does NFT stand for?", {"Non-Fungible Token", "New Financial Trade", "Network File Transfer", "Non-Fixed Transaction"})
cryptoEasy:Add("What is the name of Ethereum's cryptocurrency?", {"Ether / ETH", "Bitcoin", "Litecoin", "Solana"})
cryptoEasy:Add("What is a blockchain?", {"A distributed ledger of transactions", "A type of cryptocurrency", "A crypto wallet", "A mining algorithm"})
cryptoEasy:Add("What year was Bitcoin first created?", {"2009", "2011", "2007", "2013"})

local cryptoHard = categoryManager.New("Crypto and Blockchain", "hard")
cryptoHard:Add("What consensus mechanism does Bitcoin use?", {"Proof of Work", "Proof of Stake", "Delegated Proof of Stake", "Proof of Authority"})
cryptoHard:Add("What is the maximum supply of Bitcoin?", {"21 million", "100 million", "18 million", "Unlimited"})
cryptoHard:Add("What is a 'gas fee' in Ethereum?", {"Fee paid to process a transaction", "Mining reward", "Exchange fee", "Wallet storage cost"}, 2)
cryptoHard:Add("What is a '51% attack'?", {"Gaining majority hash rate to control the chain", "Hacking 51% of wallets", "Dumping 51% of a coin's supply", "Forking a blockchain"})
cryptoHard:Add("What is the Ethereum upgrade that switched it to Proof of Stake called?", {"The Merge", "The Switch", "ETH 2.0 Launch", "The Fork"})

end -- chunk 6

-- ===================== NEW CATEGORIES BATCH 7 =====================
do -- chunk 7

-- Roblox Script Tools
local executorEasy = categoryManager.New("Roblox Script Tools", "easy")
executorEasy:Add("What does UNC stand for in Luau script tool testing?", {"Unified Naming Convention", "Universal Native Code", "Unnamed Native Convention", "Unified Native Calls"})
executorEasy:Add("What built-in Luau function runs a string as code?", {"loadstring()", "require()", "dofile()", "pcall()"})
executorEasy:Add("What function returns all instances including ones parented to nil?", {"getnilinstances()", "getinstances()", "game:GetDescendants()", "workspace:GetChildren()"})
executorEasy:Add("What function returns every script currently running in the game?", {"getscripts()", "game.Scripts", "require()", "getinstances()"})
executorEasy:Add("What does 'decompiling' a LocalScript mean?", {"Converting bytecode back to readable Luau", "Running a script faster", "Cloning a script", "Deleting a script"})
executorEasy:Add("What does 'getgc()' return in Luau script tools?", {"All values tracked by the garbage collector", "All game instances", "All running threads", "All loaded modules"})
executorEasy:Add("What does 'getgenv()' return?", {"The global Luau environment table", "All game services", "The local script environment", "All workspace globals"})
executorEasy:Add("What is the Drawing library primarily used for?", {"Rendering 2D shapes directly on screen", "Drawing on in-game parts", "Modifying game lighting", "Creating ScreenGui elements"})

local executorMedium = categoryManager.New("Roblox Script Tools", "medium")
executorMedium:Add("What function gets the environment of a specific script instance?", {"getsenv()", "getfenv()", "getscriptenv()", "getrenv()"})
executorMedium:Add("What does 'hookfunction()' do?", {"Replaces a function while keeping access to the original", "Calls a function remotely", "Disables a function entirely", "Clones a function"})
executorMedium:Add("What does 'isexecutorclosure()' return true for?", {"Functions created by the script tool", "All closures in the game", "Native C functions only", "Functions in ReplicatedStorage"})
executorMedium:Add("What does 'setreadonly(t, false)' allow?", {"Writing to a previously read-only table", "Making a table invisible to scripts", "Locking a table from deletion", "Cloning a protected table"})
executorMedium:Add("What does 'getrawmetatable()' let you access?", {"A table's metatable even if locked", "Raw memory addresses", "The internal globals table", "All metatables in the game"})
executorMedium:Add("What does 'getcallstack()' return?", {"The stack of currently executing function calls", "All remote calls in the game", "A list of loaded scripts", "The debug log"})
executorMedium:Add("What does 'protect_gui()' do to a ScreenGui?", {"Hides it from game detection scripts", "Makes it unclosable", "Anchors it to screen", "Prevents it rendering"})
executorMedium:Add("What does 'firetouchinterest()' simulate?", {"A part touching another part", "A remote event firing", "A player clicking a button", "A proximity prompt triggering"})
executorMedium:Add("What does 'cloneref()' do to an instance?", {"Creates a separate reference to avoid detection", "Duplicates the instance in workspace", "Deep copies all children", "Clones and re-parents it"})
executorMedium:Add("What does 'getrenv()' return?", {"The global environment of the game's Luau state", "The script tool's environment", "All remote events", "The ReplicatedStorage environment"})

local executorHard = categoryManager.New("Roblox Script Tools", "hard")
executorHard:Add("What does 'newcclosure()' do?", {"Wraps a Luau function in a C closure", "Creates a new coroutine", "Clones a function with new upvalues", "Makes a function uncallable by the game"})
executorHard:Add("What is the difference between 'getfenv()' and 'getsenv()'?", {"getfenv gets a function's env, getsenv gets a script's env", "getsenv is faster", "getfenv only works on C functions", "They are identical"})
executorHard:Add("What does 'debug.getupvalues()' return?", {"The upvalues (closed-over variables) of a function", "All global variables", "The function's argument list", "Memory addresses of variables"})
executorHard:Add("What does 'checkcaller()' return true for?", {"Calls originating from the script tool", "Any function call in the game", "Only C function calls", "Calls from LocalScripts only"})
executorHard:Add("What UNC function checks if a table is read-only?", {"isreadonly()", "getreadonly()", "checkmeta()", "islocked()"})
executorHard:Add("What does 'restorefunction()' do?", {"Restores a hooked function back to its original", "Replaces all closures in a script", "Reloads a ModuleScript", "Resets the global environment"})
executorHard:Add("What does 'debug.getconstants()' return for a function?", {"Constant values embedded in the function's bytecode", "All global constants", "The function's return values", "The upvalue names"})
executorHard:Add("What does 'debug.getprotos()' return?", {"Inner functions defined inside a function", "All running coroutines", "The prototype chain of an instance", "Global function references"})
executorHard:Add("What does the 'request()' function in Luau script tools do?", {"Makes HTTP requests from the client", "Sends remote events to the server", "Requests a ModuleScript from the server", "Fetches game assets by ID"})
executorHard:Add("What does 'getloadedmodules()' return?", {"All ModuleScripts that have been required", "All scripts in the game", "Only server-side modules", "Modules in ReplicatedStorage only"})

end -- chunk 7

end -- loadQuizDefinitions


local function initCore()

local letters = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
userCooldowns = {}
quizRunning = false
HttpService = game:GetService("HttpService")
players = game:GetService("Players")
localPlayer = players.LocalPlayer
blockedPlayers = {}
whiteListedplayers = {}
mode = "Quiz" -- "Quiz", "Kahoot", "SuddenDeath", "Team"
answeredCorrectly = {}
submittedAnswer = {}
awaitingAnswer = false
questionPoints = 1
local timeSinceLastMessage = tick()
placeId = game.PlaceId
local replicatedStorage = game:GetService("ReplicatedStorage")
StarterGui = game:GetService("StarterGui")
textChatService = game:GetService("TextChatService")
quizCooldown = false
local answerOptionsSaid = 0
local minMessageCooldown = 2.3
whiteListEnabled = false
ContextActionService = game:GetService("ContextActionService")
UserInputService = game:GetService("UserInputService")

-- Streak tracking
playerStreaks = {}
STREAK_BONUS_THRESHOLD = 3
local STREAK_BONUS_MULTIPLIER = 0.5

-- Sudden Death tracking
eliminatedPlayers = {}

-- Team mode tracking
teamPoints = {A = 0, B = 0}
playerTeams = {}

-- Hint system
local hintCoroutine = nil

-- Skip tracking
skipVotes = {}
SKIP_VOTES_NEEDED = 3

settings = {
    questionTimeout = 10,
    userCooldown = 5,
    sendLeaderBoardAfterQuestions = 0,
    automaticLeaderboards = true,
    automaticCurrentQuizLeaderboard = false,
    automaticServerQuizLeaderboard = true,
    signStatus = true,
    romanNumbers = true,
    autoplay = false,
    repeatTagged = true,
    sendDetailedCategorylist = false,
    removeLeavingPlayersFromLB = true,
    streakBonusEnabled = true,
    hintEnabled = true,
    hintDelay = 7,
    showStreakInChat = true,
    suddenDeathLives = 1,
    skipVotingEnabled = true,
    trollMode = false,
    betweenQuestionDelay = 6,    -- seconds between questions (was hardcoded 6)
    showWrongAnswerInChat = true, -- whether to send "wrong answer" messages at all
    almostCorrectEnabled = true, -- detect near-miss answers and say "almost!"
}

local numberMap = {
    {1000, 'M'}, {900, 'CM'}, {500, 'D'}, {400, 'CD'},
    {100, 'C'}, {90, 'XC'}, {50, 'L'}, {40, 'XL'},
    {10, 'X'}, {9, 'IX'}, {5, 'V'}, {4, 'IV'}, {1, 'I'}
}

function intToRoman(num)
    local roman = ""
    while num > 0 do
        for _, v in pairs(numberMap) do
            local romanChar = v[2]
            local int = v[1]
            while num >= int do
                roman = roman..romanChar
                num = num - int
            end
        end
    end
    return roman
end

Chat = function (msg)
    textChatService.TextChannels.RBXGeneral:SendAsync(msg)
end

shuffle = function (tbl)
    local rng = Random.new()
    for i = #tbl, 2, -1 do
        local j = rng:NextInteger(1, i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

sortAlphabetically = function (a, b)
    return string.lower(a) < string.lower(b)
end

roundNumber = function (num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

-- Shared utility: format seconds into readable time string
formatUptime = function (seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    if h > 0 then
        return string.format("%dh %dm %ds", h, m, s)
    elseif m > 0 then
        return string.format("%dm %ds", m, s)
    else
        return string.format("%ds", s)
    end
end

local notifyBindable = Instance.new("BindableFunction")
notify = function (title, text, configTable, duration)
    configTable = configTable or {}
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Callback = notifyBindable,
        Button1 = configTable.Button1,
        Button2 = configTable.Button2,
        Duration = duration
    })
    if configTable.Callback then
        notifyBindable.OnInvoke = configTable.Callback
    end
end

setgenv = function (key, value)
    pcall(function()
        getgenv()[key] = value
    end)
end

if getgenv and getgenv().QUIZBOT_RUNNING then
    notify("quizbot is already running", "You cannot run two instances of quizbot at once")
    return
end
setgenv("QUIZBOT_RUNNING", true)

copyLatestScript = function ()
    setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/Damian-11/quizbot/master/quizbot.luau", true))()')
    notify("Script copied", "The latest version of quizbot has been copied to your clipboard")
end

local DATA_FILENAME = "quizbot_data.json"
local data = {}
if isfile and isfile(DATA_FILENAME) then
    local ok, decoded = pcall(function() return HttpService:JSONDecode(readfile(DATA_FILENAME)) end)
    if ok and decoded then data = decoded end
end

writeToDataFile = function (key, value)
    if not writefile then return end
    data[key] = value
    pcall(function() writefile(DATA_FILENAME, HttpService:JSONEncode(data)) end)
end
getDataFileValue = function (key)
    return data[key]
end

-- Load persisted numeric/string settings from data file
local function loadPersistedSettings()
    local numericKeys = {
        "questionTimeout", "userCooldown", "hintDelay",
        "sendLeaderBoardAfterQuestions", "suddenDeathLives", "betweenQuestionDelay",
    }
    local globalKeys = {
        "STREAK_BONUS_THRESHOLD", "SKIP_VOTES_NEEDED",
    }
    for _, key in numericKeys do
        local v = getDataFileValue("setting_" .. key)
        if v and tonumber(v) then settings[key] = tonumber(v) end
    end
    local savedThreshold = getDataFileValue("setting_STREAK_BONUS_THRESHOLD")
    if savedThreshold and tonumber(savedThreshold) then
        STREAK_BONUS_THRESHOLD = tonumber(savedThreshold)
    end
    local savedSkip = getDataFileValue("setting_SKIP_VOTES_NEEDED")
    if savedSkip and tonumber(savedSkip) then
        SKIP_VOTES_NEEDED = tonumber(savedSkip)
    end
    local savedMode = getDataFileValue("setting_mode")
    if savedMode then mode = savedMode end
end
loadPersistedSettings()

-- Quiz history helpers
MAX_HISTORY = 10
addToHistory = function (category)
    local history = getDataFileValue("quiz_history") or {}
    -- Remove if already present to move to front
    for i, v in ipairs(history) do
        if v == category then table.remove(history, i) break end
    end
    table.insert(history, 1, category)
    while #history > MAX_HISTORY do table.remove(history) end
    writeToDataFile("quiz_history", history)
end
getHistory = function ()
    return getDataFileValue("quiz_history") or {}
end

local LATEST_VERSION_URL = "https://raw.githubusercontent.com/Damian-11/quizbot/master/version_number.luau"
local success, LATEST_VERSION = pcall(function()
    return loadstring(game:HttpGet(LATEST_VERSION_URL))()
end)

outdated = if success and LATEST_VERSION then VERSION ~= LATEST_VERSION else false

EscapePattern = function (pattern)
    local escapePattern = "[%(%)%.%%%+%-%*%?%[%]%^%$]"
    return string.gsub(pattern, escapePattern, "%%%1")
end


-- For use outside of a quiz (rules, server info, etc.)
-- Simple cooldown-respecting send, no shared flag dependency to avoid duplicate messages
SendChatMessage = function(message)
    local elapsed = tick() - timeSinceLastMessage
    if elapsed < minMessageCooldown then
        task.wait(minMessageCooldown - elapsed)
    end
    Chat(message)
    timeSinceLastMessage = tick()
end

function SendMessageWhenReady(message, important, altMessage)
    if not quizRunning then return end
    if not settings.repeatTagged then important = false end
    if important then
        importantMessageSent = true
        messageBeforeFilter = message
        answeredByAltMessage = altMessage
        messageFiltered = false
        antiFilteringDone = false
    end
    if tick() - timeSinceLastMessage >= minMessageCooldown then
        Chat(message)
        timeSinceLastMessage = tick()
    else
        task.wait(minMessageCooldown - (tick() - timeSinceLastMessage))
        if not quizRunning then return end
        Chat(message)
        timeSinceLastMessage = tick()
    end
    if important then
        lastMessageTime = tick()
        while (not antiFilteringDone or mainQuestionSent) and quizRunning do
            task.wait()
            if tick() - lastMessageTime > 6 then
                notify("Failed to Send Quiz Message", "Message rate limit exceeded.", nil, 10)
                messageFiltered = true
                antiFilteringDone = true
                mainQuestionSent = false
                importantMessageSent = false
                break
            end
        end
    end
    importantMessageSent = false
    antiFilteringDone = true
end

boothGame = false
local signRemote
local changeSignTextRemote
if placeId == 8351248417 then
    signRemote = replicatedStorage:WaitForChild("Remotes"):WaitForChild("SettingsRem")
    changeSignTextRemote = replicatedStorage.SharedModules.TextInputPrompt.TextInputEvent
    if signRemote and changeSignTextRemote then boothGame = true end
end

UpdateSignText = function (text)
    if not boothGame or not settings.signStatus or not text then return end
    local sign = localPlayer.Character:FindFirstChild("Text Sign") or localPlayer.Backpack:FindFirstChild("Text Sign")
    if not sign then return end
    signRemote:FireServer("SignServer")
    changeSignTextRemote:FireServer(text)
end

maxCharactersInMessage = 200
if placeId == 5118029260 then maxCharactersInMessage = 100 end

endMessage = "Quiz ended"

local function CalculateReadTime(text)
    local timeToWait = #string.split(text, " ") * 0.4
    if timeToWait < minMessageCooldown then timeToWait = minMessageCooldown end
    return timeToWait
end

-- ===================== Streak System =====================
getStreak = function (playerName)
    return playerStreaks[playerName] or 0
end

local function incrementStreak(player)
    local name = player.Name
    playerStreaks[name] = (playerStreaks[name] or 0) + 1
    return playerStreaks[name]
end

resetStreak = function (playerName)
    playerStreaks[playerName] = 0
end

calculateStreakBonus = function (streak, basePoints)
    if not settings.streakBonusEnabled or streak < STREAK_BONUS_THRESHOLD then
        return 0
    end
    local milestones = math.floor(streak / STREAK_BONUS_THRESHOLD)
    return math.floor(basePoints * STREAK_BONUS_MULTIPLIER * milestones)
end

-- ===================== Hint System =====================
generateHint = function (answer)
    local rng = Random.new() -- seeded RNG instead of math.random
    local hintChars = {}
    local revealCount = math.max(1, math.floor(#answer / 3))
    local revealIndices = {}

    table.insert(revealIndices, 1)

    local attempts = 0
    while #revealIndices < revealCount and attempts < 50 do
        local idx = rng:NextInteger(2, math.max(2, #answer))
        if not table.find(revealIndices, idx) and answer:sub(idx, idx) ~= " " then
            table.insert(revealIndices, idx)
        end
        attempts += 1
    end

    for i = 1, #answer do
        local char = answer:sub(i, i)
        if char == " " then
            table.insert(hintChars, " ")
        elseif table.find(revealIndices, i) then
            table.insert(hintChars, char)
        else
            table.insert(hintChars, "_")
        end
    end
    return table.concat(hintChars, "")
end

local function startHintCoroutine(targetQuestion)
    if hintCoroutine then
        pcall(function() coroutine.close(hintCoroutine) end)
        hintCoroutine = nil
    end
    hintCoroutine = coroutine.create(function()
        task.wait(settings.hintDelay)
        if not quizRunning or questionAnsweredBy or not currentQuestion then return end
        if currentQuestion ~= targetQuestion then return end
        local answer = targetQuestion.answers[targetQuestion.rightAnswerIndex]
        local hint = generateHint(answer)
        SendMessageWhenReady("💡 | Hint: " .. hint)
    end)
    coroutine.resume(hintCoroutine)
end

cancelHintCoroutine = function ()
    if hintCoroutine then
        pcall(function() coroutine.close(hintCoroutine) end)
        hintCoroutine = nil
    end
end

-- ===================== Sudden Death =====================
suddenDeathLives = {}
-- UI label reference, set later

updateEliminatedLabel = function ()
    if not eliminatedLabel then return end
    if #eliminatedPlayers == 0 then
        eliminatedLabel:Set("Eliminated: None")
    else
        local names = {}
        for _, name in eliminatedPlayers do
            table.insert(names, name)
        end
        eliminatedLabel:Set("Eliminated: " .. table.concat(names, ", "))
    end
end

initSuddenDeath = function ()
    table.clear(eliminatedPlayers)
    table.clear(suddenDeathLives)
    for _, p in players:GetPlayers() do
        if p ~= localPlayer then
            suddenDeathLives[p.Name] = settings.suddenDeathLives
        end
    end
    updateEliminatedLabel()
end

eliminatePlayer = function (player)
    if not table.find(eliminatedPlayers, player.Name) then
        table.insert(eliminatedPlayers, player.Name)
        updateEliminatedLabel()
        SendMessageWhenReady("💀 | " .. player.DisplayName .. " has been eliminated!")
    end
end

isEliminated = function (playerName)
    return table.find(eliminatedPlayers, playerName) ~= nil
end

getSuddenDeathSurvivorCount = function ()
    local count = 0
    local lastSurvivor = nil
    for _, p in players:GetPlayers() do
        if p ~= localPlayer and not isEliminated(p.Name) then
            count += 1
            lastSurvivor = p
        end
    end
    return count, lastSurvivor
end

-- ===================== Team Mode =====================
assignTeams = function ()
    table.clear(playerTeams)
    teamPoints = {A = 0, B = 0}
    -- Filter out localPlayer BEFORE indexing so team assignment is never skewed
    local allPlayers = {}
    for _, p in players:GetPlayers() do
        if p ~= localPlayer then
            table.insert(allPlayers, p)
        end
    end
    shuffle(allPlayers)
    for i, p in allPlayers do
        local team = if i % 2 == 0 then "A" else "B"
        playerTeams[p.Name] = team
    end
    local teamANames = {}
    local teamBNames = {}
    for name, team in playerTeams do
        local p = players:FindFirstChild(name)
        local display = p and p.DisplayName or name
        if team == "A" then table.insert(teamANames, display)
        else table.insert(teamBNames, display) end
    end
    Chat("🔴 Team A: " .. table.concat(teamANames, ", "))
    task.wait(2.5)
    Chat("🔵 Team B: " .. table.concat(teamBNames, ", "))
end

-- ===================== Question OOP =====================
question = {}
question.__index = question

function question.New(quesitonText, options, value)
    local newQuestion = {}
    newQuestion.mainQuestion = quesitonText
    newQuestion.answers = options
    newQuestion.rightAnswer = letters[1]
    newQuestion.rightAnswerIndex = 1
    value = value or 1
    newQuestion.value = value
    setmetatable(newQuestion, question)
    return newQuestion
end

function question:Ask()
    if not quizRunning then return false end
    cancelHintCoroutine()
    answerOptionsSaid = 0
    table.clear(skipVotes)
    local rightAnswerBeforeShuffle = self.answers[self.rightAnswerIndex]
    self.answers = shuffle(self.answers)
    self.rightAnswerIndex = table.find(self.answers, rightAnswerBeforeShuffle)
    self.rightAnswer = letters[self.rightAnswerIndex]
    if self.value > 1 then
        SendMessageWhenReady("⭐ | " .. self.value .. "x points for this question!")
        task.wait(2)
    end
    questionAnsweredBy = nil
    UpdateSignText(self.mainQuestion)
    currentQuestion = self
    questionPoints = self.value
    mainQuestionSent = true
    SendMessageWhenReady("🎙️ | " .. self.mainQuestion, true)
    if messageFiltered then
        task.wait(3)
        Chat("➡️ | Repeated filtering detected. Skipping question...")
        return false
    end
    local waitTime = CalculateReadTime(self.mainQuestion)
    local timeWaited = 0
    while waitTime > timeWaited do
        if questionAnsweredBy or not quizRunning then return true end
        task.wait(0.1)
        timeWaited += 0.1
    end
    for i, v in ipairs(self.answers) do
        if questionAnsweredBy or not quizRunning then return true end
        if i ~= 1 then task.wait(CalculateReadTime(v)) end
        if questionAnsweredBy or not quizRunning then return true end
        SendMessageWhenReady(letters[i] .. ")" .. v, true)
        answerOptionsSaid = i
    end
    if settings.hintEnabled then
        startHintCoroutine(self)
    end
    return true
end

splitIntoMessages = function (itemTable, separtor, clearFilter, waitTime)
    local tempItemList = {}
    local messages = {}
    local currentLength = 0
    for _, item in itemTable do
        if currentLength + #item + (#separtor * #tempItemList) + 6 >= maxCharactersInMessage then
            table.insert(messages, table.concat(tempItemList, separtor))
            table.clear(tempItemList)
            table.insert(tempItemList, item)
            currentLength = #item
        else
            table.insert(tempItemList, item)
            currentLength = currentLength + #item
        end
    end
    table.insert(messages, table.concat(tempItemList, separtor))
    for messageIndex, message in messages do
        if quizRunning then return end
        local messageNumberString = string.format("(%d/%d)", messageIndex, #messages)
        if messageIndex == 2 or messageIndex == 3 then
            if clearFilter then Chat("Waiting for filter...") end
            task.wait(5)
        end
        if quizRunning then return end
        Chat(message .. " " .. messageNumberString)
        task.wait(waitTime or CalculateReadTime(message) * 0.7)
    end
end

local antiAfkEnabled = false
EnableAntiAfk = function ()
    if antiAfkEnabled then return end
    local GC = getconnections or get_signal_cons
    if GC then
        for i, v in pairs(GC(localPlayer.Idled)) do
            if v["Disable"] then v["Disable"](v)
            elseif v["Disconnect"] then v["Disconnect"](v) end
        end
    else
        local VirtualUser = cloneref(game:GetService("VirtualUser"))
        localPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
    antiAfkEnabled = true
    notify("Anti-AFK enabled", "You will not get kicked for being idle")
end

-- ===================== Category OOP =====================
categoryManager = {}
categories = {}
categories.categoryList = {}
categories.numberOfDifficulties = {}
categoryManager.__index = categoryManager

difficultyOrder = {"", "easy", "medium", "hard"}

function categoryManager.New(categoryName, difficulty)
    difficulty = difficulty or ""
    difficulty = string.lower(difficulty)
    if not categories.categoryList[categoryName] then
        categories.categoryList[categoryName] = {}
        categories.numberOfDifficulties[categoryName] = 0
    end
    if not categories.categoryList[categoryName][difficulty] then
        categories.categoryList[categoryName][difficulty] = {}
        categories.numberOfDifficulties[categoryName] += 1
        if not table.find(difficultyOrder, difficulty) then
            table.insert(difficultyOrder, difficulty)
        end
    end
    table.insert(categories.categoryList[categoryName][difficulty], {})
    local newCategory = categories.categoryList[categoryName][difficulty][#categories.categoryList[categoryName][difficulty]]
    setmetatable(newCategory, categoryManager)
    return newCategory
end

function categoryManager:Add(quesitonText, options, value, customQuestion)
    self = customQuestion or self
    local newQuestion = question.New(quesitonText, options, value)
    table.insert(self, newQuestion)
end

local function getDisplayNameByUsername(username)
    local displayName = players:FindFirstChild(username) and players:FindFirstChild(username).DisplayName
    return displayName
end

-- ===================== Points OOP =====================
pointManager = {}
userPoints = {}

function pointManager.NewAccount(player)
    userPoints[player.Name] = {}
    local playerPoints = userPoints[player.Name]
    playerPoints.DisplayName = getDisplayNameByUsername(player.Name)
    playerPoints.GlobalPoints = 0
    playerPoints.CurrentQuizPoints = 0
    return playerPoints
end

function pointManager.AddPoints(player, points, type)
    if not points or not tonumber(points) then points = 1 end
    if not type then type = "All" end
    local playerAccount = userPoints[player.Name]
    if not playerAccount then playerAccount = pointManager.NewAccount(player) end
    if type == "All" then
        playerAccount.GlobalPoints += points
        if quizRunning then playerAccount.CurrentQuizPoints += points end
    elseif playerAccount[type] then
        playerAccount[type] += points
    end
    UpdateUILeaderboard(type)
end

function pointManager.ClearQuizPoints()
    for _, v in pairs(userPoints) do
        v.CurrentQuizPoints = 0
    end
    ClearLeaderboardLabels("CurrentQuizPoints")
end

function pointManager.RemoveAccount(player)
    if userPoints[player.Name] then
        userPoints[player.Name] = nil
        UpdateUILeaderboard("All")
    end
end

function pointManager.ResetAllPoints()
    for _, v in pairs(userPoints) do
        v.GlobalPoints = 0
        v.CurrentQuizPoints = 0
    end
    table.clear(playerStreaks)
    ClearLeaderboardLabels("CurrentQuizPoints")
    ClearLeaderboardLabels("GlobalPoints")
end

local function requestSendMessage(message)
    local elapsed = tick() - timeSinceLastMessage
    if elapsed > 2.5 then
        Chat(message)
        timeSinceLastMessage = tick()
    end
end

-- ===================== Rules (dynamic, built at call time) =====================
buildRules = function ()
    quizModeRules = {
        "Each question has one correct answer. Submit via text chat only.",
        "If you submit an incorrect answer, you must wait " .. tostring(settings.userCooldown) .. " seconds before trying again.",
        "Correct answers earn you points. Answer faster to build a streak!",
        "Streaks of " .. tostring(STREAK_BONUS_THRESHOLD) .. "+ give bonus points per milestone.",
    }
    kahootModeRules = {
        "Each question has one correct answer. Submit via text chat only.",
        "You can only submit ONE answer per question. Your first answer is final.",
        "You have " .. tostring(settings.questionTimeout) .. " seconds after all options are said.",
        "The longer you wait, the fewer points you earn. First correct answer gets 1.5x points.",
    }
    suddenDeathRules = {
        "One wrong answer and you are eliminated!",
        "Last player standing wins.",
        "You must answer via text chat.",
        "Eliminated players cannot answer further questions.",
        "Each player starts with " .. tostring(settings.suddenDeathLives) .. " life/lives.",
    }
    teamRules = {
        "Players are split into Team A and Team B randomly.",
        "Any correct answer from your team earns team points.",
        "The team with the most points at the end wins.",
        "Individual points are still tracked for the server leaderboard.",
    }
    return quizModeRules, kahootModeRules, suddenDeathRules, teamRules
end

-- ===================== Answer Matching Helpers =====================
-- Strips punctuation, extra spaces, lowercases — used on both player input and answer text
local function normalizeAnswer(s)
    s = s:lower()
    s = s:gsub("[%p%s]", "") -- remove all punctuation and whitespace
    return s
end

-- Levenshtein distance — returns the edit distance between two strings
local function levenshtein(a, b)
    local la, lb = #a, #b
    if la == 0 then return lb end
    if lb == 0 then return la end
    local matrix = {}
    for i = 0, la do matrix[i] = {[0] = i} end
    for j = 0, lb do matrix[0][j] = j end
    for i = 1, la do
        for j = 1, lb do
            local cost = a:sub(i,i) == b:sub(j,j) and 0 or 1
            matrix[i][j] = math.min(
                matrix[i-1][j] + 1,
                matrix[i][j-1] + 1,
                matrix[i-1][j-1] + cost
            )
        end
    end
    return matrix[la][lb]
end

-- Returns true if the player's answer is "almost" correct:
-- within 2 edits for long answers, 1 edit for short ones, never for very short answers
local function isAlmostCorrect(playerInput, correctAnswer)
    local pNorm = normalizeAnswer(playerInput)
    local cNorm = normalizeAnswer(correctAnswer)
    if pNorm == cNorm then return false end -- exact match handled elsewhere
    local cLen = #cNorm
    if cLen <= 3 then return false end -- too short to fuzzy match safely
    local threshold = cLen <= 6 and 1 or 2
    return levenshtein(pNorm, cNorm) <= threshold
end

-- ===================== Chat Listener =====================
startChatListening = function (message, player)
    local messageContent = string.upper(message) or ""

    -- Skip vote handling
    if settings.skipVotingEnabled and quizRunning and currentQuestion and not questionAnsweredBy then
        if messageContent == "!SKIP" and not table.find(skipVotes, player.Name) then
            table.insert(skipVotes, player.Name)
            local activePlayers = 0
            for _, p in players:GetPlayers() do
                if p ~= localPlayer then activePlayers += 1 end
            end
            local needed = math.min(SKIP_VOTES_NEEDED, activePlayers)
            requestSendMessage("⏭️ | Skip vote: " .. #skipVotes .. "/" .. needed .. " (say !skip to vote)")
            if #skipVotes >= needed then
                -- Signal awaitAnswer to break its loop by clearing currentQuestion
                currentQuestion = nil
                questionAnsweredBy = nil
                cancelHintCoroutine()
                Chat("⏭️ | Question skipped by vote!")
            end
            return
        end
    end

    -- Category vote handling
    if votingActive and voteData then
        local choice = tonumber(messageContent)
        if choice and choice >= 1 and choice <= 3 and not voteData.votes[player.Name] then
            voteData.votes[player.Name] = choice
            voteData.counts[choice] = voteData.counts[choice] + 1
        end
        return
    end

    if mode == "SuddenDeath" and isEliminated(player.Name) then return end

    if not currentQuestion or questionAnsweredBy
        or table.find(userCooldowns, player.Name)
        or table.find(blockedPlayers, player.Name)
        or table.find(submittedAnswer, player.Name)
        or (whiteListEnabled and not table.find(whiteListedplayers, player.Name)) then
        return
    end

    local matchAnswer
    local minLenght = 4
    if #currentQuestion.answers[currentQuestion.rightAnswerIndex] < minLenght then
        minLenght = #currentQuestion.answers[currentQuestion.rightAnswerIndex]
    end
    local escapedMessage = EscapePattern(messageContent)
    if #messageContent >= minLenght then
        for _, v in ipairs(currentQuestion.answers) do
            local escapedAnswer = EscapePattern(v)
            if v:upper() == messageContent then
                matchAnswer = v
                break
            elseif (string.match(v:upper(), escapedMessage) and #string.match(v:upper(), escapedMessage) >= minLenght) or string.match(messageContent, escapedAnswer:upper()) then
                if matchAnswer then return end
                matchAnswer = v
            end
        end
    end

    local matchingLetter = nil
    if not matchAnswer then
        local senderCharacter = player.Character
        local character = localPlayer.Character
        if not senderCharacter or not character then return end
        local patterns = {}
        patterns[1] = "%s([A-" .. letters[#currentQuestion.answers] .. "])%s"
        patterns[2] = "%s([B-" .. letters[#currentQuestion.answers] .. "])$"
        patterns[3] = "^([A-" .. letters[#currentQuestion.answers] .. "])%s"
        patterns[4] = "^([A-" .. letters[#currentQuestion.answers] .. "])$"
        messageContent = string.gsub(messageContent, "[%).?!]", "")
        local magnitude = (character:GetPivot().Position - senderCharacter:GetPivot().Position).Magnitude
        if magnitude < 10 then
            for i = 1, 4 do
                local match = messageContent:match(patterns[i])
                if match and table.find(letters, match) <= answerOptionsSaid then
                    if matchingLetter then return end
                    matchingLetter = match
                end
            end
        else
            matchingLetter = messageContent:match(patterns[4])
            if matchingLetter then
                if table.find(letters, matchingLetter) > answerOptionsSaid then
                    matchingLetter = nil
                end
            end
        end
    end

    if matchingLetter or matchAnswer then
        local isCorrect = matchingLetter == currentQuestion.rightAnswer
            or matchAnswer == currentQuestion.answers[currentQuestion.rightAnswerIndex]

        if isCorrect then
            if mode == "Quiz" then
                questionAnsweredBy = player
                currentQuestion = nil

                local streak = incrementStreak(player)
                local bonus = calculateStreakBonus(streak, questionPoints)
                if bonus > 0 and settings.showStreakInChat then
                    task.spawn(function()
                        task.wait(0.3)
                        SendMessageWhenReady("🔥 | " .. player.DisplayName .. " is on a " .. streak .. " streak! +" .. bonus .. " bonus pts")
                    end)
                end

            elseif mode == "SuddenDeath" then
                questionAnsweredBy = player
                currentQuestion = nil
                incrementStreak(player)

            elseif mode == "Team" then
                local team = playerTeams[player.Name]
                if team then
                    -- Only add team points here; individual points handled in awaitAnswer
                    teamPoints[team] += questionPoints
                    questionAnsweredBy = player
                    currentQuestion = nil
                end

            else -- Kahoot
                table.insert(submittedAnswer, player.Name)
                table.insert(answeredCorrectly, player.DisplayName)
                if #answeredCorrectly == 1 then
                    pointManager.AddPoints(player, questionPoints * 1.5)
                else
                    pointManager.AddPoints(player, questionPoints)
                end
            end

        else
            if mode == "SuddenDeath" then
                suddenDeathLives[player.Name] = (suddenDeathLives[player.Name] or 1) - 1
                if suddenDeathLives[player.Name] <= 0 then
                    eliminatePlayer(player)
                else
                    requestSendMessage("⚠️ | " .. player.DisplayName .. " has " .. suddenDeathLives[player.Name] .. " life left!")
                end
                table.insert(userCooldowns, player.Name)
                task.delay(settings.userCooldown, function()
                    local idx = table.find(userCooldowns, player.Name)
                    if idx then table.remove(userCooldowns, idx) end
                end)
            elseif mode == "Quiz" then
                resetStreak(player.Name)
                if awaitingAnswer and settings.showWrongAnswerInChat then
                    requestSendMessage("❌ | " .. player.DisplayName .. " wrong answer. Try again in " .. tostring(settings.userCooldown) .. " seconds.")
                end
                table.insert(userCooldowns, player.Name)
                task.delay(settings.userCooldown, function()
                    local idx = table.find(userCooldowns, player.Name)
                    if idx then table.remove(userCooldowns, idx) end
                end)
            elseif mode == "Kahoot" or mode == "Team" then
                table.insert(submittedAnswer, player.Name)
            end
        end
    end
end

end -- initCore

local function initQuiz()
local filtersInARow = 0
local function processMessage(player, message)
    if player ~= localPlayer then
        startChatListening(message, player)
    else
        if not (importantMessageSent or mainQuestionSent) or not quizRunning or not messageBeforeFilter then return end
        message = string.gsub(message, "&amp;", "&")
        if messageBeforeFilter == message or (answeredByAltMessage and string.find(message, answeredByAltMessage)) then
            filtersInARow = 0
            messageFiltered = false
            mainQuestionSent = false
            antiFilteringDone = true
            return
        elseif math.abs(#message - #messageBeforeFilter) > 8 or not string.find(message, "#") then
            return
        elseif mainQuestionSent and messageFiltered then
            mainQuestionSent = false
            antiFilteringDone = true
            return
        end
        lastMessageTime = tick() + 5
        messageFiltered = true
        filtersInARow += 1
        if filtersInARow == 1 then
            SendMessageWhenReady("🔁 | Waiting for filter to clear and resending filtered message...")
            task.wait(5)
        elseif filtersInARow == 2 then
            SendMessageWhenReady("🔁 | Resending previous message because of chat filter...")
            task.wait(6)
        else
            SendMessageWhenReady("Attempting to get around Roblox tagging. Please wait...")
            task.wait(6)
            filtersInARow = 0
        end
        if not quizRunning then return end
        if questionAnsweredBy and answeredByAltMessage then
            SendMessageWhenReady(answeredByAltMessage)
            antiFilteringDone = true
            return
        elseif questionAnsweredBy then
            antiFilteringDone = true
            return
        end
        SendMessageWhenReady(messageBeforeFilter)
        antiFilteringDone = true
    end
end

local function connectChat()
    if chatConnection then
        pcall(function() chatConnection:Disconnect() end)
    end
    chatConnection = textChatService.MessageReceived:Connect(function(textChatMessage)
        local player = if textChatMessage.TextSource then players:GetPlayerByUserId(textChatMessage.TextSource.UserId) else nil
        if not player then return end
        processMessage(player, textChatMessage.Text)
    end)
end
connectChat()

-- Watchdog: reconnect if the connection silently drops
task.spawn(function()
    while true do
        task.wait(10)
        if not chatConnection.Connected then
            warn("quizbot | chat connection dropped, reconnecting...")
            connectChat()
        end
    end
end)

awaitAnswer = function (targetQuestion)
    if not quizRunning then return end
    awaitingAnswer = true
    local timeIsOut = false
    -- Record when question started being awaited for timing
    questionAskedTick = tick()
    stats.questionsAsked += 1
    refreshStatsLabels()

    local function Timeout()
        if not quizRunning then return end
        task.wait(settings.questionTimeout)
        if not quizRunning then return end
        UpdateSignText(targetQuestion.rightAnswer .. ")" .. targetQuestion.answers[targetQuestion.rightAnswerIndex])
        timeIsOut = true
        currentQuestion = nil
        questionAnsweredBy = nil
        awaitingAnswer = false
        stats.timeouts += 1
        refreshStatsLabels()
        pcall(function()
            Chat("⏰ | Time is out! Correct answer was: " .. targetQuestion.rightAnswer .. ")" .. targetQuestion.answers[targetQuestion.rightAnswerIndex])
        end)
    end

    local function SignTime()
        for timeLeft = settings.questionTimeout, 1, -1 do
            if questionAnsweredBy then return end
            if settings.romanNumbers then
                UpdateSignText(tostring(intToRoman(timeLeft)))
            else
                UpdateSignText(tostring(timeLeft))
            end
            task.wait(1)
        end
    end

    local timeoutCoroutine = coroutine.create(Timeout)
    local signTimeCoroutine = coroutine.create(SignTime)
    coroutine.resume(timeoutCoroutine)
    if boothGame and settings.signStatus then coroutine.resume(signTimeCoroutine) end

    if mode == "Quiz" or mode == "SuddenDeath" or mode == "Team" then
        while questionAnsweredBy == nil
            and currentQuestion ~= nil
            and (table.find({"normal", "running", "suspended"}, coroutine.status(timeoutCoroutine)))
            and quizRunning do
            task.wait()
        end

        if not questionAnsweredBy and not timeIsOut and not quizRunning then return end
        if not questionAnsweredBy and currentQuestion == nil and not timeIsOut then
            -- Was a skip
            pcall(function() coroutine.close(timeoutCoroutine) end)
            pcall(function() coroutine.close(signTimeCoroutine) end)
            cancelHintCoroutine()
            awaitingAnswer = false
            table.clear(userCooldowns)
            stats.skips += 1
            refreshStatsLabels()
            return
        end

        if timeIsOut or not quizRunning then return end
        pcall(function() coroutine.close(timeoutCoroutine) end)
        pcall(function() coroutine.close(signTimeCoroutine) end)
        cancelHintCoroutine()

        -- Record answer time stats
        if questionAskedTick then
            local answerTime = tick() - questionAskedTick
            stats.correctAnswers += 1
            stats.answeredQuestions += 1
            stats.totalAnswerTime += answerTime
            if stats.fastestAnswerTime == nil or answerTime < stats.fastestAnswerTime then
                stats.fastestAnswerTime = answerTime
                stats.fastestAnswerPlayer = questionAnsweredBy.DisplayName
            end
            stats.playerCorrectCount[questionAnsweredBy.Name] = (stats.playerCorrectCount[questionAnsweredBy.Name] or 0) + 1
            refreshStatsLabels()
        end

        local basePoints = targetQuestion.value
        local streak = getStreak(questionAnsweredBy.Name)
        local bonus = calculateStreakBonus(streak, basePoints)
        local totalPoints = basePoints + bonus

        pointManager.AddPoints(questionAnsweredBy, totalPoints)

        task.delay(0.5, function()
            UpdateSignText(targetQuestion.rightAnswer .. ")" .. targetQuestion.answers[targetQuestion.rightAnswerIndex])
        end)

        local bonusText = if bonus > 0 then " (+" .. bonus .. " streak bonus)" else ""
        SendMessageWhenReady(
            "✔️ | " .. questionAnsweredBy.DisplayName .. " answered correctly" .. bonusText .. ". Answer: "
                .. targetQuestion.rightAnswer .. ")" .. targetQuestion.answers[targetQuestion.rightAnswerIndex],
            true,
            "[Player] answered correctly" .. bonusText .. ". Answer: "
                .. targetQuestion.rightAnswer .. ")" .. targetQuestion.answers[targetQuestion.rightAnswerIndex]
        )
        questionAnsweredBy = nil
        awaitingAnswer = false
        table.clear(userCooldowns)

        if mode == "SuddenDeath" then
            local remaining, winner = getSuddenDeathSurvivorCount()
            if remaining <= 1 then
                if winner then
                    SendMessageWhenReady("🏆 | " .. winner.DisplayName .. " wins Sudden Death!")
                end
                quizRunning = false
                return
            end
        end
    else
        -- Kahoot mode
        while table.find({"normal", "running", "suspended"}, coroutine.status(timeoutCoroutine)) and quizRunning do
            task.wait(1)
            questionPoints = math.max(1, questionPoints - questionPoints / settings.questionTimeout)
        end
        pcall(function() coroutine.close(timeoutCoroutine) end)
        pcall(function() coroutine.close(signTimeCoroutine) end)
        cancelHintCoroutine()
        task.wait(2)
        if not quizRunning then return end
        -- Reveal the correct answer in Kahoot mode
        do
            local rightAns = targetQuestion.answers[targetQuestion.rightAnswerIndex]
            SendMessageWhenReady("✔️ | Answer: " .. targetQuestion.rightAnswer .. ")" .. rightAns)
            task.wait(2.5)
        end
        if #answeredCorrectly > 0 then
            local tempuserList = {}
            local currentLength = 22
            local firstIteration = true
            for _, user in pairs(answeredCorrectly) do
                if currentLength + #user + (2 * #tempuserList) >= maxCharactersInMessage then
                    if firstIteration then
                        SendMessageWhenReady("🏆 | Got it right: " .. table.concat(tempuserList, ", "))
                        firstIteration = false
                    else
                        SendMessageWhenReady(table.concat(tempuserList, ", "))
                    end
                    task.wait(3)
                    table.clear(tempuserList)
                    table.insert(tempuserList, user)
                    currentLength = #user
                else
                    table.insert(tempuserList, user)
                    currentLength = currentLength + #user
                end
            end
            if #tempuserList > 0 then
                if firstIteration then
                    SendMessageWhenReady("🏆 | Got it right: " .. table.concat(tempuserList, ", "))
                else
                    SendMessageWhenReady(table.concat(tempuserList, ", "))
                end
            end
        end
        table.clear(answeredCorrectly)
        table.clear(submittedAnswer)
        awaitingAnswer = false
        currentQuestion = nil
    end
end

-- ===================== Quiz Questions =====================
-- ===================== Quiz Questions =====================
loadQuizDefinitions(categoryManager)

-- ===================== Category Table Building =====================
local function addTrailingZeros(number, desiredLength)
    local numberString = tostring(number)
    local lenghtDifference = desiredLength - string.len(numberString)
    return string.rep("0", math.max(0, lenghtDifference)) .. numberString
end

categoryTable = {}
categoryLookupTable = {}

local function UpdateCategoryTable(categoryName, difficulties)
    local multipleDifficulties = categories.numberOfDifficulties[categoryName] > 1
    for difficulty, quizzes in difficulties do
        for index, quiz in quizzes do
            local listName
            if #quizzes > 1 and multipleDifficulties then
                local finalIndex = addTrailingZeros(index, string.len(#quizzes))
                listName = categoryName .. "-" .. difficulty .. finalIndex
                table.insert(categoryTable, listName)
            elseif multipleDifficulties and difficulty ~= "" then
                listName = categoryName .. "-" .. difficulty
                table.insert(categoryTable, listName)
            elseif #quizzes > 1 or (difficulty == "" and multipleDifficulties) then
                local finalIndex = addTrailingZeros(index, string.len(#quizzes))
                listName = categoryName .. "-" .. finalIndex
                table.insert(categoryTable, listName)
            else
                listName = categoryName
                table.insert(categoryTable, listName)
            end
            categoryLookupTable[listName] = {quiz, difficulty}
        end
    end
end

for categoryName, difficulties in categories.categoryList do
    UpdateCategoryTable(categoryName, difficulties)
end
table.sort(categoryTable, sortAlphabetically)

local function SortDifficulty(a, b)
    local aOrder = table.find(difficultyOrder, a:match("^(%a+)%d*$"))
    local bOrder = table.find(difficultyOrder, b:match("^(%a+)%d*$"))
    if not aOrder or not bOrder then return a < b
    elseif aOrder == bOrder then return a < b
    else return aOrder < bOrder end
end

local categoriesToSend = {}
local categoriesToSendDetailed = {}

local function addToSendCategoryTable(categoryName, difficulties)
    local formattedCategory = {}
    local multipleDifficulties = categories.numberOfDifficulties[categoryName] > 1
    for difficulty, quizzes in difficulties do
        if #quizzes > 1 and multipleDifficulties then
            for index, quiz in quizzes do
                table.insert(formattedCategory, difficulty .. index)
            end
        elseif multipleDifficulties and difficulty == "" then
            table.insert(formattedCategory, difficulty .. "1")
        elseif multipleDifficulties then
            table.insert(formattedCategory, difficulty)
        elseif #quizzes > 1 then
            table.insert(formattedCategory, tostring(#quizzes))
        end
    end
    table.sort(formattedCategory, SortDifficulty)
    if #formattedCategory > 0 then
        formattedCategory = categoryName .. " [" .. table.concat(formattedCategory, ", ") .. "]"
    else
        formattedCategory = categoryName
    end
    table.insert(categoriesToSendDetailed, formattedCategory)
    table.insert(categoriesToSend, categoryName)
end

for categoryName, difficulties in categories.categoryList do
    addToSendCategoryTable(categoryName, difficulties)
end
table.sort(categoriesToSend, sortAlphabetically)
table.sort(categoriesToSendDetailed, sortAlphabetically)

local firstTimeSendingCategories = true
local currentlySending
sendCategories = function ()
    if not quizRunning and not currentlySending then
        currentlySending = "Category list is"
        local waitTime = 5
        if firstTimeSendingCategories and settings.sendDetailedCategorylist then
            notify("Warning: possible filtering", "Turn off detailed categories in settings if the category list gets filtered")
            waitTime = 7
        end
        Chat("❓ | Quiz topics:")
        task.wait(3)
        if settings.sendDetailedCategorylist then
            splitIntoMessages(categoriesToSendDetailed, ", ", true, waitTime)
        else
            splitIntoMessages(categoriesToSend, ", ", false, waitTime)
        end
        if settings.sendDetailedCategorylist then firstTimeSendingCategories = false end
        currentlySending = nil
    elseif currentlySending then
        notify(`{currentlySending} currently being sent`, "Wait for it to finish before sending the category list")
    elseif quizRunning then
        notify("Can't send category list", "Stop the quiz or wait for it to end")
    end
end

local function IsCategoryEqual(categoryName, matchCategory, suffix)
    if categoryName == matchCategory then return true end
    local pattern = "^" .. EscapePattern(categoryName .. suffix)
    return string.match(matchCategory, pattern) ~= nil
end

local function RemoveDuplicateCategories(targetTable, categoryName, suffix)
    local tempTable = table.clone(targetTable)
    for i = 1, #targetTable do
        if IsCategoryEqual(categoryName, targetTable[i], suffix) then
            table.remove(tempTable, table.find(tempTable, targetTable[i]))
        end
    end
    return tempTable
end

local function UpdateCategory(categoryName)
    categoriesToSend = RemoveDuplicateCategories(categoriesToSend, categoryName, "")
    categoriesToSendDetailed = RemoveDuplicateCategories(categoriesToSendDetailed, categoryName, " [")
    local difficulties = categories.categoryList[categoryName]
    addToSendCategoryTable(categoryName, difficulties)
    categoryTable = RemoveDuplicateCategories(categoryTable, categoryName, "-")
    UpdateCategoryTable(categoryName, difficulties)
end

numberOfCategoriesPerDifficulty = {}
for categoryName, category in categoryLookupTable do
    if not numberOfCategoriesPerDifficulty[category[2]] then
        numberOfCategoriesPerDifficulty[category[2]] = 1
    else
        numberOfCategoriesPerDifficulty[category[2]] += 1
    end
end

-- ===================== Custom Category OOP =====================
local CustomCategoryManager = {}
CustomCategoryManager.__index = CustomCategoryManager
local categoryNames = {}

autoplayFilterDifficulties = {}

function CustomCategoryManager.New(categoryName, difficulty)
    CustomCategoryManager.scheduleRefresh()
    if type(categoryName) == "string" then
        if type(difficulty) ~= "string" then
            difficulty = ""
        else
            difficulty = string.lower(difficulty)
        end
        if not numberOfCategoriesPerDifficulty[difficulty] or numberOfCategoriesPerDifficulty[difficulty] == 0 then
            numberOfCategoriesPerDifficulty[difficulty] = 1
            if difficulty == "" then
                table.insert(autoplayFilterDifficulties, "missing difficulty")
            else
                table.insert(autoplayFilterDifficulties, difficulty)
            end
            autoplayFilterDropdown:Refresh(autoplayFilterDifficulties)
        end
        for name, _ in categories.categoryList do
            if string.lower(name) == string.lower(categoryName) then
                categoryName = name
            end
        end
        local newCategory = setmetatable(categoryManager.New(categoryName, difficulty), CustomCategoryManager)
        categoryNames[newCategory] = categoryName
        UpdateCategory(categoryNames[newCategory])
        return newCategory
    else
        print("Custom quiz error | CategoryName is not a string")
    end
    notify("Can't add custom quiz", "See the output for more information")
end

function CustomCategoryManager:Add(quesitonText, options, value)
    if type(quesitonText) == "string" then
        if type(options) == "table" then
            if #options > 1 then
                if type(value) == "nil" or type(value) == "number" then
                    categoryManager:Add(quesitonText, options, value, self)
                    return
                else
                    print("Custom quiz error | [" .. quesitonText .. "] value must be a number or nil")
                end
            else
                print("Custom quiz error | [" .. quesitonText .. "] options table needs more than one option")
            end
        else
            print("Custom quiz error | [" .. quesitonText .. "] options is not a table")
        end
    else
        print("Custom quiz error | questionText is not a string")
    end
    notify("Can't add custom question", "See the output for more information")
end

function CustomCategoryManager.scheduleRefresh()
    if not CustomCategoryManager.refreshScheduled then
        CustomCategoryManager.refreshScheduled = true
        task.defer(function()
            table.sort(categoriesToSend, sortAlphabetically)
            table.sort(categoriesToSendDetailed, sortAlphabetically)
            table.sort(categoryTable, sortAlphabetically)
            categoryDropdown:Refresh(categoryTable)
            CustomCategoryManager.refreshScheduled = false
        end)
    end
end

-- ===================== Leaderboard =====================
local function sortUserPoints(type)
    local array = {}
    for username, value in pairs(userPoints) do
        array[#array + 1] = {username, value[type], value.DisplayName}
    end
    table.sort(array, function(a, b) return a[2] > b[2] end)
    return array
end

medalEmojis = {"🥇 ", "🥈 ", "🥉 "}
sendLeaderboard = function (type, message, triggeredByUser)
    if triggeredByUser and quizRunning then
        notify("Can't send LB", "Stop the quiz or wait for it to end")
        return
    elseif currentlySending then
        notify(`{currentlySending} currently being sent`, "Wait before sending the leaderboard")
        return
    end
    currentlySending = "A LB is"
    local pointsArray
    message = message or ""
    if type == "Current quiz" then
        pointsArray = sortUserPoints("CurrentQuizPoints")
    else
        pointsArray = sortUserPoints("GlobalPoints")
    end
    task.wait(1.5)
    if triggeredByUser and quizRunning then
        currentlySending = nil
        return
    end
    local sentAny = false
    for i = 1, 3 do
        if pointsArray[i] and pointsArray[i][2] > 0 then
            sentAny = true
            break
        end
    end
    if sentAny then
        Chat(message .. type .. " leaderboard:")
        task.wait(2.5)
        sentAny = false
    end
    for i = 1, 3 do
        if pointsArray[i] and pointsArray[i][2] > 0 then
            local username = pointsArray[i][1]
            local displayName = pointsArray[i][3]
            local points = roundNumber(pointsArray[i][2], 1)
            local pointWord = if points > 1 then "points" else "point"
            local streakText = ""
            if settings.streakBonusEnabled and playerStreaks[username] and playerStreaks[username] >= STREAK_BONUS_THRESHOLD then
                streakText = " 🔥" .. playerStreaks[username]
            end
            task.wait(2.5)
            if triggeredByUser and quizRunning then
                currentlySending = nil
                return
            end
            Chat(medalEmojis[i] .. displayName .. " (@" .. username .. ") - " .. points .. " " .. pointWord .. streakText)
            UpdateSignText(medalEmojis[i] .. displayName)
            sentAny = true
        end
    end
    if not sentAny then
        Chat(message .. "No scores yet!")
    end
    task.wait(2.5)
    currentlySending = nil
end

sendTeamLeaderboard = function ()
    Chat("🏆 | Team Scores:")
    task.wait(2)
    Chat("🔴 Team A: " .. teamPoints.A .. " points")
    task.wait(2)
    Chat("🔵 Team B: " .. teamPoints.B .. " points")
    task.wait(2)
    if teamPoints.A > teamPoints.B then
        Chat("🎉 | Team A wins!")
    elseif teamPoints.B > teamPoints.A then
        Chat("🎉 | Team B wins!")
    else
        Chat("🤝 | It's a tie!")
    end
end

leaderboardLabels = {
    CurrentQuizPoints = {},
    GlobalPoints = {}
}

local function GetPointsAndUpdateLabels(type)
    local pointsArray = sortUserPoints(type)
    for index, label in leaderboardLabels[type] do
        if pointsArray[index] and pointsArray[index][2] > 0 then
            local username = pointsArray[index][1]
            local displayName = pointsArray[index][3]
            local points = roundNumber(pointsArray[index][2], 1)
            local pointWord = if points > 1 then "points" else "point"
            label:Set(`{medalEmojis[index]} {displayName} (@{username}) - {points} {pointWord}`)
        else
            label:Set(medalEmojis[index] .. " [Empty] - 0")
        end
    end
end

ClearLeaderboardLabels = function(type)
    for index, label in leaderboardLabels[type] do
        label:Set(medalEmojis[index] .. " [Empty] - 0")
    end
end

UpdateUILeaderboard = function(type)
    type = type or "All"
    if type == "All" then
        GetPointsAndUpdateLabels("GlobalPoints")
        GetPointsAndUpdateLabels("CurrentQuizPoints")
    else
        assert(leaderboardLabels[type], "Invalid leaderboard type")
        GetPointsAndUpdateLabels(type)
    end
end

-- ===================== Autoplay =====================
local autoplayChosenCategories = {}
autoPlayDifficulties = difficultyOrder

choseAutoplayCategory = function ()
    -- Check if every category in every active difficulty has been played; reset if so
    local autoplayComplete = true
    for _, difficulty in autoPlayDifficulties do
        if autoplayChosenCategories[difficulty] and not (#autoplayChosenCategories[difficulty] == numberOfCategoriesPerDifficulty[difficulty]) then
            autoplayComplete = false
            break
        elseif not autoplayChosenCategories[difficulty] and numberOfCategoriesPerDifficulty[difficulty] then
            autoplayComplete = false
            break
        end
    end
    if autoplayComplete then table.clear(autoplayChosenCategories) end

    -- Iterative pick instead of recursion to prevent stack overflow on small category tables
    local rng = Random.new()
    local maxAttempts = #categoryTable * 3 + 10
    for _ = 1, maxAttempts do
        local chosenCategory = categoryTable[rng:NextInteger(1, #categoryTable)]
        local chosenDifficulty = categoryLookupTable[chosenCategory][2]
        local alreadyPlayed = autoplayChosenCategories[chosenDifficulty]
            and table.find(autoplayChosenCategories[chosenDifficulty], chosenCategory)
        local difficultyAllowed = table.find(autoPlayDifficulties, chosenDifficulty)
        if not alreadyPlayed and difficultyAllowed then
            return chosenCategory
        end
    end
    -- Fallback: clear played list and pick anything to avoid a permanent block
    table.clear(autoplayChosenCategories)
    return categoryTable[rng:NextInteger(1, #categoryTable)]
end

isFreeToRunQuiz = function ()
    if quizRunning then
        notify("A quiz is currently running", "Stop the current quiz or wait for it to end")
        return false
    elseif quizCooldown then
        notify("Cooldown active", "Try again in a few seconds")
        return false
    end
    return true
end

-- Double points: if true the next question will be worth 2x
nextQuestionDoublePoints = false

-- Session stats
sessionStartTick = tick()
stats = {
    questionsAsked = 0,
    correctAnswers = 0,
    timeouts = 0,
    skips = 0,
    fastestAnswerTime = nil,       -- seconds
    fastestAnswerPlayer = nil,     -- display name
    totalAnswerTime = 0,           -- sum of answer times for averaging
    answeredQuestions = 0,         -- questions that got answered (for avg calc)
    playerCorrectCount = {},       -- [playerName] = count
}
local questionAskedTick = nil      -- set when a question is asked, used to time answers

-- Stats label refs (set in Stats tab)
statsLabels = {}
refreshStatsLabels = function ()
    if not statsLabels.questionsAsked then return end
    local sessionTime = formatUptime(tick() - sessionStartTick)
    local avgTime = stats.answeredQuestions > 0
        and string.format("%.1fs", stats.totalAnswerTime / stats.answeredQuestions)
        or "—"
    local fastestText = stats.fastestAnswerPlayer
        and (stats.fastestAnswerPlayer .. " (" .. string.format("%.1fs", stats.fastestAnswerTime) .. ")")
        or "—"
    -- Most active player
    local topPlayer, topCount = "—", 0
    for name, count in pairs(stats.playerCorrectCount) do
        if count > topCount then
            topCount = count
            local p = players:FindFirstChild(name)
            topPlayer = (p and p.DisplayName or name) .. " (" .. count .. ")"
        end
    end
    statsLabels.questionsAsked:Set("Questions asked: " .. stats.questionsAsked)
    statsLabels.correctAnswers:Set("Correct answers: " .. stats.correctAnswers)
    statsLabels.timeouts:Set("Timeouts: " .. stats.timeouts)
    statsLabels.skips:Set("Skips: " .. stats.skips)
    statsLabels.avgTime:Set("Avg answer time: " .. avgTime)
    statsLabels.fastest:Set("Fastest answer: " .. fastestText)
    statsLabels.topPlayer:Set("Most active player: " .. topPlayer)
    statsLabels.sessionTime:Set("Session duration: " .. sessionTime)
end

updateModeLabel = function ()
    if currentModeLabel then
        currentModeLabel:Set("Current mode: " .. mode)
    end
end

updateAutoplayLabel = function ()
    if autoplayStatusLabel then
        if settings.autoplay then
            autoplayStatusLabel:Set("Autoplay: ON")
        else
            autoplayStatusLabel:Set("Autoplay: OFF")
        end
    end
end

-- ===================== Category Vote =====================
startCategoryVote = function()
    if quizRunning then
        notify("Quiz already running", "Stop the current quiz first")
        return
    end
    if votingActive then
        notify("Vote in progress", "A category vote is already running")
        return
    end

    -- Pick 3 distinct random categories (respects autoplay difficulty filter)
    local rng = Random.new()
    local pool = {}
    for _, cat in categoryTable do
        local diff = categoryLookupTable[cat] and categoryLookupTable[cat][2]
        if diff and table.find(autoPlayDifficulties, diff) then
            table.insert(pool, cat)
        end
    end
    -- Fallback: use full table if filter leaves fewer than 3
    if #pool < 3 then pool = table.clone(categoryTable) end

    local options = {}
    local attempts = 0
    while #options < 3 and attempts < 200 do
        attempts += 1
        local pick = pool[rng:NextInteger(1, #pool)]
        if not table.find(options, pick) then
            table.insert(options, pick)
        end
    end
    if #options < 3 then
        notify("Not enough categories", "Need at least 3 categories to vote")
        return
    end

    -- Set up vote state
    votingActive = true
    voteData = {
        options = options,
        votes   = {},
        counts  = {0, 0, 0},
    }

    -- Send vote prompt — use Chat() directly with spacing, bypassing quizRunning/cooldown gates
    local function voteChat(msg)
        Chat(msg)
        task.wait(3)
    end

    voteChat("📊 | Vote for the next category! Type 1, 2 or 3 in chat")
    voteChat("1️⃣  " .. options[1])
    voteChat("2️⃣  " .. options[2])
    voteChat("3️⃣  " .. options[3])

    -- Wait for votes (25s remaining after the 4 messages above)
    task.wait(20)
    Chat("⏳ | 5 seconds left to vote!")
    task.wait(5)

    votingActive = false

    -- Tally — find winner, random tiebreak
    local maxVotes = math.max(voteData.counts[1], voteData.counts[2], voteData.counts[3])
    local winners = {}
    for i, count in voteData.counts do
        if count == maxVotes then table.insert(winners, i) end
    end
    -- Fallback: just pick option 1 if winners somehow empty
    local winIdx = #winners > 0 and winners[rng:NextInteger(1, #winners)] or 1
    local winner = voteData.options[winIdx]

    Chat("🗳️ | Results: 1️⃣ " .. voteData.counts[1] .. "  2️⃣ " .. voteData.counts[2] .. "  3️⃣ " .. voteData.counts[3])
    task.wait(3)
    Chat("✅ | Category chosen: " .. winner .. "!")
    task.wait(2)

    voteData = nil
    startQuiz(winner)
end

-- ===================== Start Quiz =====================
startQuiz = function (category)
    if not isFreeToRunQuiz() then return end
    quizRunning = true
    table.clear(playerStreaks)
    table.clear(skipVotes)
    pointManager.ClearQuizPoints()
    if quizStatusLabel then quizStatusLabel:Set("Quiz: Running — " .. category) end
    if questionCounterLabel then questionCounterLabel:Set("Question: 0/" .. #categoryLookupTable[category][1]) end

    if mode == "SuddenDeath" then
        initSuddenDeath()
        Chat("💀 | SUDDEN DEATH mode! One wrong answer and you're out!")
        task.wait(3)
    elseif mode == "Team" then
        teamPoints = {A = 0, B = 0}
        Chat("👥 | TEAM mode! Assigning teams...")
        task.wait(2)
        assignTeams()
        task.wait(3)
    end

    Chat('🚀 | Initiating "' .. category .. '" quiz...')
    UpdateSignText(category)
    task.wait(3)

    -- Build question list
    local questionList = {}
    if settings.trollMode then
        -- Troll mode: one random question pulled from a random category per slot
        local rng = Random.new()
        local normalCount = #categoryLookupTable[category][1]
        for i = 1, normalCount do
            local randomCategory = categoryTable[rng:NextInteger(1, #categoryTable)]
            local randomCategoryQuestions = categoryLookupTable[randomCategory][1]
            local randomQuestion = randomCategoryQuestions[rng:NextInteger(1, #randomCategoryQuestions)]
            table.insert(questionList, randomQuestion)
        end
    else
        for _, v in pairs(categoryLookupTable[category][1]) do
            table.insert(questionList, v)
        end
        questionList = shuffle(questionList)
    end

    local totalQuestions = #questionList
    local questionsSinceLastLB = 0  -- tracks questions since last mid-quiz LB send
    local sentMidQuizLB = false     -- tracks whether any mid-quiz LB was ever sent
    local questionNumber = 0
    for _, v in ipairs(questionList) do
        if not quizRunning then return end
        questionNumber += 1
        if questionCounterLabel then questionCounterLabel:Set("Question: " .. questionNumber .. "/" .. totalQuestions) end
        if questionPreviewLabel then questionPreviewLabel:Set("Current question: " .. v.mainQuestion) end

        if mode == "SuddenDeath" then
            local remaining, _ = getSuddenDeathSurvivorCount()
            if remaining <= 1 then break end
        end

        -- Apply double points if flagged
        local originalValue = v.value
        if nextQuestionDoublePoints then
            v.value = v.value * 2
            nextQuestionDoublePoints = false
        end

        local questionAsked = v:Ask()
        if questionAsked == false then
            v.value = originalValue -- restore in case it was doubled
            currentQuestion = nil
            questionAnsweredBy = nil
            task.wait(5)
            continue
        end
        awaitAnswer(v)
        v.value = originalValue -- always restore after asking
        if not quizRunning then return end
        task.wait(settings.betweenQuestionDelay)
        questionsSinceLastLB += 1
        if not quizRunning then return end
        -- only auto-send LB if sendLeaderBoardAfterQuestions > 0
        if settings.sendLeaderBoardAfterQuestions > 0
            and questionsSinceLastLB % settings.sendLeaderBoardAfterQuestions == 0
            and settings.automaticLeaderboards
            and settings.automaticCurrentQuizLeaderboard then
            sendLeaderboard("Current quiz", "📜 | ")
            questionsSinceLastLB = 0
            sentMidQuizLB = true
        end
    end

    task.wait(2)
    -- Send final current quiz LB if there are unanounced questions since the last mid-quiz send
    if settings.automaticLeaderboards and settings.automaticCurrentQuizLeaderboard
        and (questionsSinceLastLB > 0 or not sentMidQuizLB) then
        sendLeaderboard("Current quiz", "📜 | ")
    end

    if mode == "Team" then
        sendTeamLeaderboard()
    elseif settings.automaticLeaderboards and settings.automaticServerQuizLeaderboard then
        sendLeaderboard("Server", "🏆 | Quiz ended. ")
        task.wait(2)
    else
        SendMessageWhenReady("🏁 | Quiz ended")
        task.wait(3)
    end

    UpdateSignText(endMessage)
    task.delay(15, function()
        if not quizRunning then UpdateSignText("") end
    end)
    quizRunning = false
    if quizStatusLabel then quizStatusLabel:Set("Quiz: Idle") end
    if questionCounterLabel then questionCounterLabel:Set("Question: -/-") end
    if questionPreviewLabel then questionPreviewLabel:Set("Current question: —") end

    -- Save to history
    addToHistory(category)
    if refreshHistoryLabels then refreshHistoryLabels() end

    if settings.autoplay then
        if not autoplayChosenCategories[categoryLookupTable[category][2]] then
            autoplayChosenCategories[categoryLookupTable[category][2]] = {category}
        else
            table.insert(autoplayChosenCategories[categoryLookupTable[category][2]], category)
        end
        local chosenCategory = choseAutoplayCategory()
        Chat("🎲 | Next up: " .. chosenCategory .. "!")
        notify("Autoplay", "Next category: " .. chosenCategory)
        task.wait(6)
        startQuiz(chosenCategory)
    end
end

sendRules = function ()
    if quizRunning then
        notify("Can't send rules", "Stop the quiz or wait for it to end")
        return
    elseif currentlySending then
        notify(`{currentlySending} currently being sent`, "Wait before sending rules")
        return
    end
    currentlySending = "The rules are"
    local quizModeRules, kahootModeRules, suddenDeathRules, teamRules = buildRules()
    local ruleSet
    if mode == "Quiz" then
        SendChatMessage("📜 | Quiz mode rules:")
        ruleSet = quizModeRules
    elseif mode == "Kahoot" then
        SendChatMessage("📜 | Kahoot mode rules:")
        ruleSet = kahootModeRules
    elseif mode == "SuddenDeath" then
        SendChatMessage("📜 | Sudden Death mode rules:")
        ruleSet = suddenDeathRules
    elseif mode == "Team" then
        SendChatMessage("📜 | Team mode rules:")
        ruleSet = teamRules
    end
    task.wait(2)
    for _, rule in ipairs(ruleSet) do
        SendChatMessage(rule)
        task.wait(1)
    end
    currentlySending = nil
end

players.PlayerRemoving:Connect(function(player)
    if settings.removeLeavingPlayersFromLB then
        pointManager.RemoveAccount(player)
    end
    if not isEliminated(player.Name) then
        table.insert(eliminatedPlayers, player.Name)
        updateEliminatedLabel()
    end
    playerTeams[player.Name] = nil
    playerStreaks[player.Name] = nil
    -- Remove from skip votes if they leave mid-question
    local idx = table.find(skipVotes, player.Name)
    if idx then table.remove(skipVotes, idx) end
end)

local function getPlayerByPlayerName(name)
    if name then
        name = string.lower(name)
        for i, v in ipairs(players:GetPlayers()) do
            if string.lower(string.sub(v.Name, 1, #name)) == name then return v end
            if string.lower(string.sub(v.DisplayName, 1, #name)) == name then return v end
        end
        for i, v in ipairs(players:GetPlayers()) do
            if string.match(v.Name:lower(), name) then return v end
            if string.match(v.DisplayName:lower(), name) then return v end
        end
    end
end

getTargetPlayer = function (name)
    if name:lower() == "me" then
        return localPlayer
    end
    return getPlayerByPlayerName(name)
end

getCategoryName = function (name)
    if #name < 2 then return end
    name = name:lower()
    for _, category in categoryTable do
        if string.lower(string.sub(category, 1, #name)) == name then return category end
    end
end

end -- initQuiz

-- ===================== UI =====================
local function buildUI()
local library, window

-- Clear any cached Rayfield so the new URL is always fetched fresh
setgenv("rayfieldCached", nil)
setgenv("DISABLE_RAYFIELD_REQUESTS", nil)

local RAYFIELD_URLS = {
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/sirius-menu/rayfield/refs/heads/main/source.lua",
    "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua",
}

local success, errorMessage = pcall(function()
    for _, url in ipairs(RAYFIELD_URLS) do
        local ok, result = pcall(function()
            return loadstring(game:HttpGet(url, true))()
        end)
        if ok and result then
            library = result
            break
        end
    end
    if not library then
        error("All Rayfield URLs failed to load")
    end
    window = library:CreateWindow({
        Name = "quizbot v" .. VERSION .. " | Enhanced",
        LoadingTitle = "Loading quizbot...",
        LoadingSubtitle = "Enhanced Edition",
        ShowText = "quizbot",
        DisableRayfieldPrompts = true,
        DisableBuildWarnings = true,
        ToggleUIKeybind = Enum.KeyCode.RightShift,
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "quizbot",
            FileName = "quizbot_ui",
        },
        Theme = {
            TextColor = Color3.fromRGB(240, 240, 240),

            Background = Color3.fromRGB(10, 10, 10),
            Topbar = Color3.fromRGB(18, 18, 18),
            Shadow = Color3.fromRGB(0, 0, 0),

            NotificationBackground = Color3.fromRGB(18, 18, 18),
            NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

            TabBackground = Color3.fromRGB(30, 30, 30),
            TabStroke = Color3.fromRGB(50, 50, 50),
            TabBackgroundSelected = Color3.fromRGB(230, 230, 230),
            TabTextColor = Color3.fromRGB(180, 180, 180),
            SelectedTabTextColor = Color3.fromRGB(10, 10, 10),

            ElementBackground = Color3.fromRGB(22, 22, 22),
            ElementBackgroundHover = Color3.fromRGB(32, 32, 32),
            SecondaryElementBackground = Color3.fromRGB(15, 15, 15),
            ElementStroke = Color3.fromRGB(55, 55, 55),
            SecondaryElementStroke = Color3.fromRGB(40, 40, 40),

            SliderBackground = Color3.fromRGB(200, 200, 200),
            SliderProgress = Color3.fromRGB(240, 240, 240),
            SliderStroke = Color3.fromRGB(255, 255, 255),

            ToggleBackground = Color3.fromRGB(25, 25, 25),
            ToggleEnabled = Color3.fromRGB(220, 220, 220),
            ToggleDisabled = Color3.fromRGB(70, 70, 70),
            ToggleEnabledStroke = Color3.fromRGB(255, 255, 255),
            ToggleDisabledStroke = Color3.fromRGB(100, 100, 100),
            ToggleEnabledOuterStroke = Color3.fromRGB(160, 160, 160),
            ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 50),

            DropdownSelected = Color3.fromRGB(30, 30, 30),
            DropdownUnselected = Color3.fromRGB(20, 20, 20),

            InputBackground = Color3.fromRGB(20, 20, 20),
            InputStroke = Color3.fromRGB(70, 70, 70),
            PlaceholderColor = Color3.fromRGB(130, 130, 130),
        },
    })
end)
if not success then
    warn("quizbot error [UI LIB] | " .. tostring(errorMessage))
    -- Use StarterGui directly since notify may also fail if library didn't load
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "quizbot error",
            Text = "Failed to load UI. Check output for details.",
            Duration = 10,
        })
    end)
    return
end

-- Mobile toggle button (Rayfield handles RightShift natively on keyboard)
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    ContextActionService:BindAction("ToggleUI", function(_actionName, inputState, _inputObject)
        if inputState == Enum.UserInputState.Begin then
            library:SetVisibility(not library:IsVisible())
        end
    end, true)
    ContextActionService:SetImage("ToggleUI", "rbxassetid://100698995249426")
end

-- ===== Main Tab =====
local mainTab = window:CreateTab("Main", 74002778429106)

mainTab:CreateSection("Status")
currentModeLabel = mainTab:CreateLabel("Current mode: " .. mode)
autoplayStatusLabel = mainTab:CreateLabel("Autoplay: OFF")
quizStatusLabel = mainTab:CreateLabel("Quiz: Idle")
questionCounterLabel = mainTab:CreateLabel("Question: -/-")
local playerCountLabel = mainTab:CreateLabel("Players in server: " .. (#players:GetPlayers() - 1))
questionPreviewLabel = mainTab:CreateLabel("Current question: —")

-- Keep player count live
players.PlayerAdded:Connect(function()
    playerCountLabel:Set("Players in server: " .. (#players:GetPlayers() - 1))
end)
players.PlayerRemoving:Connect(function()
    task.defer(function()
        playerCountLabel:Set("Players in server: " .. (#players:GetPlayers() - 1))
    end)
end)

mainTab:CreateSection("Category selection")
local categoryLabel
local selectedCategory
mainTab:CreateInput({
    Name = "Category",
    PlaceholderText = "Type to search a category",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        selectedCategory = getCategoryName(value)
        if selectedCategory then
            categoryLabel:Set("Selected category: " .. selectedCategory)
            categoryDropdown:Set({selectedCategory})
        end
    end
})
categoryDropdown = mainTab:CreateDropdown({
    Name = "Category",
    Options = categoryTable,
    CurrentOption = "Select a category",
    Callback = function(option)
        selectedCategory = option[1]
        categoryLabel:Set("Selected category: " .. selectedCategory)
    end
})
mainTab:CreateButton({
    Name = "Send category list in chat",
    Callback = sendCategories
})

mainTab:CreateSection("Quiz controls")
categoryLabel = mainTab:CreateLabel("Selected category: None")
mainTab:CreateButton({
    Name = "Start quiz",
    Callback = function()
        if categoryLookupTable[selectedCategory] then
            task.spawn(function() startQuiz(selectedCategory) end)
        else
            notify("Invalid category", "Select a valid category to start the quiz")
        end
    end
})
mainTab:CreateButton({
    Name = "Stop quiz",
    Callback = function()
        if quizRunning then
            quizCooldown = true
            quizRunning = false
            currentQuestion = nil
            questionAnsweredBy = nil
            awaitingAnswer = false
            cancelHintCoroutine()
            table.clear(skipVotes)
            if quizStatusLabel then quizStatusLabel:Set("Quiz: Idle") end
            if questionCounterLabel then questionCounterLabel:Set("Question: -/-") end
            task.delay(5, function() quizCooldown = false end)
            notify("Quiz stopped", "The quiz has been stopped")
        else
            notify("No quiz running", "There is no quiz to stop")
        end
    end
})
mainTab:CreateButton({
    Name = "Ask server if they want a quiz",
    Callback = function()
        if quizRunning then
            notify("Quiz already running", "A quiz is already in progress")
            return
        end
        Chat("❓ | Anyone want a quiz? Let me know!")
    end
})
mainTab:CreateButton({
    Name = "Skip current question",
    Callback = function()
        if not quizRunning or not currentQuestion then
            notify("No active question", "There is no question to skip")
            return
        end
        cancelHintCoroutine()
        currentQuestion = nil
        questionAnsweredBy = nil
        table.clear(skipVotes)
        Chat("⏭️ | Question skipped by host.")
        notify("Question skipped", "Moved to the next question")
    end
})
mainTab:CreateButton({
    Name = "Send hint now",
    Callback = function()
        if not quizRunning or not currentQuestion then
            notify("No active question", "Start a quiz first")
            return
        end
        if questionAnsweredBy then
            notify("Already answered", "This question has already been answered")
            return
        end
        local answer = currentQuestion.answers[currentQuestion.rightAnswerIndex]
        local hint = generateHint(answer)
        cancelHintCoroutine()
        Chat("💡 | Hint: " .. hint)
    end
})
mainTab:CreateButton({
    Name = "Make next question double points",
    Callback = function()
        if not quizRunning then
            notify("No quiz running", "Start a quiz first")
            return
        end
        if nextQuestionDoublePoints then
            nextQuestionDoublePoints = false
            notify("Double points cancelled", "Next question will be normal points")
        else
            nextQuestionDoublePoints = true
            Chat("⭐⭐ | The next question will be worth DOUBLE points!")
            notify("Double points set", "Next question will be 2x points")
        end
    end
})
mainTab:CreateButton({
    Name = "Announce survivors (Sudden Death)",
    Callback = function()
        if mode ~= "SuddenDeath" then
            notify("Not in Sudden Death mode", "Switch to Sudden Death mode first")
            return
        end
        local survivors = {}
        for _, p in players:GetPlayers() do
            if p ~= localPlayer and not isEliminated(p.Name) then
                table.insert(survivors, p.DisplayName)
            end
        end
        if #survivors == 0 then
            Chat("💀 | No survivors remaining!")
        else
            Chat("💚 | Still alive (" .. #survivors .. "): " .. table.concat(survivors, ", "))
        end
    end
})

mainTab:CreateSection("Autoplay")
mainTab:CreateToggle({
    Name = "Autoplay quizzes automatically",
    CurrentValue = settings.autoplay,
    Flag = "Autoplay",
    Callback = function(value)
        settings.autoplay = value
        updateAutoplayLabel()
        if value then EnableAntiAfk() end
    end
})

for _, difficulty in difficultyOrder do
    if numberOfCategoriesPerDifficulty[difficulty] and numberOfCategoriesPerDifficulty[difficulty] > 0 then
        if difficulty == "" then difficulty = "missing difficulty" end
        table.insert(autoplayFilterDifficulties, difficulty)
    end
end
autoplayFilterDropdown = mainTab:CreateDropdown({
    Name = "Autoplay filter (unselect all to disable filter)",
    Options = autoplayFilterDifficulties,
    MultipleOptions = true,
    Callback = function(options)
        local filteredTable = table.clone(options)
        if #options == 0 then
            filteredTable = difficultyOrder
        elseif table.find(filteredTable, "missing difficulty") then
            filteredTable[table.find(filteredTable, "missing difficulty")] = ""
        end
        autoPlayDifficulties = filteredTable
    end
})
mainTab:CreateButton({
    Name = "Play random quiz",
    Callback = function()
        if isFreeToRunQuiz() then
            local chosenCategory = choseAutoplayCategory()
            notify("Random quiz chosen", "Starting: " .. chosenCategory)
            task.spawn(function() startQuiz(chosenCategory) end)
        end
    end
})
mainTab:CreateButton({
    Name = "Vote for category (30s)",
    Callback = function()
        task.spawn(function() startCategoryVote() end)
    end
})



do -- Leaderboard Tab
-- ===== Leaderboard Tab =====
local leaderboardTab = window:CreateTab("Leaderboard", 97885193604839)
leaderboardTab:CreateSection("Server leaderboard (doesn't reset)")
for i = 1, 3 do
    table.insert(leaderboardLabels.GlobalPoints, leaderboardTab:CreateLabel(medalEmojis[i] .. " [Empty] - 0"))
end
leaderboardTab:CreateButton({
    Name = "Send server leaderboard in chat",
    Callback = function() task.spawn(function() sendLeaderboard("Server", "🏆 | ", true) end) end
})

leaderboardTab:CreateSection("Current quiz leaderboard (resets every quiz)")
for i = 1, 3 do
    table.insert(leaderboardLabels.CurrentQuizPoints, leaderboardTab:CreateLabel(medalEmojis[i] .. " [Empty] - 0"))
end
leaderboardTab:CreateButton({
    Name = "Send current quiz leaderboard in chat",
    Callback = function() task.spawn(function() sendLeaderboard("Current quiz", "📜 | ", true) end) end
})

leaderboardTab:CreateSection("Team Mode")
leaderboardTab:CreateButton({
    Name = "Send team scores in chat",
    Callback = function()
        if mode ~= "Team" then
            notify("Not in team mode", "Switch to Team mode first")
            return
        end
        task.spawn(sendTeamLeaderboard)
    end
})
leaderboardTab:CreateButton({
    Name = "Re-assign teams",
    Callback = function()
        if mode ~= "Team" then
            notify("Not in team mode", "Switch to Team mode in Settings first")
            return
        end
        if not quizRunning then
            notify("No quiz running", "Teams are assigned at the start of a quiz")
            return
        end
        task.spawn(function()
            Chat("👥 | Re-assigning teams...")
            task.wait(1)
            assignTeams()
        end)
    end
})

leaderboardTab:CreateSection("Reset points")
leaderboardTab:CreateButton({
    Name = "Reset all points",
    Callback = function()
        notify("Confirm reset", "Press Reset again to confirm", {
            Button1 = "Reset",
            Button2 = "Cancel",
            Callback = function(choice)
                if choice == "Reset" then
                    pointManager.ResetAllPoints()
                    notify("Points reset", "All points and streaks have been cleared")
                end
            end
        })
    end
})
leaderboardTab:CreateButton({
    Name = "Reset all streaks",
    Callback = function()
        table.clear(playerStreaks)
        notify("Streaks cleared", "All player streaks have been reset to 0")
    end
})

end -- Leaderboard Tab

-- ===== Player Controls Tab =====
do -- Player Controls Tab
local playerControlTab = window:CreateTab("Player controls", 100068360107422)
local targetPlayer
local targetPlayerLabel
playerControlTab:CreateSection("Select target")
playerControlTab:CreateInput({
    Name = "Target",
    PlaceholderText = "Enter target name",
    Callback = function(value)
        if #value < 1 then return end
        targetPlayer = getTargetPlayer(value)
        if targetPlayer then
            targetPlayerLabel:Set(`Target: {targetPlayer.DisplayName} (@{targetPlayer.Name})`)
        else
            targetPlayerLabel:Set("Target: None (not found)")
        end
    end
})

local function TargetExists(target)
    if not target then
        notify("Invalid target", "Specify a target player")
        return false
    end
    return true
end

targetPlayerLabel = playerControlTab:CreateLabel("Target: None")

playerControlTab:CreateSection("Modify points")
local pointsToAdd
playerControlTab:CreateInput({
    Name = "Amount of points",
    PlaceholderText = "Enter points amount",
    Callback = function(value)
        if value and tonumber(value) then pointsToAdd = tonumber(value) end
    end
})
playerControlTab:CreateButton({
    Name = "Apply points",
    Callback = function()
        if not TargetExists(targetPlayer) then return end
        if pointsToAdd then
            pointManager.AddPoints(targetPlayer, pointsToAdd, "GlobalPoints")
            notify("Points added", pointsToAdd .. " server points added to " .. targetPlayer.Name)
        else
            notify("Enter a point amount", "Enter an amount of points to add")
        end
    end
})
playerControlTab:CreateButton({
    Name = "Remove all points from player",
    Callback = function()
        if not TargetExists(targetPlayer) then return end
        pointManager.RemoveAccount(targetPlayer)
        notify("Points reset", "Removed all points from " .. targetPlayer.Name)
    end
})

playerControlTab:CreateSection("Streak controls")
playerControlTab:CreateButton({
    Name = "Reset target player streak",
    Callback = function()
        if not TargetExists(targetPlayer) then return end
        resetStreak(targetPlayer.Name)
        notify("Streak reset", targetPlayer.Name .. "'s streak has been reset")
    end
})
playerControlTab:CreateButton({
    Name = "Show target player streak",
    Callback = function()
        if not TargetExists(targetPlayer) then return end
        local streak = getStreak(targetPlayer.Name)
        notify("Streak info", targetPlayer.DisplayName .. " has a streak of " .. streak)
    end
})

playerControlTab:CreateSection("Sudden Death")
eliminatedLabel = playerControlTab:CreateLabel("Eliminated: None")
playerControlTab:CreateButton({
    Name = "Eliminate target player",
    Callback = function()
        if not TargetExists(targetPlayer) then return end
        if mode ~= "SuddenDeath" then
            notify("Not in Sudden Death mode", "Switch to Sudden Death mode first")
            return
        end
        eliminatePlayer(targetPlayer)
        notify("Player eliminated", targetPlayer.DisplayName .. " has been manually eliminated")
    end
})
playerControlTab:CreateButton({
    Name = "Revive target player",
    Callback = function()
        if not TargetExists(targetPlayer) then return end
        local idx = table.find(eliminatedPlayers, targetPlayer.Name)
        if idx then
            table.remove(eliminatedPlayers, idx)
            suddenDeathLives[targetPlayer.Name] = settings.suddenDeathLives
            updateEliminatedLabel()
            notify("Player revived", targetPlayer.DisplayName .. " has been revived!")
            Chat("💚 | " .. targetPlayer.DisplayName .. " has been revived!")
        else
            notify("Player is not eliminated", targetPlayer.Name .. " hasn't been eliminated")
        end
    end
})
playerControlTab:CreateButton({
    Name = "Show remaining players",
    Callback = function()
        if mode ~= "SuddenDeath" then
            notify("Not in Sudden Death mode", "Switch to Sudden Death mode first")
            return
        end
        local remaining, _ = getSuddenDeathSurvivorCount()
        notify("Survivors", remaining .. " players still in the game")
    end
})

playerControlTab:CreateSection("Block")
playerControlTab:CreateButton({
    Name = "Block from participating",
    Callback = function()
        if not TargetExists(targetPlayer) then return end
        if not table.find(blockedPlayers, targetPlayer.Name) then
            table.insert(blockedPlayers, targetPlayer.Name)
            notify("Player blocked", targetPlayer.Name .. " has been blocked")
        else
            notify("Can't block player", targetPlayer.Name .. " is already blocked")
        end
    end
})
playerControlTab:CreateButton({
    Name = "Unblock from participating",
    Callback = function()
        if not TargetExists(targetPlayer) then return end
        local idx = table.find(blockedPlayers, targetPlayer.Name)
        if idx then
            table.remove(blockedPlayers, idx)
            notify("Player unblocked", targetPlayer.Name .. " is no longer blocked")
        else
            notify("Can't unblock player", targetPlayer.Name .. " is not blocked")
        end
    end
})
playerControlTab:CreateButton({
    Name = "Unblock all",
    Callback = function()
        notify("Unblocked everyone", #blockedPlayers .. " players have been unblocked")
        table.clear(blockedPlayers)
    end
})

playerControlTab:CreateSection("Whitelist")
playerControlTab:CreateToggle({
    Name = "Enable whitelist",
    CurrentValue = whiteListEnabled,
    Callback = function(value) whiteListEnabled = value end
})
playerControlTab:CreateButton({
    Name = "Whitelist target",
    Callback = function()
        if not TargetExists(targetPlayer) then return end
        if not table.find(whiteListedplayers, targetPlayer.Name) then
            table.insert(whiteListedplayers, targetPlayer.Name)
            local status = if whiteListEnabled then "whitelist is enabled" else "whitelist is currently disabled"
            notify("Player whitelisted", targetPlayer.Name .. " whitelisted. " .. status)
        else
            notify("Already whitelisted", targetPlayer.Name .. " is already on the whitelist")
        end
    end
})
playerControlTab:CreateButton({
    Name = "Unwhitelist target",
    Callback = function()
        if not TargetExists(targetPlayer) then return end
        local idx = table.find(whiteListedplayers, targetPlayer.Name)
        if idx then
            table.remove(whiteListedplayers, idx)
            notify("Player removed from whitelist", targetPlayer.Name .. " removed")
        else
            notify("Not whitelisted", targetPlayer.Name .. " is not on the whitelist")
        end
    end
})
playerControlTab:CreateButton({
    Name = "Clear whitelist",
    Callback = function()
        notify("Whitelist cleared", #whiteListedplayers .. " players removed")
        table.clear(whiteListedplayers)
    end
})

end -- Player Controls Tab

-- ===== Settings Tab =====
local settingsTab = window:CreateTab("Settings", 112502172419483)
settingsTab:CreateSection("Select mode")
settingsTab:CreateDropdown({
    Name = "Mode",
    Options = {"Quiz", "Kahoot", "SuddenDeath", "Team"},
    CurrentOption = mode,
    Flag = "QuizMode",
    Callback = function(option)
        mode = option[1]
        updateModeLabel()
        writeToDataFile("setting_mode", mode)
        local modeMessages = {
            Quiz = "❓ | Quiz mode enabled",
            Kahoot = "✉️ | Kahoot mode enabled",
            SuddenDeath = "💀 | Sudden Death mode enabled",
            Team = "👥 | Team mode enabled",
        }
        if modeMessages[mode] then
            Chat(modeMessages[mode])
        end
    end
})
settingsTab:CreateButton({
    Name = "Send rules in chat",
    Callback = function() task.spawn(sendRules) end
})

settingsTab:CreateSection("Time settings")
settingsTab:CreateInput({
    Name = "Question timeout (seconds)",
    PlaceholderText = tostring(settings.questionTimeout),
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            settings.questionTimeout = num
            writeToDataFile("setting_questionTimeout", num)
        end
    end
})
settingsTab:CreateInput({
    Name = "User cooldown on wrong answer",
    PlaceholderText = tostring(settings.userCooldown),
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 then
            settings.userCooldown = num
            writeToDataFile("setting_userCooldown", num)
        end
    end
})

settingsTab:CreateSection("Hint settings")
settingsTab:CreateToggle({
    Name = "Enable hints",
    CurrentValue = settings.hintEnabled,
    Flag = "HintsEnabled",
    Callback = function(value)
        settings.hintEnabled = value
    end
})
settingsTab:CreateInput({
    Name = "Hint delay (seconds after options are said)",
    PlaceholderText = tostring(settings.hintDelay),
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 then
            settings.hintDelay = num
            writeToDataFile("setting_hintDelay", num)
        end
    end
})

settingsTab:CreateSection("Skip vote settings")
settingsTab:CreateToggle({
    Name = "Enable skip voting (!skip in chat)",
    CurrentValue = settings.skipVotingEnabled,
    Flag = "SkipVotingEnabled",
    Callback = function(value)
        settings.skipVotingEnabled = value
    end
})
settingsTab:CreateInput({
    Name = "Votes needed to skip",
    PlaceholderText = tostring(SKIP_VOTES_NEEDED),
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 1 then
            SKIP_VOTES_NEEDED = math.floor(num)
            writeToDataFile("setting_SKIP_VOTES_NEEDED", SKIP_VOTES_NEEDED)
        end
    end
})

settingsTab:CreateSection("Streak settings")
settingsTab:CreateToggle({
    Name = "Enable streak bonuses",
    CurrentValue = settings.streakBonusEnabled,
    Flag = "StreakBonusEnabled",
    Callback = function(value)
        settings.streakBonusEnabled = value
    end
})
settingsTab:CreateToggle({
    Name = "Show streak announcements in chat",
    CurrentValue = settings.showStreakInChat,
    Flag = "ShowStreakInChat",
    Callback = function(value)
        settings.showStreakInChat = value
    end
})
settingsTab:CreateInput({
    Name = "Streak threshold (streaks of X+ give bonus)",
    PlaceholderText = tostring(STREAK_BONUS_THRESHOLD),
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 2 then
            STREAK_BONUS_THRESHOLD = math.floor(num)
            writeToDataFile("setting_STREAK_BONUS_THRESHOLD", STREAK_BONUS_THRESHOLD)
        end
    end
})

settingsTab:CreateSection("Sudden Death settings")
settingsTab:CreateInput({
    Name = "Lives per player",
    PlaceholderText = tostring(settings.suddenDeathLives),
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 1 then
            settings.suddenDeathLives = math.floor(num)
            writeToDataFile("setting_suddenDeathLives", settings.suddenDeathLives)
        end
    end
})

settingsTab:CreateSection("Leaderboard settings")
settingsTab:CreateToggle({
    Name = "Remove leaving players from leaderboard",
    CurrentValue = settings.removeLeavingPlayersFromLB,
    Flag = "RemoveLeavingPlayers",
    Callback = function(value)
        settings.removeLeavingPlayersFromLB = value
    end
})
settingsTab:CreateInput({
    Name = "Send current quiz LB every X questions (0 = off)",
    PlaceholderText = tostring(settings.sendLeaderBoardAfterQuestions),
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 then
            settings.sendLeaderBoardAfterQuestions = math.floor(num)
            writeToDataFile("setting_sendLeaderBoardAfterQuestions", settings.sendLeaderBoardAfterQuestions)
            if num > 0 and not settings.automaticCurrentQuizLeaderboard then
                notify("Current quiz LB is disabled", "Enable it in settings first")
            end
        end
    end
})

settingsTab:CreateDivider()
local disableBothLeaderboardsToggle, disableCurrentLeaderboardToggle, disableServerLeaderboardToggle
local originalSettings = {not settings.automaticCurrentQuizLeaderboard, not settings.automaticServerQuizLeaderboard}
disableBothLeaderboardsToggle = settingsTab:CreateToggle({
    Name = "Disable automatic sending of both leaderboards",
    CurrentValue = not settings.automaticLeaderboards,
    Flag = "DisableBothLBs",
    Callback = function(value)
        settings.automaticLeaderboards = not value
        if value then
            originalSettings = {not settings.automaticCurrentQuizLeaderboard, not settings.automaticServerQuizLeaderboard}
            disableCurrentLeaderboardToggle:Set(true)
            disableServerLeaderboardToggle:Set(true)
        else
            disableCurrentLeaderboardToggle:Set(originalSettings[1])
            disableServerLeaderboardToggle:Set(originalSettings[2])
        end
    end
})
disableCurrentLeaderboardToggle = settingsTab:CreateToggle({
    Name = "Disable automatic sending of current quiz LB",
    CurrentValue = not settings.automaticCurrentQuizLeaderboard or not settings.automaticLeaderboards,
    Flag = "DisableCurrentLB",
    Callback = function(value)
        if value == false and settings.automaticLeaderboards == false then
            originalSettings = {false, not settings.automaticServerQuizLeaderboard}
            settings.automaticLeaderboards = true
            disableBothLeaderboardsToggle:Set(false)
        end
        settings.automaticCurrentQuizLeaderboard = not value
    end
})
disableServerLeaderboardToggle = settingsTab:CreateToggle({
    Name = "Disable automatic sending of server LB",
    CurrentValue = not settings.automaticServerQuizLeaderboard or not settings.automaticLeaderboards,
    Flag = "DisableServerLB",
    Callback = function(value)
        if value == false and settings.automaticLeaderboards == false then
            originalSettings = {not settings.automaticCurrentQuizLeaderboard, false}
            settings.automaticLeaderboards = true
            disableBothLeaderboardsToggle:Set(false)
        end
        settings.automaticServerQuizLeaderboard = not value
    end
})

settingsTab:CreateSection("Miscellaneous settings")
settingsTab:CreateToggle({
    Name = "Troll mode (announces selected category, plays random questions)",
    CurrentValue = settings.trollMode,
    Flag = "TrollMode",
    Callback = function(value)
        settings.trollMode = value
        if value then
            notify("Troll mode ON", "Players will see the category you pick but get random questions")
        end
    end
})
settingsTab:CreateToggle({
    Name = "Do not repeat tagged messages",
    CurrentValue = not settings.repeatTagged,
    Flag = "DontRepeatTagged",
    Callback = function(value) settings.repeatTagged = not value end
})
settingsTab:CreateToggle({
    Name = "Send detailed category list in chat (may get tagged)",
    CurrentValue = settings.sendDetailedCategorylist,
    Flag = "DetailedCategoryList",
    Callback = function(value) settings.sendDetailedCategorylist = value end
})
if boothGame then
    settingsTab:CreateToggle({
        Name = "Disable sign status (booth game only)",
        Flag = "DisableSign",
        Callback = function(value) settings.signStatus = not value end
    })
    settingsTab:CreateToggle({
        Name = "Don't use roman numbers for sign timer",
        Flag = "NoRomanNumbers",
        Callback = function(value) settings.romanNumbers = not value end
    })
end
settingsTab:CreateSection("Disable script")
settingsTab:CreateButton({
    Name = "Destroy UI and disable script",
    Callback = function()
        chatConnection:Disconnect()
        quizCooldown = true
        quizRunning = false
        currentQuestion = nil
        questionAnsweredBy = nil
        awaitingAnswer = false
        cancelHintCoroutine()
        table.clear(skipVotes)
        pcall(function() ContextActionService:UnbindAction("ToggleUI") end)
        library:Destroy()
        setgenv("QUIZBOT_RUNNING", false)
    end
})

do -- History Tab
-- ===== History Tab =====
local historyTab = window:CreateTab("History", 71624534813660)

historyTab:CreateSection("Recently played categories")
local historyLabels = {}
for i = 1, MAX_HISTORY do
    table.insert(historyLabels, historyTab:CreateLabel(i .. ". —"))
end

local function refreshHistoryLabels()
    local history = getHistory()
    for i, label in historyLabels do
        if history[i] then
            label:Set(i .. ". " .. history[i])
        else
            label:Set(i .. ". —")
        end
    end
end

refreshHistoryLabels()

historyTab:CreateButton({
    Name = "Play most recent category again",
    Callback = function()
        local history = getHistory()
        if not history[1] then
            notify("No history", "You haven't played any categories yet this session")
            return
        end
        if not categoryLookupTable[history[1]] then
            notify("Category not found", history[1] .. " no longer exists")
            return
        end
        if isFreeToRunQuiz() then
            task.spawn(function() startQuiz(history[1]) end)
        end
    end
})
historyTab:CreateButton({
    Name = "Clear history",
    Callback = function()
        writeToDataFile("quiz_history", {})
        refreshHistoryLabels()
        notify("History cleared", "Quiz history has been wiped")
    end
})

historyTab:CreateSection("Bonus question")
historyTab:CreateLabel("Fire a single question without starting a full quiz.")
local bonusQuestionText = ""
local bonusAnswers = {"", "", "", ""}
historyTab:CreateInput({
    Name = "Question text",
    PlaceholderText = "Enter your question",
    Callback = function(value) bonusQuestionText = value end
})
historyTab:CreateInput({
    Name = "Correct answer (A)",
    PlaceholderText = "Correct answer",
    Callback = function(value) bonusAnswers[1] = value end
})
historyTab:CreateInput({
    Name = "Wrong answer B",
    PlaceholderText = "Wrong answer",
    Callback = function(value) bonusAnswers[2] = value end
})
historyTab:CreateInput({
    Name = "Wrong answer C",
    PlaceholderText = "Wrong answer (optional)",
    Callback = function(value) bonusAnswers[3] = value end
})
historyTab:CreateInput({
    Name = "Wrong answer D",
    PlaceholderText = "Wrong answer (optional)",
    Callback = function(value) bonusAnswers[4] = value end
})
historyTab:CreateButton({
    Name = "Fire bonus question",
    Callback = function()
        if quizRunning then
            notify("Quiz already running", "Stop the current quiz first")
            return
        end
        if bonusQuestionText == "" then
            notify("No question text", "Enter a question first")
            return
        end
        if bonusAnswers[1] == "" or bonusAnswers[2] == "" then
            notify("Not enough answers", "Enter at least a correct answer and one wrong answer")
            return
        end
        -- Build answer list — filter out empty optional answers
        local answerList = {}
        for _, v in ipairs(bonusAnswers) do
            if v ~= "" then table.insert(answerList, v) end
        end
        local bonusQ = question.New(bonusQuestionText, answerList, 1)
        task.spawn(function()
            quizRunning = true
            if quizStatusLabel then quizStatusLabel:Set("Quiz: Bonus question") end
            bonusQ:Ask()
            awaitAnswer(bonusQ)
            quizRunning = false
            if quizStatusLabel then quizStatusLabel:Set("Quiz: Idle") end
            if questionCounterLabel then questionCounterLabel:Set("Question: -/-") end
            if questionPreviewLabel then questionPreviewLabel:Set("Current question: —") end
        end)
    end
})

end -- History Tab

do -- Server Info + Server Hop Tabs
-- ===== Server Info Tab =====
local serverInfoTab = window:CreateTab("Server Info", 80889399720196)

local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local serverStartTick = tick()

local function getServerInfo()
    local info = {}
    local placeInfo = {}
    pcall(function()
        placeInfo = game:GetService("MarketplaceService"):GetProductInfo(placeId)
    end)

    local playerList = players:GetPlayers()
    local playerNames = {}
    local premiumCount = 0
    local totalAccountAge = 0
    for _, p in playerList do
        table.insert(playerNames, p.DisplayName .. " (@" .. p.Name .. ")")
        if p.MembershipType == Enum.MembershipType.Premium then
            premiumCount += 1
        end
        totalAccountAge += p.AccountAge
    end
    local avgAge = #playerList > 0 and math.floor(totalAccountAge / #playerList) or 0

    info.placeName = placeInfo.Name or "Unknown"
    info.placeId = tostring(placeId)
    info.jobId = game.JobId ~= "" and game.JobId or "Unknown"
    info.playerCount = #playerList
    info.maxPlayers = game:GetService("Players").MaxPlayers
    info.premiumCount = premiumCount
    info.avgAccountAge = avgAge
    info.uptime = formatUptime(tick() - serverStartTick)
    info.gravity = tostring(workspace.Gravity)
    info.playerList = playerNames
    info.isStudio = RunService:IsStudio()
    info.gameVersion = tostring(game.PlaceVersion)

    return info
end

serverInfoTab:CreateSection("Live server info")
local siPlaceName    = serverInfoTab:CreateLabel("Game: —")
local siPlaceId      = serverInfoTab:CreateLabel("Place ID: —")
local siJobId        = serverInfoTab:CreateLabel("Server ID: —")
local siPlayers      = serverInfoTab:CreateLabel("Players: —")
local siPremium      = serverInfoTab:CreateLabel("Premium players: —")
local siAvgAge       = serverInfoTab:CreateLabel("Avg account age: —")
local siUptime       = serverInfoTab:CreateLabel("Server uptime: —")
local siGravity      = serverInfoTab:CreateLabel("Gravity: —")
local siVersion      = serverInfoTab:CreateLabel("Place version: —")
local siStudio       = serverInfoTab:CreateLabel("Running in Studio: —")

local function refreshServerInfoLabels()
    local info = getServerInfo()
    siPlaceName:Set("Game: " .. info.placeName)
    siPlaceId:Set("Place ID: " .. info.placeId)
    siJobId:Set("Server ID: " .. info.jobId)
    siPlayers:Set("Players: " .. info.playerCount .. "/" .. info.maxPlayers)
    siPremium:Set("Premium players: " .. info.premiumCount)
    siAvgAge:Set("Avg account age: " .. info.avgAccountAge .. " days")
    siUptime:Set("Server uptime: " .. info.uptime)
    siGravity:Set("Gravity: " .. info.gravity)
    siVersion:Set("Place version: " .. info.gameVersion)
    siStudio:Set("Running in Studio: " .. tostring(info.isStudio))
end

refreshServerInfoLabels()

-- Auto-refresh uptime every 5s
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            siUptime:Set("Server uptime: " .. formatUptime(tick() - serverStartTick))
            siPlayers:Set("Players: " .. #players:GetPlayers() .. "/" .. players.MaxPlayers)
        end)
    end
end)

serverInfoTab:CreateButton({
    Name = "Refresh info",
    Callback = function()
        pcall(refreshServerInfoLabels)
        notify("Refreshed", "Server info updated")
    end
})

serverInfoTab:CreateSection("Send to chat")
serverInfoTab:CreateButton({
    Name = "Send server info in chat",
    Callback = function()
        local info = getServerInfo()
        task.spawn(function()
            SendChatMessage("📊 | Server Info:")
            SendChatMessage("🎮 Game: " .. info.placeName .. " | Place ID: " .. info.placeId)
            SendChatMessage("👥 Players: " .. info.playerCount .. "/" .. info.maxPlayers .. " | Premium: " .. info.premiumCount)
            SendChatMessage("⏱ Uptime: " .. info.uptime .. " | Version: " .. info.gameVersion)
            SendChatMessage("🌍 Gravity: " .. info.gravity .. " | Avg account age: " .. info.avgAccountAge .. " days")
        end)
    end
})
serverInfoTab:CreateButton({
    Name = "Send player list in chat",
    Callback = function()
        local info = getServerInfo()
        task.spawn(function()
            SendChatMessage("👥 | Players in server (" .. info.playerCount .. "):")
            local chunk = {}
            for i, name in ipairs(info.playerList) do
                table.insert(chunk, name)
                if #chunk == 3 or i == #info.playerList then
                    SendChatMessage(table.concat(chunk, ", "))
                    table.clear(chunk)
                end
            end
        end)
    end
})
serverInfoTab:CreateButton({
    Name = "Copy server ID to clipboard",
    Callback = function()
        local jobId = game.JobId
        if jobId ~= "" then
            pcall(setclipboard, jobId)
            notify("Copied", "Server ID copied to clipboard")
        else
            notify("Unavailable", "Server ID not available (Studio?)")
        end
    end
})

-- ===== Server Hopper Tab =====
local serverHopTab = window:CreateTab("Server Hop", 97397006436785)

local fetchedServers = {}

local function fetchServers(callback)
    task.spawn(function()
        local ok, result = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100&sortOrder=Asc"
            -- Executors expose their own http function; HttpService:RequestAsync is server-side only
            local httpFunc = request or http_request or (syn and syn.request)
            if not httpFunc then
                error("No HTTP function available on this executor")
            end
            local response = httpFunc({
                Url = url,
                Method = "GET",
            })
            if response and response.StatusCode == 200 then
                return HttpService:JSONDecode(response.Body)
            end
            return nil
        end)
        if ok and result and result.data then
            callback(result.data)
        else
            callback(nil)
        end
    end)
end

serverHopTab:CreateSection("Quick hop")
local serverHopStatus = serverHopTab:CreateLabel("Status: Idle")

serverHopTab:CreateButton({
    Name = "Join random server",
    Callback = function()
        serverHopStatus:Set("Status: Fetching servers...")
        fetchServers(function(servers)
            if not servers or #servers == 0 then
                serverHopStatus:Set("Status: No servers found")
                notify("No servers found", "Could not fetch server list")
                return
            end
            -- Filter out current server and full servers
            local valid = {}
            for _, s in ipairs(servers) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    table.insert(valid, s)
                end
            end
            if #valid == 0 then
                serverHopStatus:Set("Status: No other servers available")
                notify("No servers", "No other servers available to hop to")
                return
            end
            local chosen = valid[math.random(#valid)]
            serverHopStatus:Set("Status: Joining server...")
            notify("Joining server", "Players: " .. chosen.playing .. "/" .. chosen.maxPlayers)
            task.wait(1)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(placeId, chosen.id, localPlayer)
            end)
        end)
    end
})

serverHopTab:CreateButton({
    Name = "Rejoin current game (new server)",
    Callback = function()
        serverHopStatus:Set("Status: Rejoining...")
        pcall(function()
            TeleportService:Teleport(placeId, localPlayer)
        end)
    end
})

serverHopTab:CreateSection("Server list")
serverHopTab:CreateLabel("Refresh to load, select a page, enter a number and join.")

local SERVERS_PER_PAGE = 15
local MAX_PAGES = 6
local currentPage = 1
local serverListLabels = {}

-- Create 15 labels for the current page
for i = 1, SERVERS_PER_PAGE do
    table.insert(serverListLabels, serverHopTab:CreateLabel(i .. ". [Not loaded]"))
end

local function getServerEntry(page, slot)
    return fetchedServers[(page - 1) * SERVERS_PER_PAGE + slot]
end

local function refreshPageLabels(page)
    for i = 1, SERVERS_PER_PAGE do
        local s = getServerEntry(page, i)
        local globalIndex = (page - 1) * SERVERS_PER_PAGE + i
        if s then
            local current = s.id == game.JobId and " ← YOU" or ""
            local full = s.playing >= s.maxPlayers and " [FULL]" or ""
            serverListLabels[i]:Set(globalIndex .. ". " .. s.playing .. "/" .. s.maxPlayers .. " players" .. full .. current)
        else
            serverListLabels[i]:Set(globalIndex .. ". [Empty]")
        end
    end
end

serverHopTab:CreateDropdown({
    Name = "Page",
    Options = {"Page 1 (1-15)", "Page 2 (16-30)", "Page 3 (31-45)", "Page 4 (46-60)", "Page 5 (61-75)", "Page 6 (76-90)"},
    CurrentOption = "Page 1 (1-15)",
    Callback = function(option)
        local pageNum = tonumber(option[1]:match("Page (%d+)"))
        if pageNum then
            currentPage = pageNum
            refreshPageLabels(currentPage)
        end
    end
})

local selectedServerNumber = nil
serverHopTab:CreateInput({
    Name = "Server number to join",
    PlaceholderText = "Enter global number (e.g. 17 for page 2 slot 2)",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 1 and num <= SERVERS_PER_PAGE * MAX_PAGES then
            selectedServerNumber = math.floor(num)
        end
    end
})

serverHopTab:CreateButton({
    Name = "Join selected server",
    Callback = function()
        if not selectedServerNumber then
            notify("No server selected", "Enter a server number first")
            return
        end
        local s = fetchedServers[selectedServerNumber]
        if not s then
            notify("Not loaded", "That server slot is empty or not fetched yet")
            return
        end
        if s.id == game.JobId then
            notify("Already here", "You are already in this server")
            return
        end
        serverHopStatus:Set("Status: Joining server " .. selectedServerNumber .. "...")
        notify("Joining", "Players: " .. s.playing .. "/" .. s.maxPlayers)
        task.wait(1)
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, s.id, localPlayer)
        end)
    end
})

serverHopTab:CreateButton({
    Name = "Refresh server list",
    Callback = function()
        serverHopStatus:Set("Status: Fetching servers...")
        table.clear(fetchedServers)
        for i = 1, SERVERS_PER_PAGE do
            serverListLabels[i]:Set(i .. ". [Loading...]")
        end
        fetchServers(function(servers)
            if not servers or #servers == 0 then
                serverHopStatus:Set("Status: No servers found")
                for i = 1, SERVERS_PER_PAGE do
                    serverListLabels[i]:Set(i .. ". [No servers found]")
                end
                notify("No servers found", "Could not fetch server list")
                return
            end
            local count = math.min(#servers, SERVERS_PER_PAGE * MAX_PAGES)
            for i = 1, count do
                fetchedServers[i] = servers[i]
            end
            -- Reset any beyond what we got
            for i = count + 1, SERVERS_PER_PAGE * MAX_PAGES do
                fetchedServers[i] = nil
            end
            currentPage = 1
            refreshPageLabels(currentPage)
            serverHopStatus:Set("Status: Loaded " .. count .. " servers")
            notify("Server list loaded", count .. " servers across " .. math.ceil(count / SERVERS_PER_PAGE) .. " pages")
        end)
    end
})

end -- Server Info + Server Hop Tabs

-- ===== Stats Tab =====
local statsTab = window:CreateTab("Stats", 108774730729455)

statsTab:CreateSection("Session stats")
statsLabels.questionsAsked = statsTab:CreateLabel("Questions asked: 0")
statsLabels.correctAnswers = statsTab:CreateLabel("Correct answers: 0")
statsLabels.timeouts = statsTab:CreateLabel("Timeouts: 0")
statsLabels.skips = statsTab:CreateLabel("Skips: 0")
statsLabels.avgTime = statsTab:CreateLabel("Avg answer time: —")
statsLabels.fastest = statsTab:CreateLabel("Fastest answer: —")
statsLabels.topPlayer = statsTab:CreateLabel("Most active player: —")
statsLabels.sessionTime = statsTab:CreateLabel("Session duration: —")

-- Auto-refresh session duration every 5s
task.spawn(function()
    while task.wait(5) do
        pcall(refreshStatsLabels)
    end
end)

statsTab:CreateButton({
    Name = "Refresh stats",
    Callback = function()
        refreshStatsLabels()
    end
})

statsTab:CreateSection("Send to chat")
statsTab:CreateButton({
    Name = "Send session stats in chat",
    Callback = function()
        local avgTime = stats.answeredQuestions > 0
            and string.format("%.1fs", stats.totalAnswerTime / stats.answeredQuestions)
            or "N/A"
        local fastestText = stats.fastestAnswerPlayer
            and (stats.fastestAnswerPlayer .. " in " .. string.format("%.1fs", stats.fastestAnswerTime))
            or "N/A"
        local topPlayer, topCount = "N/A", 0
        for name, count in pairs(stats.playerCorrectCount) do
            if count > topCount then
                topCount = count
                local p = players:FindFirstChild(name)
                topPlayer = (p and p.DisplayName or name) .. " (" .. count .. " correct)"
            end
        end
        task.spawn(function()
            Chat("📊 | Session Stats:")
            task.wait(2.5)
            Chat("❓ Questions: " .. stats.questionsAsked .. " | ✔ Correct: " .. stats.correctAnswers .. " | ⏰ Timeouts: " .. stats.timeouts .. " | ⏭ Skips: " .. stats.skips)
            task.wait(2.5)
            Chat("⚡ Fastest: " .. fastestText .. " | ⏱ Avg time: " .. avgTime)
            task.wait(2.5)
            Chat("🏆 Most active: " .. topPlayer)
        end)
    end
})

statsTab:CreateSection("Reset")
statsTab:CreateButton({
    Name = "Reset session stats",
    Callback = function()
        stats.questionsAsked = 0
        stats.correctAnswers = 0
        stats.timeouts = 0
        stats.skips = 0
        stats.fastestAnswerTime = nil
        stats.fastestAnswerPlayer = nil
        stats.totalAnswerTime = 0
        stats.answeredQuestions = 0
        table.clear(stats.playerCorrectCount)
        sessionStartTick = tick()
        refreshStatsLabels()
        notify("Stats reset", "All session stats cleared")
    end
})

-- ===== Script Hub Tab =====
local scriptHubTab = window:CreateTab("Script Hub", 80478986427724)

scriptHubTab:CreateSection("Scripts")
scriptHubTab:CreateLabel("Click a script to load it. A confirmation prompt will appear first.")

-- Helper: creates a hub button with a confirm prompt before executing
local function hubScript(name, url)
    scriptHubTab:CreateButton({
        Name = name,
        Callback = function()
            notify("Run script?", "Load and execute: " .. name, {
                Button1 = "Run",
                Button2 = "Cancel",
                Callback = function(choice)
                    if choice == "Run" then
                        local ok, err = pcall(function()
                            loadstring(game:HttpGet(url, true))()
                        end)
                        if not ok then
                            notify("Script failed", tostring(err))
                        end
                    end
                end
            }, 10)
        end
    })
end

hubScript("Fly GUI", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
hubScript("Fling GUI", "https://raw.githubusercontent.com/K1LAS1K/Ultimate-Fling-GUI/main/flingscript.lua")
hubScript("Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
hubScript("Dark Dex (Explorer)", "https://raw.githubusercontent.com/LorekeeperZinnia/Dex/master/Dex.lua")

scriptHubTab:CreateSection("Coming Soon")
scriptHubTab:CreateLabel("More scripts will be added in future updates.")

-- ===== Universal Tab =====
do
local universalTab = window:CreateTab("Universal", 80478986427724)

local lp = game:GetService("Players").LocalPlayer
local function getChar() return lp.Character or lp.CharacterAdded:Wait() end
local function getHum() return getChar():FindFirstChildOfClass("Humanoid") end

-- ===================== Speed =====================
universalTab:CreateSection("Speed")
local speedEnabled = false
local defaultSpeed = 16
local customSpeed = 50
local speedConnection

universalTab:CreateInput({
    Name = "Speed value",
    PlaceholderText = "Default: 50",
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then customSpeed = n end
        if speedEnabled then
            local hum = getHum()
            if hum then hum.WalkSpeed = customSpeed end
        end
    end
})
universalTab:CreateToggle({
    Name = "Speed boost",
    CurrentValue = false,
    Callback = function(value)
        speedEnabled = value
        local hum = getHum()
        if not hum then return end
        if value then
            hum.WalkSpeed = customSpeed
            if speedConnection then speedConnection:Disconnect() end
            speedConnection = lp.CharacterAdded:Connect(function(char)
                local h = char:WaitForChild("Humanoid")
                if speedEnabled then h.WalkSpeed = customSpeed end
            end)
        else
            hum.WalkSpeed = defaultSpeed
            if speedConnection then speedConnection:Disconnect() speedConnection = nil end
        end
    end
})

-- ===================== Jump =====================
universalTab:CreateSection("Jump")
local jumpEnabled = false
local customJump = 100
local jumpConnection

universalTab:CreateInput({
    Name = "Jump power value",
    PlaceholderText = "Default: 100",
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then customJump = n end
        if jumpEnabled then
            local hum = getHum()
            if hum then hum.JumpPower = customJump end
        end
    end
})
universalTab:CreateToggle({
    Name = "Jump boost",
    CurrentValue = false,
    Callback = function(value)
        jumpEnabled = value
        local hum = getHum()
        if not hum then return end
        if value then
            hum.JumpPower = customJump
            if jumpConnection then jumpConnection:Disconnect() end
            jumpConnection = lp.CharacterAdded:Connect(function(char)
                local h = char:WaitForChild("Humanoid")
                if jumpEnabled then h.JumpPower = customJump end
            end)
        else
            hum.JumpPower = 50
            if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
        end
    end
})

local infiniteJumpEnabled = false
local ijConnection
universalTab:CreateToggle({
    Name = "Infinite jump",
    CurrentValue = false,
    Callback = function(value)
        infiniteJumpEnabled = value
        if value then
            ijConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if infiniteJumpEnabled then
                    local hum = getHum()
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end)
        else
            if ijConnection then ijConnection:Disconnect() ijConnection = nil end
        end
    end
})

-- ===================== Noclip =====================
universalTab:CreateSection("Noclip")
local noclipEnabled = false
local noclipConnection

universalTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(value)
        noclipEnabled = value
        if value then
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                if not noclipEnabled then return end
                local char = getChar()
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
            local char = getChar()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
})

-- ===================== ESP =====================
universalTab:CreateSection("ESP")
local espEnabled = false
local espHighlights = {}
local espCharConnections = {}
local espPlayerAddedConnection

local function clearESP()
    for _, h in pairs(espHighlights) do
        pcall(function() h:Destroy() end)
    end
    table.clear(espHighlights)
    for _, c in pairs(espCharConnections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(espCharConnections)
end

local function addESP(player)
    if player == lp then return end
    local function applyHighlight(char)
        pcall(function()
            if espHighlights[player.Name] then
                espHighlights[player.Name]:Destroy()
            end
            local h = Instance.new("Highlight")
            h.FillColor = Color3.fromRGB(255, 50, 50)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.FillTransparency = 0.5
            h.OutlineTransparency = 0
            h.Adornee = char
            h.Parent = char
            espHighlights[player.Name] = h
        end)
    end
    if player.Character then applyHighlight(player.Character) end
    espCharConnections[player.Name] = player.CharacterAdded:Connect(function(char)
        if espEnabled then applyHighlight(char) end
    end)
end

universalTab:CreateToggle({
    Name = "Player ESP (red highlight)",
    CurrentValue = false,
    Callback = function(value)
        espEnabled = value
        if value then
            for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                addESP(p)
            end
            if espPlayerAddedConnection then espPlayerAddedConnection:Disconnect() end
            espPlayerAddedConnection = game:GetService("Players").PlayerAdded:Connect(function(p)
                if espEnabled then addESP(p) end
            end)
        else
            if espPlayerAddedConnection then
                espPlayerAddedConnection:Disconnect()
                espPlayerAddedConnection = nil
            end
            clearESP()
        end
    end
})

end -- Universal Tab

-- ===== The Chosen One Tab =====
local tcoTab = window:CreateTab("The Chosen One", 80478986427724)

-- ── Time Tracker ─────────────────────────────────────────────
tcoTab:CreateSection("Server Time Tracker")
tcoTab:CreateLabel("Tracks your time in this server from your leaderstats.")

local timeLabel = tcoTab:CreateLabel("Server Time: checking...")
local timeTrackerRunning = false
local timeTrackerConnection = nil

local function getServerTime()
    local player = game:GetService("Players").LocalPlayer
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return nil end
    for _, v in leaderstats:GetChildren() do
        if v:IsA("NumberValue") or v:IsA("IntValue") then
            return v.Name, v.Value
        end
    end
    return nil
end

tcoTab:CreateToggle({
    Name = "Track Server Time",
    CurrentValue = false,
    Callback = function(value)
        if value then
            timeTrackerRunning = true
            timeTrackerConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local name, val = getServerTime()
                if name and val then
                    local minutes = math.floor(val / 60)
                    local seconds = val % 60
                    timeLabel:Set("Server Time (" .. name .. "): " .. string.format("%d:%02d", minutes, seconds))
                else
                    timeLabel:Set("Server Time: leaderstats not found")
                end
            end)
        else
            timeTrackerRunning = false
            if timeTrackerConnection then
                timeTrackerConnection:Disconnect()
                timeTrackerConnection = nil
            end
            timeLabel:Set("Server Time: tracking stopped")
        end
    end
})

-- ── Building Diagnostic ───────────────────────────────────────
tcoTab:CreateSection("Building")
tcoTab:CreateLabel("Check if ReplicatedStorage.Brick is present or missing.")

tcoTab:CreateButton({
    Name = "Run Building Diagnostic",
    Callback = function()
        local rs = game:GetService("ReplicatedStorage")
        local brick = rs:FindFirstChild("Brick")
        local getPos = rs:FindFirstChild("GetPos")
        local buildGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Build")

        local lines = {}
        if brick then
            table.insert(lines, "✓ Brick exists — Size: " .. tostring(brick.Size))
        else
            table.insert(lines, "✗ Brick is MISSING — building is broken!")
        end
        if getPos then
            table.insert(lines, "✓ GetPos exists")
        else
            table.insert(lines, "✗ GetPos is MISSING")
        end
        if buildGui then
            table.insert(lines, "✓ Build GUI exists (Enabled: " .. tostring(buildGui.Enabled) .. ")")
        else
            table.insert(lines, "✗ Build GUI missing")
        end

        notify("Building Diagnostic", table.concat(lines, "\n"))
    end
})

-- ── Break Building (testing only) ────────────────────────────
tcoTab:CreateSection("Break Building")
tcoTab:CreateLabel("For testing in private servers only. Requires Delete tool in character.")

tcoTab:CreateButton({
    Name = "Break Building (priv server only!)",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
        if not char then
            notify("Error", "No character found")
            return
        end
        local deleteTool = char:FindFirstChild("Delete") or player.Backpack:FindFirstChild("Delete")
        if not deleteTool then
            notify("Error", "Delete tool not found — equip bkit first")
            return
        end
        local event = deleteTool:FindFirstChild("Event", true)
        local brick = game:GetService("ReplicatedStorage"):FindFirstChild("Brick")
        if not event then
            notify("Error", "Delete remote not found")
            return
        end
        if not brick then
            notify("Error", "Brick already missing — building already broken")
            return
        end
        event:FireServer(brick, char.HumanoidRootPart.Position)
        notify("Break Building", "Fired. Building should now be broken.")
    end
})

-- ── Server Hopper ─────────────────────────────────────────────
tcoTab:CreateSection("Server Hopper")
tcoTab:CreateLabel("Hops to a server with the most players (less likely to be broken).")

local httpService = game:GetService("HttpService")
local teleportService = game:GetService("TeleportService")
local tcoHopCursor = ""
local tcoHopping = false

tcoTab:CreateButton({
    Name = "Hop to new server",
    Callback = function()
        if tcoHopping then return end
        tcoHopping = true
        notify("Server Hop", "Fetching servers...")

        local ok, result = pcall(function()
            local url = "https://games.roblox.com/v1/games/"
                .. game.PlaceId
                .. "/servers/Public?sortOrder=Asc&limit=25&cursor="
                .. tcoHopCursor
            local response = request({ Url = url, Method = "GET" })
            return httpService:JSONDecode(response.Body)
        end)

        if not ok then
            notify("Server Hop", "Failed to fetch servers.")
            tcoHopping = false
            return
        end

        tcoHopCursor = result.nextPageCursor or ""

        local candidates = {}
        for _, server in ipairs(result.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                table.insert(candidates, server)
            end
        end

        if #candidates == 0 then
            notify("Server Hop", "No other servers found.")
            tcoHopping = false
            return
        end

        -- Pick server with most players
        table.sort(candidates, function(a, b) return a.playing > b.playing end)
        local target = candidates[1]

        notify("Server Hop", "Joining server with " .. target.playing .. " players...")
        pcall(function()
            teleportService:TeleportToPlaceInstance(game.PlaceId, target.id, game:GetService("Players").LocalPlayer)
        end)
        tcoHopping = false
    end
})



end -- buildUI

local function main()

local KEY = "pigeonrobber"
local KEY_FILE = "quizbot_key.txt"
local keyPassed = false

do
    local alreadyUnlocked = false
    if isfile and isfile(KEY_FILE) then
        local ok, saved = pcall(readfile, KEY_FILE)
        if ok and saved == KEY then
            alreadyUnlocked = true
        end
    end

    if alreadyUnlocked then
        keyPassed = true
    else
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "QuizbotKeyUI"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
        if not screenGui.Parent then
            screenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
        end

        local backdrop = Instance.new("Frame")
        backdrop.Size = UDim2.fromScale(1, 1)
        backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        backdrop.BackgroundTransparency = 0.4
        backdrop.BorderSizePixel = 0
        backdrop.Parent = screenGui

        local card = Instance.new("Frame")
        card.Size = UDim2.fromOffset(420, 240)
        card.Position = UDim2.fromScale(0.5, 0.5)
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        card.BorderSizePixel = 0
        card.Parent = screenGui

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 6)
        cardCorner.Parent = card

        local cardStroke = Instance.new("UIStroke")
        cardStroke.Color = Color3.fromRGB(60, 60, 60)
        cardStroke.Thickness = 1
        cardStroke.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 44)
        title.Position = UDim2.fromOffset(0, 18)
        title.BackgroundTransparency = 1
        title.Text = "quizbot"
        title.TextColor3 = Color3.fromRGB(240, 240, 240)
        title.TextSize = 22
        title.Font = Enum.Font.GothamBold
        title.Parent = card

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, 0, 0, 22)
        sub.Position = UDim2.fromOffset(0, 58)
        sub.BackgroundTransparency = 1
        sub.Text = "Enter your key to continue"
        sub.TextColor3 = Color3.fromRGB(140, 140, 140)
        sub.TextSize = 13
        sub.Font = Enum.Font.Gotham
        sub.Parent = card

        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(1, -48, 0, 38)
        inputBox.Position = UDim2.fromOffset(24, 102)
        inputBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        inputBox.BorderSizePixel = 0
        inputBox.Text = ""
        inputBox.PlaceholderText = "Key..."
        inputBox.TextColor3 = Color3.fromRGB(230, 230, 230)
        inputBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
        inputBox.TextSize = 14
        inputBox.Font = Enum.Font.Gotham
        inputBox.ClearTextOnFocus = false
        inputBox.Parent = card

        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 4)
        inputCorner.Parent = inputBox

        local inputStroke = Instance.new("UIStroke")
        inputStroke.Color = Color3.fromRGB(55, 55, 55)
        inputStroke.Thickness = 1
        inputStroke.Parent = inputBox

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, -48, 0, 18)
        statusLabel.Position = UDim2.fromOffset(24, 148)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = ""
        statusLabel.TextColor3 = Color3.fromRGB(200, 80, 80)
        statusLabel.TextSize = 12
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = card

        local continueBtn = Instance.new("TextButton")
        continueBtn.Size = UDim2.new(1, -48, 0, 38)
        continueBtn.Position = UDim2.fromOffset(24, 172)
        continueBtn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
        continueBtn.BorderSizePixel = 0
        continueBtn.Text = "Continue"
        continueBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
        continueBtn.TextSize = 14
        continueBtn.Font = Enum.Font.GothamBold
        continueBtn.Parent = card

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = continueBtn

        local unlocked = false
        local function tryUnlock()
            local entered = inputBox.Text:lower():gsub("%s+", "")
            if entered == KEY then
                unlocked = true
                statusLabel.TextColor3 = Color3.fromRGB(80, 200, 80)
                statusLabel.Text = "\xe2\x9c\x94 Key accepted!"
                continueBtn.Text = "Loading..."
                if writefile then
                    pcall(writefile, KEY_FILE, KEY)
                end
                task.wait(0.8)
                screenGui:Destroy()
            else
                statusLabel.TextColor3 = Color3.fromRGB(200, 80, 80)
                statusLabel.Text = "\xe2\x9c\x98 Incorrect key."
                local orig = card.Position
                for i = 1, 4 do
                    card.Position = orig + UDim2.fromOffset(i % 2 == 0 and 6 or -6, 0)
                    task.wait(0.04)
                end
                card.Position = orig
            end
        end

        continueBtn.MouseButton1Click:Connect(tryUnlock)
        inputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then tryUnlock() end
        end)

        while screenGui.Parent and not unlocked do
            task.wait(0.1)
        end

        if unlocked then
            keyPassed = true
        end
    end
end

if not keyPassed then return end
-- ===================== End Key System =====================

initCore()
initQuiz()
buildUI()

end -- close main()
main()
