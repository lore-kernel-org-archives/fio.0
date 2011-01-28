Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41503 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1A1Wen (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 28 Jan 2011 17:34:43 -0500
Received: by qwa26 with SMTP id 26so3812750qwa.19
        for <fio@vger.kernel.org>; Fri, 28 Jan 2011 14:34:43 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 28 Jan 2011 23:34:42 +0100
Message-ID: <AANLkTim=h7b8_FRy8D=iYpXs6gdGp7_ReN8Gw5VaMQ0K@mail.gmail.com>
Subject: Error while running fio on a samba share
From: Stefano Doni <stefano.doni@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

First of all many thanks for this great tool!


I wanted to test the performance of a samba network share with fio,
file server access pattern.

I can execute it on a local directory without any issue. Too bad, that
is not the case when I run fio on a directory mounted from a samba
share.

I get this error:


ste@ubuntu:~/.gvfs/fio on localhost$ ~/Downloads/fio-1.50/fio
~/iometer-file-access-server.ro --timeout=120
iometer: (g=0): rw=randread, bs=512-64K/512-64K, ioengine=sync, iodepth=64
fio 1.50
Starting 1 process
fio: pid=4999, err=22/file:filesetup.c:495, func=open(iometer.1.0),
error=Invalid argument


Run status group 0 (all jobs):


I even tried to use a normal sync engine, but the error is still there.


Any idea?


Many thanks in advance.
