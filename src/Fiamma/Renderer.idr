module Fiamma.Renderer

import Fiamma.Markup

%access public export

--| A NOde
data Node
	= Element String (List Attr) (List Node)
	| Text String

toNodes : Markup -> List Node
toNodes (MkElement name (Just children) attrs rest) =
	Element name attrs (toNodes children) :: toNodes rest
toNodes (MkElement name Nothing attrs rest) =
	Element name attrs Nil :: toNodes rest
toNodes (MkContent text rest) = Text text :: toNodes rest
toNodes (MkReturn _) = Nil

renderAttr : Attr -> String
renderAttr (MkAttr key val) = " " ++ key ++ "=\"" ++ val ++ "\""

renderAttrs : List Attr -> String
renderAttrs attrs =
	concat (map renderAttr attrs)

renderNode : Node -> String
renderNode (Element name a c) =
	"<" ++ name ++ renderAttrs a ++ showTail c
		where
			showTail : List Node -> String
			showTail Nil = "/>"
			showTail c =
				">" ++ (concat (map renderNode c)) ++ "</" ++ name ++ ">"
renderNode (Text s) = s

renderMarkup : Markup -> String
renderMarkup = concat . (map renderNode) . toNodes
