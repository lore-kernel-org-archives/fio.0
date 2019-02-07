Return-Path: <fio-owner@vger.kernel.org>
Received: from forward100j.mail.yandex.net ([5.45.198.240]:49301 "EHLO
        forward100j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726448AbfBGJV0 (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 7 Feb 2019 04:21:26 -0500
Received: from mxback16g.mail.yandex.net (mxback16g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:316])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id B75ED50E0188
        for <fio@vger.kernel.org>; Thu,  7 Feb 2019 12:21:23 +0300 (MSK)
From: =?utf-8?B?0J/RgNC+0YXQvtGA0L7QsiDQkNC70LXQutGB0LDQvdC00YA=?= 
        <cauhuk@yandex.ru>
Subject: slash problem windows
MIME-Version: 1.0
Date: Thu, 07 Feb 2019 12:21:23 +0300
Message-Id: <48713691549531283@myt6-fe24916a5562.qloud-c.yandex.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello!
3) verison: fio-3.12 (exe, download from bluestop)
2) Environment: Windows 10 professional x64 ver 1803
4) steps to reproduce:
4.1) download and unzip folder (path C: \ fio-3.12-x64)
4.2) creat test "readi.fio" with text:
[global]
ioengine = windowsaio
rw = readwrite
size = 1g
directory = I \: \
thread = 1
[trivial-readwrite-1g]
4.3) launch test from powershell or cmd
FIO created file, but after:
trivial-readwrite-1g: Laying out IO file (1 file / 1024MiB)
windowsaio: failed to open file "I: \ trivial-readwrite-1g.0.0"
trivial-readwrite-1g: No I / O performed by windowsaio, perhaps try - debug = io option for details?

1) What i think about: it’s in windowsaio with the READWRITE command. Write operation or read operation are sucess. But reading after writing catch trouble with windows path slash
Path with folders is failed too : directory = I\:\s\  -> windowsaio: failed to open file "I:\s/trivial-readwrite-1g.0.0"

-- 


