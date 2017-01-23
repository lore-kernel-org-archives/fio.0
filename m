Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/8] Use ARRAY_SIZE()
Date: Tue, 24 Jan 2017 00:13:05 +0900
Message-Id: <1485184391-11036-2-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

They can assume ARRAY_SIZE() is defined and usable as far as fio's
internal code is concerned (i.e. FIO_INTERNAL defined).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 gclient.c     | 2 +-
 gfio.c        | 2 +-
 lib/num2str.c | 4 +---
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/gclient.c b/gclient.c
index 5ce33d0..928a1b7 100644
--- a/gclient.c
+++ b/gclient.c
@@ -48,7 +48,7 @@ static GtkActionEntry results_menu_items[] = {
 	{ "PrintFile", GTK_STOCK_PRINT, "Print", "<Control>P", NULL, G_CALLBACK(results_print) },
 	{ "CloseFile", GTK_STOCK_CLOSE, "Close", "<Control>W", NULL, G_CALLBACK(results_close) },
 };
-static gint results_nmenu_items = sizeof(results_menu_items) / sizeof(results_menu_items[0]);
+static gint results_nmenu_items = ARRAY_SIZE(results_menu_items);
 
 static const gchar *results_ui_string = " \
 	<ui> \
diff --git a/gfio.c b/gfio.c
index 9ccf78c..9c917cb 100644
--- a/gfio.c
+++ b/gfio.c
@@ -1271,7 +1271,7 @@ static GtkActionEntry menu_items[] = {
 	{ "Quit", GTK_STOCK_QUIT, NULL,   "<Control>Q", NULL, G_CALLBACK(quit_clicked) },
 	{ "About", GTK_STOCK_ABOUT, NULL,  NULL, NULL, G_CALLBACK(about_dialog) },
 };
-static gint nmenu_items = sizeof(menu_items) / sizeof(menu_items[0]);
+static gint nmenu_items = ARRAY_SIZE(menu_items);
 
 static const gchar *ui_string = " \
 	<ui> \
diff --git a/lib/num2str.c b/lib/num2str.c
index 940d4a5..ed3545d 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -4,8 +4,6 @@
 
 #include "../fio.h"
 
-#define ARRAY_LENGTH(arr)	sizeof(arr) / sizeof((arr)[0])
-
 /**
  * num2str() - Cheesy number->string conversion, complete with carry rounding error.
  * @num: quantity (e.g., number of blocks, bytes or bits)
@@ -75,7 +73,7 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 
 	if (modulo == -1U) {
 done:
-		if (post_index >= ARRAY_LENGTH(sistr))
+		if (post_index >= ARRAY_SIZE(sistr))
 			post_index = 0;
 
 		sprintf(buf, "%llu%s%s", (unsigned long long) num,
-- 
2.5.5


