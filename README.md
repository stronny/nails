nails
=====

Summary
-------
`nails` are bits of Bash code similar to Ruby `gems` and Python `eggs`.
The goal is to make it simple and efficient to use the code made by others
and to publish your own code for others to use.

As assotiative arrays are in use, Bash 4 is required.

Nail structure
--------------
Nail is a directory inside `${__NAILS_PATH}` with a layout like this:
```
~/.nails/
	example/
		bin/
			example
		lib/
			example.bash
			example/
				subexample_a.bash
				subexample_b.bash
		test/
			example.test
		README
```

Usage
-----
- drop bash-hammer to your ~/bin/
- change the shebang of your script to `#!/usr/bin/env bash-hammer`
- inside the script call `require <nail_name>`

Examples
--------
To be honest all this is really trivial at the moment, so just poke
around the code. Real docs will come later, after there is something
to document in the first place.
