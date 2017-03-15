Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38314 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdCOWKS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Mar 2017 18:10:18 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1coH7L-0005pw-0B
        for fio@vger.kernel.org; Wed, 15 Mar 2017 23:10:03 +0100
From: Antoine Beaupre <anarcat@orangeseeds.org>
Subject: could fio be used to wipe disks?
Date: Wed, 15 Mar 2017 17:42:55 -0400
Message-ID: <87fuie2p40.fsf@curie.anarc.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm writing a stress-testing tool and i'm looking at using fio to
stress-test disks. The point is not exactly to benchmark the disks, but
put sustained load on the disks to make sure they are generally in
working order.

Right now, I came up with something like this:

      fio --name=stressant --readwrite=randrw  --filename=/dev/sdX \
          --size=100% --numjob=4 --sync=1 --direct=1 --group_reporting

My question is:

 1. will this reliably wipe the whole drive? i know that some data can
    remain due to magnetic properties of the drive or nasty SSD tricks,
    but assume we don't do crazy forensics

 2. if not, is there a way to directly test write I/O directly through
    the device (to ignore filesystem-related issues) non-destructively?

Thanks!

A.

PS: for those curious, my prototype is available here:

https://gitlab.com/anarcat/stressant/blob/master/stressant.py

Nothing serious so far...

-- 
La publicité est la dictature invisible de notre société.
                        - Jacques Ellul

