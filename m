Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D94CC004D4
	for <fio@archiver.kernel.org>; Sat, 21 Jan 2023 13:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjAUNAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 21 Jan 2023 08:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjAUNAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 21 Jan 2023 08:00:10 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3CD458B0
        for <fio@vger.kernel.org>; Sat, 21 Jan 2023 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=3cu9YEbjJeQIDRRpugdPNhoBqH9RZun15u5R+zsNuX0=; b=b/JSbv2OjFWNZ52vi3dZawSXoQ
        m6cPQ4VWJQQMS9+tG90/vU/Z2kDLGS29n0yiUP6bGD9XyEuD1Z9GaQ7e/PpPideIOd/bFlAjY7q/q
        5PiB4KCX8XevY04I6efxuYNvZdkqRSwUAfU5imRDavD5DM/Oyfanpx4dxEWIBNaKF9TPPxxPx3Btw
        UC+BMc4beq8hCU2dyX5so055cqdnQCMPZw8BEumUW28Vbj2hZ4nGZRoXRk4m0UGZtOn91ESssnU1z
        3asLBbSy4r+DubWhk1v1eh6bZ0g6xDcD0HOfQsVZRBfRAEY940X40C81hPZimmbQLvmr5sEuVsmbA
        moNDkyiA==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pJDT5-000ybE-25
        for fio@vger.kernel.org;
        Sat, 21 Jan 2023 12:59:36 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E52A81BC016D; Sat, 21 Jan 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230121130001.E52A81BC016D@kernel.dk>
Date:   Sat, 21 Jan 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 69bb4b00b20047e7b5af9a6e35cc872cae605071:

  tools/fiograph: improve default config file search (2023-01-18 19:52:15 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cab9bedf70f34142b70cf97bf4d8c8df57a6f82f:

  examples: remove test.png (2023-01-19 13:10:22 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      examples: remove test.png

 examples/test.png | Bin 30141 -> 0 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 examples/test.png

---

Diff of recent changes:

diff --git a/examples/test.png b/examples/test.png
deleted file mode 100644
index 6be50029..00000000
Binary files a/examples/test.png and /dev/null differ
