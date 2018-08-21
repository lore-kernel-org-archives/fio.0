Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:54260 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbeHUNle (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Aug 2018 09:41:34 -0400
Received: by mail-it0-f46.google.com with SMTP id 72-v6so3420368itw.3
        for <fio@vger.kernel.org>; Tue, 21 Aug 2018 03:22:00 -0700 (PDT)
MIME-Version: 1.0
From: Chao Guo <guochao@nutstore.net>
Date: Tue, 21 Aug 2018 18:21:19 +0800
Message-ID: <CADhrBQRs9AnEwucJi01ydagqZjuZ=CYeWKeBG+Ds0P46sb-g+Q@mail.gmail.com>
Subject: [Bug-Report] fio cannot handle some situation
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

1) A description of what you think the bug is:

  when using readwrite=randread and do_verify=1, fio always fails with
'Invalid or incomplete multibyte or wide character'


2) Environment (Linux distro version, kernel version). This is mostly
   needed if it's a build bug.

   CentOS 7(fio 3.1-2)

   CentOS 7(build from github.com/axboe/fio, master)

   Ubuntu 18.04(fio 3.1-1)

3) The output from fio --version.

   See above

4) How to reproduce. Please include a full list of the parameters
   passed to fio and the job file used (if any).

[global]
ioengine=libaio
direct=1
group_reporting
iodepth=128
bs=1M
readwrite=randread
size=500MB
do_verify=1
verify=crc32c-intel

[test]
filename=test

