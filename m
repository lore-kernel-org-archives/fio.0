Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:56695 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab3AYLml (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 25 Jan 2013 06:42:41 -0500
Received: by mail-bk0-f53.google.com with SMTP id j10so174049bkw.12
        for <fio@vger.kernel.org>; Fri, 25 Jan 2013 03:42:39 -0800 (PST)
Date: Fri, 25 Jan 2013 12:42:36 +0100
From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Why does 'direct' influence 'fsync'?
Message-ID: <20130125114236.GA26765@stefanha-thinkpad.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Asias He <asias@redhat.com>

Is there a way to flush the disk write cache when O_DIRECT is in use?

It seems that direct=1 causes the fsync setting to be ignored.  Asias
writes:

> The O_DIRECT do affect the flush behaviour. e.g
> 
> guest$ fio --fsync=100 --direct=1
> No virtio_blk_handle_flush is observed on host side every 100 IOs
> 
> guest$ fio --fsync=100 --direct=0
> virtio_blk_handle_flush is observed on host side every 100 IOs

Am I missing a reason for this behavior?  To me it seems weird since you
could already use --fsync=0 --direct=1 if you want to guarantee that
fsync is not called.  I don't see a need to override the fsync setting.

Stefan
