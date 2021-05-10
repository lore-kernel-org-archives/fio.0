Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] oslib/linux-blkzoned: make sure that we always support
 zone capacity
References: <20210506131827.68407-1-Niklas.Cassel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <da0ff0d5-081b-6f58-0b36-3684a33eb8ea@kernel.dk>
Date: Mon, 10 May 2021 09:25:56 -0600
MIME-Version: 1.0
In-Reply-To: <20210506131827.68407-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-ID: <fio@vger.kernel.org>

On 5/6/21 7:18 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> A common problem is that users upgrade their kernel to support NVMe ZNS
> devices, however, they still use the kernel uapi headers provided by their
> distro.
> 
> This means that even if the kernel will populate the zone capacity fields
> for each zone in the zone report returned by the ioctl, fio will not know
> how to interpret that data.
> 
> This leads to fio writing past the zone capacity, which will lead to
> I/O errors.
> 
> It is not trivial for a user to realize that the kernel uapi headers
> provided by their distro is the reason for these I/O errors.
> 
> In order to make it easier for these users, provide a copy of the current
> zoned block device kernel uapi structs.
> 
> If the kernel uapi headers installed on the system are too old to support
> zone capacity, use the locally defined structs instead.
> If the installed headers are new enough to support zone capacity, use the
> installed headers.
> 
> This way, fio will always be able to handle zone capacity (if the kernel
> supports it). At the same time, we will not redefine any structs from the
> installed headers if they are newer than our locally defined structs.

Applied, thanks.

-- 
Jens Axboe


