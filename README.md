Language tools repo for fun and pleasure while editing translations for if me.

run bundle install

This repo needs a better readme.md

Most tools require a path to your ifme checkout. I've set ../ifme as the default, provide --path if you need a different path.

## Suggest language
Contains a little tool to check if me translation files for better style suggestions based on LanguageTool.org

Needs a LanguageTool.org instance running locally. (See http://wiki.languagetool.org/http-server)

```
ruby suggestlang.rb --help
```

## Compare languages
Contains a little tool that shows which keys don't exist in the comparelanguage.

Best used with en (default) as a source language. Example below compares 'en' locale on the lefth hand side and 'nl' on the right hand site.

```
ruby comparelang.rb -c nl
```