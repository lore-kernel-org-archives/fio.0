Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] engines: add engine for file stat
References: <925A83423110DA4D836092D40AC7A7E8085CB462@APYOKXMS108.ap.sony.com>
 <CALjAwxhtdp3zJisFDdXt4no2hHwFKktuDNEMEV5EZN7fo=mL4Q@mail.gmail.com>
 <SG2PR04MB2492F64F703104122008D211FD520@SG2PR04MB2492.apcprd04.prod.outlook.com>
 <CALjAwxjd9u+DLLOmf7reEtnkX=wL=vqK0dpCTq3cFHdVN0z7dg@mail.gmail.com>
 <027dde15-1c6a-47a5-f89b-0d808d4cd1f3@kernel.dk>
 <SG2PR04MB24924423F87B356C30A9AF54FD3E0@SG2PR04MB2492.apcprd04.prod.outlook.com>
 <HK0PR04MB2388DC18A61F0D5483D72BE8FD0D0@HK0PR04MB2388.apcprd04.prod.outlook.com>
 <56461733-2fef-6faa-ac60-2436bf7d692d@kernel.dk>
 <HK0PR04MB23886E2661C532F057030540FD0C0@HK0PR04MB2388.apcprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <613a7d9e-4a0f-1b89-128d-5da7cf4390e2@kernel.dk>
Date: Wed, 22 Jan 2020 08:32:25 -0700
MIME-Version: 1.0
In-Reply-To: <HK0PR04MB23886E2661C532F057030540FD0C0@HK0PR04MB2388.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Su, Friendy" <Friendy.Su@sony.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, "Kobayashi, Kento (Sony)" <Kento.A.Kobayashi@sony.com>
List-ID: <fio@vger.kernel.org>

On 1/21/20 8:07 PM, Su, Friendy wrote:
> This engine is to measure performance of accessing file's meta data.
> This is for the actual access pattern which does not do real IO, but
> just look up the file and get file's attribute.

Applied, just one minor fixup:

> +	if (f->filetype != FIO_TYPE_FILE) {
> +		log_err("fio: only files are supported fallocate \n");
> +		return 1;
> +	}

Not sure where this fallocate came from, too much copy paste perhaps?

-- 
Jens Axboe


