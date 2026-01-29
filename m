Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5939E1ADFE4
	for <fio@vger.kernel.org>; Thu, 29 Jan 2026 18:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769712194; cv=none; b=kZAL7W3nHYD3FQ93iJNU5gdYvGkNeFrPSyzuAQrfbM8ja2q//a6PlOn2chKTE5qAKOm2bi/VoLJIPRBKCwpIk6NV/q/1HoNuOta6PsIVSmw+rfT8dft16T2HEZRvKoladzTv4wzBgPe5cQNoSGxpRbXcu3s9vx7VfNCmxjyNlLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769712194; c=relaxed/simple;
	bh=v3u6rZzv04Ozte6hHFzgftSNZoxEv5nLZZ4HzVC+2zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbVvXRA+OI3WZQKXNLIQDSbStsifvPp9jg4o18L7NSUnH4tvGERMqFYTF2DOk4A9EPHxicGCNZP1HckqKmGQYzyyZbCVHyOqjd4T74jxYlEJQPLpdbOtQ9O3RWHpJXtNvolsB+86RpF8gAzxHfIFtxKrir0xaGm3gAaQLuHDp6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGtRpe5/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGtRpe5/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769712192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wtR0Cwd66yVFVMCrqAXmiG+71//1fY03v7B3n1bdamM=;
	b=ZGtRpe5/3qqamrsvIcuQo/sbbhDLYUUcL4gzZMgesPceACC6QqL0ZmI4vMj+5t1XnIqMQ/
	RtZVr7OsSIUV8EVTBn1i1DS7KK8Mq6aq3v6BOPZDaGHj+LAMjUHsCnoyb53Qjj/JxOg6Dv
	ChXI7Nc6p/qMwqrMEFOu8Tx3Y4tTlt0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-201-b3bzjVesPpC3f846P0i90Q-1; Thu,
 29 Jan 2026 13:43:09 -0500
X-MC-Unique: b3bzjVesPpC3f846P0i90Q-1
X-Mimecast-MFC-AGG-ID: b3bzjVesPpC3f846P0i90Q_1769712188
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68A291956046;
	Thu, 29 Jan 2026 18:43:08 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.167])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2ABAA3001DB7;
	Thu, 29 Jan 2026 18:43:07 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk,
	vincentfu@gmail.com,
	npache@redhat.com,
	david@kernel.org,
	willy@infradead.org
Subject: [RFC 1/2] page_fault: add mmap-backed ioengine for anonymous faults
Date: Thu, 29 Jan 2026 11:43:00 -0700
Message-ID: <20260129184302.34887-2-npache@redhat.com>
In-Reply-To: <20260129184302.34887-1-npache@redhat.com>
References: <20260129184302.34887-1-npache@redhat.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Introduce a new ioengine that mmaps anonymous memory and copies data
on read/write to trigger page faults. This allows us to leverage FIOs
powerful framework for MM related testing, and will ideally allow us to
quickly expand testing, by leveraging previously FS related fio scripts.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 Makefile                |   2 +-
 engines/page_fault.c    | 105 ++++++++++++++++++++++++++++++++++++++++
 examples/page_fault.fio |   9 ++++
 3 files changed, 115 insertions(+), 1 deletion(-)
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
index 00000000..e0a3c9e5
--- /dev/null
+++ b/engines/page_fault.c
@@ -0,0 +1,105 @@
+#include "ioengines.h"
+#include "fio.h"
+#include <sys/mman.h>
+
+struct fio_page_fault_data {
+    void *mmap_ptr;
+    size_t mmap_sz;
+    off_t mmap_off;
+};
+
+static int fio_page_fault_init(struct thread_data *td)
+{
+    size_t total_io_size;
+    struct fio_page_fault_data *fpd = calloc(1, sizeof(*fpd));
+    if (!fpd)
+        return 1;
+    
+    total_io_size = td->o.size;
+    fpd->mmap_sz = total_io_size;
+    fpd->mmap_off = 0;
+    fpd->mmap_ptr = mmap(NULL, total_io_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+    if (fpd->mmap_ptr == MAP_FAILED)
+    {
+        free(fpd);
+        return 1;
+    }
+
+    FILE_SET_ENG_DATA(td->files[0], fpd);
+	return 0;
+}
+
+static int fio_page_fault_prep(struct thread_data *td, struct io_u *io_u)
+{
+	return 0;
+}
+
+static enum fio_q_status fio_page_fault_queue(struct thread_data *td, struct io_u *io_u)
+{
+    void * mmap_head;
+    struct fio_page_fault_data *fpd = FILE_ENG_DATA(io_u->file);
+    if (!fpd)
+        return 1;
+
+    if (io_u->offset + io_u->buflen > fpd->mmap_sz)
+        return 1;
+
+    mmap_head = fpd->mmap_ptr + io_u->offset;
+    switch (io_u->ddir)
+    {
+        case DDIR_READ:
+            for (size_t i = 0; i < io_u->buflen; i++)
+            {
+                ((unsigned char *)(io_u->xfer_buf))[i] = ((unsigned char *)(mmap_head))[i];
+            }
+            break;
+        case DDIR_WRITE:
+            for (size_t i = 0; i < io_u->buflen; i++)
+            {
+                ((unsigned char *)(mmap_head))[i] = ((unsigned char *)(io_u->xfer_buf))[i];
+            }
+            break;
+        default:
+            return 1;
+    }
+
+	return FIO_Q_COMPLETED;
+}
+
+static int fio_page_fault_open_file(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static int fio_page_fault_close_file(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_page_fault_data *fpd = FILE_ENG_DATA(f);
+	if (!fpd)
+		return 1;
+    if (fpd->mmap_ptr && fpd->mmap_sz)
+        munmap(fpd->mmap_ptr, fpd->mmap_sz);
+	free(fpd);
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name		= "page_fault",
+	.version	= FIO_IOOPS_VERSION,
+	.init		= fio_page_fault_init,
+	.prep		= fio_page_fault_prep,
+	.queue		= fio_page_fault_queue,
+	.open_file	= fio_page_fault_open_file,
+	.close_file	= fio_page_fault_close_file,
+	.get_file_size	= generic_get_file_size,
+	.flags		= FIO_SYNCIO | FIO_NOEXTEND | FIO_DISKLESSIO,
+};
+
+static void fio_init fio_page_fault_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_page_fault_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
\ No newline at end of file
diff --git a/examples/page_fault.fio b/examples/page_fault.fio
new file mode 100644
index 00000000..9001f570
--- /dev/null
+++ b/examples/page_fault.fio
@@ -0,0 +1,9 @@
+[global]
+bs=4k
+
+[page_fault]
+ioengine=page_fault
+size=2g
+rw=randrw
+rwmixread=50
+verify=crc32c
\ No newline at end of file
-- 
2.52.0

