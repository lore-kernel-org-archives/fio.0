Return-Path: <axboe@kernel.dk>
Subject: Re: Zoned block device regression test 11
References: <a6d3d008-3a44-9d42-2c0c-b26ca9d92d3a@acm.org>
 <CY4PR21MB07732B0B200EAB77AAB4F737DC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <CY4PR21MB07731302C97CFA7EF56BBA1CDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8907fd89-a0ba-39c4-35a0-a267e24a57f6@kernel.dk>
Date: Wed, 22 Aug 2018 09:48:34 -0600
MIME-Version: 1.0
In-Reply-To: <CY4PR21MB07731302C97CFA7EF56BBA1CDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>, Bart Van Assche <bvanassche@acm.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/22/18 9:47 AM, Michael Kelley (EOSG) wrote:
> Any special configuration needed to run this test?    Any options needs on
> command line?  I figured out to enable CONFIG_BLK_DEV_ZONED, but
> now I get the following on my 4.18.3 kernel:
> 
> root@MHKfio2:~# ./fio/t/zbd/run-tests-against-zoned-nullb
> ./fio/t/zbd/run-tests-against-zoned-nullb: line 27: ./fio/t/zbd/test-zbd-support: No such file or directory
> 
> /sys/kernel/config/nullb/nullb0/* and /dev/nullb0 are present as expected.

You need current -git from Linus, the zoned null_blk support was added
after 4.18.

-- 
Jens Axboe


