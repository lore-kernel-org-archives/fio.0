Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Subject: Re: [PATCH 00/15] ZBD fixes and improvements
References: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <4e35b427-c7df-f744-3c11-8e301e83999d@acm.org>
Date: Fri, 20 Nov 2020 20:01:15 -0800
MIME-Version: 1.0
In-Reply-To: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 11/20/20 6:45 PM, Dmitry Fomichev wrote:
> This patch series contains bug fixes and refactoring changes
> related to support for Zoned Block Devices (ZBD) in fio.
> The highlights:
> 
>  - fix several errors related to running workloads that span
>    a mix of conventional zones and write pointer zones.
>  - improve counting of sectors with data (SWD).
>  - remove dependencies on particular zone types in the code.
>  - add code to gracefully handle offline zones.

Hi Dmitry,

This patch series looks interesting. Out of curiosity, do you perhaps
know how much of the modified code is covered by the tests in t/zbd?

Thanks,

Bart.

