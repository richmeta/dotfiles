#!/usr/bin/env python3 -W ignore::DeprecationWarning

import unittest
import os
from pathlib import Path
from unittest.mock import patch
from contextlib import contextmanager

from pyinfo import find_symbol_internal

"""
note: can't run both test classes due to sys.modules mangling
use one of
./tests2.py PyInfoDraTests
./tests2.py PyInfoCPTests
"""


@contextmanager
def buffer(filename: Path, extra: list[str] | str | None = None):
    with open(filename) as fp:
        data = fp.read().split("\n")

    if isinstance(extra, str):
        data.insert(0, extra)
    elif isinstance(extra, list):
        for imp in extra:
            data.insert(0, imp)

    with patch("pyinfo.vim_current_buffer", side_effect=lambda: data):
        yield


class PyInfoDraTests(unittest.TestCase):
    extra_imports = "shared.sqlalchemy.model"
    project_root = Path("/Users/richard.french/src/dra/main")
    env = Path("/Users/richard.french/src/dra/main/.venv")

    def setUp(self):
        os.environ["VIRTUAL_ENV"] = str(self.env)

    def tearDown(self):
        os.environ["VIRTUAL_ENV"] = ""

    def test_symbol_this_module(self):
        # symbol = "" -> this module
        filename = "apps/commission_delivery/routes.py"
        symbol = ""
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "apps.commission_delivery.routes")
            self.assertEqual(res["import"], "import apps.commission_delivery.routes")
            self.assertEqual(res["starimport"], "from apps.commission_delivery.routes import *")
            self.assertEqual(res["path"], filename)

    def test_symbol_from_x_import_y(self):
        # symbol = "Y" -> from X import Y
        filename = "apps/commission_delivery/routes.py"

        # from shared.utils import make_download
        symbol = "make_download"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "shared.utils.make_download")
            self.assertEqual(res["import"], "from shared.utils import make_download")
            self.assertEqual(res["starimport"], "from shared.utils import *")
            self.assertEqual(res["path"], "shared/utils.py")

    def test_symbol_from_dot_import_y(self):
        # symbol = "Y" -> from . import Y
        filename = "apps/commission_delivery/routes.py"

        # from . import controller
        symbol = "controller"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "apps.commission_delivery.controller")
            self.assertEqual(res["import"], "from apps.commission_delivery import controller")
            self.assertEqual(res["starimport"], "from apps.commission_delivery import *")
            self.assertEqual(res["path"], "apps/commission_delivery/__init__.py")

    def test_symbol_from_dot_mod_import_y(self):
        # symbol = "Y" -> from .mod import Y
        filename = "apps/commission_delivery/routes.py"

        # from .blueprint import api
        symbol = "api"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "apps.commission_delivery.blueprint.api")
            self.assertEqual(res["import"], "from apps.commission_delivery.blueprint import api")
            self.assertEqual(res["starimport"], "from apps.commission_delivery.blueprint import *")
            self.assertEqual(res["path"], "apps/commission_delivery/blueprint.py")

    def test_symbol_import_x(self):
        # symbol = "X" -> import X
        filename = "apps/commission_delivery/controller.py"

        # import logging
        symbol = "logging"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "logging")
            self.assertEqual(res["import"], "import logging")
            self.assertEqual(res["starimport"], "from logging import *")
            self.assertTrue(res["path"].endswith("logging/__init__.py"))

    def test_symbol_mod_level_attr(self):
        # symbol = mod level attr of this file
        filename = "apps/commission_delivery/controller.py"
        symbol = "get_individual_summary"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], f"apps.commission_delivery.controller.{symbol}")
            self.assertEqual(res["import"], f"from apps.commission_delivery.controller import {symbol}")
            self.assertEqual(res["starimport"], "from apps.commission_delivery.controller import *")
            self.assertEqual(res["path"], filename)


class PyInfoCPTests(unittest.TestCase):
    extra_imports = ""
    project_root = Path("/Users/richard.french/src/client-portal/apps/api")
    env = Path("/Users/richard.french/src/client-portal/apps/api/.venv")

    def setUp(self):
        os.environ["VIRTUAL_ENV"] = str(self.env)

    def tearDown(self):
        os.environ["VIRTUAL_ENV"] = ""

    def test_symbol_this_module(self):
        # symbol = "" -> this module
        filename = "app/api/routes.py"
        symbol = ""
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "app.api.routes")
            self.assertEqual(res["import"], "import app.api.routes")
            self.assertEqual(res["starimport"], "from app.api.routes import *")
            self.assertEqual(res["path"], filename)

    def test_symbol_from_x_import_y(self):
        # symbol = "Y" -> from X import Y
        filename = "app/api/routes.py"

        # from app.api.deps import RequestContext
        symbol = "RequestContext"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "app.api.deps.RequestContext")
            self.assertEqual(res["import"], "from app.api.deps import RequestContext")
            self.assertEqual(res["starimport"], "from app.api.deps import *")
            self.assertEqual(res["path"], "app/api/deps.py")

    def test_symbol_from_x_import_y_with_child(self):
        # symbol = "Y" -> from X import Y
        filename = "app/api/routes.py"

        # from app.api import controller
        symbol = "controller.get_me"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "app.api.deps.RequestContext")
            self.assertEqual(res["import"], "from app.api.deps import RequestContext")
            self.assertEqual(res["starimport"], "from app.api.deps import *")
            self.assertEqual(res["path"], "app/api/deps.py")

    def test_symbol_from_dot_import_y(self):
        # symbol = "Y" -> from . import Y
        filename = "app/api/modules/__init__.py"

        # from . import cost, risk, schedule
        symbol = "risk"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "app.api.modules.risk")
            self.assertEqual(res["import"], "from app.api.modules import risk")
            self.assertEqual(res["starimport"], "from app.api.modules import *")
            self.assertEqual(res["path"], "app/api/modules/__init__.py")

    def test_symbol_from_dot_mod_import_y(self):
        # symbol = "Y" -> from .mod import Y
        filename = "app/api/controller.py"

        # from .ingest_schemas import ImageSize, IngestField
        symbol = "IngestField"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "app.api.ingest_schemas.IngestField")
            self.assertEqual(res["import"], "from app.api.ingest_schemas import IngestField")
            self.assertEqual(res["starimport"], "from app.api.ingest_schemas import *")
            self.assertEqual(res["path"], "app/api/ingest_schemas.py")

    def test_symbol_import_x(self):
        # symbol = "X" -> import X
        filename = "app/api/controller.py"

        # import sqlalchemy
        symbol = "pycountry"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "pycountry")
            self.assertEqual(res["import"], "import pycountry")
            self.assertEqual(res["starimport"], "from pycountry import *")
            self.assertIn("pycountry", res["path"])

    def test_symbol_import_x_with_child(self):
        # symbol = "X" -> import X
        filename = "app/api/controller.py"

        # import sqlalchemy.exc
        symbol = "sqlalchemy.exc"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "sqlalchemy.exc")
            self.assertEqual(res["import"], "import sqlalchemy.exc")
            self.assertEqual(res["starimport"], "from sqlalchemy.exc import *")
            self.assertIn("sqlalchemy/exc", res["path"])

    def test_symbol_mod_level_attr(self):
        # symbol = mod level attr of this file
        filename = "app/api/routes.py"
        symbol = "me"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], f"app.api.routes.{symbol}")
            self.assertEqual(res["import"], f"from app.api.routes import {symbol}")
            self.assertEqual(res["starimport"], "from app.api.routes import *")
            self.assertEqual(res["path"], filename)

    # TODO:
# ERROR:pyinfo:pyinfo: 'id_token' not found in "google.oauth2"
# portal_global_service/app/auth.py
#         claims = id_token.verify_token(id_token_str, request)
#                  ^



if __name__ == "__main__":
    unittest.main()


if __name__ == "__main__":
    unittest.main()
