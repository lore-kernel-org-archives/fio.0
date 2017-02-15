Return-Path: <tkusumi@tuxera.com>
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: [PATCH 2/2] Explicitly check td_trim(td) for the direction of next io_u
Date: Wed, 15 Feb 2017 22:40:55 +0200
Message-ID: <20170215204055.50646-2-tkusumi@tuxera.com>
In-Reply-To: <20170215204055.50646-1-tkusumi@tuxera.com>
References: <20170215204055.50646-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

This else case should explicitly check td_trim(td) since there is
a potential unused enum (e.g. DDIR_WAIT only used by iolog for now).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 io_u.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_u.c b/io_u.c
index f1a3916..69bec4b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -758,8 +758,10 @@ static enum fio_ddir get_rw_ddir(struct thread_data *td)
 		ddir = DDIR_READ;
 	else if (td_write(td))
 		ddir = DDIR_WRITE;
-	else
+	else if (td_trim(td))
 		ddir = DDIR_TRIM;
+	else
+		ddir = DDIR_INVAL;
 
 	td->rwmix_ddir = rate_ddir(td, ddir);
 	return td->rwmix_ddir;
-- 
2.9.3


