Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f51.google.com ([209.85.221.51]:40942 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbeK2O3q (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Nov 2018 09:29:46 -0500
Received: by mail-wr1-f51.google.com with SMTP id p4so356956wrt.7
        for <fio@vger.kernel.org>; Wed, 28 Nov 2018 19:25:53 -0800 (PST)
Received: from [192.168.29.142] (24-151-137-62.dhcp.oxfr.ma.charter.com. [24.151.137.62])
        by smtp.gmail.com with ESMTPSA id j8sm908430wmd.0.2018.11.28.19.25.51
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Nov 2018 19:25:51 -0800 (PST)
From: Michael Green <mishagreen@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: rados_connect failed / fio_rbd_connect failed
Message-Id: <EF2C30AE-94EF-460F-A641-88CE6B1CD616@gmail.com>
Date: Wed, 28 Nov 2018 22:25:49 -0500
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

FIO 3.12 (2ce58465415fc4d900c4dd89b86acbcaa51d9dfb) here.=20

I'm trying to get FIO w/ RBD engine running on a working CEPH cluster. =
The error I'm getting is:

[cephuser@sm10 ~]$ sudo /usr/local/bin/fio ./rbd.fio
rbd_iodepth32: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) =
4096B-4096B, (T) 4096B-4096B, ioengine=3Drbd, iodepth=3D32
fio-3.12
Starting 1 process
rados_connect failed.
fio_rbd_connect failed.


Run status group 0 (all jobs):

The job file is a slightly modified example/rbd.fio
-----
[global]
invalidate=3D0
ioengine=3Drbd
clientname=3Dcephuser
clustername=3Dceph
pool=3Drbd
rbdname=3Dsm10_v0
rw=3Drandwrite
bs=3D4k

[rbd_iodepth32]
iodepth=3D32
-------
I'm able to run 'ceph status' from the client node (sm10) where FIO =
fails either as root or cephuser.=20

The pool rbd does exist:
[cephuser@sm10 ~]$ ceph osd lspools
4 rbd

The RBD image does exist in that pool:
[cephuser@sm10 ~]$ rbd ls -p rbd | grep sm10_v0
sm10_v0

fio --debug=3Dall isn't helpful. Google turned up some results where =
people changed client name from username to client.username which didn't =
help in my case.

Any pointers how to troubleshoot?

--
Michael Green
mishagreen@gmail.com




