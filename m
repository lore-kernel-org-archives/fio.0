Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr60103.outbound.protection.outlook.com ([40.107.6.103]:45975
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726025AbfLYJLw (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Dec 2019 04:11:52 -0500
From: Oleg Sivokon <oleg.sivokon@replix.io>
Subject: Multiple jobs and fill_device
Date: Wed, 25 Dec 2019 09:11:46 +0000
Message-ID: <871rssdb1x.fsf@replix.io>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello list,

I'm wondering how the configuration below is interpreted:

    [global]
    ioengine=3Dlibaio
    direct=3D1
    loops=3D1
    numjobs=3D8
   =20
    [write-prep]
    rw=3Dwrite
    filename=3D/dev/sdb
    iodepth=3D16
    bs=3D16k
    fill_device=3D1
    stonewall=3D1

Will every one of the 8 jobs try to fill the device completely or will
they split the task of filling the device between themselves, where each
will do only 1/8 of filling the device?  My reading of documentation
seems to suggest the device will be filled 8 times, with jobs, possibly,
stepping on each other's toes (i.e. contesting the same block), but I'm
not sure.

Best.

Oleg

