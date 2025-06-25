import ast
import importlib
import os
import re
import sys
import logging
from datetime import datetime
from pathlib import Path
from typing import Iterable
try:
    import vim      # type: ignore
except ImportError:
    vim = None

# TODO: if debug logging is on
# TODO: advanced finds from variables, or class instances, class symbols

"""
Plugin module to give
    the python path of a symbol
    the filepath of a symbol
"""

logging.basicConfig(filename="/tmp/pyinfo.log", level=logging.INFO)
logger = logging.getLogger(__name__)


re_from = re.compile(r"^\s*from\s+(\S+)\s+import\s+")
re_import = re.compile(r"import\s+(\S+)")
re_replmod = re.compile(r"\.\w+$")


class PyInfoError(Exception):
    pass


def vim_command(arg: str) -> None:
    if vim:
        vim.command(arg)


def vim_current_buffer() -> Iterable[str] | None:
    if vim:
        return vim.current.buffer
    return None


def _handle_exception(ex: Exception | str) -> None:
    msg = str(ex)
    msg = msg.replace("'", "\"")
    vim_command(f"echom '{msg}'")


def _find_current_pypath(buffer_path: Path, project_path: Path) -> str:
    """
    given /project_root/path/to/some/file.py
    return pypath = path.to.some.file
    """

    ext = -len(buffer_path.suffix)

    # check if we have anything in sys.path first
    for p in map(Path, sys.path):
        if buffer_path.is_relative_to(p):
            subpath = buffer_path.relative_to(p)
            break
    else:
        subpath = buffer_path.relative_to(project_path)

    # TODO: when top level module isn't the same as project_path
    # remove parent:  project_path/something/mod.py -> something/mod.py
    # subpath = Path(*subpath.parts[1:])

    # remove .py and slash to dot
    return str(subpath)[:ext].replace("/", ".")


def _find_parent_of_current_pypath(buffer_path: Path, project_path: Path) -> str:
    """
    given /project_root/path/to/some/file.py
    current pypath = path.to.some.file
    return parent = path.to.some
    """
    # remove .py and slash to dot
    current_pypath = _find_current_pypath(buffer_path, project_path)

    # remove last level to return parent
    return re_replmod.sub("", current_pypath)


def _find_in_ast(code: ast.Module, symbol: str) -> str | None:
    for node in code.body:
        if isinstance(node, ast.Import):
            for alias in node.names:
                if alias.name == symbol:
                    return f"import {alias.name}"
        elif isinstance(node, ast.ImportFrom):
            for alias in node.names:
                if alias.name == symbol:
                    level = '.' * node.level

                    # node.module=None when 'from . import X'
                    return f"from {level}{node.module or ''} import {alias.name}"

    return None


def _find_import(symbol: str) -> str | None:
    buf = vim_current_buffer()
    if buf:
        try:
            code = ast.parse("\n".join(buf))
        except SyntaxError as ex:
            raise PyInfoError(f"couldnt parse module: {ex}")
        return _find_in_ast(code, symbol)
    return None


def _set_path_from_virtualenv(virtual_env: Path) -> None:
    lib = virtual_env / "lib"

    # find the max pythonX dir
    pyx = max([p.name for p in lib.iterdir()])
    site_packages = lib / pyx / "site-packages"
    logger.info(f"injecting site path: {site_packages}")
    sys.path.insert(0, str(site_packages))


def _add_to_path(project_root: str | Path) -> None:
    pythonpath = os.environ.get("PYTHONPATH")
    if pythonpath:
        # assume path is already setup
        return

    virtual_env = os.environ.get("VIRTUAL_ENV")
    if virtual_env:
        _set_path_from_virtualenv(Path(virtual_env))

    proj_root = str(project_root)
    if proj_root not in sys.path:
        logger.info(f"injecting path: {proj_root}")
        sys.path.insert(0, str(project_root))


def find_symbol_internal(project_root: str | Path, buffer_path: str | Path, symbol: str, extra_imports: str) -> dict:
    logger.info(f"\n{datetime.now().isoformat()}: _find_symbol: {project_root}, {buffer_path}, {symbol}")
    project_root = Path(project_root).resolve()
    buffer_path = Path(buffer_path).resolve()
    _add_to_path(project_root)

    if extra_imports:
        imports = extra_imports.split(",")
        for imp in imports:
            logger.info(f"importing extra: {imp}")
            importlib.import_module(imp)

    if symbol == "":
        # just return the info to this buffer
        mod_name = _find_current_pypath(buffer_path, project_root)
        logger.info(f"symbol is empty, importing this buffer -> import_module({mod_name})")
        mod = importlib.import_module(mod_name)
    else:
        import_stmt = _find_import(symbol)
        if import_stmt is not None:
            # > from X import Y
            m = re_from.match(import_stmt)
            if m is not None:
                mod_name = m.group(1)
                current_path = ""
                try:
                    if mod_name == ".":
                        # > from . import X
                        # first import the child module, so its in sys.modules
                        # first then the parent, so getattr will resolve
                        mod_name = f".{symbol}"
                        current_path = _find_parent_of_current_pypath(buffer_path, project_root)
                        logger.info(f"from . import X -> importing parent module -> import_module({mod_name}, {current_path})")
                        importlib.import_module(mod_name, current_path)
                        logger.info(f"from . import X -> importing child module -> import_module({current_path})")
                        mod = importlib.import_module(current_path)
                    elif mod_name.startswith("."):
                        current_path = _find_parent_of_current_pypath(buffer_path, project_root)
                        logger.info(f"from .X import Y -> import_module({mod_name}, {current_path})")
                        mod = importlib.import_module(mod_name, current_path)
                    else:
                        logger.info(f"from X import Y -> import_module({mod_name})")
                        mod = importlib.import_module(mod_name)
                except ModuleNotFoundError as ex:
                    logger.error(f"pyinfo: module not found \"{mod_name}\" using {mod_name} . {current_path}: {ex}")
                    raise PyInfoError(f"pyinfo: module not found \"{mod_name}\" using {mod_name} . {current_path}: {ex}")
            else:
                # import X
                m = re_import.match(import_stmt)
                if m is None:
                    logger.error("pyinfo: not an import statement")
                    raise PyInfoError("pyinfo: not an import statement")
                else:
                    symbol = ""  # there's no symbol in this case
                    mod_name = m.group(1)
                    logger.info(f"import X -> import_module({mod_name})")
                    mod = importlib.import_module(mod_name)
        else:
            # try for current module.symbol
            mod_name = _find_current_pypath(buffer_path, project_root)
            logger.info(f"import from current -> import_module({mod_name})")
            mod = importlib.import_module(mod_name)

    if symbol:
        try:
            getattr(mod, symbol)
        except AttributeError:
            logger.error(f"pyinfo: '{symbol}' not found in \"{mod_name}\"")
            raise PyInfoError(f"pyinfo: '{symbol}' not found in \"{mod_name}\"")

    ret = {}
    if symbol:
        ret["pypath"] = f"{mod.__name__}.{symbol}"
        ret["import"] = f"from {mod.__name__} import {symbol}"
        ret["starimport"] = f"from {mod.__name__} import *"
    else:
        ret["pypath"] = f"{mod.__name__}"
        ret["import"] = f"import {mod.__name__}"
        ret["starimport"] = f"from {mod.__name__} import *"
    logger.info(f"{ret=}")

    if mod.__file__:
        path = Path(mod.__file__)
        if path.is_relative_to(project_root):
            path = path.relative_to(project_root)
        ret["path"] = str(path)

    return ret


def find_symbol(project_root: str | Path, buffer_path: str | Path, symbol: str, return_as: str, extra_imports: str) -> None:
    """
    finds the fullpath and the python path of term using "from import" statement
    when term is empty, just return module info ( applicable to "import xyz" )

    from path.to.module import SomeObject, SomeOtherObject
    from . import SomeObject
    from .submod import SomeObject

    return_as can be either "pypath" or "path"
    ->  path: "project_root/path/to/module.py"
    ->  pypath: "path.to.module.SomeObject"
    ->  import: "from X import Y" or "import X"
    ->  starimport: "from X import *"
    """

    try:
        result = find_symbol_internal(project_root, buffer_path, symbol, extra_imports)
        vim_command(f"let pyinfo_result = '{result[return_as]}'")
    except KeyError:
        _handle_exception("pypath: return_as should be \"path\" or \"pypath\"")
    except PyInfoError as ex:
        _handle_exception(ex)

