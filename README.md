[![forthebadge](http://forthebadge.com/images/badges/gluten-free.svg)](http://forthebadge.com)

[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)
[![Known Vulnerabilities](https://snyk.io/test/github/sexybiggetje/ifme-languagetools/badge.svg)](https://snyk.io/test/github/sexybiggetje/ifme-languagetools)
[![Maintainability](https://api.codeclimate.com/v1/badges/6e8f9a0185eecd01d251/maintainability)](https://codeclimate.com/github/sexybiggetje/ifme-languagetools/maintainability)

Some helper tools to validate and compare language files for the [if me](https://github.com/julianguyen/ifme/) project.

In order to get started, install your dependencies with bundler.
```
bundle install
```

Most tools require a path to your local ifme checkout. I've set ../ifme as the default, provide --path if you need a different path.

## Suggest language
Contains a little tool to check if me translation files for better style suggestions based on LanguageTool.org

Needs a LanguageTool.org instance running locally. (See http://wiki.languagetool.org/http-server)

```
ruby suggestlang.rb --help
Usage: suggestlang.rb [options]
Make sure a languagetool.org instance is running.
See: http://wiki.languagetool.org/http-server

    -l, --language LANGUAGE          Language code (default: en)
    -p, --path PATH                  Path to if me checkout (default: ../ifme)
    -t, --tool URI                   Url to languagetool.org instance (default: http://localhost:8081/v2)
```

## Compare languages
Contains a little tool that shows which keys don't exist in the comparelanguage.
```
ruby comparelang.rb --help
Usage: comparelang.rb [options]
Compares two languages for missing keys

    -s, --sourcelanguage LANGUAGE    Language code (default: en)
    -c, --comparelanguage LANGUAGE   Language code (default: sv)
    -p, --path PATH                  Path to if me checkout (default: ../ifme)
```

Best used with en (default) as a source language. Example below compares 'en' locale on the left hand side and 'nl' on the right hand site.

```
ruby comparelang.rb -c nl
```