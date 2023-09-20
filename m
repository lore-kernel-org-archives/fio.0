Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1529ECE79CF
	for <fio@archiver.kernel.org>; Wed, 20 Sep 2023 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbjITMAP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 20 Sep 2023 08:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbjITMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 20 Sep 2023 08:00:14 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8079AAD
        for <fio@vger.kernel.org>; Wed, 20 Sep 2023 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=yRi9DA2UN9s8K4GYBLOJslL6hBzHuFx77MO9EyJ4foo=; b=RHqohHZHNF6j7enJ66YBUcQbvb
        vBhf/d5L9UmiDuleG7qkXooS7VhsGqLm0dqWXNTJlBxJFnTMGvgWyFAj7NDcvn5TNY5iNqkvCLWe9
        YkBeP9JqLNVJJCnb9sEtKu7v17Dt0t8oST+27JpYQ6BGsWH9P9c7ihRxtFIqIQsL0jy0NrwcXKY3y
        XwiM8DmxUKWc+o9B90AozNAdMkmTiSbGHGf5+QYRSCRDPyomszQ0f5mMBJ2Mp8Qk73tX4AHIomTl+
        NIovW/YsvevZN+wcFtKtu+kScSoJnqpm8ab6m/sV6tMackK6fVIdUVP0iAhME2Q1yc9p/vb0QjHZe
        ije5TpUw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qivsB-00EYjF-3C
        for fio@vger.kernel.org;
        Wed, 20 Sep 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 6B8271BC0175; Wed, 20 Sep 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230920120001.6B8271BC0175@kernel.dk>
Date:   Wed, 20 Sep 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit e2c5f17e3559cc7c96706cd75c2609f12675c60b:

  verify: open state file in binary mode on Windows (2023-09-14 18:54:25 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a142e0df6c1483a76d92ff7f9d8c07242af9910e:

  Merge branch 'fio_client_server_doc_fix' of https://github.com/pcpartpicker/fio (2023-09-20 07:41:17 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'fio_client_server_doc_fix' of https://github.com/pcpartpicker/fio

aggieNick02 (1):
      Update docs to clarify how to pass job options in client mode

 HOWTO.rst | 3 +++
 fio.1     | 3 +++
 2 files changed, 6 insertions(+)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 7f26978a..cc7124b1 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -5105,6 +5105,9 @@ is the connect string, and `remote-args` and `job file(s)` are sent to the
 server. The `server` string follows the same format as it does on the server
 side, to allow IP/hostname/socket and port strings.
 
+Note that all job options must be defined in job files when running fio as a
+client. Any job options specified in `remote-args` will be ignored.
+
 Fio can connect to multiple servers this way::
 
     fio --client=<server1> <job file(s)> --client=<server2> <job file(s)>
diff --git a/fio.1 b/fio.1
index 8159caa4..628e278d 100644
--- a/fio.1
+++ b/fio.1
@@ -4838,6 +4838,9 @@ is the connect string, and `remote\-args' and `job file(s)' are sent to the
 server. The `server' string follows the same format as it does on the server
 side, to allow IP/hostname/socket and port strings.
 .P
+Note that all job options must be defined in job files when running fio as a
+client. Any job options specified in `remote\-args' will be ignored.
+.P
 Fio can connect to multiple servers this way:
 .RS
 .P
