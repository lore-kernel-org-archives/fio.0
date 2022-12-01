Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B78C47088
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiLAWJT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiLAWJR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:09:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76827193D0
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bCFqzYyTFsCamdBGC0q0qdyPcNO65r+8G7TB8R6uuOo=;
        b=XEyByT/9lC/RYwXXJI3+idDEljlAx1dML5Xa6/U2G3oiqyD2oItn1Vqqgd8JlTsDVVHpHy
        /Odk03N9Xs6h8qtpCg0NgT7loBXREfuSphGRvN3LNjVXiR3dreJ41QJEw6OtRM8WyLm425
        R72Q5T2e03MtDaa6lE4r/iXNUeV9SYA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-F8pfDcqTMDqVYnLBy-b8hw-1; Thu, 01 Dec 2022 17:08:11 -0500
X-MC-Unique: F8pfDcqTMDqVYnLBy-b8hw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AFEB296A60D;
        Thu,  1 Dec 2022 22:08:11 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B472B477F55;
        Thu,  1 Dec 2022 22:08:09 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Vincent Fu <vincentfu@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH v2 02/10] Add engine flag FIO_SKIPPABLE_IOMEM_ALLOC
Date:   Thu,  1 Dec 2022 22:07:55 +0000
Message-Id: <20221201220803.52057-3-afaria@redhat.com>
In-Reply-To: <20221201220803.52057-1-afaria@redhat.com>
References: <20221201220803.52057-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

It makes it valid to set option mem/iomem even when the engine specifies
iomem_alloc and iomem_free callbacks, allowing users to optionally use
fio's customizable memory allocation logic instead of the engine's.

This is in preparation for giving libblkio engine users the choice
between controlling memory allocation or delegating it to the libblkio
library.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 ioengines.h |  2 ++
 memory.c    | 22 ++++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/ioengines.h b/ioengines.h
index 11d2115c..d43540d0 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -87,6 +87,8 @@ enum fio_ioengine_flags {
 	FIO_NO_OFFLOAD	= 1 << 15,	/* no async offload */
 	FIO_ASYNCIO_SETS_ISSUE_TIME
 			= 1 << 16,	/* async ioengine with commit function that sets issue_time */
+	FIO_SKIPPABLE_IOMEM_ALLOC
+			= 1 << 17,	/* skip iomem_alloc & iomem_free if job sets mem/iomem */
 };
 
 /*
diff --git a/memory.c b/memory.c
index 6cf73333..577d3dd5 100644
--- a/memory.c
+++ b/memory.c
@@ -305,16 +305,18 @@ int allocate_io_mem(struct thread_data *td)
 	dprint(FD_MEM, "Alloc %llu for buffers\n", (unsigned long long) total_mem);
 
 	/*
-	 * If the IO engine has hooks to allocate/free memory, use those. But
-	 * error out if the user explicitly asked for something else.
+	 * If the IO engine has hooks to allocate/free memory and the user
+	 * doesn't explicitly ask for something else, use those. But fail if the
+	 * user asks for something else with an engine that doesn't allow that.
 	 */
-	if (td->io_ops->iomem_alloc) {
-		if (fio_option_is_set(&td->o, mem_type)) {
-			log_err("fio: option 'mem/iomem' conflicts with specified IO engine\n");
-			ret = 1;
-		} else
-			ret = td->io_ops->iomem_alloc(td, total_mem);
-	} else if (td->o.mem_type == MEM_MALLOC)
+	if (td->io_ops->iomem_alloc && fio_option_is_set(&td->o, mem_type) &&
+	    !td_ioengine_flagged(td, FIO_SKIPPABLE_IOMEM_ALLOC)) {
+		log_err("fio: option 'mem/iomem' conflicts with specified IO engine\n");
+		ret = 1;
+	} else if (td->io_ops->iomem_alloc &&
+		   !fio_option_is_set(&td->o, mem_type))
+		ret = td->io_ops->iomem_alloc(td, total_mem);
+	else if (td->o.mem_type == MEM_MALLOC)
 		ret = alloc_mem_malloc(td, total_mem);
 	else if (td->o.mem_type == MEM_SHM || td->o.mem_type == MEM_SHMHUGE)
 		ret = alloc_mem_shm(td, total_mem);
@@ -342,7 +344,7 @@ void free_io_mem(struct thread_data *td)
 	if (td->o.odirect || td->o.oatomic)
 		total_mem += page_mask;
 
-	if (td->io_ops->iomem_alloc) {
+	if (td->io_ops->iomem_alloc && !fio_option_is_set(&td->o, mem_type)) {
 		if (td->io_ops->iomem_free)
 			td->io_ops->iomem_free(td);
 	} else if (td->o.mem_type == MEM_MALLOC)
-- 
2.38.1

