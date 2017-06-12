Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/6] sg: drop unneeded strdup from ->errdetails() handler
Date: Mon, 12 Jun 2017 23:02:07 +0300
Message-Id: <20170612200211.17022-3-tkusumi@tuxera.com>
In-Reply-To: <20170612200211.17022-1-tkusumi@tuxera.com>
References: <20170612200211.17022-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

*ret as well as strdup aren't really necessary, but only make the code
complicated as shown in the previous commit. No functional change.

This commit includes reverting of the previous commit.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/sg.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/engines/sg.c b/engines/sg.c
index 9d339bd..b924ca3 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -572,17 +572,17 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 	struct sg_io_hdr *hdr = &io_u->hdr;
 #define MAXERRDETAIL 1024
 #define MAXMSGCHUNK  128
-	char *msg, msgchunk[MAXMSGCHUNK], *ret = NULL;
+	char *msg, msgchunk[MAXMSGCHUNK];
 	int i;
 
 	msg = calloc(1, MAXERRDETAIL);
+	strcpy(msg, "");
 
 	/*
 	 * can't seem to find sg_err.h, so I'll just echo the define values
 	 * so others can search on internet to find clearer clues of meaning.
 	 */
 	if (hdr->info & SG_INFO_CHECK) {
-		ret = msg;
 		if (hdr->host_status) {
 			snprintf(msgchunk, MAXMSGCHUNK, "SG Host Status: 0x%02x; ", hdr->host_status);
 			strlcat(msg, msgchunk, MAXERRDETAIL);
@@ -755,16 +755,14 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 		if (hdr->resid != 0) {
 			snprintf(msgchunk, MAXMSGCHUNK, "SG Driver: %d bytes out of %d not transferred. ", hdr->resid, hdr->dxfer_len);
 			strlcat(msg, msgchunk, MAXERRDETAIL);
-			ret = msg;
 		}
 	}
 
-	if (!ret) {
-		ret = strdup("SG Driver did not report a Host, Driver or Device check");
-		free(msg);
-	}
+	if (!(hdr->info & SG_INFO_CHECK) && !strlen(msg))
+		strncpy(msg, "SG Driver did not report a Host, Driver or Device check",
+			MAXERRDETAIL - 1);
 
-	return ret;
+	return msg;
 }
 
 /*
-- 
2.9.4


