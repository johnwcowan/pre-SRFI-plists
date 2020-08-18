Launch Chibi Scheme like this:

LD_LIBRARY_PATH=".:/usr/local/src/chibi-scheme" DYLD_LIBRARY_PATH=".:/usr/local/src/chibi-scheme" CHIBI_IGNORE_SYSTEM_PATH=1 CHIBI_MODULE_PATH=".:/usr/local/src/chibi-scheme/lib" /usr/local/src/chibi-scheme/chibi-scheme 

> (import (plist))
> plist->alist
#<procedure plist->alist>
> (plist->alist '(k1 v1 k2 v2))
((k1 . v1) (k2 . v2))

> (import (plist-test))
> (run-tests)
%%%% Starting test plists  (Writing full log to "plists.log")
# of expected passes      41
