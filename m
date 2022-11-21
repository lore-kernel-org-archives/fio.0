Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7EDC4332F
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 18:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiKUSaJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiKUSaI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 13:30:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F2CD06ED
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 10:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fpAGq2pLZHNpHZ38HM4iDDKPgvb//E8Wy6rwCNu7tTY=;
        b=UMLS4eXygYpXeaQaaCP20xa/ORn4EvbDUFIpsq6fglcM+Cq3OoBQLLJ123xZbNUO0wB1L/
        kpq8FG/SH67BoJeR4tTuDPdjUEFRwLFcWShs55muTi27zEECtF42Y0jgYBN9ww7j9WnO31
        w2PdONvhuQNgBhueKGwd5Zz3uZ329hc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-ktJQ9QG1NTu7ppvGSQDH-w-1; Mon, 21 Nov 2022 13:29:05 -0500
X-MC-Unique: ktJQ9QG1NTu7ppvGSQDH-w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D780485A588
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 18:29:04 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5065492B06;
        Mon, 21 Nov 2022 18:29:03 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH 00/10] Add a libblkio engine
Date:   Mon, 21 Nov 2022 18:28:52 +0000
Message-Id: <20221121182902.373491-1-afaria@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The libblkio library provides a unified API for efficiently accessing
block devices using modern high-performance block I/O interfaces like
io_uring and vhost-user-blk. Using libblkio reduces the amount of code
needed for interfacing with storage devices and allows developers to
focus on their applcations.

Add a libblkio engine that uses libblkio to perform I/O. This is useful
to benchmark the library itself, and also adds support for storage
interfaces and devices otherwise not supported by fio, such as
virtio-blk PCI, vhost-user, and vhost-vDPA devices.

See the libblkio documentation [2] or KVM Forum 2022 [3] presentation
for more information on the library itself.

[1] https://gitlab.com/libblkio/libblkio
[2] https://libblkio.gitlab.io/libblkio/index.html
[3] https://static.sched.com/hosted_files/kvmforum2022/8c/libblkio-kvm-forum-2022.pdf

Alberto Faria (10):
  Add a libblkio engine
  Add engine flag FIO_SKIPPABLE_IOMEM_ALLOC
  engines/libblkio: Allow setting option mem/iomem
  engines/libblkio: Add support for poll queues
  engines/libblkio: Add option libblkio_vectored
  engines/libblkio: Add option libblkio_write_zeroes_on_trim
  engines/libblkio: Add option libblkio_wait_mode
  engines/libblkio: Add option libblkio_force_enable_completion_eventfd
  engines/libblkio: Add options for some driver-specific properties
  engines/libblkio: Share a single blkio instance among threads in same
    process

 HOWTO.rst                                 |  86 ++
 Makefile                                  |   6 +
 configure                                 |  25 +
 engines/libblkio.c                        | 966 ++++++++++++++++++++++
 examples/libblkio-io_uring.fio            |  29 +
 examples/libblkio-virtio-blk-vfio-pci.fio |  28 +
 fio.1                                     |  74 ++
 ioengines.h                               |   2 +
 memory.c                                  |  22 +-
 optgroup.h                                |   2 +
 10 files changed, 1230 insertions(+), 10 deletions(-)
 create mode 100644 engines/libblkio.c
 create mode 100644 examples/libblkio-io_uring.fio
 create mode 100644 examples/libblkio-virtio-blk-vfio-pci.fio

-- 
2.38.1

