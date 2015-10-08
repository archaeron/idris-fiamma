module Main

import Fiamma

doc : Markup
doc = html <!> lang "en" $ do
	head $ do
		meta <!> charset "utf-8"
		meta <!> httpEquiv "X-UA-Compatible" <!> content "IE=edge,chrome=1"
		title $ text "OMG HAI LOL"
		meta <!> name "description" <!> content "YES OMG HAI LOL"
		meta <!> name "viewport" <!> content "width=device-width"
		link <!> rel "stylesheet" <!> href "css/screen.css"
	body $ do
		h1 $ text "OMG HAI LOL"
		p $ text "This is clearly the best Markup DSL ever invented."

main : IO ()
main =
	putStrLn $ renderMarkup doc
