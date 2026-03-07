#!/usr/bin/env python3 -W ignore::DeprecationWarning

import unittest
import os
from pathlib import Path
from unittest.mock import patch
from contextlib import contextmanager

from pyinfo import find_symbol_internal

# required for settings
os.environ["FIREBASE_SERVICE_ACCOUNT_JSON"] = "e30="
os.environ["CLOUD_STORAGE_ACCOUNT_JSON"] = "e30="
os.environ["CLOUD_STORAGE_BUCKET"] = ""
os.environ["AUTH0_TENANT_URL"] = ""
os.environ["AUTH0_MANAGEMENT_CLIENT_ID"] = ""
os.environ["AUTH0_MANAGEMENT_CLIENT_SECRET"] = ""
os.environ["ENVIRONMENT_ID"] = ""
os.environ["USER_ENVIRONMENT_URL"] = ""
os.environ["USER_ENVIRONMENT_AUDIENCE"] = ""
os.environ["ENVIRONMENT_CONFIG_URL"] = ""
os.environ["MAILGUN_URL"] = ""
os.environ["MAILGUN_API_KEY"] = ""
os.environ["MAILGUN_DOMAIN"] = ""
os.environ["MAILGUN_SENDER"] = ""
os.environ["HIVE_PORTAL_URL"] = ""
os.environ["EXTERNAL_DOMAINS"] = ""
os.environ["EXTERNAL_DOMAIN_ACCESS_TYPE"] = ""
os.environ["INVITE_EMAIL_WHITELIST"] = ""
os.environ["POSTGRES_USER"] = ""
os.environ["POSTGRES_PASSWORD"] = ""
os.environ["POSTGRES_DB"] = ""
os.environ["POSTGRES_HOSTNAME"] = ""


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


class PyInfoCPTests(unittest.TestCase):
    extra_imports = ""
    project_root = Path("/Users/richard.french/src/cp/main/apps/api")
    env = Path("/Users/richard.french/src/cp/main/apps/api/.venv")

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
            self.assertEqual(res["pypath"], "app.api.controller.get_me")
            self.assertEqual(res["import"], "from app.api.controller import get_me")
            self.assertEqual(res["starimport"], "from app.api.controller import *")
            self.assertEqual(res["path"], "app/api/controller.py")

    def test_symbol_from_dot_import_y(self):
        # symbol = "Y" -> from . import Y
        filename = "app/api/modules/__init__.py"

        # from . import cost, risk, schedule
        symbol = "risk"
        with buffer(self.project_root / filename):
            res = find_symbol_internal(self.project_root, filename, symbol, self.extra_imports)
            self.assertEqual(res["pypath"], "app.api.modules.project.risk")
            self.assertEqual(res["import"], "from app.api.modules.project import risk")
            self.assertEqual(res["starimport"], "from app.api.modules.project import *")
            self.assertEqual(res["path"], "app/api/modules/project/__init__.py")

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

