Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33965 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752380AbdCHPIA (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Mar 2017 10:08:00 -0500
Received: by mail-qk0-f182.google.com with SMTP id p64so70326941qke.1
        for <fio@vger.kernel.org>; Wed, 08 Mar 2017 07:07:54 -0800 (PST)
MIME-Version: 1.0
From: Saju Nair <saju.mad.nair@gmail.com>
Date: Wed, 8 Mar 2017 20:37:53 +0530
Message-ID: <CAKV1nBZEgd=r9fjn9xG57c08y-xH44sJiK2r==hGcdCHo0x+zw@mail.gmail.com>
Subject: FIO data integrity - description for different fields
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi FIO community,
I am doing a data integrity checks to an SSD device (DUT - device under test)
This is done with FIO using
-verify=crc32c
-verify_pattern=0x88888888

block size  =4KB

We get a failure, and there are *53248..expected and *53248.received.
Could somebody explain the meta information in the beginning of the block data.
We could locate the LBA (53248 = 0xd000) at location offset = 0x10,
But a comprehensive explanation would help to identify the issue.
What is the CRC32 field ?
Does the CRC32 include the header information as well ?

The Expected file is :
0000000: caac 0500 0010 0000 0000 0000 0000 0000  ................
0000010: 00d0 0000 0000 0000 0000 0000 0000 0000  ................
0000020: 0100 0d00 303c bb47 203f d2f2 8888 8888  ....0<.G ?......
0000030: 8888 8888 8888 8888 8888 8888 8888 8888  ................
0000040: 8888 8888 8888 8888 8888 8888 8888 8888  ................
....
0000fe0: 8888 8888 8888 8888 8888 8888 8888 8888  ................
0000ff0: 8888 8888 8888 8888 8888 8888 8888 8888  ................


Regards,
- Saju.
