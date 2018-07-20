Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-db5eur01on0046.outbound.protection.outlook.com ([104.47.2.46]:60480
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732219AbeGTQjG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Jul 2018 12:39:06 -0400
Subject: Re: FIO mixed tests with different patters and block sizes
References: <c574a91d-0d38-03d8-dc44-37f5662a6e52@cern.ch>
 <MWHPR04MB03206430AD9D3A7258A28E758F530@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Adam Abed Abud <adam.abed.abud@cern.ch>
Message-ID: <0667051b-3cd5-a3f7-6555-edd9b4eba055@cern.ch>
Date: Fri, 20 Jul 2018 17:50:08 +0200
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB03206430AD9D3A7258A28E758F530@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Thank you it worked with both access patterns and blocksizes!


On 18/07/18 19:44, Jeff Furlong wrote:
>> I'm using FIO for testing some distributed file systems and I am interested in running a single test where I have a mix of both reading and writing. The problem is that I want to have different access patterns (e.g. sequential writing and random reading) and different block sizes. How can I run such a job?
> I recently went through a similar exercise.  Several options allow for read/write/trim settings to be unique.  For example, consider setting the percentage_random to 100 for reads and 0 for writes:
>
> fio --name=rr_sw --ioengine=libaio --direct=1 --rw=randrw --norandommap --randrepeat=0 --filename=/dev/nvme0n1 --runtime=10s --time_based --percentage_random=100,0
>
> You can use the same concept for blocksize and invoke rwmixread to further control the amount of reads/writes.
>
> Regards,
> Jeff
>
>

