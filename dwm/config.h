/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;        /* snap pixel */
static const int showbar            = 1;         /* 0 means no bar */
static const int topbar             = 1;         /* 0 means bottom bar */
static const char *fonts[]          = { "monospace:size=10" };
static const char dmenufont[]       = "monospace:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class            instance    title   tags mask   isfloating  iscentered  monitor */
	{ "Gimp",           NULL,       NULL,   0,          1,          1,          -1 },
	{ "qutebrowser",    NULL,       NULL,   1 << 0,     0,          0,          -1 },  /* always on tag 1 */
	{ "Thunar",         NULL,       NULL,   0,          1,          1,          -1 },  /* float + center */
};

/* layout(s) */
static const float mfact     = 0.55;  /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;     /* number of clients in master area */
static const int resizehints = 1;     /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1;  /* 1 will force focus on the fullscreen window */
static const int refreshrate = 165;   /* refresh rate for 2560x1600@165hz */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* floating */
	{ "[M]",      monocle }, /* monocle */
};

/* key definitions */
#define MODKEY Mod4Mask   /* Super key */
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]    = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]     = { "kitty", NULL };
static const char *clipmenucmd[] = { "clipmenu", NULL };
static const char *thunarcmd[]   = { "thunar", NULL };
static const char *yazicmd[]     = { "kitty", "-e", "yazi", NULL };
static const char *zedcmd[] = { "/home/bobofthehawk/.local/bin/zed-launch.sh", NULL };

static const Key keys[] = {
	/* modifier                     key                       function        argument */

	/* --- apps --- */
	{ MODKEY,                       XK_d,                     spawn,          {.v = dmenucmd } },                 /* Super+D:           dmenu */
	{ MODKEY,                       XK_Return,                spawn,          {.v = termcmd } },                  /* Super+Enter:       kitty */
	{ MODKEY,                       XK_r,                     spawn,          {.v = zedcmd } },                   /* Super+R:           Zed editor */
	{ MODKEY,                       XK_e,                     spawn,          {.v = thunarcmd } },                /* Super+E:           Thunar */
	{ MODKEY|ShiftMask,             XK_e,                     spawn,          {.v = yazicmd } },                  /* Super+Shift+E:     yazi */
	{ MODKEY,                       XK_c,                     spawn,          {.v = clipmenucmd } },              /* Super+C:           clipboard history */

	/* --- screenshots --- */
	{ 0,                            XK_Print,                 spawn,          SHCMD("f=/home/bobofthehawk/Screenshots/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png; maim $f && xclip -selection clipboard -t image/png < $f") },             /* Print:             full screenshot */
	{ MODKEY|ShiftMask,             XK_s,                     spawn,          SHCMD("f=/home/bobofthehawk/Screenshots/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png; maim -s $f && xclip -selection clipboard -t image/png < $f") },         /* Super+Shift+S:     region screenshot */

	/* --- volume --- */
	{ 0,                            XF86XK_AudioRaiseVolume,  spawn,          SHCMD("pactl set-sink-volume @DEFAULT_SINK@ +5%") },
	{ 0,                            XF86XK_AudioLowerVolume,  spawn,          SHCMD("pactl set-sink-volume @DEFAULT_SINK@ -5%") },
	{ 0,                            XF86XK_AudioMute,         spawn,          SHCMD("pactl set-sink-mute @DEFAULT_SINK@ toggle") },
	{ 0,                            XF86XK_AudioMicMute,      spawn,          SHCMD("pactl set-source-mute @DEFAULT_SOURCE@ toggle") },

	/* --- brightness --- */
	{ 0,                            XF86XK_MonBrightnessUp,   spawn,          SHCMD("brightnessctl set +5%") },
	{ 0,                            XF86XK_MonBrightnessDown, spawn,          SHCMD("brightnessctl set 5%-") },

	/* --- window management --- */
	{ MODKEY,                       XK_q,                     killclient,     {0} },                              /* Super+Q:           close window */
	{ MODKEY,                       XK_b,                     togglebar,      {0} },                              /* Super+B:           toggle bar */
	{ MODKEY,                       XK_j,                     focusstack,     {.i = +1 } },                       /* Super+J:           focus next */
	{ MODKEY,                       XK_k,                     focusstack,     {.i = -1 } },                       /* Super+K:           focus prev */
	{ MODKEY,                       XK_h,                     setmfact,       {.f = -0.05} },                     /* Super+H:           shrink master */
	{ MODKEY,                       XK_l,                     setmfact,       {.f = +0.05} },                     /* Super+L:           grow master */
	{ MODKEY,                       XK_i,                     incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_o,                     incnmaster,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_Return,                zoom,           {0} },                              /* Super+Shift+Enter: swap master */
	{ MODKEY,                       XK_Tab,                   view,           {0} },                              /* Super+Tab:         last tag */
	{ MODKEY|ShiftMask,             XK_space,                 togglefloating, {0} },                              /* Super+Shift+Space: toggle float */

	/* --- layouts --- */
	{ MODKEY,                       XK_t,                     setlayout,      {.v = &layouts[0]} },               /* Super+T:           tile */
	{ MODKEY,                       XK_space,                 setlayout,      {.v = &layouts[1]} },               /* Super+Space:       floating */
	{ MODKEY,                       XK_m,                     setlayout,      {.v = &layouts[2]} },               /* Super+M:           monocle */
	{ MODKEY,                       XK_f,                     togglefullscr,  {0} },                              /* Super+F:           true fullscreen */

	/* --- tags --- */
	{ MODKEY,                       XK_0,                     view,           {.ui = ~0 } },                      /* Super+0:           view all tags */
	{ MODKEY|ShiftMask,             XK_0,                     tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,                 focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period,                focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,                 tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,                tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                     0)
	TAGKEYS(                        XK_2,                     1)
	TAGKEYS(                        XK_3,                     2)
	TAGKEYS(                        XK_4,                     3)
	TAGKEYS(                        XK_5,                     4)
	TAGKEYS(                        XK_6,                     5)
	TAGKEYS(                        XK_7,                     6)
	TAGKEYS(                        XK_8,                     7)
	TAGKEYS(                        XK_9,                     8)
	{ MODKEY|ShiftMask,             XK_q,                     quit,           {0} },                              /* Super+Shift+Q:     quit dwm */
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
