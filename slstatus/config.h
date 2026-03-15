/* See LICENSE file for copyright and license details. */

/* interval between updates (in ms) */
const unsigned int interval = 200;

/* text to show if no value can be retrieved */
static const char unknown_str[] = "n/a";

/* maximum output string length */
#define MAXLEN 2048

static const struct arg args[] = {
	/* function       format          argument */
	{ cpu_perc,       " CPU %s%%  ",  NULL },
	{ run_command,    " VOL %s%%  ",  "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '[0-9]+(?=%)' | head -1" },
	{ netspeed_rx,    " ↓ %s  ",      "wlan0" },
	{ netspeed_tx,    " ↑ %s  ",      "wlan0" },
	{ datetime,       " %s ",         "%a %d %b  %H:%M" },
};
