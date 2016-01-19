Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0124.hostedemail.com ([216.40.44.124]:59552 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755517AbcASAk4 convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 18 Jan 2016 19:40:56 -0500
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: How to stress a 8Gbps card to get 500 000 IOPS or 1600 MB/s
From: David Nellans <david@nellans.org>
In-Reply-To: <CAM8G_BJ22QGD3jgKO3i2HXjEpi4He_eUegAr+XDPPO-AYU_5xg@mail.gmail.com>
Date: Mon, 18 Jan 2016 18:40:53 -0600
Content-Transfer-Encoding: 8BIT
Message-Id: <DA15262B-D52B-4FF3-B8A9-079073DEC874@nellans.org>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com> <56840F80.4060903@kernel.dk> <VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com> <5684A8F1.6010105@kernel.dk> <VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com> <CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com> <VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com> <CANvN+e=X09zp=HRme4Wwad2_HhmNkOQkL8zXGWozuVWCm+NMYg@mail.gmail.com> <VI1PR05MB1343810AF909BB41065666C9B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com> <CANvN+e=cxWLEnu3Ve7RQKTh4TQubWMzkt0fkZ_AyKbNPAt21QQ@mail.gmail.com> <VI1PR05MB13430232A50B8818A220B23DB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com> <CANvN+emwcrcVpuGsHBuNiw28WDKyyuNQvVd7G3QJFuy5siXqYw@mail.gmail.com> <VI1PR05MB13431DA43361FC9F4F55FC95B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com> <VI1PR05MB1343E7E335FA4E27991FD523B1C00@VI1PR05MB1343.eurprd05.prod.outlook.com> <941
 9CB2F-E2A7-453F-A5CE-88533306BC00@nellans.org> <CAM8G_BJ22QGD3jgKO3i2HXjEpi4He_eUegAr+XDPPO-AYU_5xg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>
Cc: Thierry BERTAUD <tbertaud@conforama.fr>, "fio@vger.kernel.org" <fio@vger.kernel.org>

agree with vasu - assuming you're trying to hit numbers a vendor spec'd however on a flash drive of some sort.

you're doing random writes which is also tough on some flash drive if they're into write amplification. try changing to random reads and you only need a couple of threads (with a depth of 128 each) to generate enough iodepth to saturate most drives. 64 threads might be more threads than you have CPUs to run them so you're switching which also hurts performance

> On Jan 18, 2016, at 6:33 PM, Kulkarni, Vasu <vasu.kulkarni@gmail.com> wrote:
> 
> Well IOPS/througput is also dependent on the physical drive as well,
> HBA alone is not sufficient to get those rates, you will need a
> SSD/NVMe device to get very high IOPS as well. your harddrive
> will have IOPS and max range you should check that.
> 
>> On Mon, Jan 18, 2016 at 4:15 PM, David Nellans <david@nellans.org> wrote:
>> you have two typos in your config that will likely result in less than sufficient iodepth to hit 500k IOPS. check if those are in your actual config or not...
>> 
>>> On Jan 18, 2016, at 5:58 PM, Thierry BERTAUD <tbertaud@conforama.fr> wrote:
>>> 
>>> Hello fio team,
>>> 
>>> I tryed to stress my 8 Gbps hba with fio wit a lot of case:
>>> I know that the hba card is capable of 500 000 IOPS or get data rate neat that 8 Gbps (1600 MB/sec).
>>> i tried to change block size, iodepth, numjobs, iodepth but idon't have good resulut. (42000 IOPS and throughput 162 MB/s).
>>> 
>>> Below fio conf:
>>> [global]
>>> thread
>>> numjobs=1
>>> iodepth=1
>>> group_reporting
>>> bs=4k
>>> norandommap=1
>>> refill_buffers
>>> direct=1
>>> ioengine=posixaio
>>> runtime=300
>>> time_based
>>> filename=/dev/hdisk6
>>> log_avg_msec=1000
>>> [randwrite_64_64]
>>> rw=randwrite
>>> numjobs=64
>>> ioepth=64
>>> stonewal
>>> 
>>> 
>>> 
>>> Regards,
>>> Thierry--
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> A ship is safer in a harbor.  But that's not what ships are built for.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
