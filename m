Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix residual size
References: <MWHPR04MB03206BA957345969502C3CCC8F320@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0a916033-3959-0794-b9b7-c669194079e8@kernel.dk>
Date: Tue, 21 Aug 2018 09:16:28 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB03206BA957345969502C3CCC8F320@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8/20/18 5:25 PM, Jeff Furlong wrote:
> If we target a number of bytes of IO and keep subtracting a
> xfer_buflen, we need to ensure the residual length is of the same
> size.

Thanks, applied.

-- 
Jens Axboe


