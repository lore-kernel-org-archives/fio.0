Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 00/11] Improve io_uring and libaio IO priority support
References: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9af3c84b-22fe-7586-e3d9-b4d7433ec427@kernel.dk>
Date: Fri, 3 Sep 2021 10:12:47 -0600
MIME-Version: 1.0
In-Reply-To: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 9/3/21 9:20 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> This series improves io_uring/libaio engine support for IO priority,
> adding options to allow for mixed priority workloads to be specified
> more easily and to match the kernel supported IO priority features.
> 
> This series is based on Damien's V1 series which can be found here:
> https://www.spinics.net/lists/fio/msg09614.html

Applied, thanks.

-- 
Jens Axboe


