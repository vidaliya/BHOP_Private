# Crucible Bhop Server (Garry's Mod)

Private/friends bhop server setup for Arch Linux with SteamCMD, Source dedicated server, Sourcemod/Metamod, and shavit's bhoptimer.

## Directory Layout

```text
gmod-bhop/
├── steamcmd/
├── server/
│   ├── garrysmod/
│   │   ├── cfg/
│   │   │   ├── server.cfg
│   │   │   └── autoexec.cfg
│   │   ├── addons/
│   │   │   └── sourcemod/configs/admins_simple.ini
│   │   ├── maps/
│   │   └── data/
│   ├── mapcycle.txt
│   └── maplist.txt
├── gmod-bhop.service
├── start-bhop.sh
├── update-server.sh
└── README.md
```

## 1) First-time setup (Arch Linux)

Install prerequisites:

```bash
sudo pacman -Syu --needed tmux curl lib32-gcc-libs lib32-glibc ca-certificates
```

Make scripts executable:

```bash
chmod +x ~/gmod-bhop/update-server.sh ~/gmod-bhop/start-bhop.sh
```

Run initial server install/update:

```bash
cd ~/gmod-bhop
./update-server.sh
```

## 2) Install Metamod:Source + SourceMod

After first install, place releases into:

- `~/gmod-bhop/server/garrysmod/addons/`

Recommended workflow:

1. Download latest **Metamod:Source** build for GMod/Source engine from the official website.
2. Download latest **SourceMod** stable build.
3. Extract both archives into `server/garrysmod/` so they create/merge `addons/metamod` and `addons/sourcemod`.
4. Validate load in server console with:
   - `meta version`
   - `sm version`

## 3) Install shavit's bhoptimer

1. Clone/download [shavit's bhoptimer](https://github.com/shavitush/bhoptimer).
2. Compile `.sp` files with SourceMod compiler (`spcomp`) if needed.
3. Copy produced `.smx` files to `garrysmod/addons/sourcemod/plugins/`.
4. Copy accompanying configs/translations as documented by the plugin repo.
5. Restart server and verify commands:
   - `!wr`
   - `!rank`
   - `!top`

### Timer feature goals

- Styles: autohop + scroll (optional sideways)
- Zone system: start/end zones on each map
- HUD: speed, time, sync
- Replays enabled
- Built-in points/ranking by style

## 4) Run server

```bash
cd ~/gmod-bhop
./start-bhop.sh
```

This script updates via SteamCMD then launches srcds with:

- game: `garrysmod`
- app id: `4020`
- tickrate: `100`
- max players: `8`

## 5) Optional systemd service

Install user service as root (replace `diego` with your username):

```bash
sudo cp ~/gmod-bhop/gmod-bhop.service /etc/systemd/system/gmod-bhop@.service
sudo systemctl daemon-reload
sudo systemctl enable --now gmod-bhop@diego
```

Check status/logs:

```bash
systemctl status gmod-bhop@diego
journalctl -u gmod-bhop@diego -f
```

## 6) Maps: starter pool and adding maps

Current curated pool is in both `mapcycle.txt` and `maplist.txt`.

To add maps:

1. Add map `.bsp` files to `server/garrysmod/maps/` **or** mount via workshop collection.
2. Add map names (without `.bsp`) to:
   - `server/mapcycle.txt`
   - `server/maplist.txt`
3. Restart map cycle or change map.

For this private server, FastDL is intentionally omitted.

## 7) Admin setup and commands

`admins_simple.ini` already includes Diego's Steam ID in SourceMod format with root permissions.

Useful commands:

- `!map <mapname>` — change map
- `!addmap <mapname>` — add map to nomination/rotation systems (if enabled)
- `!setzone` — create timer zones
- `!settier <1-6>` — set map tier for points

Other maintenance commands:

- `sm plugins list`
- `sm_reloadadmins`
- `changelevel <mapname>`

## 8) Database: SQLite (default) and MySQL migration path

### SQLite (default)

- Simplest setup, no extra services.
- Timer DB files live under `garrysmod/data/sqlite/` or plugin-defined `data/` paths.

### MySQL/MariaDB (optional later)

If you want persistence across reinstalls/hosts:

1. Install MariaDB server.
2. Create database/user for bhoptimer.
3. Update SourceMod DB config (`addons/sourcemod/configs/databases.cfg`) with credentials.
4. Point shavit modules to named DB entry per plugin docs.

## 9) Configuration notes

- Server name: `Crucible Bhop`
- Password: `[MooseMan98]`
- `sv_airaccelerate 150`
- `sv_autobunnyhopping 1`
- gravity `800`
- stamina costs disabled

Change `rcon_password` in `server.cfg` before public exposure.
