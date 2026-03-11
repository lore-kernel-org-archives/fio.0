Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6402336D4FD
	for <fio@vger.kernel.org>; Wed, 11 Mar 2026 15:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773244342; cv=none; b=dETyjcjvTwJc8pxSkTrdYeDxAB1ZTmubazQVHJ/nUAxgdoCBuxYP8xFEH+GufpUHTheVz5mKo4fa3Ib/w+u+9oGcu0fs0wPJtST+jmbRCja/2A2gewBjiCPDmwRwJmf6tGaCvJl+YO4c+p9yRBS78pZCfDGfMvSsFUzMetk5OJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773244342; c=relaxed/simple;
	bh=KckfMuUEQih0KMJILqQ387fWebrUnXh5MHnjt37A2lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8jiGqsCqfOEfoX7IPQaVAXUzAwJw3X64R86HI1c2Xn3gmEmJfnqIU55R13yrIzZonmfiQhwFY6IB51XYljRDa+gmOjIPd5mbrWhPzn7p89K6XYuiH6TIovKbPLQHxhhmHqNQZ9M6bC1FuZb1+zbfGYWqHclQJMJLuVPyKVzHCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D6b3MWE9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D6b3MWE9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773244340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kGEqTZsYo0s/smAA4kaafoow6Ha/4TNjrv96bCRJTXA=;
	b=D6b3MWE9/RAsTBg39impb86kFvsqG46qYJNbFO7UZomzHHmFXI4bjwgtGiF1yjxSrq16te
	vXO1J+urIxo7VEJSubJczp6EKuKJgfPphUC9TGnbD2y6mKtB5G9YMFkcNW2CmeKcM731u+
	qEXpIjzsXi9kkDD+Y6J6OaC/2X7Y2mU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-TGRdubJkP-mXowla7VVn1w-1; Wed,
 11 Mar 2026 11:52:17 -0400
X-MC-Unique: TGRdubJkP-mXowla7VVn1w-1
X-Mimecast-MFC-AGG-ID: TGRdubJkP-mXowla7VVn1w_1773244336
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ECD2119560B0;
	Wed, 11 Mar 2026 15:52:15 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.69])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4D7531800759;
	Wed, 11 Mar 2026 15:52:14 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: vincentfu@gmail.com,
	axboe@kernel.dk,
	fio@vger.kernel.org
Cc: jvozar@redhat.com,
	jjurca@redhat.com,
	jhladky@redhat.com,
	peterx@redhat.com,
	spetrovi@redhat.com,
	david@kernel.org
Subject: [PATCH v2 1/2] page_fault: add mmap-backed ioengine for anonymous faults
Date: Wed, 11 Mar 2026 09:51:11 -0600
Message-ID: <20260311155114.198006-2-npache@redhat.com>
In-Reply-To: <20260311155114.198006-1-npache@redhat.com>
References: <20260311155114.198006-1-npache@redhat.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Introduce a new ioengine that mmaps anonymous memory and copies data
on read/write to trigger page faults. This allows us to leverage FIOs
powerful framework for MM related testing, and will ideally allow us to
quickly expand testing, by leveraging previously FS related fio scripts.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 Makefile                |   2 +-
 engines/page_fault.c    | 116 ++++++++++++++++++++++++++++++++++++++++
 examples/page_fault.fio |  60 +++++++++++++++++++++
 3 files changed, 177 insertions(+), 1 deletion(-)
 create mode 100644 engines/page_fault.c
 create mode 100644 examples/page_fault.fio

diff --git a/Makefile b/Makefile
index 0337e8fe..099e2f94 100644
--- a/Makefile
+++ b/Makefile
@@ -57,7 +57,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
 		engines/ftruncate.c engines/fileoperations.c \
-		engines/exec.c \
+		engines/exec.c engines/page_fault.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
diff --git a/engines/page_fault.c b/engines/page_fault.c
new file mode 100644
index 00000000..88108644
--- /dev/null
+++ b/engines/page_fault.c
@@ -0,0 +1,116 @@
+/*
+ * page_fault engine
+ *
+ * IO engine that reads/writes directly to/from anonymous memory
+ * by triggering page faults.
+ */
+#include "fio.h"
+#include "ioengines.h"
+#include <sys/mman.h>
+
+struct fio_page_fault_data {
+  void *mmap_ptr;
+  size_t mmap_sz;
+};
+
+static int fio_page_fault_init(struct thread_data *td) {
+  size_t total_io_size;
+  struct fio_page_fault_data *fpd;
+
+  if (td->o.nr_files > 1) {
+    log_err("page_fault engine does not support multiple files\n");
+    return 1;
+  }
+
+  fpd = calloc(1, sizeof(*fpd));
+  if (!fpd)
+    return 1;
+
+  total_io_size = td->o.size;
+  fpd->mmap_sz = total_io_size;
+  fpd->mmap_ptr = mmap(NULL, total_io_size, PROT_READ | PROT_WRITE,
+                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+  if (fpd->mmap_ptr == MAP_FAILED) {
+    free(fpd);
+    return 1;
+  }
+
+  td->io_ops_data = fpd;
+  FILE_SET_ENG_DATA(td->files[0], fpd);
+  return 0;
+}
+
+static enum fio_q_status fio_page_fault_queue(struct thread_data *td,
+                                              struct io_u *io_u) {
+  void *mmap_head;
+  struct fio_page_fault_data *fpd = FILE_ENG_DATA(io_u->file);
+  if (!fpd) {
+    io_u->error = EINVAL;
+    return FIO_Q_COMPLETED;
+  }
+
+  if (io_u->offset + io_u->buflen > fpd->mmap_sz) {
+    io_u->error = EINVAL;
+    return FIO_Q_COMPLETED;
+  }
+
+  mmap_head = fpd->mmap_ptr + io_u->offset;
+  switch (io_u->ddir) {
+  case DDIR_READ:
+    memcpy(io_u->xfer_buf, mmap_head, io_u->buflen);
+    break;
+  case DDIR_WRITE:
+    memcpy(mmap_head, io_u->xfer_buf, io_u->buflen);
+    break;
+  case DDIR_SYNC:
+  case DDIR_DATASYNC:
+  case DDIR_SYNC_FILE_RANGE:
+  case DDIR_SYNCFS:
+    break;
+  default:
+    io_u->error = EINVAL;
+    break;
+  }
+
+  return FIO_Q_COMPLETED;
+}
+
+static int fio_page_fault_open_file(struct thread_data *td,
+                                    struct fio_file *f) {
+  return 0;
+}
+
+static int fio_page_fault_close_file(struct thread_data *td,
+                                     struct fio_file *f) {
+  return 0;
+}
+
+static void fio_page_fault_cleanup(struct thread_data *td) {
+  struct fio_page_fault_data *fpd = td->io_ops_data;
+
+  if (!fpd)
+    return;
+  if (fpd->mmap_ptr && fpd->mmap_sz)
+    munmap(fpd->mmap_ptr, fpd->mmap_sz);
+  free(fpd);
+}
+
+static struct ioengine_ops ioengine = {
+    .name = "page_fault",
+    .version = FIO_IOOPS_VERSION,
+    .init = fio_page_fault_init,
+    .cleanup = fio_page_fault_cleanup,
+    .queue = fio_page_fault_queue,
+    .open_file = fio_page_fault_open_file,
+    .close_file = fio_page_fault_close_file,
+    .get_file_size = generic_get_file_size,
+    .flags = FIO_SYNCIO | FIO_NOEXTEND | FIO_DISKLESSIO,
+};
+
+static void fio_init fio_page_fault_register(void) {
+  register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_page_fault_unregister(void) {
+  unregister_ioengine(&ioengine);
+}
\ No newline at end of file
diff --git a/examples/page_fault.fio b/examples/page_fault.fio
new file mode 100644
index 00000000..4a49fb7d
--- /dev/null
+++ b/examples/page_fault.fio
@@ -0,0 +1,60 @@
+[global]
+stonewall
+ioengine=page_fault
+size=5*1024*1024*$mb_memory/8 # 5/8 of the memory
+bs=$pagesize
+
+[page_fault_write]
+rw=write
+
+[page_fault_mixed]
+rw=randrw
+rwmixread=50
+
+[page_fault_process_storm]
+size=8*1024*$pagesize
+rw=randrw
+rwmixread=50
+numjobs=$ncpus
+
+[page_fault_mthp]
+bsrange=16k-1M
+blockalign=2M
+rw=write
+
+[page_fault_seq_read]
+rw=read
+
+[page_fault_rand_read]
+rw=randread
+
+[page_fault_rand_write]
+rw=randwrite
+
+[page_fault_warm]
+rw=randrw
+rwmixread=50
+loops=3
+
+[page_fault_read_heavy]
+rw=randrw
+rwmixread=90
+
+[page_fault_write_heavy]
+rw=randrw
+rwmixread=10
+
+[page_fault_large_block]
+bs=2M
+blockalign=2M
+rw=write
+
+[page_fault_cache_hot]
+size=64*$pagesize
+rw=randrw
+rwmixread=50
+loops=100
+
+[page_fault_pressure]
+size=7*1024*1024*$mb_memory/8 # 7/8 of the memory
+rw=write
-- 
2.53.0

