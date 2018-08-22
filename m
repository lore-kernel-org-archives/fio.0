Return-Path: <bvanassche@acm.org>
Subject: Re: Zoned block device regression test 11
References: <a6d3d008-3a44-9d42-2c0c-b26ca9d92d3a@acm.org>
 <CY4PR21MB07732B0B200EAB77AAB4F737DC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <CY4PR21MB07731302C97CFA7EF56BBA1CDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <8907fd89-a0ba-39c4-35a0-a267e24a57f6@kernel.dk>
 <CY4PR21MB0773D0F69E91EA2BD4B34FAFDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <1918a5c7-d8a1-e19f-e71f-2ad376e0f95b@acm.org>
 <CY4PR21MB0773B46B04D9FCFF10F898DFDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <b995c191-e6c6-469b-9f6c-05f08d63683e@acm.org>
Date: Wed, 22 Aug 2018 12:54:36 -0700
MIME-Version: 1.0
In-Reply-To: <CY4PR21MB0773B46B04D9FCFF10F898DFDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>, Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 08/22/18 12:04, Michael Kelley (EOSG) wrote:
> One more question:  What's the preferred source for the zbc_* commands?
> I built from https://github.com/hgst/libzbc, but get this runtime failure:
> 
> root@MHKfio2:~# zbc_report_zones /dev/nullb0
> Device /dev/nullb0:
>      Vendor ID: FAKE HGST HM libzbc
>      Emulated zoned block device interface, Host-managed zone model
>      2097152 512-bytes sectors
>      262144 logical blocks of 4096 B
>      262144 physical blocks of 4096 B
>      1.074 GB capacity
>      Read commands are restricted
>      Maximum number of open sequential write required zones: 32
> zbc_report_nr_zones at 0, ro 0x00 failed -6

Hello Michael,

Thank you for having started to look quickly into what I had reported. 
After I had reported the behavior change I started looking myself into 
this and I think that I have found the root cause (which is not in the 
axmap code). I will continue working on this and will keep you posted.

Bart.


