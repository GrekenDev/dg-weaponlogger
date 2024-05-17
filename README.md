# Weapon Firing Detector

This FiveM script automatically captures a screenshot whenever a player fires a weapon and sends this image along with detailed event information to a configured Discord webhook.

## Features

- **Automatic Screenshot**: Takes a screenshot when a weapon is fired.
- **Discord Integration**: Sends the screenshot and event details directly to Discord.
- **Configurable**: Allows customization of webhook URLs, message appearance, and more.
- **Weapon Blacklist**: Exclude specific weapons from triggering notifications.

## Installation

Follow these steps to install the Weapon Firing Detector on your FiveM server:

1. **Download the Script**:
   Download the latest version of the script from the GitHub repository.
2. **Install the Resource**:
   Copy the `weapon-firing-detector` folder into the `resources` directory of your FiveM server.
3. **Modify Server Configuration**:
   Open your `server.cfg` file and add the following line: ensure dg-weaponlogger

## Configuration

Edit the `config.lua` file within the script's directory to adjust the settings according to your needs:

- **`WebhookUrl`**: Specify the full URL to your Discord webhook.
- **`ScreenshotSettings`**: Configure the screenshot format and quality (e.g., JPEG, PNG, quality level).
- **`ScreenshotCooldown`**: Set the cooldown period (in milliseconds) to prevent excessive screenshot capture.
- **`BlacklistWeapons`**: List of weapon codes that should not trigger screenshots.
- **`DiscordMessageSettings`**:
- `title`: Title of the Discord message.
- `color`: Color code of the message embed.

## Usage

Once installed and configured, the script operates automatically. When a player fires a weapon not on the blacklist, the script captures a screenshot and sends it along with a detailed message to the specified Discord channel.

## Support



## Contributing

Contributions are welcome! If you'd like to improve the Weapon Firing Detector, please fork the repository, make your changes, and submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
