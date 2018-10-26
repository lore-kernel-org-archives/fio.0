Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.dell-outbound.iphmx.com ([68.232.153.90]:52787 "EHLO
        esa1.dell-outbound.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728133AbeJ0Hbp (ORCPT
        <rfc822;fio@vger.kernel.org>); Sat, 27 Oct 2018 03:31:45 -0400
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9QMlpKg132228
        for <fio@vger.kernel.org>; Fri, 26 Oct 2018 18:52:50 -0400
Received: from esa4.dell-outbound2.iphmx.com (esa4.dell-outbound2.iphmx.com [68.232.154.98])
        by mx0b-00154901.pphosted.com with ESMTP id 2nc92tgrc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <fio@vger.kernel.org>; Fri, 26 Oct 2018 18:52:50 -0400
From: "Beierl, Mark" <Mark.Beierl@dell.com>
Subject: Re: fio on vmware esxi
Date: Fri, 26 Oct 2018 22:52:31 +0000
Message-ID: <D4B312FE-5719-4B64-A1A8-2D639D4C68DD@emc.com>
References: <001001d460c6$8c44b090$a4ce11b0$@integritech.solutions>
 <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com>
 <AE78B431-F6A6-4796-BB7E-1FE45E328D74@integritech.solutions>
 <0DE2B6A6-1AFB-4FAD-BD99-53136B45BCD8@emc.com>
 <CALjAwxjazAUEip=nea=7K8LVRBRwq6c0h9FheeCVvh372ZvaKw@mail.gmail.com>
 <6E7254E9-4B9B-4208-9392-2ABD43FE36A4@emc.com>
 <555423228.215547.1540355274473@email.1and1.com>
 <CALjAwxi5T_p5JTpRfazPcV1KoeKNm0CnO9ffBKAtCBCAMhA5=w@mail.gmail.com>
 <C7097D32-CB26-49DF-BA3C-A52EAA5A361F@integritech.solutions>
 <D36925B2-A77A-47AD-BDD6-4A45558DC32E@emc.com>
 <2234B3B7-5680-4238-A48C-BED3EA5EA733@integritech.solutions>
 <000601d46d77$201945d0$604bd170$@integritech.solutions>,<AT5PR8401MB11690CF299A451394CCC5640ABF00@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB11690CF299A451394CCC5640ABF00@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-CA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "eliezer@integritech.solutions" <eliezer@integritech.solutions>, Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>



> On Oct 26, 2018, at 18:30, Elliott, Robert (Persistent Memory) <elliott@h=
pe.com> wrote:
>=20
>=20
> [EXTERNAL EMAIL]=20
> Please report any suspicious attachments, links, or requests for sensitiv=
e information.
>=20
>=20
>=20
>> I run FIO with the following parameters and used the different engines I=
 listed above:
>> --randrepeat=3D1
>> --ioengine=3Dposixaio
>> --direct=3D1
>> --sync=3D1
>> --name=3Dmytest
>> --filename=3Dmytestfile.fio
>> --overwrite=3D1
>> --iodepth=3D64
>> --size=3D100MB
>> --readwrite=3Drandrw
>> --rwmixread=3D50
>> --rwmixwrite=3D50
>> --bs=3D16k
>>=20
> ...
>> -ioengine=3Dpsync on a 1000 IOPS Perf storage:::     read=3D177 write=3D=
185 IOPS
>> -ioengine=3Dpvsync on a 1000 IOPS Perf storage:::    read=3D176 write=3D=
184 IOPS
>> -ioengine=3Dsync on a 1000 IOPS Perf storage:::      read=3D145 write=3D=
152 IOPS
>> -ioengine=3Dposixaio on a 1000 IOPS Perf storage:::  read=3D528 write=3D=
551 IOPS*
>>=20
>> Based on the FIO results I posted above, I've concluded that the suitabl=
e FIO engine for Block Storage
>> is "posixaio"; and for NFS it can be psync or pvsync or sync.
>> If I use the FIO engine "posixaio" on VMware to test block storage, I'm =
seeing the expected IOPS.
>> However, if I use the same FIO engine ("posixaio") to test NFS, I'm NOT =
seeing the expected IOPS.  I'd
>> have to use either psync, or pvsync, or sync to see the IOPS I'm expecti=
ng.
>>  These tests are on the same baremetal server running the version of VMW=
are I posted above.
>>=20
>> Can someone please shed some light on why FIO results is skewed when "po=
sixaio" engine is used to test
>> an NFS storage?   The same goes with ioengines psync/pvsync/sync skews I=
OPS  results on a block
>> storage device?
>=20
> NFS might introduce all sorts of problems.  For the block device cases...
>=20
> Synchronous engines like sync do not honor the iodepth; you need to use
> jobs=3D to get multiple concurrent IOs.  posixaio is an  asynchronous eng=
ine,=20
> so it is honoring your iodepth (it spawns threads for you).
>=20
> Also, if your storage devices do any sort of buffering and caching, the
> tiny 100 MiB size is likely to result in lots of cache hits, distorting
> the results.
>=20
> ---
> Robert Elliott, HPE Persistent Memory
>=20

My typical rule of thumb is to make your test data size be around 5x the to=
tal size of all cache available. This can become very large, btw, once you =
factor in SDS like vSAN. =

