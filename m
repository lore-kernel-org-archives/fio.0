Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34838 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933009AbdGTI0v (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Jul 2017 04:26:51 -0400
Received: by mail-qk0-f176.google.com with SMTP id d145so296402qkc.2
        for <fio@vger.kernel.org>; Thu, 20 Jul 2017 01:26:51 -0700 (PDT)
MIME-Version: 1.0
From: Elhamer Oussama AbdelKHalek <abdelkhalekdev@gmail.com>
Date: Thu, 20 Jul 2017 10:26:50 +0200
Message-ID: <CABhOJBTsk9O4ENXxrJagA5BurXWFWQ4Xmue0Wcy4JD1xX-4KBg@mail.gmail.com>
Subject: Random writes' bandwidth evolves differently for different disk's portion
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I've tried to measure the evolution of the bandwidth in an NVMe disk
when i write only a portion of the disk, so i wrote a simple script
that basically do that:

For write portion in {10,20...,100} %
|- Write the entire disk with 1s;
|- Write a portion% of the disk randomly using 128k bs; #using fio
|- Log the bandwidth each 50s
End for
My fio file looks like this:

[global]
ioengine=libaio
iodepth=256
size=X%
direct=1
do_verify=0
continue_on_error=all
filename=/dev/nvme0n1
randseed=1
[write-job]
rw=randwrite
bs=128k
Logically the bandwidth should start from the best bandwidth (for 128k
block size), which is around 1.3 GiB/s for my NVMe, then gets down
till the written portion is met.
But this is not the case, the randwrites for 80%, 90% and 100% of the
disk size start at a different bandwidth than the others!

This chart shows the evolution of the bandwidth for each portion over the time:
https://user-images.githubusercontent.com/2827220/28362904-97f53fdc-6c7e-11e7-80cd-df36ebbe748e.png


If we have 10 identical cars with different fuel amount, shouldn't
they all start at the same speed until the fuel is done !
Does fio take into consideration how much he will write and limit the
bandwidth?!
Is this a normal fio functioning? Or am i missing something about how
fio handles portion random writes?
Thank you.
