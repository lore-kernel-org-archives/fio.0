Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/6] binject: don't use void* for pointer arithmetic (gcc)
Date: Mon, 12 Jun 2017 23:02:11 +0300
Message-Id: <20170612200211.17022-7-tkusumi@tuxera.com>
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
 engines/binject.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/engines/binject.c b/engines/binject.c
index 932534a..792dbbd 100644
--- a/engines/binject.c
+++ b/engines/binject.c
@@ -59,11 +59,12 @@ static int pollin_events(struct pollfd *pfds, int fds)
 	return 0;
 }
 
-static unsigned int binject_read_commands(struct thread_data *td, void *p,
+static unsigned int binject_read_commands(struct thread_data *td, void *buf,
 					  int left, int *err)
 {
 	struct fio_file *f;
 	int i, ret, events;
+	char *p = buf;
 
 one_more:
 	events = 0;
-- 
2.9.4


