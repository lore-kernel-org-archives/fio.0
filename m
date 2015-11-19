Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36401 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbbKSPhR (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Nov 2015 10:37:17 -0500
Received: by lbblt2 with SMTP id lt2so45947307lbb.3
        for <fio@vger.kernel.org>; Thu, 19 Nov 2015 07:37:15 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 19 Nov 2015 16:37:15 +0100
Message-ID: <CADr68WZZqpVAeS-EuUgc5eOz=XoyrcCWCTymx58WBEAger442A@mail.gmail.com>
Subject: RBD client cache
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

A couple of releases ago, ceph has changed the default value for

rbd cache writethrough until flush

from false to true. As the fio rbd backend currently does not emit the
necessary fsync to trigger writeback mode, this implies that tests
will run in writethrough, possibly giving a significantly reduced
performance when compared to other clients, e.g. when running fio
within a qemu-based instance accessing the same RBD volume.

Would it make sense for fio to simply issue a rbd_flush after each
rbd_open at https://github.com/axboe/fio/blob/master/engines/rbd.c#L138
? Or do you think that this would need a dedicated flag to be enabled?
