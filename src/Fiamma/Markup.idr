module Fiamma.Markup

data Attr = MkAttr String String

data Attribute = MkAttribute (List Attr)

instance Semigroup Attribute where
	(MkAttribute xs) <+> (MkAttribute ys) = MkAttribute (xs <+> ys)

instance Monoid Attribute where
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

class Attributable a where
	withAttribute : a -> Attribute -> a

instance Attributable Markup where
	withAttribute (MkElement el kids attrs rest) (MkAttribute xs) = MkElement el kids (attrs ++ xs) rest

instance Attributable (Markup -> Markup) where
	withAttribute k xs m = k m `withAttribute` xs

infixl 4 <!>

(<!>) : Attributable a => a -> Attribute -> a
(<!>) = withAttribute

instance Functor MarkupM where
	map f (MkElement el kids attrs rest) = MkElement el kids attrs (map f rest)
	map f (MkContent s rest) = MkContent s (map f rest)
	map f (MkReturn a) = MkReturn (f a)

mutual
	instance Applicative MarkupM where
		pure = MkReturn
		(<*>) f a =
			do
				f' <- f
				a' <- a
				return (f' a')

	instance Monad MarkupM where
		(>>=) (MkElement el kids attrs rest) f = MkElement el kids attrs (rest >>= f)
		(>>=) (MkContent s rest) f = MkContent s (rest >>= f)
		(>>=) (MkReturn a) f = f a

instance Semigroup (MarkupM a) where
  x <+> y = x *> y

instance Monoid (MarkupM Unit) where
  neutral = MkReturn ()
