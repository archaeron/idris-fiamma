# Idris Fiamma

Idris port of [purescript-smolder](https://github.com/bodil/purescript-smolder)

## Example

```idris
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
```

Results in:

```html
<html lang="en"><head><meta charset="utf-8"/><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/><title>OMG HAI LOL</title><meta name="description" content="YES OMG HAI LOL"/><meta name="viewport" content="width=device-width"/><link rel="stylesheet" href="css/screen.css"/></head><body><h1>OMG HAI LOL</h1><p>This is clearly the best Markup DSL ever invented.</p></body></html>
```
