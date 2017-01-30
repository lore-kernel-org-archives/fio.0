Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:34609 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbdA3Tlu (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 30 Jan 2017 14:41:50 -0500
Received: by mail-qt0-f171.google.com with SMTP id w20so145172045qtb.1
        for <fio@vger.kernel.org>; Mon, 30 Jan 2017 11:41:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANo=J14ZkfPLR020xzii7X-UZdaJOPZU_g__WSECGbDhEF_HMg@mail.gmail.com>
References: <CAPqbHXh4m_UgDRtj1Htb8DByZu2JJxQFB-w8wNZthOJkX64tHA@mail.gmail.com>
 <CANo=J14ZkfPLR020xzii7X-UZdaJOPZU_g__WSECGbDhEF_HMg@mail.gmail.com>
From: Prabhakaran <prabhugce@gmail.com>
Date: Mon, 30 Jan 2017 12:41:49 -0700
Message-ID: <CAPqbHXjmt9=2sB=ooQs635j__=O_uAy7aNO6Wshio-nS62CEGQ@mail.gmail.com>
Subject: Re: Offset in percentage rather than in LBA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tim Walker <tim.t.walker@seagate.com>
Cc: fio@vger.kernel.org

Thanks Tim!! I think, it's the best alternate way at this point and it work=
s :)

On 27 January 2017 at 15:50, Tim Walker <tim.t.walker@seagate.com> wrote:
> I can't answer your question directly, but one could call fio from a BASH
> script that sets environment variables appropriately. Here is an example =
of
> dividing an ATA drive into 4 regions and setting environment variables to
> the starts. You can add offset=3D${offset_1} to your basic fio script the=
n run
> it with these environmental variable set. My script assumes 512 byte
> sectors.
>
> (I didn't actually try the fio part, but I did test the BASH portion, so
> YMMV)
>
> bytes_per_sector=3D512
> maxlba=3D`hdparm -g /dev/sda | grep sectors | awk '{print $6}' | tr ',' '=
 '`
>
> quarter=3D$((${maxlba} / 4 * ${bytes_per_sector}))
> offset_1=3D0
> offset_2=3D$(($quarter * 1))
> offset_3=3D$(($quarter * 2))
> offset_4=3D$(($quarter * 3))
>
> echo $offset_1
> echo $offset_2
> echo $offset_3
> echo $offset_4
>
>
>
> On Fri, Jan 27, 2017 at 2:58 PM, Prabhakaran <prabhugce@gmail.com> wrote:
>>
>> Hi,
>>
>> Can offset be specified in percentage rather than in capacity value
>> like gb or mb?
>> I have a config file which fills a drive once randomly. I got 4 jobs
>> running in parallel (4*64qd=3D256qd) with lba space divided among them.
>> I want to specify in percentage, so that all the jobs are equally
>> used, rather than hard-coding the capacity.
>>
>> The following example configuration is designed for 450GB NVMe drive.
>>
>>
>> #################################################
>> [global]
>> ioengine=3Dlibaio
>> thread
>> cpus_allowed=3D0-7
>> cpus_allowed_policy=3Dsplit
>> direct=3D1
>> size=3D100g
>> loops=3D6
>>
>> [4k-4k_randwrite_0_rd_qd256_numjob1]
>> bs=3D4k
>> ba=3D4k
>> iodepth=3D64
>> offset=3D0
>> rw=3Drandwrite
>> randrepeat=3D0
>> norandommap
>> refill_buffers
>> log_avg_msec=3D1000
>> unified_rw_reporting=3D1
>> write_bw_log=3D4k-4k_randwrite_0_rd_qd256_numjob1
>> write_iops_log=3D4k-4k_randwrite_0_rd_qd256_numjob1
>>
>> [4k-4k_randwrite_0_rd_qd256_numjob2]
>> bs=3D4k
>> ba=3D4k
>> iodepth=3D64
>> offset=3D100g
>> rw=3Drandwrite
>> randrepeat=3D0
>> norandommap
>> refill_buffers
>> log_avg_msec=3D1000
>> unified_rw_reporting=3D1
>> write_bw_log=3D4k-4k_randwrite_0_rd_qd256_numjob2
>> write_iops_log=3D4k-4k_randwrite_0_rd_qd256_numjob2
>>
>> [4k-4k_randwrite_0_rd_qd256_numjob3]
>> bs=3D4k
>> ba=3D4k
>> iodepth=3D64
>> offset=3D200g
>> rw=3Drandwrite
>> randrepeat=3D0
>> norandommap
>> refill_buffers
>> log_avg_msec=3D1000
>> unified_rw_reporting=3D1
>> write_bw_log=3D4k-4k_randwrite_0_rd_qd256_numjob3
>> write_iops_log=3D4k-4k_randwrite_0_rd_qd256_numjob3
>>
>> [4k-4k_randwrite_0_rd_qd256_numjob4]
>> bs=3D4k
>> ba=3D4k
>> iodepth=3D64
>> offset=3D300g
>> rw=3Drandwrite
>> randrepeat=3D0
>> norandommap
>> refill_buffers
>> log_avg_msec=3D1000
>> unified_rw_reporting=3D1
>> write_bw_log=3D4k-4k_randwrite_0_rd_qd256_numjob4
>> write_iops_log=3D4k-4k_randwrite_0_rd_qd256_numjob4
>> #################################################
>>
>>
>> Thanks,
>> Prabhu
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__vger.kernel.org_ma=
jordomo-2Dinfo.html&d=3DDwIBaQ&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNElu=
Z8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3D0gTEIsl_-d0HQ0ndt8ua9fiIR5Kigo0mnZKBy3Fr=
qS0&s=3DNZyL5aNn-frWDTJuCfS7XH7peqTcbHBIGubxUH6A0DM&e=3D
>
>
>
>
> --
> Tim Walker
> Product Design Systems Engineering, Seagate Technology
>



--=20
Thanks,
Prabhakaran
