Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AC1C636CC
	for <fio@archiver.kernel.org>; Mon, 13 Feb 2023 13:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjBMNYO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Feb 2023 08:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjBMNYM (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Feb 2023 08:24:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368D45FF4
        for <fio@vger.kernel.org>; Mon, 13 Feb 2023 05:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676294611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VJqYPQGNST8YIxhX73nnzrn6SEVpVfMeaXDqPYq8Ly8=;
        b=UkFLInGn7YjH6Hf6hE5vW3QvRexOjziAOAyptRvHKhnwDQG/Alwd6Ct5pRrvdpl5toD/Pg
        gJw95sI4P3kpYxh8wWqEgs1sfxUCm57/p6p17F3JomU2gl0TTGSjrRnKdOy1ivc47qzB87
        fvTH+XxiBB+Ny/fIi+HTj6VKb+lTgqQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-pYr9TdynPD6VHnNNyDwVPg-1; Mon, 13 Feb 2023 08:23:30 -0500
X-MC-Unique: pYr9TdynPD6VHnNNyDwVPg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC4A51C04336;
        Mon, 13 Feb 2023 13:23:29 +0000 (UTC)
Received: from pick.home.annexia.org (unknown [10.39.192.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49884C16022;
        Mon, 13 Feb 2023 13:23:29 +0000 (UTC)
From:   "Richard W.M. Jones" <rjones@redhat.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org
Subject: [PATCH fio] examples: Small updates to nbd.fio
Date:   Mon, 13 Feb 2023 13:23:27 +0000
Message-Id: <20230213132327.445863-1-rjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Improve the documentation, describing how to use nbdkit with a local
file.  Move the suggested test file to /var/tmp since /tmp might be a
tmpfs.  Use indenting to make it easier to read.

Use ${uri} instead of ${unixsocket} since nbdkit 1.14 was released
nearly 4 years ago.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 examples/nbd.fio | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/examples/nbd.fio b/examples/nbd.fio
index 6900ebe7..31629fad 100644
--- a/examples/nbd.fio
+++ b/examples/nbd.fio
@@ -1,21 +1,25 @@
-# To use fio to test nbdkit:
+# To use fio to test nbdkit + RAM disk:
 #
-# nbdkit -U - memory size=256M --run 'export unixsocket; fio examples/nbd.fio'
+#   nbdkit -U - memory size=256M --run 'export uri; fio examples/nbd.fio'
 #
-# To use fio to test qemu-nbd:
+# To use fio to test nbdkit + local file:
 #
-# rm -f /tmp/disk.img /tmp/socket
-# truncate -s 256M /tmp/disk.img
-# export unixsocket=/tmp/socket
-# qemu-nbd -t -k $unixsocket -f raw /tmp/disk.img &
-# fio examples/nbd.fio
-# killall qemu-nbd
+#   rm -f /var/tmp/disk.img
+#   truncate -s 256M /var/tmp/disk.img
+#   nbdkit -U - file /var/tmp/disk.img --run 'export uri; fio examples/nbd.fio'
+#
+# To use fio to test qemu-nbd + local file:
+#
+#   rm -f /var/tmp/disk.img /var/tmp/socket
+#   truncate -s 256M /var/tmp/disk.img
+#   export uri='nbd+unix:///?socket=/var/tmp/socket'
+#   qemu-nbd -t -k /var/tmp/socket -f raw /var/tmp/disk.img &
+#   fio examples/nbd.fio
+#   killall qemu-nbd
 
 [global]
 ioengine=nbd
-uri=nbd+unix:///?socket=${unixsocket}
-# Starting from nbdkit 1.14 the following will work:
-#uri=${uri}
+uri=${uri}
 rw=randrw
 time_based
 runtime=60
-- 
2.39.0

