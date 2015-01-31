Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbbAaNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 31 Jan 2015 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YHXeg-0007dQ-JE
	for fio@vger.kernel.org; Sat, 31 Jan 2015 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150131130003.821244018E@lyth.info>
Date: Sat, 31 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d47d7cb371fd24419ea5b4d83469ab66f31aa42e:

  gettime: remember to tear down clock cpumask on normal exit (2015-01-29 09:23:39 -0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e507fa596c6923acc0160de85e7591c91df708e6:

  Update the moral license (2015-01-30 09:38:20 -0800)

----------------------------------------------------------------
Jens Axboe (1):
      Update the moral license

 LICENSE => MORAL-LICENSE |    0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename LICENSE => MORAL-LICENSE (100%)

---

Diff of recent changes:

diff --git a/LICENSE b/LICENSE
deleted file mode 100644
index d7c0b1b..0000000
--- a/LICENSE
+++ /dev/null
@@ -1,17 +0,0 @@
-As specified by the COPYING file, fio is free software published under version
-2 of the GPL license. That covers the copying part of the license. By using fio,
-you are also promising to uphold the following moral obligations:
-
-- If you publish results that are done using fio, it must be clearly stated
-  that fio was used. The specific version should also be listed.
-
-- If you develop features or bug fixes for fio, they should be sent upstream
-  for inclusion into the main repository. This isn't specific to fio, that
-  is a general rule for any open source project. It's just the Right Thing
-  to do. Plus it means that you don't have to maintain the feature or change
-  internally. In the long run, this is saving you a lot of time.
-
-I would consider the above to fall under "common courtesy", but since
-people tend to have differing opinions of that, it doesn't hurt to spell out
-my expectations clearly.
-
diff --git a/MORAL-LICENSE b/MORAL-LICENSE
new file mode 100644
index 0000000..d7c0b1b
--- /dev/null
+++ b/MORAL-LICENSE
@@ -0,0 +1,17 @@
+As specified by the COPYING file, fio is free software published under version
+2 of the GPL license. That covers the copying part of the license. By using fio,
+you are also promising to uphold the following moral obligations:
+
+- If you publish results that are done using fio, it must be clearly stated
+  that fio was used. The specific version should also be listed.
+
+- If you develop features or bug fixes for fio, they should be sent upstream
+  for inclusion into the main repository. This isn't specific to fio, that
+  is a general rule for any open source project. It's just the Right Thing
+  to do. Plus it means that you don't have to maintain the feature or change
+  internally. In the long run, this is saving you a lot of time.
+
+I would consider the above to fall under "common courtesy", but since
+people tend to have differing opinions of that, it doesn't hurt to spell out
+my expectations clearly.
+
