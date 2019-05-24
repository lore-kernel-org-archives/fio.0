Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:34722 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389057AbfEXMfo (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 24 May 2019 08:35:44 -0400
Received: from pps.filterd (m0170391.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4OCZ7Gw015024
        for <fio@vger.kernel.org>; Fri, 24 May 2019 08:35:43 -0400
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 2sp60jj44x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <fio@vger.kernel.org>; Fri, 24 May 2019 08:35:43 -0400
Received: from pps.filterd (m0134318.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4OCXfuK030041
        for <fio@vger.kernel.org>; Fri, 24 May 2019 08:35:42 -0400
Received: from ausxipps301.us.dell.com (ausxipps301.us.dell.com [143.166.148.223])
        by mx0a-00154901.pphosted.com with ESMTP id 2sjcpe5r05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <fio@vger.kernel.org>; Fri, 24 May 2019 08:35:42 -0400
From: <Kurt.Dorsey@dell.com>
Subject: Reverse Sequential with Offset
Date: Fri, 24 May 2019 12:35:40 +0000
Message-ID: <72b31a3d5cb84498b62265003e6882e2@ausx13mps316.AMER.DELL.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,=20

I am looking to do reverse sequential IO and am having some issues.

Per the man page and docs this is the job I am using, utilizing the read:-6=
4K   Read 32K then backtrack 64K

fio --group_reporting=3D1 --name=3Dreverse_seq --filename=3D/dev/sdb --iode=
pth=3D1 --rw=3Dread:-64K --offset=3D1024K --rwmixwrite=3D0  --bs=3D32K --de=
scription=3D32K_Reverse_Seq --random_generator=3Dtausworthe64 --randrepeat=
=3D1  --numjobs=3D1 --ba=3D4K --ioengine=3Dlibaio  --direct=3D1=20

Looking at the block trace it is definitely doing a reverse sequential but =
it is starting at the LAST LBA of the device and working backwards to 0. =20
  8,16  17        1     0.000000000 58480  Q   R 21781364224 + 64 [fio]
  8,16  19        1     0.008029219     0  C   R 21781364224 + 64 [0]
  8,16  19        2     0.008062815 58480  Q   R 21781364160 + 64 [fio]
  8,16   0        1     0.008550943     0  C   R 21781364160 + 64 [0]
  8,16   0        2     0.008599707 58480  Q   R 21781364096 + 64 [fio]

Unfortunately it doesn't look like --offset is doing what I wanted. Looking=
 at the man page  --offset will not work in this instance "Data before the =
given offset will not be touched."

Since there is a difference on Sequential (and Reverse Sequential) Performa=
nce for HDDs depending on if you are working on the ID or OD I need to give=
 an offset to the job and then have it work backwards from that offset to 0=
 rather than work back from Max LBA to 0. =20

Is there a way to do this or add this functionality?

Thank you,
Kurt

