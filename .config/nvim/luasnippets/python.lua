local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node
local u = require("user.snip")


return {
    -- top of file
    s( { trig = "imp", dscr = "import mod" },
        fmt('import {}', i(0))
    ),

    s( { trig = "#!", dscr = "shebang", snippetType = "autosnippet" },
        t{'#!/usr/bin/env python3', ''}
    ),

    s( { trig = "from", dscr = "with" },
        fmt(
[[from {} import {} ]], { i(1), i(2) })
    ),

    -- common imports
    s( "Path", t{'from pathlib import Path', ''} ),
    s( "datetime", t{'from datetime import datetime, timedelta', ''} ),
    s( "timedelta", t{'from datetime import timedelta', ''} ),
    s( "pprint", t{'from pprint import pprint', ''} ),
    s( "dataclass", t{'from dataclasses import dataclass', ''} ),
    s( "StringIO", t{'from io import StringIO', ''} ),

    s( { trig = "pdb", dscr = "pdb trace" },
        t{'__import__("pdb").set_trace()'}
    ),

    s( { trig = "logging", dscr = "setup logging" }, fmt(
[[import logging

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)

# add to main
if argv.verbose:
    logger.setLevel(logging.DEBUG)
    {}
]],
        i(0))
    ),

    -- constructs
    s( { trig = "with", dscr = "with" }, fmt(
[[with {}:
    {}]], { i(1), i(0) })
    ),

    s( { trig = "for", dscr = "for loop" }, fmt(
[[for {} in {}:
    {}]], { i(1, "i"), i(2, "range(10)"), i(3, "pass") })
    ),

    s( { trig = "class", dscr = "simple class" }, fmt(
[[class {}:
    def __init__(self, {}):
        {}
]],
        { i(1), i(2), i(0, "pass") })
    ),

    s( { trig = "init", dscr = "constructor" }, fmt(
[[def __init__(self, {}):
    {}]],
        { i(1), i(0, "pass") })
    ),

    s( { trig = "property", dscr = "property" }, fmt(
[[@property
def {}(self):
    return self.{}

@{}.setter
def {}(self, value):
    self.{} = value]],
        {
            i(1, "name"),
            i(2, "prop"),
            rep(1),
            rep(1),
            rep(2)
        })
    ),

    s( { trig = "if", dscr = "if" }, fmt(
[[if {}:
    {}]],
        { i(1), i(0, "pass") })
    ),

    s( { trig = "ife", dscr = "if else" }, fmt(
[[if {}:
    {}
else:
    {}
]],
        { i(1), i(2), i(0, "pass") })
    ),

    s( { trig = "ex", dscr = "catch" }, fmt(
[[except {} as ex:
    {}]],
        { i(1), i(0, "pass") })
    ),

    s( { trig = "try", dscr = "try catch/finally" }, fmt(
[[try:
    {}{}
except {} as {}:
    {}
finally:
    {}
]],
        {
            u.visual(1),
            i(0),
            i(2, "Exception"),
            i(3, "ex"),
            i(4, "pass"),
            i(5, "pass")
        })
    ),

    s( { trig = "lam", dscr = "lambda function" },
        fmt('lambda {}: {}', { i(1), i(2) })
    ),

    s( { trig = '"""', dscr = "long comment", snippetType = "autosnippet" }, fmt(
[["""
{}
"""]], i(0))
    ),

    -- main func / argparse
    s( { trig = "main", dscr = "simple main" }, fmt(
[[
def {}():
    {}


if __name__ == "__main__":
    {}()]],
        {
            rep(1),
            i(0, "pass"),
            i(1, "main")
        } )
    ),

    s( { trig = "amain", dscr = "async main" }, fmt(
[[
import asyncio

async def {}():
    {}


if __name__ == "__main__":
    asyncio.run({}())]],
        {
            rep(1),
            i(0, "pass"),
            i(1, "main")
        } )
    ),

    s( { trig = "mainpa", dscr = "main with parse args" }, fmt(
[[import argparse
import logging
logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def parse_args():
    parser = argparse.ArgumentParser(description="{}")
    parser.add_argument("--verbose", "-v", action="store_true", help="verbose output")

    argv = parser.parse_args()
    if argv.verbose:
        logger.setLevel(logging.DEBUG)
    return argv


def main():
    argv = parse_args()


if __name__ == '__main__':
    main()
]],
        i(0) )
    ),

    -- argparse
    s( { trig = "parse_args", dscr = "parse args" }, fmt(
[[def parse_args():
    parser = argparse.ArgumentParser(description="{}")
    parser.add_argument("--verbose", "-v", action="store_true", help="verbose output")

    return parser.parse_args()
]],
        i(0) )
    ),

    s( { trig = "addarg", dscr = "argparse.add_argument" }, fmt(
[[parser.add_argument("{}", "{}", {}help="{}")]],
        { i(1, "--arg"),
          f(function(arg)
              local value = arg[1][1]
              if #value > 0 then
                return value:match("-%w")
              end
          end, 1),
          i(0, 'action="store_true",'),
          i(2)
        })
    ),

    s( { trig = "mainsa", dscr = "main with parse args + subcomds" }, fmt(
[[import argparse
import logging
logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def parse_args():
    parser = argparse.ArgumentParser(description="switch aws credentials")
    parser.add_argument("--verbose", "-v", action="store_true", help="verbose output")

    subparsers = parser.add_subparsers()

    sub_parser = subparsers.add_parser("action", help="")
    sub_parser.set_defaults(func=function_name)

    argv = parser.parse_args()
    if argv.verbose:
        logger.setLevel(logging.DEBUG)
    return argv


def main():
    argv = parse_args()
    kv = vars(argv)
    {}

    try:
        repo = get_repo()
        resp = argv.func(repo, **vars(argv))
        print(resp)
    except Exception as ex:
        print(ex)


if __name__ == '__main__':
    main()
]],
        i(0))
    ),

    -- misc
    s( { trig = "borg", dscr = "borg pattern" },
        t{
            'class Borg:',
            '   _shared_state = {}',
            '',
            '   def __init__(self):',
            '       self.__dict__ = self._shared_state',
            ''
        }
    )

}
