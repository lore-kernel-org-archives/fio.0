Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 3/4] Fix e7e136da (Add device_is_mounted() support for BSDs)
Date: Mon, 17 Oct 2016 23:17:40 +0900
Message-Id: <1476713861-8325-3-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1476713861-8325-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1476713861-8325-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

The actual C code was good, but the code to check getmntinfo(3)
in ./configure was missing * for st. getmntinfo(3) on FreeBSD/
DragonFlyBSD/etc takes statfs** as an argument.

I failed to catch this error as gcc without -Werror only gives
warning and sets $? to 0, though as a result it didn't break anything.

It did nothing to Linux since getmntinfo(3) doesn't compile on
Linux whether arg is * or **.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 configure |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure b/configure
index a24e3ef..e8e6953 100755
--- a/configure
+++ b/configure
@@ -1628,7 +1628,7 @@ cat > $TMPC << EOF
 #include <sys/mount.h>
 int main(int argc, char **argv)
 {
-  struct statfs st;
+  struct statfs *st;
   return getmntinfo(&st, MNT_NOWAIT);
 }
 EOF
-- 
1.7.1


