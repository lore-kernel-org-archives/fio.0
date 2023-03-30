Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5EDC7619A
	for <fio@archiver.kernel.org>; Thu, 30 Mar 2023 21:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjC3V17 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 30 Mar 2023 17:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjC3V15 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Mar 2023 17:27:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ADC1FC1
        for <fio@vger.kernel.org>; Thu, 30 Mar 2023 14:27:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 205-20020a2503d6000000b00b7411408308so19792746ybd.1
        for <fio@vger.kernel.org>; Thu, 30 Mar 2023 14:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680211675;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zMAftdNnYqJFW9DAl5ZWz3TXAOsGNXgF4f3dazPxjOI=;
        b=q3UJpAeSYj9MV5ouUjel/rZS1locNc1e/fgQOEApQJLQVL20yzf0Lw0WUMef3HnNee
         qvBysiO0/2Hgw5VC0Lk7XQX6pOTQTmus90Nfd+utGYlhf7ZicxwXqwgF4nfUU2ckxFCI
         w0elITt3Eymmy6iWxojPlhfJ0nWd2QGyU2p1CrBFL+mfVO4OF3STzZcUqQqt2SpnWzkc
         OghoK2Kr9C1WvITrp3JttmvbHa6I8WfoAZh+6kcf4OFyy3q+g6k6ChO/ADRA/FV7mKhV
         f6npbpSBTFuQJMi/QEjOFp0VVbmdK7lnyLassQiTQVKWH3nQYXOTsESiBtnjC6HuGrsI
         ESKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680211675;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zMAftdNnYqJFW9DAl5ZWz3TXAOsGNXgF4f3dazPxjOI=;
        b=3rKMUFdMZZEsJaoJrGjOCfJBYJdBg7KSPKCWPsse8oniihJlH+FuwQnzgqrcogpw83
         mUv/xaCgwJPIjWmeW8JBk71UnztAs/XUw6d9mHOfBi4mexaBLjX4PG3ej/52qo991wOM
         9ojBie5yNPgFsYPD1prYIIPS/iTsK8zZSr+g855vBLtnXzjh8tbUBZUJ8sYMuiWTGYa4
         gxB5r8cuXLEyw4DuHNqfSYFYVOHFyoZT9pkfCTIZ5Z94XYbjVRDT8xwEokrsGfOtRfMi
         nmX0MhTes9lLokp/3Vif+h8MJx84XKs3UhvGgaDcoy/XCc2UVy3htSroxjJnaavn+nbl
         +SYQ==
X-Gm-Message-State: AAQBX9cByR/7TLABf3VUElkzY/sJtcaH6o1Uwr2qy6mTY3yHyzwBJDUs
        x102F5mYNsZ4j9iNoR3DnLOlJa6GLmUt
X-Google-Smtp-Source: AKy350YhGD4SvSYuatrAeBPIOweAdv57gut0mqr8Tfj5P0imnDGg8LWERgBS6g3PLCk3UAKLge+prFcYGOkj
X-Received: from yuanchu.svl.corp.google.com ([2620:15c:2d4:203:38bc:7140:ab63:2a52])
 (user=yuanchu job=sendgmr) by 2002:a05:6902:1549:b0:b77:be38:6406 with SMTP
 id r9-20020a056902154900b00b77be386406mr12999729ybu.9.1680211675388; Thu, 30
 Mar 2023 14:27:55 -0700 (PDT)
Date:   Thu, 30 Mar 2023 14:27:04 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230330212705.2992931-1-yuanchu@google.com>
Subject: [PATCH 1/2] fio: add support for POSIX_FADV_NOREUSE
From:   Yuanchu Xie <yuanchu@google.com>
To:     Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        fio@vger.kernel.org
Cc:     Yu Zhao <yuzhao@google.com>,
        "T . J . Alumbaugh" <talumbau@google.com>,
        Yuanchu Xie <yuanchu@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

As of Linux kernel commit 17e810229cb3 ("mm: support
POSIX_FADV_NOREUSE"), POSIX_FADV_NOREUSE hints at the LRU algorithm to
ignore accesses to mapped files with this flag. Previously, it was a
no-op.

Add it in fio as an fadvise_hint option to test the new behavior.

Signed-off-by: Yuanchu Xie <yuanchu@google.com>
---
 fio.h       | 1 +
 ioengines.c | 2 ++
 options.c   | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/fio.h b/fio.h
index 32535517..f2acd430 100644
--- a/fio.h
+++ b/fio.h
@@ -163,6 +163,7 @@ enum {
 	F_ADV_TYPE,
 	F_ADV_RANDOM,
 	F_ADV_SEQUENTIAL,
+	F_ADV_NOREUSE,
 };
 
 /*
diff --git a/ioengines.c b/ioengines.c
index e2316ee4..56759c53 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -565,6 +565,8 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 			flags = POSIX_FADV_RANDOM;
 		else if (td->o.fadvise_hint == F_ADV_SEQUENTIAL)
 			flags = POSIX_FADV_SEQUENTIAL;
+		else if (td->o.fadvise_hint == F_ADV_NOREUSE)
+			flags = POSIX_FADV_NOREUSE;
 		else {
 			log_err("fio: unknown fadvise type %d\n",
 							td->o.fadvise_hint);
diff --git a/options.c b/options.c
index 18857795..fe580ebb 100644
--- a/options.c
+++ b/options.c
@@ -2740,6 +2740,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = F_ADV_SEQUENTIAL,
 			    .help = "Advise using FADV_SEQUENTIAL",
 			  },
+			  { .ival = "noreuse",
+			    .oval = F_ADV_NOREUSE,
+			    .help = "Advise using FADV_NOREUSE",
+			  },
 		},
 		.help	= "Use fadvise() to advise the kernel on IO pattern",
 		.def	= "1",
-- 
2.40.0.348.gf938b09366-goog

