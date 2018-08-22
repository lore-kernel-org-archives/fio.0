Return-Path: <bvanassche@acm.org>
Subject: Re: Zoned block device regression test 11
References: <a6d3d008-3a44-9d42-2c0c-b26ca9d92d3a@acm.org>
 <CY4PR21MB07732B0B200EAB77AAB4F737DC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <CY4PR21MB07731302C97CFA7EF56BBA1CDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <8907fd89-a0ba-39c4-35a0-a267e24a57f6@kernel.dk>
 <CY4PR21MB0773D0F69E91EA2BD4B34FAFDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <1918a5c7-d8a1-e19f-e71f-2ad376e0f95b@acm.org>
Date: Wed, 22 Aug 2018 10:04:16 -0700
MIME-Version: 1.0
In-Reply-To: <CY4PR21MB0773D0F69E91EA2BD4B34FAFDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 08/22/18 09:54, Michael Kelley (EOSG) wrote:
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

My advice is to grab Linus' latest tree 
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/). 
Linus' tree works fine on my test setups but I have not yet tested 
linux-next. You need the following two commits that are not yet in 
kernel v4.18:
* ca4b2a011948 ("null_blk: add zone support")
* 76f17d8ba1cb ("block: Rename the null_blk_mod kernel module back into 
null_blk")

Bart.


