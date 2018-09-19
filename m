Return-Path: <fio-owner@vger.kernel.org>
Received: from forward100j.mail.yandex.net ([5.45.198.240]:60423 "EHLO
        forward100j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728254AbeISVeA (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 19 Sep 2018 17:34:00 -0400
Received: from mxback17o.mail.yandex.net (mxback17o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::68])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id BDC505D86C3A
        for <fio@vger.kernel.org>; Wed, 19 Sep 2018 18:46:48 +0300 (MSK)
From: =?utf-8?B?0JfQsNGF0LDRgNC+0LIg0JDQu9C10LrRgdC10Lk=?= 
        <zakharov.a.g@yandex.ru>
Subject: Fio O_SYNC and libaio on 4.15 kernel doesn't flush data
MIME-Version: 1.0
Date: Wed, 19 Sep 2018 22:46:48 +0700
Message-Id: <1769401537372008@iva3-a2a8aac410a1.qloud-c.yandex.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I'm testing bcache device in ubuntu 16.04 with 4.4 and 4.15 (hwe-edge) kernels and noticed some strange fio behaviour.
When i run fio with --ioengine=libaio and --sync=1 options - it only works as expected on 4.4 kernel. There're additional flush "write" requests, also to backing device of bcache. If i run it on 4.15 - then iops on caching device are same as fio shows and there're no any io on backing device. But, if i set ioengine to posixaio or sync or even if i set --fsync=1 option, then it works as expected on 4.15 - i can see flush io's.
It looks like O_SYNC doesn't work with 4.15 when fio runs with libaio.
Kernel was installed from ubuntu repos, but libaio is used same as for 4.4 kernel and I assume that it is the root cause. But i can't find any proof of this guess.

Have any changes been done in kernel that affect O_SYNC or is it libaio(or fio) bug?

Used fio-2.2.10 and fio-3.9.

Hope for any help with understanding this behaviour.

-- 
Regards,
Aleksei Zakharov


