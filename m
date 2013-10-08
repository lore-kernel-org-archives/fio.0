Return-Path: <honkiko@gmail.com>
MIME-Version: 1.0
From: Hong Zhiguo <honkiko@gmail.com>
Subject: [PATCH] fix crash: free of wrong pointer in bssplit_ddir
Date: Tue, 8 Oct 2013 15:02:25 +0800
Message-ID: <1381215745-15813-1-git-send-email-zhiguohong@tencent.com>
Content-Type: text/plain
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, jaxboe@fusionio.com, Hong Zhiguo <zhiguohong@tencent.com>
List-ID: <fio@vger.kernel.org>

From: Hong Zhiguo <zhiguohong@tencent.com>

I got SIGABRT when I passed "bssplit=4k/10:64k/50:/40" to fio.
It should be "bssplit=4k/10:64k/50:32k/40" but I missed "32k" in
my typing. The bug turns out to be another typo just like mine:)

*** glibc detected *** /viki/lkml/fio/fio: free(): invalid pointer:
0x000000000071fd30 ***
======= Backtrace: =========
/lib/libc.so.6(+0x78bb6)[0x7ffff700cbb6]
/lib/libc.so.6(cfree+0x73)[0x7ffff7013483]
/viki/lkml/fio/fio[0x42c108]
/viki/lkml/fio/fio[0x42c475]
/viki/lkml/fio/fio[0x429194]
/viki/lkml/fio/fio[0x42a888]
/viki/lkml/fio/fio(parse_option+0x101)[0x42ac47]
/viki/lkml/fio/fio(fio_options_parse+0x95)[0x42e5b3]
/viki/lkml/fio/fio(parse_jobs_ini+0x3ae)[0x4103ae]
/viki/lkml/fio/fio(parse_options+0x112)[0x41198a]
/viki/lkml/fio/fio(main+0x3b)[0x460f5b]
/lib/libc.so.6(__libc_start_main+0xfd)[0x7ffff6fb2c4d]
/viki/lkml/fio/fio[0x40a7c9]

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
Tested-by: Hong Zhiguo <zhiguohong@tencent.com>
---
 options.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/options.c b/options.c
index a064764..4b91f52 100644
--- a/options.c
+++ b/options.c
@@ -104,7 +104,7 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 
 		if (str_to_decimal(fname, &val, 1, o)) {
 			log_err("fio: bssplit conversion failed\n");
-			free(o->bssplit);
+			free(bssplit);
 			return 1;
 		}
 
-- 
1.7.0.4


