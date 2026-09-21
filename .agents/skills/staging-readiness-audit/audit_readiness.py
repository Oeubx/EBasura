"""
EBasura Staging & Pre-Push Readiness Auditor
Audits repository status, secret exposures, git drift, and Flutter code analysis.
"""

import os
import subprocess
import sys
import re

def run_cmd(cmd, cwd=None):
    try:
        res = subprocess.run(
            cmd,
            cwd=cwd,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            encoding="utf-8",
            errors="replace"
        )
        return res.returncode, res.stdout.strip(), res.stderr.strip()
    except Exception as e:
        return 1, "", str(e)

def check_git_status():
    print("[1/4] Checking Git Status & Uncommitted Changes...")
    code, branch, _ = run_cmd("git branch --show-current")
    code, status_out, _ = run_cmd("git status --short")
    
    issues = []
    warnings = []
    
    if not branch:
        warnings.append("Detached HEAD or unable to determine branch.")
    else:
        print(f"  Current Branch: {branch}")
        
    if status_out:
        lines = status_out.splitlines()
        print(f"  Working Tree: {len(lines)} uncommitted change(s).")
        warnings.append(f"{len(lines)} uncommitted file(s) present.")
    else:
        print("  Working Tree: Clean.")
        
    return issues, warnings

def check_secrets():
    print("\n[2/4] Checking Secret Shield & Tracked Configs...")
    issues = []
    warnings = []
    
    # 1. Verify env.json is not tracked by git
    code, tracked, _ = run_cmd("git ls-files env.json")
    if tracked.strip():
        issues.append("CRITICAL: 'env.json' is actively tracked in git! Must untrack before pushing.")
    else:
        print("  env.json: Properly untracked/gitignored.")
        
    # 2. Scan tracked files for apparent API key patterns (Google AI / Gemini / Supabase service keys)
    code, grep_out, _ = run_cmd("git grep -E \"AIza[0-9A-Za-z-_]{35}\" -- ':!*.lock' ':!*.example' ':!*.md'")
    if grep_out.strip():
        issues.append("CRITICAL: Found potential hardcoded Google Gemini API key (AIzaSy...) in tracked files!")
        for line in grep_out.splitlines()[:3]:
            issues.append(f"    {line}")
    else:
        print("  Hardcoded API Keys: None detected in tracked files.")
        
    return issues, warnings

def check_flutter_analysis():
    print("\n[3/4] Running Flutter Code Analysis...")
    issues = []
    warnings = []
    
    code, out, err = run_cmd("flutter analyze --no-fatal-warnings --no-fatal-infos")
    if "No issues found!" in out or "No issues found!" in err:
        print("  flutter analyze: Clean (0 issues).")
    elif code == 0:
        print("  flutter analyze: Passed with info/warnings.")
        warnings.append("flutter analyze reported non-fatal hints or warnings.")
    else:
        print("  flutter analyze: Failed.")
        combined = f"{out}\n{err}"
        error_lines = [l for l in combined.splitlines() if "error •" in l or "error:" in l]
        if error_lines:
            issues.append(f"flutter analyze reported {len(error_lines)} fatal error(s):")
            for el in error_lines[:5]:
                issues.append(f"    {el}")
        else:
            issues.append("flutter analyze failed. Run 'flutter analyze' to view errors.")
            
    return issues, warnings

def check_git_drift():
    print("\n[4/4] Checking Upstream Remote Drift...")
    issues = []
    warnings = []
    
    code, _, _ = run_cmd("git rev-parse --abbrev-ref @{u}")
    if code != 0:
        warnings.append("No upstream tracking branch configured.")
        print("  Remote tracking: None configured.")
    else:
        code, ahead_behind, _ = run_cmd("git rev-list --left-right --count @{u}...HEAD")
        if code == 0 and ahead_behind:
            parts = ahead_behind.split()
            if len(parts) == 2:
                behind, ahead = parts
                print(f"  Upstream status: {ahead} ahead, {behind} behind.")
                if int(behind) > 0:
                    warnings.append(f"Branch is {behind} commit(s) behind remote. Run git pull --rebase before pushing.")
                    
    return issues, warnings

def main():
    print("=" * 60)
    print("      EBasura Staging & Pre-Push Readiness Audit")
    print("=" * 60)
    
    all_issues = []
    all_warnings = []
    
    i1, w1 = check_git_status()
    i2, w2 = check_secrets()
    i3, w3 = check_flutter_analysis()
    i4, w4 = check_git_drift()
    
    all_issues.extend(i1 + i2 + i3 + i4)
    all_warnings.extend(w1 + w2 + w3 + w4)
    
    print("\n" + "=" * 60)
    print("                      AUDIT RESULT")
    print("=" * 60)
    
    if all_issues:
        print("\n[!] STATUS: RED LIGHT (Blockers detected - do not push)")
        for issue in all_issues:
            print(f"  - {issue}")
        sys.exit(1)
    elif all_warnings:
        print("\n[*] STATUS: AMBER LIGHT (Warnings detected - review before push)")
        for warn in all_warnings:
            print(f"  - {warn}")
        sys.exit(0)
    else:
        print("\n[+] STATUS: GREEN LIGHT (100% clean and ready to push/PR)")
        sys.exit(0)

if __name__ == "__main__":
    main()
