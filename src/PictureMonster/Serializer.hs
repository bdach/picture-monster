-- | Module used to serialize data passing through the application.
-- TODO: Maybe do this with Conduit?
module PictureMonster.Serializer (serializeSession) where

import Network.URI
import PictureMonster.Data
import System.IO

-- | Serializes the data associated with a session to the supplied 'Handle'.
serializeSession :: Handle      -- 'Handle' of the file to write to.
                 -> SessionData -- 'SessionData' object to be serialized.
                 -> IO ()
serializeSession handle session = header handle >>
    putUris handle (uris session) >>
    putDepth handle (depth session) >>
    putExtension handle (extension session) >>
    putTargetDir handle (targetDir session)

-- | Prints the header of the file.
header :: Handle -> IO ()
header handle = hPutStrLn handle "# Picture Monster" >>
    hPutStrLn handle "## Session information"

-- | Prints a list of 'URI's, formatted as a bullet list, to the handle.
putUris :: Handle -> [URI] -> IO ()
putUris handle uris = hPutStrLn handle "* URLs found:" >>
    mapM_ (\uri -> hPutStr handle "\t- " >> backquote handle (show uri)) uris

-- | Prints 'SearchDepth' information to the handle.
putDepth :: Handle -> SearchDepth -> IO ()
putDepth handle depth = hPutStr handle "* Maximum search depth: " >> hPutStrLn handle (show depth)

-- | Prints the desired file extension to the handle.
putExtension :: Handle -> Maybe String -> IO ()
putExtension handle extension = hPutStr handle "* Target file extension: " >>
    case extension of
        Nothing     -> hPutStrLn handle "None"
        Just ext    -> backquote handle ext

-- | Prints the target directory path to the handle.
putTargetDir :: Handle -> FilePath -> IO ()
putTargetDir handle path = hPutStr handle "* Target directory: " >> backquote handle path

-- | Prints the supplied string in backquotes to the handle.
backquote :: Handle -> String -> IO ()
backquote handle str = hPutStr handle "`" >> hPutStr handle str >> hPutStrLn handle "`"