Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.201]:47375 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbcASBQA convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Jan 2016 20:16:00 -0500
Received: from localhost (enchanter.cs.umn.edu [160.94.22.228])
	by mail.cs.umn.edu (Postfix) with ESMTP id 8E7981FEEA5
	for <fio@vger.kernel.org>; Mon, 18 Jan 2016 19:15:59 -0600 (CST)
Received: from mail.cs.umn.edu ([128.101.32.201])
	by localhost (enchanter.cs.umn.edu [160.94.22.228]) (amavisd-new, port 10024)
	with ESMTP id mjtfOiaBhiRk for <fio@vger.kernel.org>;
	Mon, 18 Jan 2016 19:15:58 -0600 (CST)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com [209.85.223.180])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id 7DEBB1FEE9C
	for <fio@vger.kernel.org>; Mon, 18 Jan 2016 19:15:58 -0600 (CST)
Received: by mail-io0-f180.google.com with SMTP id 1so518800312ion.1
        for <fio@vger.kernel.org>; Mon, 18 Jan 2016 17:15:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB1343FA34ED1B8DE6E04DE3D5B1C10@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <56840F80.4060903@kernel.dk> <VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5684A8F1.6010105@kernel.dk> <VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>
 <VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+e=X09zp=HRme4Wwad2_HhmNkOQkL8zXGWozuVWCm+NMYg@mail.gmail.com>
 <VI1PR05MB1343810AF909BB41065666C9B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+e=cxWLEnu3Ve7RQKTh4TQubWMzkt0fkZ_AyKbNPAt21QQ@mail.gmail.com>
 <VI1PR05MB13430232A50B8818A220B23DB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+emwcrcVpuGsHBuNiw28WDKyyuNQvVd7G3QJFuy5siXqYw@mail.gmail.com>
 <VI1PR05MB13431DA43361FC9F4F55FC95B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <VI1PR05MB1343E7E335FA4E27991FD523B1C00@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CAM8G_BJ22QGD3jgKO3i2HXjEpi4He_eUegAr+XDPPO-AYU_5xg@mail.gmail.com>
 <DA15262B-D52B-4FF3-B8A9-079073DEC874@nellans.org> <VI1PR05MB1343FA34ED1B8DE6E04DE3D5B1C10@VI1PR05MB1343.eurprd05.prod.outlook.com>
From: Alireza Haghdoost <alireza@cs.umn.edu>
Date: Mon, 18 Jan 2016 19:15:18 -0600
Message-ID: <CAB-428nR4aYto5P6di8oKM2pDC3ixEy2kfRUoGTjtbs_-BbcKQ@mail.gmail.com>
Subject: Re: How to stress a 8Gbps card to get 500 000 IOPS or 1600 MB/s
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Thierry BERTAUD <tbertaud@conforama.fr>
Cc: David Nellans <david@nellans.org>, "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

I would assume you have a loop-back HBA since you are not going to get
Max Bandwidth with "Unknown" storage device in the back-end.
Your best bet is with large transfer size like:
bs=256k

and high queue depth:
iodepth=256

Make sure your HBA queue depth is not limited.

Do the math again, you cannot get 1600 MB/s with a 8Gbps fiber in theory.

--Alireza

On Mon, Jan 18, 2016 at 7:04 PM, Thierry BERTAUD <tbertaud@conforama.fr> wrote:
> David and Vasu,
>
>>>agree with vasu - assuming you're trying to hit numbers a vendor spec'd however on a flash drive of >>some sort.
>
>>>you're doing random writes which is also tough on some flash drive if they're into write >>amplification. try changing to random reads and you only need a couple of threads (with a depth of >>128 each) to generate enough iodepth to saturate most drives. 64 threads might be more threads >>than you have CPUs to run them so you're switching which also hurts performance
>
> I test against a SAN LUN (Infinidat F2000).
> This my AIX LUN:
> # lsattr -El hdisk6
> PCM             PCM/friend/NFINIDATpcm                                      Path Control Module          False
> PR_key_value                                                                Persistent Reserve Key value True
> algorithm       round_robin                                                 Algorithm                    True
> hcheck_cmd      test_unit_rdy                                               Health Check Command         True
> hcheck_interval 60                                                          Health Check Interval        True
> hcheck_mode     nonactive                                                   Health Check Mode            True
> lun_id          0x1000000000000                                             Logical Unit Number ID       False
> lun_reset_spt   yes                                                         LUN Reset Supported          True
> max_transfer    0x80000                                                     Maximum TRANSFER Size        True
> node_name       0x5742b0f00004c700                                          FC Node Name                 False
> pvid            none                                                        Physical volume identifier   False
> q_type          simple                                                      Queuing TYPE                 True
> queue_depth     64                                                          Queue DEPTH                  True
> reserve_policy  no_reserve                                                  Reserve Policy               True
> rw_timeout      30                                                          READ/WRITE time out value    True
> scsi_id         0x1e0800                                                    SCSI ID                      False
> unique_id       3B1F742b0f0000004c700000000000001d609InfiniBox08NFINIDATfcp Unique device identifier     False
> ww_name         0x5742b0f00004c711                                          FC World Wide Name           False
> #
>
> With this conf:
> # cat randwrite.fio
> [global]
> thread
> numjobs=1
> iodepth=1
> group_reporting
> bs=4k
> norandommap=1
> refill_buffers
> direct=1
> ioengine=posixaio
> runtime=300
> time_based
> filename=/dev/hdisk6
> log_avg_msec=1000
> [randread_32_128]
> rw=randread
> numjobs=32
> iodepth=128
> stonewall
> #
>
> I have now bad resulsts:
> IOPS: 2 800
> Bandwith:11 MB/s
> latency : 6ms
>
> before with old configuration file:
> IOPS: 42 000
> Bandwith:164 MB/s
> latency : 0.2 ms
>
> Regards,
> Thierry--
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
