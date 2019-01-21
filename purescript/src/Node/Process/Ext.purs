module Node.Process.Ext (columns, rows) where

import Effect (Effect)

foreign import columns :: Effect Int

foreign import rows :: Effect Int

