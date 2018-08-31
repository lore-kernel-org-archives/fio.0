Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] client: fix nr_samples
References: <MWHPR04MB0320E9310CC7A95563EB30698F0F0@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e88a8fbd-53a8-2bb5-5d9d-7594def23e9a@kernel.dk>
Date: Fri, 31 Aug 2018 12:44:21 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB0320E9310CC7A95563EB30698F0F0@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8/31/18 12:26 PM, Jeff Furlong wrote:
> In convert_iolog_gz() a 32 bit variable is created to store struct cmd_iolog_pdu's 64 bit member.

Applied, thanks.

-- 
Jens Axboe


