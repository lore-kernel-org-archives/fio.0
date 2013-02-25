Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64646 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3BYFsM (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 25 Feb 2013 00:48:12 -0500
Received: by mail-wg0-f54.google.com with SMTP id fm10so2050557wgb.33
        for <fio@vger.kernel.org>; Sun, 24 Feb 2013 21:48:11 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 25 Feb 2013 00:48:10 -0500
Message-ID: <CACTzACXjqA8U8rX8_Da-7-HE-chhf=Y7251Km8Qkm+z=9Aqh4g@mail.gmail.com>
Subject: FIO process priority issue
From: David N <android.wm.edu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm trying to run a reader process and writer process and give higher
priority to the reader.
I ran into an issue below. Am I missing something?

Thanks in advance for your inputs!
David

root@android:/sdcard/tmp # fio random-readwrite2-test.fio
Bad option <prioclass=2>
fio: job random-write dropped

1|root@android:/sdcard/tmp # cat random-readwrite2-test.fio
; parallel random read and write with read priority

[global]
size=128m
bs=4k
directory=/sdcard/tmp/test
randrepeat=1

[random-write]
rw=randwrite
prioclass=2

[random-read]
rw=randread
prioclass=1
