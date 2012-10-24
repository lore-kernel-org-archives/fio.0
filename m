Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61184 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935411Ab2JXVpi (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 24 Oct 2012 17:45:38 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so960239oag.19
        for <fio@vger.kernel.org>; Wed, 24 Oct 2012 14:45:38 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Oct 2012 16:45:38 -0500
Message-ID: <CAEQv8RE=W_7RShF-ce1kV1V9VaFSBC4hq=QbxEy9GNHYXDo+uw@mail.gmail.com>
Subject: Anyone doing async I/O on FreeBSD?
From: Tom Blamer <blamer@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On a clean install of 9.0-RELEASE, fio-2.0.10 built from source, any
job with posixaio fails with a "Function not implemented" error (see
below).

It looks like the ports collection contains some kind of emulation
tool for libaio (linux-libaio), should I be looking into that?

bsdserv1# cat doit.job
[doit]
thread
ioengine=posixaio
iodepth=2
size=16M
nrfiles=1
rw=rw
rwmixread=90

bsdserv1# fio doit.job
doit: (g=0): rw=rw, bs=4K-4K/4K-4K/4K-4K, ioengine=posixaio, iodepth=2
fio-2.0.10
Starting 1 thread
fio: pid=100082, err=78/file:engines/posixaio.c:198, func=xfer,
error=Function not implemented

doit: (groupid=0, jobs=1): err=78 (file:engines/posixaio.c:198,
func=xfer, error=Function not implemented): pid=100082: Wed Oct 24
16:27:05 2012
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=5
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=50.0%, 4=50.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=1/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
bsdserv1#
