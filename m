Return-Path: <axboe@kernel.dk>
Message-ID: <5320B15F.1060401@kernel.dk>
Date: Wed, 12 Mar 2014 13:11:27 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: ioengine=sync issue on Windows
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com> <53208C60.8090708@kernel.dk> <07a59dd29eae446f83d85387bff2a130@BLUPR04MB467.namprd04.prod.outlook.com>
In-Reply-To: <07a59dd29eae446f83d85387bff2a130@BLUPR04MB467.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <BCran@fusionio.com>, =?ISO-8859-1?Q?S=E9bastien_Bouchex?= =?ISO-8859-1?Q?_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/12/2014 12:02 PM, Bruce Cran wrote:
> It turns out this is unrelated, but in stat.c the following change should probably be made:
>
> -#define FIO_STATUS_FILE                "/tmp/fio-dump-status"
> +#define FIO_STATUS_FILE                "fio-dump-status"
>

How about we make that use os_get_tmpdir() instead?

-- 
Jens Axboe


