Return-Path: <fio-owner@vger.kernel.org>
Received: from sv65.cmaisonneuve.qc.ca ([206.167.118.84]:24423 "EHLO
        courriel.cmaisonneuve.qc.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753482AbeBFUag (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 6 Feb 2018 15:30:36 -0500
Subject: Re: Curious randwrite results on raid10 md device
References: <a4f3cafa-dd28-28aa-551e-85cb27cf234d@cmaisonneuve.qc.ca>
 <CALjAwxhMC7wt6U+EKNvFeo8EoHKyZqkO5qiCac7TNg7ZJJPvLg@mail.gmail.com>
 <BN1PR0401MB1106A85FFAD6EC920540A9C781FD0@BN1PR0401MB1106.namprd04.prod.outlook.com>
From: =?UTF-8?B?SsOpcsO0bWUgQ2hhcmFvdWk=?= <jcharaoui@cmaisonneuve.qc.ca>
Message-ID: <65ee7bb8-d67e-26d4-d3ab-cc80bf2f2cdb@cmaisonneuve.qc.ca>
Date: Tue, 6 Feb 2018 15:30:34 -0500
MIME-Version: 1.0
In-Reply-To: <BN1PR0401MB1106A85FFAD6EC920540A9C781FD0@BN1PR0401MB1106.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi Kris,

Le 2018-02-06 à 10:24, Kris Davis a écrit :
> The performance variation you mention below doesn't sound unusual for a non-preconditioned SSD.  You didn't mention what sort of "preconditioning" you did to the SSDs prior to your measurements.   You may be unaware that SSDs require some usually extensive preconditioning operations to obtain stable results.  Take a look at the SNIA test methodology for a pretty good explanation (http://www.snia.org/sites/default/files/SSS_PTS_Enterprise_v1.1.pdf) I think starting around page 18.

I think you hit the nail on the head here. I didn't do any sort of 
preconditioning, as I didn't think it necessary. To test this, I created 
a logical volume and an ext4 filesystem on top the the md device and ran 
the same test except with a fixed-size IO file of 10G.

I noticed that at the beginning, fio "lays out" this file, which may be 
just enough "preconditioning" because then the random writes are much 
more stable at the beginning and the curve observed in the previous test 
is absent.

Thanks,

-- Jerome

