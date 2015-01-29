Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43601 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbbA2SHk (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 29 Jan 2015 13:07:40 -0500
Received: by mail-pa0-f46.google.com with SMTP id lj1so41882613pab.5
        for <fio@vger.kernel.org>; Thu, 29 Jan 2015 10:07:39 -0800 (PST)
From: castor.fu@egocast.org
Subject: [PATCH] configure: fix libnuma_v2 probe to work with -Werror
Date: Thu, 29 Jan 2015 10:07:36 -0800
Message-Id: <1422554856-65305-1-git-send-email-castor.fu@egocast.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Castor Fu <castor@alumni.caltech.edu>

From: Castor Fu <castor@alumni.caltech.edu>

I noticed that libnuma_v2 wasn't getting detected in our build
environment because we would get an error that mask was unused.

---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 6e1376f..892335b 100755
--- a/configure
+++ b/configure
@@ -887,7 +887,7 @@ cat > $TMPC << EOF
 int main(int argc, char **argv)
 {
   struct bitmask *mask = numa_parse_nodestring(NULL);
-  return 0;
+  return mask->size == 0;
 }
 EOF
 if compile_prog "" "" "libnuma api"; then
-- 
1.9.3 (Apple Git-50)

