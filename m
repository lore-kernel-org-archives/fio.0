Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E13C38142
	for <fio@archiver.kernel.org>; Tue, 24 Jan 2023 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbjAXNAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 24 Jan 2023 08:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjAXNAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Jan 2023 08:00:08 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538463A9D
        for <fio@vger.kernel.org>; Tue, 24 Jan 2023 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Omee+NtVlexbeE7zvxwFx5TcJdpDRKAij1BtNBoui1A=; b=IKdb4sflX+uC0yzEyPKp3JH/G4
        JxnLFD+vozL1R7ftknAi+bSgRviNKoTupD4DC4xqCnQRW//xf67QhjuSjT9mK6M+Y7nkanc2Dh+vi
        dnj/Bw0F+ghlSFloqXiOEYab61EqtXiGJqnw50kFs/jlXyqxdSJL6okbCRxqdb1mu40j26+1s/sue
        5oLqptgb4ZRokn2EBV3Z0O3TCO87vwivyen+2h0LSF8wlgfG3tod7y2qFPbF6Mog9fSEI4WpO5yMl
        0s5/LIODhXqdIMogoJaoamcs/c0zrv3QM/igmdWMISq9vilnaWHpB8I/qYbZ0AtHQMM8PLvYdUW2r
        WF6SZcrw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pKIti-001qil-3A
        for fio@vger.kernel.org;
        Tue, 24 Jan 2023 12:59:35 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E5EBE1BC014D; Tue, 24 Jan 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230124130001.E5EBE1BC014D@kernel.dk>
Date:   Tue, 24 Jan 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit cab9bedf70f34142b70cf97bf4d8c8df57a6f82f:

  examples: remove test.png (2023-01-19 13:10:22 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 13bc47b65d32df6fd212c4687c7fd29b4ab7c09d:

  tools/fiograph: accommodate job files not ending in .fio (2023-01-23 13:51:16 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      tools/fiograph: accommodate job files not ending in .fio

 tools/fiograph/fiograph.py | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/tools/fiograph/fiograph.py b/tools/fiograph/fiograph.py
index 86ed40a8..cfb9b041 100755
--- a/tools/fiograph/fiograph.py
+++ b/tools/fiograph/fiograph.py
@@ -1,4 +1,6 @@
 #!/usr/bin/env python3
+import uuid
+import time
 import errno
 from graphviz import Digraph
 import argparse
@@ -293,13 +295,6 @@ def main():
     global config_file
     args = setup_commandline()
 
-    if args.output is None:
-        output_file = args.file
-        if output_file.endswith('.fio'):
-            output_file = output_file[:-4]
-    else:
-        output_file = args.output
-
     if args.config is None:
         if os.path.exists('fiograph.conf'):
             config_filename = 'fiograph.conf'
@@ -312,9 +307,25 @@ def main():
     config_file = configparser.RawConfigParser(allow_no_value=True)
     config_file.read(config_filename)
 
-    fio_to_graphviz(args.file, args.format).render(output_file, view=args.view)
+    temp_filename = uuid.uuid4().hex
+    image_filename = fio_to_graphviz(args.file, args.format).render(temp_filename, view=args.view)
+
+    output_filename_stub = args.file
+    if args.output:
+        output_filename = args.output
+    else:
+        if output_filename_stub.endswith('.fio'):
+            output_filename_stub = output_filename_stub[:-4]
+        output_filename = image_filename.replace(temp_filename, output_filename_stub)
+    if args.view:
+        time.sleep(1)
+        # allow time for the file to be opened before renaming it
+    os.rename(image_filename, output_filename)
+
     if not args.keep:
-        os.remove(output_file)
+        os.remove(temp_filename)
+    else:
+        os.rename(temp_filename, output_filename_stub + '.gv')
 
 
 main()
