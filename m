Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] revert/rework 81647a9a('fix load_ioengine() not to
 support no "external:" prefix')
References: <20170901195412.119846-1-tkusumi@tuxera.com>
 <20170901195412.119846-2-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0d69e46c-ee6f-3630-d767-af22d0b92165@kernel.dk>
Date: Fri, 1 Sep 2017 13:58:58 -0600
MIME-Version: 1.0
In-Reply-To: <20170901195412.119846-2-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 09/01/2017 01:54 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> We have decided to revert 81647a9a, which disallowed loading an external
> ioengine without using (explicitly documented)"external:" prefix.

Thanks, applied.

-- 
Jens Axboe


