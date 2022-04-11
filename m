Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F279C433EF
	for <fio@archiver.kernel.org>; Mon, 11 Apr 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243531AbiDKMCX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Apr 2022 08:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiDKMCW (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Apr 2022 08:02:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064D6286C4
        for <fio@vger.kernel.org>; Mon, 11 Apr 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=fByDFQlzq0/9snAV6XQDDBvhO3VeGz1EWZHZkOTEd7A=; b=KXM4f5Q/Tor7rNiRiCwtOojtcJ
        Fykwv45CWksXs1l19gw6OtY5MyM8XN7gctkWhVkB0ka7fmyvZ0jj6d50Y5N3lfxaDlfW28NypvCIm
        RSybnbf5UKMlbo+dOqPhMPvBxVQpRM/YwpTTzxzefogNaAIvAQqCqldCWU/MtPxMDrek4iBgNGoFK
        nymGpKC19n2FfNwRUTDqJfM3WoxFs2KKWaiB9FB+vMVfQPZns/+LqxgMFXpSgTjetxtr4dKv+Q35J
        6Xprunga2PsYbx45WZpThpxWqpEc7xdTSYdD1ovSqqYOnV+wIjEcwhgs3cdgbruVSPnx004SHPu09
        Y/Ih6DRQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ndsiD-00CIdZ-9u
        for fio@vger.kernel.org; Mon, 11 Apr 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 370D51BC012C; Mon, 11 Apr 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220411120002.370D51BC012C@kernel.dk>
Date:   Mon, 11 Apr 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6d01ac19170fadaf46a6db6b4cc347f1b389f422:

  iolog: Use %llu for 64-bit (2022-04-08 12:46:44 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d684bb2839d1fa010fba1e64f9b0c16240d8bdae:

  Merge branch 'fix/remove-sudo-in-test-script' of https://github.com/dpronin/fio (2022-04-10 15:18:42 -0600)

----------------------------------------------------------------
Denis Pronin (1):
      actions-full-test.sh, removed sudo from the script

Jens Axboe (1):
      Merge branch 'fix/remove-sudo-in-test-script' of https://github.com/dpronin/fio

 ci/actions-full-test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 91790664..8282002f 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -6,9 +6,9 @@ main() {
     echo "Running long running tests..."
     export PYTHONUNBUFFERED="TRUE"
     if [[ "${CI_TARGET_ARCH}" == "arm64" ]]; then
-        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20"
+        python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20"
     else
-        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
+        python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
     fi
     make -C doc html
 }
