Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: don't read past the WP on a read only workload with
 verify
References: <20200813150148.14655-1-niklas.cassel@wdc.com>
 <MN2PR04MB595192579EC087B4C9EAECE1E1550@MN2PR04MB5951.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0fc74fa5-69e8-7675-84bd-526a7ca11227@kernel.dk>
Date: Thu, 27 Aug 2020 12:27:52 -0600
MIME-Version: 1.0
In-Reply-To: <MN2PR04MB595192579EC087B4C9EAECE1E1550@MN2PR04MB5951.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/27/20 12:09 PM, Dmitry Fomichev wrote:
> + Jens... and ping for this patch, I believe it has two reviews by now.

Yep sorry about that, I missed it. Applied, thanks!

-- 
Jens Axboe


