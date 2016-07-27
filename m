Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 10/15] Add missing --cmdhelp type string for FIO_OPT_UNSUPPORTED
Date: Wed, 27 Jul 2016 22:37:15 +0900
Message-Id: <1469626640-13335-10-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Without "unsupported" at index 12 (FIO_OPT_UNSUPPORTED) of typehelp[],
unsupported commands print irrelevant binary at typehelp[12].

 # fio --cmdhelp=numa_cpu_nodes
       numa_cpu_nodes: Build fio with libnuma-dev(el) to enable this option
                 type: ÏÿF
              default: no default

With this commit.
 # fio --cmdhelp=numa_cpu_nodes
       numa_cpu_nodes: Build fio with libnuma-dev(el) to enable this option
                 type: unsupported
              default: no default

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/parse.c b/parse.c
index bb16bc1..086f786 100644
--- a/parse.c
+++ b/parse.c
@@ -109,6 +109,7 @@ static void show_option_help(struct fio_option *o, int is_err)
 		"list of floating point values separated by ':' (opt=5.9:7.8)",
 		"no argument (opt)",
 		"deprecated",
+		"unsupported",
 	};
 	size_t (*logger)(const char *format, ...);
 
-- 
2.5.5


