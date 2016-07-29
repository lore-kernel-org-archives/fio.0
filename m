Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 4/4] Use larger local buffer for I/O engine name
Date: Sat, 30 Jul 2016 00:06:00 +0900
Message-Id: <1469804760-17333-4-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469804760-17333-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469804760-17333-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

16 bytes may not be large enough in the future if a new I/O engine
with a name longer than strlen(name)=15 is added.

The longest one right now seems to be "fusion-aw-sync" which is 14(+1).

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 ioengines.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ioengines.c b/ioengines.c
index f7b5ed6..4129ac2 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -126,7 +126,7 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
 {
 	struct ioengine_ops *ops;
-	char engine[16];
+	char engine[64];
 
 	dprint(FD_IO, "load ioengine %s\n", name);
 
-- 
1.7.1


