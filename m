Return-Path: <axboe@kernel.dk>
Message-ID: <5320B85C.7070806@kernel.dk>
Date: Wed, 12 Mar 2014 13:41:16 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: ioengine=sync issue on Windows
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com> <53208C60.8090708@kernel.dk> <07a59dd29eae446f83d85387bff2a130@BLUPR04MB467.namprd04.prod.outlook.com> <5320B15F.1060401@kernel.dk> <bd155da4787d49eb88221a9cc7f4612a@BLUPR04MB467.namprd04.prod.outlook.com> <5320B5E6.7010902@kernel.dk> <749c722481744d36883cdd77210a41be@BLUPR04MB467.namprd04.prod.outlook.com> <5320B7BC.3090801@kernel.dk>
In-Reply-To: <5320B7BC.3090801@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <BCran@fusionio.com>, =?ISO-8859-1?Q?S=E9bastien_Bouchex?= =?ISO-8859-1?Q?_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/12/2014 01:38 PM, Jens Axboe wrote:
> On 03/12/2014 01:36 PM, Bruce Cran wrote:
>> Oh, I see - that works.   Though the existing code also does with the
>> removal of
>  > 'tmp' from FIO_STATUS_FILE - Windows defines both TMP and TEMP
> environment variables.
>
> So the getenv() works fine on Windows? If so, I can clean it up some more.

Queued this up:

http://git.kernel.dk/?p=fio.git;a=commit;h=dac45f23c3c7d146f7df82047ae7f25abf231ed3

-- 
Jens Axboe


