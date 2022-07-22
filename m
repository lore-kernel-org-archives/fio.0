Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEAEC43334
	for <fio@archiver.kernel.org>; Fri, 22 Jul 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiGVMAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 22 Jul 2022 08:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiGVMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Jul 2022 08:00:11 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9178DB62
        for <fio@vger.kernel.org>; Fri, 22 Jul 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=PzNj/GRsjVUBaOZNbuL96UdpTh4bjKlwlcw7BFlC430=; b=OTY+dQZALLjNEp6dM7eVEMmUwg
        97rwTpN9kfwdbAjEWzYh82boweskBI9K3TywDcfRsToNn1HxEBa+/c0Pjytxvz9sZ58OtTpvpSzXk
        E7ACKdm+IZf7nFzbYYQZIFK3CQ332BdWyrpEbr9kSWEQ/1WrqMfAF3KiOulrxihFxseW6h3526wVV
        /BufuMLTDCwAhYZQi5Lus+goyndStJTLLsMCiGdCjRos9uthivq0HF7SChMlT628BrPPhuYzxcnLv
        6qGXfTPg7ZuR+F8FbHzKZiGDl3Jm4Sn060FnoKlWYxnuDY/8KAC3AJX81fmVp9+Xz+FuQ8Ck7hwrg
        dIUXYbTg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oErK9-005qnb-9Z
        for fio@vger.kernel.org; Fri, 22 Jul 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 433B31BC00FB; Fri, 22 Jul 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220722120002.433B31BC00FB@kernel.dk>
Date:   Fri, 22 Jul 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 9c1c1a8d6a4f30eba9595da951d18db1685c03d8:

  engines/http: silence openssl 3.0 deprecation warnings (2022-07-19 13:21:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 02a36caa69f5675f7144fbeddb7a32e1d35ce0c7:

  docs: clarify write_iolog description (2022-07-21 15:18:18 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      docs: clarify write_iolog description

 HOWTO.rst | 3 ++-
 fio.1     | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 470777e2..104cce2d 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3049,7 +3049,8 @@ I/O replay
 
 	Write the issued I/O patterns to the specified file. See
 	:option:`read_iolog`.  Specify a separate file for each job, otherwise the
-	iologs will be interspersed and the file may be corrupt.
+        iologs will be interspersed and the file may be corrupt. This file will
+        be opened in append mode.
 
 .. option:: read_iolog=str
 
diff --git a/fio.1 b/fio.1
index 948c01f9..ce9bf3ef 100644
--- a/fio.1
+++ b/fio.1
@@ -2793,7 +2793,8 @@ of milliseconds. Defaults to 1000.
 .BI write_iolog \fR=\fPstr
 Write the issued I/O patterns to the specified file. See
 \fBread_iolog\fR. Specify a separate file for each job, otherwise the
-iologs will be interspersed and the file may be corrupt.
+iologs will be interspersed and the file may be corrupt. This file will be
+opened in append mode.
 .TP
 .BI read_iolog \fR=\fPstr
 Open an iolog with the specified filename and replay the I/O patterns it
