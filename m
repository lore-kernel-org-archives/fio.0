Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Add fill_quota option
References: <20200811194445.GA152146@dione.lan>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d3b41f1b-5bd7-a9f2-5511-7a6062aaa5bf@kernel.dk>
Date: Fri, 28 Aug 2020 17:53:34 -0600
MIME-Version: 1.0
In-Reply-To: <20200811194445.GA152146@dione.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Martin Bukatovic <martin.bukatovic@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/11/20 1:44 PM, Martin Bukatovic wrote:
> Option fill_quota causes fio to write until EDQUOT occurs (assuming rw=write),
> in the same way as fill_device option makes fio to write until ENOSPC.

Might be easier and saner to just accept EDQUOT by default, instead of
adding an option for it?

-- 
Jens Axboe


