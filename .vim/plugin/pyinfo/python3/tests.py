#!/usr/bin/env python3

import unittest
import re
from pathlib import Path
from unittest.mock import patch
from contextlib import contextmanager

from pyinfo import PyInfoError, find_symbol

PROJECT_ROOT = (Path(__file__).parent / "test_proj").resolve()
MAIN_PY = PROJECT_ROOT / "main.py"
SM_PY = PROJECT_ROOT / "somemodule" / "mod.py"
SC_PY = PROJECT_ROOT / "somemodule" / "submodule" / "child.py"
CFG_PY = PROJECT_ROOT / "somemodule" / "config.py"


def relpath(path: Path) -> str:
    return str(path.relative_to(PROJECT_ROOT))


class PyInfoTests(unittest.TestCase):
    @contextmanager
    def buffer(self, filename: Path, extra: list[str] | str | None = None):
        d = {}

        def _command(s: str) -> None:
            if 'echom' in s:
                raise PyInfoError(s[6:])
            elif s.startswith('let'):
                m = re.match(r"let \w+\s*=\s*'(.*)'", s)
                assert m, "expected match to let"
                d["result"] = m.group(1)

        with open(filename) as fp:
            data = fp.read().split("\n")

        if isinstance(extra, str):
            data.insert(0, extra)
        elif isinstance(extra, list):
            for imp in extra:
                data.insert(0, imp)

        with patch("pyinfo.vim_command", side_effect=_command):
            with patch("pyinfo.vim_current_buffer", side_effect=lambda: data):
                yield d

    def test_abs_import(self):
        with self.buffer(MAIN_PY) as d:
            find_symbol(PROJECT_ROOT, MAIN_PY, "some_func", "pypath")
            self.assertEqual(d["result"], "somemodule.mod.some_func")

            find_symbol(PROJECT_ROOT, MAIN_PY, "some_func", "path")
            self.assertEqual(d["result"], relpath(SM_PY))

    def test_rel_import(self):
        with self.buffer(SM_PY) as d:
            find_symbol(PROJECT_ROOT, SM_PY, "VAR1", "pypath")
            self.assertEqual(d["result"], "somemodule.config.VAR1")

            find_symbol(PROJECT_ROOT, SM_PY, "VAR1", "path")
            self.assertEqual(d["result"], relpath(CFG_PY))

    def test_abs_import_nested(self):
        with self.buffer(MAIN_PY) as d:
            find_symbol(PROJECT_ROOT, MAIN_PY, "some_child_func", "pypath")
            self.assertEqual(d["result"], "somemodule.submodule.child.some_child_func")

            find_symbol(PROJECT_ROOT, MAIN_PY, "some_child_func", "path")
            self.assertEqual(d["result"], relpath(SC_PY))

    def test_rel_import_nested(self):
        with self.buffer(SC_PY) as d:
            find_symbol(PROJECT_ROOT, SC_PY, "VAR1", "pypath")
            self.assertEqual(d["result"], "somemodule.config.VAR1")

            find_symbol(PROJECT_ROOT, SC_PY, "VAR1", "path")
            self.assertEqual(d["result"], relpath(CFG_PY))

    def test_symbol_not_found(self):
        # symb not found in current module
        with self.buffer(MAIN_PY):
            with self.assertRaises(PyInfoError) as ex:
                find_symbol(PROJECT_ROOT, MAIN_PY, "missing_symbol", "pypath")
                self.assertIn("'missing_symbol' not found", ex.exception.args[0])

    def test_abs_module_not_found(self):
        # symb not found in current module
        with self.buffer(MAIN_PY, extra="from missing_module import missing_func"):
            with self.assertRaises(PyInfoError) as ex:
                find_symbol(PROJECT_ROOT, MAIN_PY, "missing_func", "pypath")
                self.assertIn("module not found", ex.exception.args[0])

    def test_rel_symbol_not_found(self):
        # import line found, but var doesn't exist
        with self.buffer(SM_PY, extra="from .config import MISSING"):
            with self.assertRaises(PyInfoError) as ex:
                find_symbol(PROJECT_ROOT, SM_PY, "MISSING", "pypath")
                self.assertIn("'missing_symbol' not found", ex.exception.args[0])

    def test_rel_mod_not_found(self):
        # symb not found in current module
        with self.buffer(SM_PY, extra="from .missing_module import missing_func"):
            with self.assertRaises(PyInfoError) as ex:
                find_symbol(PROJECT_ROOT, MAIN_PY, "missing_func", "pypath")
                self.assertIn("'missing_func' not found", ex.exception.args[0])

    def test_normal_import(self):
        with self.buffer(MAIN_PY, extra="import re") as d:
            find_symbol(PROJECT_ROOT, MAIN_PY, "re", "pypath")
            self.assertEqual(d["result"], "re")

            find_symbol(PROJECT_ROOT, MAIN_PY, "re", "path")
            self.assertEqual(d["result"], re.__file__)


if __name__ == "__main__":
    unittest.main()
