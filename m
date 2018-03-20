Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH] Fix build error (compile-time assertion added by 96344ff0)
Date: Wed, 21 Mar 2018 02:34:18 +0900
Message-Id: <1521567258-1008-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

> optgroup.c:208: error: expected identifier or '(' before 'do'
> optgroup.c:208: error: expected identifier or '(' before 'while'

compiletime_assert() (do{...}while(0)) can't be in global scope.
Not sure where you would want this instead, but main() has one already.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 fio.c      |    1 +
 fio.h      |    1 +
 optgroup.c |    2 --
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fio.c b/fio.c
index 7b61ffc..4998bc0 100644
--- a/fio.c
+++ b/fio.c
@@ -33,6 +33,7 @@ int main(int argc, char *argv[], char *envp[])
 	int ret = 1;
 
 	compiletime_assert(TD_NR <= TD_ENG_FLAG_SHIFT, "TD_ENG_FLAG_SHIFT");
+	compiletime_assert(__FIO_OPT_G_NR <= 8 * sizeof(uint64_t), "__FIO_OPT_G_NR");
 
 	if (initialize_fio(envp))
 		return 1;
diff --git a/fio.h b/fio.h
index 9551048..b15a132 100644
--- a/fio.h
+++ b/fio.h
@@ -28,6 +28,7 @@
 #include "iolog.h"
 #include "helpers.h"
 #include "options.h"
+#include "optgroup.h"
 #include "profile.h"
 #include "fio_time.h"
 #include "gettime.h"
diff --git a/optgroup.c b/optgroup.c
index 1c418f5..b70e301 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -204,5 +204,3 @@ const struct opt_group *opt_group_cat_from_mask(uint64_t *mask)
 {
 	return group_from_mask(fio_opt_cat_groups, mask, FIO_OPT_G_INVALID);
 }
-
-compiletime_assert(__FIO_OPT_G_NR <= 8 * sizeof(uint64_t), "__FIO_OPT_G_NR");
-- 
1.7.1


