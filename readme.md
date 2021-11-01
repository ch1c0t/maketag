# Introduction

`maketag` is a tool to make [web.tags][web.tags].

[web.tags]: https://github.com/ch1c0t/web.tags

You can install it globally with 

```
npm i maketag -g
```

and then use

```
maketag new NAME
```

to create a directory named NAME and a new package providing a tag.
NAME must start with a capital letter.
For example, `maketag new SomeTag`.

Then, you can enter the directory with `cd Sometag`
and start working on a tag.

## Entry points

There are two entry points to a tag:

### Script

`src/script.coffee` is the main script file.
It must end with a call to [`window.tag`][window.tag]
or with a function literal defining a tag.

`maketag new NAME` generates a package with a valid `src/script.coffee`.

[window.tag]: https://github.com/ch1c0t/web.tags#windowtag

### Style

`src/style.sass` is the main style file.
It is optional(if your tag doesn't need any style).

On the first invocation of a tag

```coffee
import { SomeTag } from 'some-tag'
element = SomeTag() # first invocation
element2 = SomeTag() # second invocation
```

, it adds its style to [the head][head] as

```
<style id="SomeTagStyle">css from src/style.sass</style>
```

.

It adds [a style tag][style] with [an id attribute][id],
whose value is obtained from appending "Style" to the NAME.

[head]: https://developer.mozilla.org/en-US/docs/Glossary/Head
[style]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/style
[id]: https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/id

## Commands

Inside of the directory generated by `maketag new NAME`,
you can use the following commands:

### `test`

`maketag test`(or `npm test`) to run the tests.

`maketag new NAME` generates a tag and a basic test of it with Jasmine and Puppeteer.

### `build`

`maketag build`(or `npm run build`) to build the project.

### `start`

`maketag watch`(or `npm start`) to start a development session.
It builds the project, and then rebuilds the project when the sources change.
