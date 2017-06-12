Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/6] sg: add missing free(msg); in ->errdetails() handler
Date: Mon, 12 Jun 2017 23:02:06 +0300
Message-Id: <20170612200211.17022-2-tkusumi@tuxera.com>
In-Reply-To: <20170612200211.17022-1-tkusumi@tuxera.com>
References: <20170612200211.17022-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

msg gets malloc'd unconditionally, so we need to free msg if we're
not using msg for ret (strdup isn't really needed here to begin with).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/sg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/engines/sg.c b/engines/sg.c
index 2148e87..9d339bd 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -759,8 +759,10 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 		}
 	}
 
-	if (!ret)
+	if (!ret) {
 		ret = strdup("SG Driver did not report a Host, Driver or Device check");
+		free(msg);
+	}
 
 	return ret;
 }
-- 
2.9.4


