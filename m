Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F73C4332F
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiLAWJP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiLAWJI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:09:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BE8286F7
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=R8n3OlXjXWn+zVPiid6BHiNPHtzGvEoq4YSQPihLYPc=;
        b=RsVHz3dd54RHcVACmWm8XkN2Lz9mlpEkhqymNtxvcNLxlRiHDfMBgPF86rVnmvygQIXDoh
        qT7GgSyi/nR88I0KCdfNyFKm+zOusUhEdzc27cUg0rqntg0w2slGBwt8ElWCrz6jfshhBA
        KI27Ogse/auQJ1F8ZgULGIvasPJ2buw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-_vzi_97_PjSYka2u6jgvwg-1; Thu, 01 Dec 2022 17:08:07 -0500
X-MC-Unique: _vzi_97_PjSYka2u6jgvwg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A5CF185A7A8;
        Thu,  1 Dec 2022 22:08:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2699B477F55;
        Thu,  1 Dec 2022 22:08:06 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Vincent Fu <vincentfu@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH v2 00/10] Add a libblkio engine
Date:   Thu,  1 Dec 2022 22:07:53 +0000
Message-Id: <20221201220803.52057-1-afaria@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

v2:
- In the HOWTO and manpage, point users to the libblkio docs to know
  what drivers and properties are available.
- Avoid mentioning libblkio API symbols in the HOWTO and manpage.
- Don't document FIO_OPT_STR_SET options as having type bool in the
  HOWTO and manpage.
- Prevent null deref in fio_blkio_init() error path.
- Fix total_threaded_subjobs() to only count jobs using the libblkio
  engine.
- Force `td->o.disable_slat = 1`, as request enqueueing is fast and it
  is not possible to know exactly when a request is submitted.
- Have all type declarations near the top of the file.
- Be more economical with blank lines.

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

 HOWTO.rst                                 |  95 +++
 Makefile                                  |   6 +
 configure                                 |  25 +
 engines/libblkio.c                        | 914 ++++++++++++++++++++++
 examples/libblkio-io_uring.fio            |  29 +
 examples/libblkio-virtio-blk-vfio-pci.fio |  29 +
 fio.1                                     |  78 ++
 ioengines.h                               |   2 +
 memory.c                                  |  22 +-
 optgroup.h                                |   2 +
 10 files changed, 1192 insertions(+), 10 deletions(-)
 create mode 100644 engines/libblkio.c
 create mode 100644 examples/libblkio-io_uring.fio
 create mode 100644 examples/libblkio-virtio-blk-vfio-pci.fio

-- 
2.38.1

