h1. Domainatrix

"http://github.com/pauldix/domainatrix":http://github.com/pauldix/domainatrix

h2. Summary

A cruel mistress that uses the public suffix domain list to dominate URLs by canonicalizing, finding public suffixes, and breaking them into their domain parts.

h2. Description

This simple library can parse a URL into its canonical form. It uses the list of domains from "http://publicsuffix.org":http://publicsuffix.org to break the domain into its public suffix, domain, and subdomain.

h2. Installation

<pre>
  gem install domainatrix --source http://gemcutter.org
</pre>

h2. Use

<pre>
require 'rubygems'
require 'domainatrix'

url = Domainatrix.parse("http://www.pauldix.net")
url.url       # => "http://www.pauldix.net" (the original url)
url.public_suffix       # => "net"
url.domain    # => "pauldix"
url.canonical # => "net.pauldix"

url = Domainatrix.parse("http://foo.bar.pauldix.co.uk/asdf.html?q=arg")
url.public_suffix       # => "co.uk"
url.domain    # => "pauldix"
url.subdomain # => "foo.bar"
url.path      # => "/asdf.html?q=arg"
url.canonical # => "uk.co.pauldix.bar.foo/asdf.html?q=arg"
</pre>

h2. LICENSE

(The MIT License)

Copyright (c) 2009:

"Paul Dix":http://pauldix.net

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
