You can launch Chibi Scheme something like this, from this srfi subdirectory:

LD_LIBRARY_PATH=".:/usr/local/src/chibi-scheme" DYLD_LIBRARY_PATH=".:/usr/local/src/chibi-scheme" CHIBI_IGNORE_SYSTEM_PATH=1 CHIBI_MODULE_PATH=".:/usr/local/src/chibi-scheme/lib" /usr/local/src/chibi-scheme/chibi-scheme 

You can add -m "(plist)" at the end to import the SRFI sample implimentation, or enter the usual (import (plist)) at the REPL.

This will run the test suite:

LD_LIBRARY_PATH=".:/usr/local/src/chibi-scheme" DYLD_LIBRARY_PATH=".:/usr/local/src/chibi-scheme" CHIBI_IGNORE_SYSTEM_PATH=1 CHIBI_MODULE_PATH=".:/usr/local/src/chibi-scheme/lib" /usr/local/src/chibi-scheme/chibi-scheme -m "(plist-test)" -e "(run-tests)"

You should see output something like this:

%%%% Starting test plists  (Writing full log to "plists.log")
# of expected passes      41
