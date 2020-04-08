Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: Fix build errors on Windows and MacOS
References: <20200408015426.1609539-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <fd18ee51-3e2a-19d4-5eff-d03a2ee3f6c2@kernel.dk>
Date: Tue, 7 Apr 2020 19:21:09 -0700
MIME-Version: 1.0
In-Reply-To: <20200408015426.1609539-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>
List-ID: <fio@vger.kernel.org>

On 4/7/20 6:54 PM, Damien Le Moal wrote:
> Including dirent.h is not needed, so remove it to avoid a compilation
> error on Windows and MacOS. Also make sure that EREMOTEIO is defined as
> some OSes do not have this error code.

Applied, thanks.

-- 
Jens Axboe


