module Fiamma.Markup

%access public export

data Attr = MkAttr String String

data Attribute = MkAttribute (List Attr)

implementation Semigroup Attribute where
	(MkAttribute xs) <+> (MkAttribute ys) = MkAttribute (xs <+> ys)

implementation Monoid Attribute where
	neutral = MkAttribute neutral

mutual
	data MarkupM a
		= MkElement String (Maybe Markup) (List Attr) (MarkupM a)
		| MkContent String (MarkupM a)
		| MkReturn a

	Markup : Type
	Markup = MarkupM Unit

attribute : String -> String -> Attribute
attribute key value = MkAttribute [MkAttr key value]

text : String -> Markup
text s = MkContent s (MkReturn ())

parent : String -> Markup -> Markup
parent el kids = MkElement el (Just kids) [] (MkReturn ())

leaf : String -> Markup
leaf el = MkElement el Nothing [] (MkReturn ())

interface Attributable a where
	withAttribute : a -> Attribute -> a

implementation Attributable Markup where
	withAttribute (MkElement el kids attrs rest) (MkAttribute xs) = MkElement el kids (attrs ++ xs) rest

implementation Attributable (Markup -> Markup) where
	withAttribute k xs m = k m `withAttribute` xs

infixl 4 <!>

(<!>) : Attributable a => a -> Attribute -> a
(<!>) = withAttribute

implementation Functor MarkupM where
	map f (MkElement el kids attrs rest) = MkElement el kids attrs (map f rest)
	map f (MkContent s rest) = MkContent s (map f rest)
	map f (MkReturn a) = MkReturn (f a)

mutual
	implementation Applicative MarkupM where
		pure = MkReturn
		(<*>) f a =
			do
				f' <- f
				a' <- a
				return (f' a')

	implementation Monad MarkupM where
		(>>=) (MkElement el kids attrs rest) f = MkElement el kids attrs (rest >>= f)
		(>>=) (MkContent s rest) f = MkContent s (rest >>= f)
		(>>=) (MkReturn a) f = f a

implementation Semigroup (MarkupM a) where
  x <+> y = x *> y

implementation Monoid (MarkupM Unit) where
  neutral = MkReturn ()
