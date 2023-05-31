Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B220CC77B7A
	for <fio@archiver.kernel.org>; Wed, 31 May 2023 12:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbjEaMAX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 31 May 2023 08:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbjEaMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 May 2023 08:00:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A064D9D
        for <fio@vger.kernel.org>; Wed, 31 May 2023 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=EyAVRWV1bl140JjS5pZmf3DWehvNN7ZQUVH/UHrUTUY=; b=PpJHYxt06LcFSZoMtEUHSmAjJs
        jzfMe3rAgrYDk3YGH94RXbXHcttxpYyvyl876NIsWLCCQ4uBtmWBXvbo/edd4DcrwLjTLQU3cTQny
        3CJOO7n+QSmSOd7Wr3/0P9+DsqjkTRdjvhCIpValTqBjrnsshZDslN3V93VWrfT4im2vX0RaizVhF
        q0E+Z3ch/Yg5EWpmURJxTeY7OkZ6o9jdDnhNGaj4xl7J32S7LJ1fVPZBZ5Y93njjWpuHP7PRAra+X
        7l5ApZg1vYXnYm7lSX1JKlz35ZmF4uSDglI1x43cl07oM8aLuBxeSRVdJR37+55wWzgbwKOHw82Q8
        +ySC3blA==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q4KUo-00FRrZ-2A
        for fio@vger.kernel.org;
        Wed, 31 May 2023 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D29B01BC013A; Wed, 31 May 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230531120001.D29B01BC013A@kernel.dk>
Date:   Wed, 31 May 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 954b86f71b0718943796192be1a89ffb0da5a97c:

  ci: upload tagged GitHub Actions Windows installers as releases (2023-05-24 09:58:11 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4820d46cef75f806d8c95afaa77f86ded4e3603e:

  ci: disable tls for msys2 builds (2023-05-26 20:09:53 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      ci: disable tls for msys2 builds

 ci/actions-build.sh | 3 +++
 1 file changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/ci/actions-build.sh b/ci/actions-build.sh
index 351b8d18..31d3446c 100755
--- a/ci/actions-build.sh
+++ b/ci/actions-build.sh
@@ -53,6 +53,9 @@ main() {
                 "x86_64")
                     ;;
             esac
+            if [ "${CI_TARGET_BUILD}" = "windows-msys2-64" ]; then
+                configure_flags+=("--disable-tls")
+            fi
 	    ;;
     esac
     configure_flags+=(--extra-cflags="${extra_cflags}")
