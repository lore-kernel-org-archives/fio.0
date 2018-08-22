Return-Path: <axboe@kernel.dk>
Subject: Re: Zoned block device regression test 11
References: <a6d3d008-3a44-9d42-2c0c-b26ca9d92d3a@acm.org>
 <CY4PR21MB07732B0B200EAB77AAB4F737DC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <CY4PR21MB07731302C97CFA7EF56BBA1CDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <8907fd89-a0ba-39c4-35a0-a267e24a57f6@kernel.dk>
 <CY4PR21MB0773D0F69E91EA2BD4B34FAFDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8b834df5-0e58-d012-d9c3-b040ea6c4925@kernel.dk>
Date: Wed, 22 Aug 2018 11:05:44 -0600
MIME-Version: 1.0
In-Reply-To: <CY4PR21MB0773D0F69E91EA2BD4B34FAFDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>, Bart Van Assche <bvanassche@acm.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/22/18 10:54 AM, Michael Kelley (EOSG) wrote:
> From: Jens Axboe <axboe@kernel.dk> Sent: Wednesday, August 22, 2018 8:49 AM
>>
>> On 8/22/18 9:47 AM, Michael Kelley (EOSG) wrote:
>>> Any special configuration needed to run this test?    Any options needs on
>>> command line?  I figured out to enable CONFIG_BLK_DEV_ZONED, but
>>> now I get the following on my 4.18.3 kernel:
>>>
>>> root@MHKfio2:~# ./fio/t/zbd/run-tests-against-zoned-nullb
>>> ./fio/t/zbd/run-tests-against-zoned-nullb: line 27: ./fio/t/zbd/test-zbd-support: No such file or
>> directory
>>>
>>> /sys/kernel/config/nullb/nullb0/* and /dev/nullb0 are present as expected.
>>
>> You need current -git from Linus, the zoned null_blk support was added
>> after 4.18.
> 
> So grab the linux-next tree, or are you referring to something else?  In my
> 4.18.3 tree, the source file drivers/block/null_blk_zoned.c is there and builds.

Just grab Linus's tree, for instance. 4.18.3 does definitely not have support
for zoned null_blk, and null_blk_zoned.c should not exist. It was introduced
by this commit:

commit ca4b2a011948fae4e4d31490107db4926385a983
Author: Matias Bjørling <matias.bjorling@wdc.com>
Date:   Fri Jul 6 19:38:39 2018 +0200

    null_blk: add zone support

which is not in 4.18. So either your sources are messed up, or something else
funky is going on at your end.

-- 
Jens Axboe


