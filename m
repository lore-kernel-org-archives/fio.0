Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62C3C00A5A
	for <fio@archiver.kernel.org>; Thu, 19 Jan 2023 13:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjASNAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 19 Jan 2023 08:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjASNAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 Jan 2023 08:00:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BAC3581
        for <fio@vger.kernel.org>; Thu, 19 Jan 2023 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=cMurExxi0FxtjCIfUVziCTx+BdYVzANd0m70rTqPVsI=; b=rVm+RfFOgXjajuT25wqKsSvEYH
        9U90DH1TIlVkcK/wdkD9wZXFlLYE/cdvJsxUSLGn9s6Rweb2NDRIGHUWmbqVMtVXAkir99g+xswVo
        ysATAGf0DUqTIf4nDWr7gdXqBEwcW+GHH9O9K5mHdJDKiG0fI016HCDrUd9k+LJoMbt2/D4tmDkBo
        BzL4vJpZrPrD9eBKOLo+rVm9GUDo+ZUX/6bS+jVqxYgw5fdMq1syNV1B7cVLbv7gv4ahRxBtgUMwl
        brf3BcgWMqe0w8saYZJ33JxdikZe8sZ2JQKvc3HZDsKl+FNhTWhwHWNcq9XuZ91DOxmDXwL9FR+7/
        Tse8q3XQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIUWS-000yfP-4N
        for fio@vger.kernel.org; Thu, 19 Jan 2023 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 67FED1BC0175; Thu, 19 Jan 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230119130002.67FED1BC0175@kernel.dk>
Date:   Thu, 19 Jan 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 44834c57f944074684c1b58604cc44199cf5e633:

  examples: add missing fiograph diagram for sg_write_same_ndob.fio (2023-01-11 15:22:40 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 69bb4b00b20047e7b5af9a6e35cc872cae605071:

  tools/fiograph: improve default config file search (2023-01-18 19:52:15 -0500)

----------------------------------------------------------------
Vincent Fu (3):
      tools/fiograph: add link to file formats
      tools/fiograph: improve default output file name
      tools/fiograph: improve default config file search

 tools/fiograph/fiograph.py | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/tools/fiograph/fiograph.py b/tools/fiograph/fiograph.py
index 384decda..86ed40a8 100755
--- a/tools/fiograph/fiograph.py
+++ b/tools/fiograph/fiograph.py
@@ -1,4 +1,5 @@
 #!/usr/bin/env python3
+import errno
 from graphviz import Digraph
 import argparse
 import configparser
@@ -274,7 +275,7 @@ def setup_commandline():
     parser.add_argument('--format', action='store',
                         type=str,
                         default='png',
-                        help='the output format')
+                        help='the output format (see https://graphviz.org/docs/outputs/)')
     parser.add_argument('--view', action='store_true',
                         default=False,
                         help='view the graph')
@@ -283,7 +284,6 @@ def setup_commandline():
                         help='keep the graphviz script file')
     parser.add_argument('--config', action='store',
                         type=str,
-                        default='fiograph.conf',
                         help='the configuration filename')
     args = parser.parse_args()
     return args
@@ -292,13 +292,26 @@ def setup_commandline():
 def main():
     global config_file
     args = setup_commandline()
+
     if args.output is None:
         output_file = args.file
-        output_file = output_file.replace('.fio', '')
+        if output_file.endswith('.fio'):
+            output_file = output_file[:-4]
     else:
         output_file = args.output
+
+    if args.config is None:
+        if os.path.exists('fiograph.conf'):
+            config_filename = 'fiograph.conf'
+        else:
+            config_filename = os.path.join(os.path.dirname(__file__), 'fiograph.conf')
+            if not os.path.exists(config_filename):
+                raise FileNotFoundError("Cannot locate configuration file")
+    else:
+        config_filename = args.config
     config_file = configparser.RawConfigParser(allow_no_value=True)
-    config_file.read(args.config)
+    config_file.read(config_filename)
+
     fio_to_graphviz(args.file, args.format).render(output_file, view=args.view)
     if not args.keep:
         os.remove(output_file)
