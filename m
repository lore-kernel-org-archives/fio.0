Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB874C001DF
	for <fio@archiver.kernel.org>; Thu,  3 Aug 2023 12:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjHCMAR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Aug 2023 08:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjHCMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Aug 2023 08:00:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD45134
        for <fio@vger.kernel.org>; Thu,  3 Aug 2023 05:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=2Fa79aY/6A8CIqanagsojKuIvkyiV59xqm628FYFFWU=; b=DLzbBOgx5kY+ULVfs/lDRvBgRQ
        GX2KSerUYd76OTu7P9gyKJ/X+ilyZu+2qEEIKnktgqPrLugYiLTrIn8dK36TcV1HE7YEyaTbRE8uC
        rKtWSeBXXXi6TpcY6AyHzLNcT9zSd5Zjz4ZLg41oDGPerffaCUJotMG0wVa4NHATMNpke38rDMYHo
        /ZJjM0aSY74rtqJTc/sHR+uOkiinnew0y59Z3GHPhRrhtoM3LBZ/4ydQFIbLdE0G6YbvzC97mtDJK
        lB1bjhLhHBWSWTuiIX2FVkXNbMcDb/NAosxmrze2lmZPctxcj1/l0KFW88bM5TlE+3FUrOtvJ4zB/
        Tt15BBpw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qRX00-003V0a-Ie
        for fio@vger.kernel.org; Thu, 03 Aug 2023 12:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E50911BC0136; Thu,  3 Aug 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230803120001.E50911BC0136@kernel.dk>
Date:   Thu,  3 Aug 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 1660df6601e24a17dda9e12cbc901337fd5fd925:

  Merge branch 'master' of https://github.com/min22/fio (2023-07-31 15:03:37 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7b57011427a8204bd63671b08dde56cd9e879d68:

  t/fiotestlib: make recorded command prettier (2023-08-02 12:58:16 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      t/nvmept: fix typo
      t/fiotestlib: make recorded command prettier

 t/fiotestlib.py | 2 +-
 t/nvmept.py     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/t/fiotestlib.py b/t/fiotestlib.py
index 0fe17b74..1f35de0a 100755
--- a/t/fiotestlib.py
+++ b/t/fiotestlib.py
@@ -75,7 +75,7 @@ class FioExeTest(FioTest):
         command = [self.paths['exe']] + self.parameters
         with open(self.filenames['cmd'], "w+",
                   encoding=locale.getpreferredencoding()) as command_file:
-            command_file.write(" ".join(command))
+            command_file.write(" \\\n ".join(command))
 
         try:
             with open(self.filenames['stdout'], "w+",
diff --git a/t/nvmept.py b/t/nvmept.py
index cc26d152..c08fb350 100755
--- a/t/nvmept.py
+++ b/t/nvmept.py
@@ -295,7 +295,7 @@ def main():
               'fio_path': fio_path,
               'fio_root': str(Path(__file__).absolute().parent.parent),
               'artifact_root': artifact_root,
-              'basename': 'readonly',
+              'basename': 'nvmept',
               }
 
     _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
