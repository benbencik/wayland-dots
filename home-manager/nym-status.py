#!/usr/bin/env python3
"""Summary of the current NymVPN connection: entry/exit gateway location,
quality, latency, throughput and confirmed exit IP.
"""
import argparse
import json
import re
import subprocess
import sys


def run(cmd: list[str], timeout: float | None = None) -> str:
    try:
        return subprocess.run(
            cmd, capture_output=True, text=True, timeout=timeout
        ).stdout.strip()
    except (subprocess.TimeoutExpired, FileNotFoundError):
        return ""


def get_status() -> dict:
    status = run(["nym-vpnc", "status"])
    if "Connected wg" not in status:
        return {"connected": False, "raw": status}

    # "Connected wg to <entry_ip>:<port> [<entry_pubkey>] -> <exit_ip>:<port> [<exit_pubkey>]"
    pubkeys = re.findall(r"\[([^\]]+)\]", status)
    entry_pubkey, exit_pubkey = (pubkeys + [None, None])[:2]
    m = re.search(r"→ ([0-9.]+):", status)
    exit_ip = m.group(1) if m else None

    gateways = run(["nym-vpnc", "gateway", "list", "wg"])
    entry_line = next((l for l in gateways.splitlines() if entry_pubkey and entry_pubkey in l), "")
    exit_line = next((l for l in gateways.splitlines() if exit_pubkey and exit_pubkey in l), "")

    def field(line: str, n: int) -> str:
        parts = line.split("|")
        return parts[n].strip() if len(parts) > n else ""

    return {
        "connected": True,
        "entry_name": field(entry_line, 1) or "unknown",
        "entry_loc": field(entry_line, 2) or "unknown",
        "entry_quality": field(entry_line, 3) or "?",
        "exit_name": field(exit_line, 1) or "unknown",
        "exit_loc": field(exit_line, 2) or "unknown",
        "exit_quality": field(exit_line, 3) or "?",
        "exit_ip": exit_ip,
    }


def get_latency() -> str:
    out = run(["ping", "-c", "4", "-q", "1.1.1.1"], timeout=6)
    m = re.search(r"rtt.*= [\d.]+/([\d.]+)/", out)
    return f"~{float(m.group(1)):.0f}ms (avg)" if m else "unavailable"


def get_confirmed_ip() -> str:
    return run(["curl", "-s", "--max-time", "5", "https://ipinfo.io/ip"], timeout=6) or "unavailable"


def get_throughput() -> str:
    out = run(
        [
            "curl", "-s", "--max-time", "15", "-o", "/dev/null",
            "-w", "%{speed_download}",
            "https://speed.cloudflare.com/__down?bytes=25000000",
        ],
        timeout=17,
    )
    try:
        mbps = (float(out) * 8) / 1_000_000
        return f"~{mbps:.0f} Mbps"
    except ValueError:
        return "unavailable"


def print_table(rows: list[tuple[str, str]]) -> None:
    col1 = max(len(k) for k, _ in rows)
    col2 = max(len(v) for _, v in rows)
    hr = f"├{'─' * (col1 + 2)}┼{'─' * (col2 + 2)}┤"
    print(f"┌{'─' * (col1 + 2)}┬{'─' * (col2 + 2)}┐")
    for i, (k, v) in enumerate(rows):
        print(f"│ {k:<{col1}} │ {v:<{col2}} │")
        if i < len(rows) - 1:
            print(hr)
    print(f"└{'─' * (col1 + 2)}┴{'─' * (col2 + 2)}┘")


FIELD_HELP = "single field only, for scripting/conky (e.g. status bar widgets)"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--speed", action="store_true", help="measure download throughput (slow)")
    parser.add_argument("--json", action="store_true", help="output all fields as JSON")
    field_group = parser.add_mutually_exclusive_group()
    field_group.add_argument("--entry", action="store_true", help=f"print entry gateway only ({FIELD_HELP})")
    field_group.add_argument("--exit", action="store_true", help=f"print exit gateway only ({FIELD_HELP})")
    field_group.add_argument("--ip", action="store_true", help=f"print confirmed exit IP only ({FIELD_HELP})")
    field_group.add_argument("--latency", action="store_true", help=f"print latency only ({FIELD_HELP})")
    args = parser.parse_args()

    status = get_status()
    if not status["connected"]:
        if args.json:
            print(json.dumps(status))
        else:
            print("Not connected. Current state:")
            print(f"  {status['raw']}")
        return 1

    # single-field modes skip the slow probes (latency/ip) unless that field was asked for
    if args.entry:
        print(status["entry_loc"])
        return 0
    if args.exit:
        print(status["exit_loc"])
        return 0
    if args.ip:
        print(get_confirmed_ip())
        return 0
    if args.latency:
        print(get_latency())
        return 0

    latency = get_latency()
    confirmed_ip = get_confirmed_ip()
    throughput = get_throughput() if args.speed else "skipped (pass --speed to measure)"

    if args.json:
        print(json.dumps({**status, "latency": latency, "confirmed_ip": confirmed_ip, "throughput": throughput}))
        return 0

    rows = [
        ("Entry", f"{status['entry_name']} - {status['entry_loc']}"),
        ("Exit", f"{status['exit_name']} - {status['exit_loc']}"),
        ("Quality", f"entry: {status['entry_quality']} / exit: {status['exit_quality']}"),
        ("Latency", latency),
        ("Throughput", throughput),
        ("Exit IP confirmed", confirmed_ip),
    ]
    print_table(rows)
    return 0


if __name__ == "__main__":
    sys.exit(main())
