Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f42.google.com ([209.85.128.42]:54681 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbeK3PkW (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Nov 2018 10:40:22 -0500
Received: by mail-wm1-f42.google.com with SMTP id z18so4398358wmc.4
        for <fio@vger.kernel.org>; Thu, 29 Nov 2018 20:32:22 -0800 (PST)
Received: from [192.168.29.142] (24-151-137-62.dhcp.oxfr.ma.charter.com. [24.151.137.62])
        by smtp.gmail.com with ESMTPSA id j33sm5649618wre.91.2018.11.29.20.32.20
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Nov 2018 20:32:20 -0800 (PST)
From: Michael Green <mishagreen@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: rbdname question
Message-Id: <01463E86-AD81-4F02-B2D3-C30853376967@gmail.com>
Date: Thu, 29 Nov 2018 23:32:18 -0500
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hello collective wisdom,

fio-3.12 + CEPH 13.2.2 (mimic) here.

So it appears that unlike file based engines such as libaio where =
--filename allows for multiple block devices to be specified on the same =
line,  --rbdname of RBD engine, doesn't accept multiple rbd images =
separated by colon (:). If that's indeed the case, is it possible to =
enable such functionality? If yes, how can I put in a request?

While at this, will the IO be spread evenly among the RBD images,  if I =
specify multiple rbdname  like below?

[global]
invalidate=3D0
ioengine=3Drbd
clientname=3Dcephuser
clustername=3Dceph
pool=3Drbd
rw=3Drandwrite
bs=3D4k

[rbd_iodepth32]
iodepth=3D32
rbdname=3Dimage0
rbdname=3Dimage1

--
Michael=20=

