Return-Path: <bruce@cran.org.uk>
Subject: Re: Windows Make Broken
References: <BN3PR0401MB14571048CD0CFE7699E18400F7C30@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <56A1536A.6060308@cran.org.uk> <56A1AD7C.3060802@kernel.dk>
 <56A271EF.6040401@cran.org.uk> <56A279E4.8090209@kernel.dk>
 <56A2A6DB.2090802@cran.org.uk> <56A2A940.9000105@kernel.dk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <56A2AAA3.3020208@cran.org.uk>
Date: Fri, 22 Jan 2016 15:18:11 -0700
MIME-Version: 1.0
In-Reply-To: <56A2A940.9000105@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 1/22/16 3:12 PM, Jens Axboe wrote:

> I think you earlier added it in the cygwin section. We need to kill that
> one, not the generic one, since that would fail on systems not providing
> strcasestr().
>
> http://git.kernel.dk/cgit/fio/commit/?id=ada83043abcb94dde7c603ce60ae8de9693a022f

Ah, that's it - thanks!

-- 
Bruce


