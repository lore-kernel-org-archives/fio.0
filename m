Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:38860 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbdGYHRR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Jul 2017 03:17:17 -0400
Received: by mail-ua0-f179.google.com with SMTP id w45so96232473uac.5
        for <fio@vger.kernel.org>; Tue, 25 Jul 2017 00:17:17 -0700 (PDT)
MIME-Version: 1.0
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 25 Jul 2017 10:16:35 +0300
Message-ID: <CAHndrBkV55xWU0yioqqYARdE3SzVpjxxnp9e8qoxxF+-Y_5F+A@mail.gmail.com>
Subject: The commit 'filesetup: add native fallocate' breaks on Cygwin
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi
It seems the recent commit 2c3e17be ('filesetup: add native
fallocate') breaks on Cygwin.
It works on FreeBSD by the way.

---
$ uname
CYGWIN_NT-10.0
$ ./fio --name=xxx --ioengine=sync --rw=read --bs=4k --size=1m
fio: this platform does not support process shared mutexes, forcing
use of threads. Use the 'thread' option to get rid of this warning.
xxx: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=sync, iodepth=1
fio-2.21-80-g2c3e
Starting 1 thread

This application has requested the Runtime to terminate it in an unusual way.
Please contact the application's support team for more information.
xxx: Laying out IO file (1 file / 1MiB)
fio: unknown fallocate mode: 0
Assertion failed!
