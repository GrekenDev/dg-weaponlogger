# DG Weapon Logger

DG Weapon Logger is a script for FiveM servers using the QBCore framework. It logs weapon firing events, captures screenshots, and sends the information to a specified Discord channel via webhooks. The script can also filter out blacklisted weapons and jobs.

## Features

- Logs weapon firing events
- Captures screenshots when a weapon is fired
- Sends detailed information to a Discord channel
- Filters out blacklisted weapons and jobs
- Configurable screenshot cooldown
- Debug mode for troubleshooting

## Requirements

- QBCore Framework
- `screenshot-basic` resource
- `oxmysql` resource

## Installation

1. **Clone or Download the Repository:**
   - Clone the repository or download the ZIP file and extract it into your `resources` folder.

2. **Add the Resource to Your Server:**
   - Ensure the resource is added to your server configuration file (`server.cfg` or `resources.cfg`).

    ```plaintext
    ensure dg-weaponlogger
    ```

3. **Configure the Script:**
   - Open `config.lua` and update the settings to your preference. Make sure to set your Discord webhook URLs and other configurations.

    ```lua
    Config = {}

    -- Settings for debug
    Config.Debug = true

    -- URL for Discord webhooks
    Config.WebhookUrlMessage = "YOUR_DISCORD_WEBHOOK_URL_FOR_MESSAGES"
    Config.WebhookUrlScreenshot = "YOUR_DISCORD_WEBHOOK_URL_FOR_SCREENSHOTS"

    -- Settings for screenshot
    Config.ScreenshotSettings = {
        encoding = "png",
        quality = 0.8
    }

    -- Blacklisted weapons
    Config.BlacklistWeapons = {
        "Minigun",
        "Railgun",
        "Taser"
    }

    -- Blacklisted jobs
    Config.BlacklistJobs = {
        "police",
    }

    -- Cooldown time for screenshot (in milliseconds)
    Config.ScreenshotCooldown = 5000

    -- Settings for Discord messages
    Config.DiscordMessageSettings = {
        title = "Shots fired!",
        color = 16711680,  -- Red
        thumbnail_url = "https://example.com/thumbnail.jpg"
    }

    -- Username for Discord webhook
    Config.Username = "Shooting Log"
    ```

4. **Ensure Dependencies are Installed:**
   - Make sure you have `screenshot-basic` and `oxmysql` resources installed and running on your server.

## Usage

Once installed and configured, the script will automatically log weapon firing events, capture screenshots, and send the information to your specified Discord channel.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
