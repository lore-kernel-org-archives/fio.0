Return-Path: <axboe@kernel.dk>
Subject: Re: what is the sample logger doing when the buffer fills up?
References: <CAF+0mvnTM6Rv3Vh1oOZd=9TQ1wVtWWrHMVkbKxdisufiYvZ0Zw@mail.gmail.com>
 <BN3PR0401MB14573F44F190D9B11CCF836FF7080@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <805ada82-a3be-5b0f-226c-258d7e6f7711@kernel.dk>
 <CAJ9yE1CXNBvGFnJ1FNnodRKanXrqMgEfJsBrCz1dXBcNq4Qwxg@mail.gmail.com>
 <BN3PR0401MB1457787C3D5632BD79FFFC5BF7090@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CAJ9yE1AYiuwX2tZbybqQw25YtGC8U40_JRz_iFQWypei_EVcMg@mail.gmail.com>
 <BN3PR0401MB1457883E34BC695500DEAF57F7090@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <20160722144702.GA7328@kernel.dk>
 <87c24164-a129-c6cd-b9bf-49ae52f7034f@kernel.dk>
 <39517e39-daeb-29ed-a4e3-8d5e759d9382@kernel.dk>
 <BN3PR0401MB14578638FC8BA420D42FACFCF70A0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <587a3a61-3cfc-0e29-21bb-4a5f77a2c5ae@kernel.dk>
 <52bca033-7898-8a86-7266-11fa64016412@kernel.dk>
 <BN3PR0401MB14575C9A18FA75A34F69B838F70A0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b54aac68-13dd-a78b-a671-99aee462710b@kernel.dk>
Date: Fri, 22 Jul 2016 13:49:01 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14575C9A18FA75A34F69B838F70A0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: Karl Cronburg <kcronbur@redhat.com>, Matthew Eaton <m.eaton82@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/22/2016 01:40 PM, Jeff Furlong wrote:
> Excellent.  My test job is working great, and I created a few more job variations that also work great.  Thanks for the help.

Sweet! I've tagged 2.13 with the changes, to kill this issue off. Thanks 
for testing and reporting.

-- 
Jens Axboe


