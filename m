Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045DFC43334
	for <fio@archiver.kernel.org>; Mon, 11 Jul 2022 02:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiGKC4C (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 10 Jul 2022 22:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKC4B (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 10 Jul 2022 22:56:01 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7857183B2
        for <fio@vger.kernel.org>; Sun, 10 Jul 2022 19:55:59 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 037DA3200312;
        Sun, 10 Jul 2022 22:55:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 10 Jul 2022 22:55:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsdio.com; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1657508158; x=1657594558; bh=C2nOwk0lxqX19qYb50Mo1rqeQ
        0mHo8dVbutEV+UiGQI=; b=Zt2tk2vZWHpe/Tf3s/uTFnBmOh2DqttnJX+efLmkO
        EEQ2POb1dTqBGZCgydaGel89RRZkwMKmjChHrN55YHhA9WS6jUAX5ym7cFm6qQsP
        8dhtxJa+2FRFHUkluo+hDGT8k4SOjom/H/N9WAfPi1R1GCey8s+0NDd0ayhr+9Cd
        WKB+c9lWgnlY1X/ktrl1MTzyg9rMc6aV3vahw7sgV4SARp7riDD7plJMvYaGFFaN
        T4EBGVwOqSmzmeQshzJmwytWiY+wm4GmVHpZ/AvtkEr+iMdyYUWKRgEy48py6xeb
        Lt/s6PLY3eTjyoi6Ve0GLpfU8FAa3vXsh1secp06D9SzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1657508158; x=1657594558; bh=C2nOwk0lxqX19qYb50Mo1rqeQ0mHo8dVbut
        EV+UiGQI=; b=c05734SYSwNr13WbXbIDGs9WsilCh3/6PvuxmUwJD/e8/b6/UIf
        GW3FBSMAPY/Vbc/1t8C1eppKRYxfLmqQVsF69ceaKNuUaibE45QenwUYHgLWMTLa
        q1ZyNelZsKL0okembE+4go6vRfSt+AtE9iiwNnXAiG1/hR3fYgd9lksJpVNIBeXA
        hJrnfGIpNqNw7zKys7P7C/TvW/J645taCFXLj+oxWS1vPNl9VW3lcYPRzDPQgEHX
        IoX3Rt3x7Pj7M1s5gTb1zg7Gx0VPMOHZPbB1FiSOsGEu3b72Ib6/wdNXxv5kmn6k
        OxDyWIJ14PjKPScKLI8YyLVbKomv36l8pbQ==
X-ME-Sender: <xms:PpHLYo_AjDRvt0PR90OPrZXgqgV1lFlFRihpRRx5O_2lhOCq9uuDyw>
    <xme:PpHLYguTuKKh6mXDPBA1ueKTZI2bQEJdPhUQahYFKi8XZua5tvOWX-DK9viRE8G2T
    3uCK-LQ8Zmt8jf2s9Y>
X-ME-Received: <xmr:PpHLYuDVNixS3Vr8Y9olq6rXbfJxi6JiwQYDIBksy-OxSnBvHrK3sLF4iLJt9WK144OHGOlW5-ja7_67xElSQEaVGrvZ7sxFvo2QdC7wFjfZK94>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejvddgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheptfgvsggvtggt
    rgcuvehrrghnuceorhgvsggvtggtrgessghsughiohdrtghomheqnecuggftrfgrthhtvg
    hrnhepkeegfeffteffgefgffetvdfhgedvjeefgeehgffhfeefteduuefffeetveehtedv
    necuffhomhgrihhnpehgihhthhhusgdrsghlohhgpdgsshguihhordgtohhmpdhkvghrnh
    gvlhdrughkpdhkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmpdhsphhinhhitghs
    rdhnvghtpdguvggsihgrnhdrohhrghdpuhgsuhhnthhurdgtohhmpdgthihgfihinhdrtg
    homhdphhhtmhhlrdhtohdpshhphhhinhigqdguohgtrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprhgvsggvtggtrgessghsughioh
    drtghomh
X-ME-Proxy: <xmx:PpHLYoe848ZU5TPuu6zgewIVUhqb-sMlwqDkeFK4T3A3GYDut1UZEQ>
    <xmx:PpHLYtNTEGX7YGqrleVxNO9NZ37URvXdd4cAPR0yhSZFZzIm0XEmAw>
    <xmx:PpHLYinfrXRu4oJ2k06VaCzihTqbJ-UOPGvrpsps2HYQ6q-8ge4O1Q>
    <xmx:PpHLYr0xTUmR_fsMQg46Q_h6XvuREm8gcxnUUT2d1sk0_f_7AqlgvA>
Feedback-ID: i5b994698:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Jul 2022 22:55:57 -0400 (EDT)
From:   Rebecca Cran <rebecca@bsdio.com>
To:     Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc:     Rebecca Cran <rebecca@bsdio.com>
Subject: [PATCH] Update README.rst to specify secure protocols where possible
Date:   Sun, 10 Jul 2022 20:55:47 -0600
Message-Id: <20220711025547.11917-1-rebecca@bsdio.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Change git clone commands to specify https instead of git or http.
GitHub has removed support for the git protocol
(https://github.blog/changelog/2022-03-15-removed-unencrypted-git-protocol-and-certain-ssh-keys/)
and http accesses will normally redirect to https.

Update links to use https where possible: all the sites with updated links
automatically redirect http accesses to https.

Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
---
 README.rst | 27 ++++++--------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/README.rst b/README.rst
index 527f33ab..ce5c0707 100644
--- a/README.rst
+++ b/README.rst
@@ -27,31 +27,20 @@ Source
 
 Fio resides in a git repo, the canonical place is:
 
-	git://git.kernel.dk/fio.git
-
-When inside a corporate firewall, git:// URL sometimes does not work.
-If git:// does not work, use the http protocol instead:
-
-	http://git.kernel.dk/fio.git
+	https://git.kernel.dk/fio.git
 
 Snapshots are frequently generated and :file:`fio-git-*.tar.gz` include the git
 meta data as well. Other tarballs are archives of official fio releases.
 Snapshots can download from:
 
-	http://brick.kernel.dk/snaps/
+	https://brick.kernel.dk/snaps/
 
 There are also two official mirrors. Both of these are automatically synced with
 the main repository, when changes are pushed. If the main repo is down for some
 reason, either one of these is safe to use as a backup:
 
-	git://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git
-
 	https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git
 
-or
-
-	git://github.com/axboe/fio.git
-
 	https://github.com/axboe/fio.git
 
 
@@ -70,7 +59,7 @@ email to majordomo@vger.kernel.org with
 
 in the body of the email. Archives can be found here:
 
-	http://www.spinics.net/lists/fio/
+	https://www.spinics.net/lists/fio/
 
 or here:
 
@@ -97,12 +86,12 @@ Binary packages
 
 Debian:
 	Starting with Debian "Squeeze", fio packages are part of the official
-	Debian repository. http://packages.debian.org/search?keywords=fio .
+	Debian repository. https://packages.debian.org/search?keywords=fio .
 
 Ubuntu:
 	Starting with Ubuntu 10.04 LTS (aka "Lucid Lynx"), fio packages are part
 	of the Ubuntu "universe" repository.
-	http://packages.ubuntu.com/search?keywords=fio .
+	https://packages.ubuntu.com/search?keywords=fio .
 
 Red Hat, Fedora, CentOS & Co:
 	Starting with Fedora 9/Extra Packages for Enterprise Linux 4, fio
@@ -176,7 +165,7 @@ directory.
 
 How to compile fio on 64-bit Windows:
 
- 1. Install Cygwin (http://www.cygwin.com/). Install **make** and all
+ 1. Install Cygwin (https://www.cygwin.com/). Install **make** and all
     packages starting with **mingw64-x86_64**. Ensure
     **mingw64-x86_64-zlib** are installed if you wish
     to enable fio's log compression functionality.
@@ -205,8 +194,8 @@ browser to :file:`./doc/output/html/index.html`.  To build manual page run
 ``make -C doc man`` and then ``man doc/output/man/fio.1``.  To see what other
 output formats are supported run ``make -C doc help``.
 
-.. _reStructuredText: http://www.sphinx-doc.org/rest.html
-.. _Sphinx: http://www.sphinx-doc.org
+.. _reStructuredText: https://www.sphinx-doc.org/rest.html
+.. _Sphinx: https://www.sphinx-doc.org
 
 
 Platforms
-- 
2.25.1

