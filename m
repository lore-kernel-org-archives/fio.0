Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42FA5C64EC7
	for <fio@archiver.kernel.org>; Tue, 28 Feb 2023 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjB1NAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 28 Feb 2023 08:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1NAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Feb 2023 08:00:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169401CAC7
        for <fio@vger.kernel.org>; Tue, 28 Feb 2023 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=/e60mDTM4N3ZT/hPKBn+i1LGVqMklFZAKyCkN5TYSiw=; b=RQg2rMsv0tQ+KSGcIWwxj4gB6u
        bhiJpeHfqy3rEffc+9MryWRlTUei7r9lfVoy4IVv+bcnBtt1kw0sSUfUz4vhILtCjo4ks8G80wevd
        jjx31GeQfHEOZRZZ0YzxAZtyIg2gf65dcSdQ4VXXbdntGmMhz4ethbn0Fugw8X4qyowEjX56grW/U
        /Ch7bOxTXwYNKW9OIRgtAwW2GjW2UVU42m9TP18DP4N2AvnizVUdHQT8WMiFwpUpPMN1wcef1HDfN
        ihUoNI5ElvyhrVhn7dB/jGf9SR3sl8hzmjEnGDWERjOjlUdKu/c3pnVdjLRTB1E2GXoecB4tRIDeR
        c21i5Rgg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pWzaO-000ryu-Eu
        for fio@vger.kernel.org; Tue, 28 Feb 2023 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 89C331BC015D; Tue, 28 Feb 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230228130001.89C331BC015D@kernel.dk>
Date:   Tue, 28 Feb 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit b5904c0d7434a49770cdb90eada1c724f0f7fe4e:

  Merge branch 'master' of https://github.com/bvanassche/fio (2023-02-23 20:17:31 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8d94106730d11047f313caadda87e450f242f53c:

  Merge branch 'master' of https://github.com/Cuelive/fio (2023-02-28 05:55:55 -0700)

----------------------------------------------------------------
Cuelive (1):
      blktrace: fix compilation error on the uos system

Jens Axboe (1):
      Merge branch 'master' of https://github.com/Cuelive/fio

 blktrace.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index d5c8aee7..ef9ce6bf 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -5,6 +5,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
+#include <sys/sysmacros.h>
 
 #include "flist.h"
 #include "fio.h"
