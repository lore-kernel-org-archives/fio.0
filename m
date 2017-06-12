Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/6] sg: don't use void* for pointer arithmetic (gcc)
Date: Mon, 12 Jun 2017 23:02:09 +0300
Message-Id: <20170612200211.17022-5-tkusumi@tuxera.com>
In-Reply-To: <20170612200211.17022-1-tkusumi@tuxera.com>
References: <20170612200211.17022-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I think gcc extension should be avoided when it can be done by
just changing a pointer type.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/sg.c b/engines/sg.c
index 833d920..4540b57 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -124,7 +124,7 @@ static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
 	}
 
 	while (left) {
-		void *p;
+		char *p;
 
 		dprint(FD_IO, "sgio_getevents: sd %p: left=%d\n", sd, left);
 
-- 
2.9.4


