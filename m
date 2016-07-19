Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
Message-ID: <578ea76f.4de0420a.3a0fb.0ce7@mx.google.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] Add missing header inclusion for Android from 1c764dbe
Date: Wed, 20 Jul 2016 07:30:42 +0900
In-Reply-To: <y>
References: <y>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>

1c764dbe (which just got committed) was missing below for Android,
sorry about that.
 #include "./os-linux-syscall.h"

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 os/os-android.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/os/os-android.h b/os/os-android.h
index 70d0570..cdae703 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -16,6 +16,7 @@
 #include <linux/major.h>
 #include <asm/byteorder.h>
 
+#include "./os-linux-syscall.h"
 #include "binject.h"
 #include "../file.h"
 
-- 
1.7.1


