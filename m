Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/6] zbd cleanup, small fixes and zoneskip support
References: <20190829072135.2872-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <242d2305-d21a-c273-675c-65dc6961c8c9@kernel.dk>
Date: Thu, 29 Aug 2019 06:31:09 -0600
MIME-Version: 1.0
In-Reply-To: <20190829072135.2872-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/29/19 1:21 AM, Damien Le Moal wrote:
> The first 5 patches of this series are small cleanups and fixes to the
> zone block device code (zbd.c) and man page documentation.
> 
> The last patch of this series implements zoneskip option support for
> zonemode=zbd in response to field customers request wanting to
> test/qualify very large capacity SMR disks without having to do
> full-pack read/write of the entire disk capacity, while retaining the
> convenience of the auomatic handling of zone write pointer alignment and
> zone reset of this mode (as opposed to the zonemode=strided mode).
> 
> The zoneskip option support for zonemode=zbd applies only to sequential
> read/write workloads, allowing to skip zoneskip bytes once the current
> zone of a job has been fully written or read. The zoneskip value must be
> zone aligned.

Applied, thanks Damien.

-- 
Jens Axboe


