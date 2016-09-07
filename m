Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43026 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbcIGMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Sep 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bhbWN-0001jh-DI
        for fio@vger.kernel.org; Wed, 07 Sep 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160907120002.5AD2B2C0285@kernel.dk>
Date: Wed,  7 Sep 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b678fac65b13dabd0f78ceb338547b9acb5a4f2d:

  server: bump version (2016-09-02 11:24:59 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 27c9aab2d9a45a1babf01a3aa0123e1f5ce36a24:

  Makes use of configparser portable to older versions by: - relying on its' own NoOptionError exception - using getter method instead of dictionary overriding - and using readfp() as older version does not autodetect fp vs string types (2016-09-06 10:22:00 -0400)

----------------------------------------------------------------
Karl Cronburg (1):
      Makes use of configparser portable to older versions by:     - relying on its' own NoOptionError exception     - using getter method instead of dictionary overriding     - and using readfp() as older version does not autodetect fp vs string types

 tools/hist/fiologparser_hist.py | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
index 93dca01..ead5e54 100755
--- a/tools/hist/fiologparser_hist.py
+++ b/tools/hist/fiologparser_hist.py
@@ -257,22 +257,22 @@ def main(ctx):
 
     if ctx.job_file:
         try:
-            from configparser import SafeConfigParser
+            from configparser import SafeConfigParser, NoOptionError
         except ImportError:
-            from ConfigParser import SafeConfigParser
+            from ConfigParser import SafeConfigParser, NoOptionError
 
         cp = SafeConfigParser(allow_no_value=True)
         with open(ctx.job_file, 'r') as fp:
-            cp.read(fp)
+            cp.readfp(fp)
 
         if ctx.interval is None:
             # Auto detect --interval value
             for s in cp.sections():
                 try:
-                    hist_msec = cp[s]['log_hist_msec']
+                    hist_msec = cp.get(s, 'log_hist_msec')
                     if hist_msec is not None:
                         ctx.interval = int(hist_msec)
-                except KeyError:
+                except NoOptionError:
                     pass
 
     if ctx.interval is None:
