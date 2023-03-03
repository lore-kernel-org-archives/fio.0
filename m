Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EF5C678D4
	for <fio@archiver.kernel.org>; Fri,  3 Mar 2023 13:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjCCNAT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Mar 2023 08:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjCCNAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Mar 2023 08:00:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960945CC1B
        for <fio@vger.kernel.org>; Fri,  3 Mar 2023 05:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=rIIdydnYq80h8WhqCemNGpujWMrx519Xm1MSGfImGqs=; b=mp+mA6p25M2QsXIvWc0WhBv+Kx
        R3wRrfoWhQStIepok3CILXLUSZqRgOfjWfVx4NYg0NJLrUnIcwq2BbYhtX/AVYvfnagQyoxY7bAxG
        4DVmD8wdPkGoiiNzeMTu2Crb69QHsdH4qpsGBvnzGLQTYZUVHQe3rMJMAYbonzH4IPgOY8L+DBfTQ
        gbWT+nHczx0hOs5MoRQdEvRPDHVTU0G/2GV1s7+5HbE4F4RzlFcA1ZgIE9DjKTMQdU2WKXOnn2fmc
        uTZWvfX5OYJr++s2cR7oLcU6pU8vt4uurS2iBMu+0ITebfOB376/renSy3IrbN7XWdNvr8sw2DO+2
        ukH1EmEQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pY517-0038Vc-1r
        for fio@vger.kernel.org; Fri, 03 Mar 2023 13:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 7AAF61BC0118; Fri,  3 Mar 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230303130002.7AAF61BC0118@kernel.dk>
Date:   Fri,  3 Mar 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5a37211238f995657c50e5d0ea6e5e22ff3ca69e:

  examples: add fiograph diagram for uring-cmd-fdp.fio (2023-02-28 13:58:58 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5f81856714671287e93e087af8943d3d1779dd5f:

  Merge branch 'fiologparser-fix' of https://github.com/patrakov/fio (2023-03-02 19:57:17 -0500)

----------------------------------------------------------------
Alexander Patrakov (1):
      fix fiologparser.py to work with new logging format

Vincent Fu (1):
      Merge branch 'fiologparser-fix' of https://github.com/patrakov/fio

 tools/fiologparser.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/tools/fiologparser.py b/tools/fiologparser.py
index 054f1f60..708c5d49 100755
--- a/tools/fiologparser.py
+++ b/tools/fiologparser.py
@@ -166,7 +166,7 @@ class TimeSeries(object):
         f = open(fn, 'r')
         p_time = 0
         for line in f:
-            (time, value, foo, bar) = line.rstrip('\r\n').rsplit(', ')
+            (time, value) = line.rstrip('\r\n').rsplit(', ')[:2]
             self.add_sample(p_time, int(time), int(value))
             p_time = int(time)
  
