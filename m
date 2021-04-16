Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v4 1/1] engines: add engine for file delete
References: <PU1PR04MB23909EA73FD1006DE2D5D8D5FD4E9@PU1PR04MB2390.apcprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <fe3ec0cd-c6a8-1158-bd0c-a665a0ea9279@kernel.dk>
Date: Fri, 16 Apr 2021 05:57:12 -0600
MIME-Version: 1.0
In-Reply-To: <PU1PR04MB23909EA73FD1006DE2D5D8D5FD4E9@PU1PR04MB2390.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Friendy.Su@sony.com, fio@vger.kernel.org
Cc: sitsofe@gmail.com, Kento.A.Kobayashi@sony.com, Wataru.Aoyama@sony.com
List-ID: <fio@vger.kernel.org>

On 4/13/21 9:57 PM, Friendy.Su@sony.com wrote:
> This engine is to measure the performance of deleting files.
> 
> In practice, it is an important benchmark for a file system that
> how quick it can release the disk space of deleted files.

Applied, thanks.

-- 
Jens Axboe


