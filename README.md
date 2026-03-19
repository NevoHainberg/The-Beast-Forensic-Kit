
This is my personal project for learning and practicing **Cyber Forensics (DFIR)**. I built this script to better understand the forensic workflow and to see how different tools can be automated to collect evidence from a Windows machine.

My goal was to move from theory to practice—building a system that follows the "Order of Volatility" and organizes artifacts in a way that makes analysis easier.

 What the Script Does:
The script automates the collection process in 5 main stages:
1. **RAM Capture**: Collecting volatile memory.
2. **Triage**: Gathering system artifacts (Registry, Prefetch, etc.) using KAPE.
3. **Persistence**: Mapping out how a potential threat might stay on the system.
4. **Log Analysis**: Converting Windows Event Logs into a readable timeline.
5. **Malware Scanning**: Running IOC scans with Thor Lite.

 Included Resources:
* **Start_Investigation_Script.bat**: The main automation script I developed.
* **00_Pre_Investigation**: PowerShell scripts for initial Domain Controller auditing.
* **Playbook.md**: A step-by-step guide I wrote to document the investigation process.

 Important Note:
This repository contains the scripts and the folder structure I designed. **It does not include the third-party tools** (like KAPE or Thor). To use this kit, you need to download the binaries and place them in the correct folders (Step One / Step Two) as explained in the Playbook.
