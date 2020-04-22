Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726477AbgDVMAc (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 22 Apr 2020 08:00:32 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBCBC03C1A8
        for <fio@vger.kernel.org>; Wed, 22 Apr 2020 05:00:32 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRE35-0007Sy-F2
        for fio@vger.kernel.org; Wed, 22 Apr 2020 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200422120002.0C8091BC016C@kernel.dk>
Date: Wed, 22 Apr 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 173ff874d01466fa19f41998225d173cafd7e3bc:

  json: don't use named initializers for anonymous unions (2020-04-20 21:20:03 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3966740cd903ed95f306e59892075faf9fd2a151:

  Merge branch 'gcc1' of https://github.com/kusumi/fio (2020-04-21 15:44:31 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'gcc1' of https://github.com/kusumi/fio

Tomohiro Kusumi (1):
      json: Fix compile error on RHEL6

 json.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/json.h b/json.h
index b2bb457e..1544ed76 100644
--- a/json.h
+++ b/json.h
@@ -92,9 +92,9 @@ static inline int json_object_add_value_object(struct json_object *obj,
 {
 	struct json_value arg = {
 		.type = JSON_TYPE_OBJECT,
-		.object = val,
 	};
 
+	arg.object = val;
 	return json_object_add_value_type(obj, name, &arg);
 }
 

