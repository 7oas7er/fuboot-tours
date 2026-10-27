#!/usr/bin/env python3
"""Local static server with VRML/X3D MIME types for X_ITE.

By default serves the public deploy tree under site/ (same paths as production).
"""

from __future__ import annotations

import argparse
import functools
import http.server
import os
import socketserver

REPO_ROOT = os.path.dirname(os.path.abspath(__file__))
DEFAULT_ROOT = os.path.join(REPO_ROOT, "site")
DEFAULT_PORT = 8765

EXTRA_TYPES = {
    ".wrl": "model/vrml",
    ".WRL": "model/vrml",
    ".wrz": "model/vrml",
    ".x3d": "model/x3d+xml",
    ".x3dv": "model/x3d+vrml",
    ".x3dj": "model/x3d+json",
}


class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        **getattr(http.server.SimpleHTTPRequestHandler, "extensions_map", {}),
        **EXTRA_TYPES,
    }

    def end_headers(self) -> None:
        # Helpful while iterating on assets; browsers still cache CDN X_ITE.
        self.send_header("Cache-Control", "no-cache")
        super().end_headers()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-p", "--port", type=int, default=DEFAULT_PORT)
    parser.add_argument(
        "--root",
        default=DEFAULT_ROOT,
        help=f"Directory to serve (default: {DEFAULT_ROOT})",
    )
    args = parser.parse_args()

    root = os.path.abspath(args.root)
    if not os.path.isdir(root):
        raise SystemExit(f"Serve root does not exist: {root}")

    os.chdir(root)
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", args.port), functools.partial(Handler, directory=root)) as httpd:
        landing = f"http://127.0.0.1:{args.port}/"
        opensea = f"http://127.0.0.1:{args.port}/vrml/play-opensea.html"
        harbour = f"http://127.0.0.1:{args.port}/vrml/harbour/play.html"
        framed = f"http://127.0.0.1:{args.port}/vrml/harbour/index-xite.html"
        print(f"Serving {root}")
        print(f"  Landing:  {landing}")
        print(f"  Open sea: {opensea}")
        print(f"  Harbour:  {harbour}")
        print(f"  Frames:   {framed}")
        print("Ctrl+C to stop.")
        httpd.serve_forever()


if __name__ == "__main__":
    main()
