-- All the extensions and imports
{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveFoldable #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE StandaloneKindSignatures #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RoleAnnotations #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE PolyKinds #-}

import Data.List
import Data.Maybe
import Data.Either
import Data.Foldable
import Data.Traversable
import Data.Functor
import Data.Bifunctor
import Data.Ord
import Data.Int
import Data.Word
import Data.Bool
import Data.Char
import Data.Function (on, (&))
import Data.Kind
import Control.Applicative
import Control.Monad
import Data.Map qualified as Map
import Data.Map qualified as M
import Data.Set qualified as Set
import Data.Set qualified as S
import Data.IntSet qualified as ISet
import Data.IntMap.Lazy qualified as IMap
import Data.HashMap.Lazy qualified as HMap
import System.IO
import Text.Read
import Data.List.Split
