Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD489C433F5
	for <fio@archiver.kernel.org>; Wed,  9 Mar 2022 13:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbiCINBL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Mar 2022 08:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiCINBL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Mar 2022 08:01:11 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F2B172247
        for <fio@vger.kernel.org>; Wed,  9 Mar 2022 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+XdkU+VXX8Ai+X2sw0sxh973e+C7W4Jc0ZkvUjZACj8=; b=iX2vFmYtPVNR+kUSKjGw0EqIp7
        2ZtC5nQtyQfTHO2ukUIjpCTt5AaNYTQuZm3Z7qQBLDDrhubRrfS303iSC8OWZC+V9ykGtgKekc4u/
        3OmKqtAjJxWWOKTuEzsp4gY7kR75Fll5tXjZsGdWR/YNbtpHuNn6iFH8iBWiNcFGtqq31m1laEByf
        2s0fpY1e18RILXdzJRd7MdQ5V8fe+g+JoNIOyMFQVL+63OyvqH/T1orca8Ofim2gswJFtMLOCRlOk
        ffwCEPU5tpHSYrqm7cFVDCnOTZU+i6B5wBbdUKtScz8nsXuAoNN/tVDuxUhodp8H+CFHDzZrh3WjX
        s9GOYxqA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRvvB-00GlS6-PI
        for fio@vger.kernel.org; Wed, 09 Mar 2022 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id F05461BC016E; Wed,  9 Mar 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220309130001.F05461BC016E@kernel.dk>
Date:   Wed,  9 Mar 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit dc44588f2e445edd7a4ca7dc9bf05bb3b4b2789e:

  Makefile: get rid of fortify source (2022-03-07 09:16:39 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a24ef2702e2c1b948df37080eb3f18cca60d414b:

  Merge branch 'master' of https://github.com/dpronin/fio (2022-03-08 16:42:37 -0700)

----------------------------------------------------------------
Denis Pronin (1):
      - fixed typo in configure script

Jens Axboe (1):
      Merge branch 'master' of https://github.com/dpronin/fio

 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index be4605f9..67e5d535 100755
--- a/configure
+++ b/configure
@@ -2098,7 +2098,7 @@ if test "$libhdfs" = "yes" ; then
     hdfs_conf_error=1
   fi
   if test "$FIO_LIBHDFS_INCLUDE" = "" ; then
-    echo "configure: FIO_LIBHDFS_INCLUDE should be defined to libhdfs inlude path"
+    echo "configure: FIO_LIBHDFS_INCLUDE should be defined to libhdfs include path"
     hdfs_conf_error=1
   fi
   if test "$FIO_LIBHDFS_LIB" = "" ; then
