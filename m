Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:39333 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdKVXfd (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Nov 2017 18:35:33 -0500
Received: by mail-pf0-f181.google.com with SMTP id l24so12737163pfj.6
        for <fio@vger.kernel.org>; Wed, 22 Nov 2017 15:35:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145791EDDCE1E1F98FB2D4CD8F200@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <CAPqbHXh=+CXA1+Y0mmHbDmJauu53h6AmFNWW8ASWViP-LxKiEw@mail.gmail.com>
 <BN3PR0401MB145791EDDCE1E1F98FB2D4CD8F200@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Prabhakaran <prabhugce@gmail.com>
Date: Wed, 22 Nov 2017 16:35:32 -0700
Message-ID: <CAPqbHXj_N20pBvC3fvrsUS7eYH9oGRhhwmG4L6YZPrr=gdHMMA@mail.gmail.com>
Subject: Re: Running for a specific number of IOs
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jeff,

I wanted to generate ~1 billion IOs irrespective of runtime/size. I
think with your example, fio would break, if it reaches 'number_ios',
before it comes to end of first fill. With my example shown below, fio
exits after reaching size=100%, which I have not specified in my job
file.

[global]
ioengine=libaio
clat_percentiles=1
percentile_list=50.0:95.0:99.0:99.5:99.9:99.99:99.999:99.9999:99.99999:99.999999:99.9999999
disable_slat=1
disable_lat=1
disable_clat=1
thread
cpus_allowed=0-7
cpus_allowed_policy=split
direct=1


[4k-4k_100_rd_qd32]
stonewall
bs=4k
ba=4k
iodepth=32
number_ios=10000000000
rw=randread
log_avg_msec=1000
randrepeat=0
norandommap
refill_buffers
write_bw_log=4k-4k_100_rd_qd32
write_iops_log=4k-4k_100_rd_qd32

Thanks,
Prabhu

On 22 November 2017 at 16:06, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> What parameters are you using?  Here is a counterexample from a previous post that shows number_ios running and then the job terminating:
>
> fio --name=test_job --ioengine=libaio --direct=1 --rw=read --iodepth=1 --size=100% --bs=4k --filename=/dev/nvme1n1 --number_ios=8
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Prabhakaran
> Sent: Wednesday, November 22, 2017 2:47 PM
> To: fio@vger.kernel.org
> Subject: Running for a specific number of IOs
>
> Hi,
>
> Is there a parameter in FIO that can be used to run for a specific number of IOs? I thought 'number_ios' might to this, but actually it does fill 1x of the drive usable space and exits.
>
> Thanks,
> Prabhu
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
Prabhakaran
