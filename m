Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 07/17] Explicitly check td_trim(td) to detect open(2) flag
Date: Tue,  7 Mar 2017 22:12:58 +0200
Message-Id: <20170307201308.66814-8-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This part is a bit complicated due to td's ddir being a bit flag.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index 9388bfc..fab9c5d 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -619,7 +619,8 @@ open_again:
 			f->fd = dup(STDIN_FILENO);
 		else
 			from_hash = file_lookup_open(f, flags);
-	} else { //td trim
+	} else if (td_trim(td)) {
+		assert(!td_rw(td)); /* should have matched above */
 		flags |= O_RDWR;
 		from_hash = file_lookup_open(f, flags);
 	}
-- 
2.9.3


