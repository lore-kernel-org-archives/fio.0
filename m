Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] two patches
References: <20190911145640.30005-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b4cd876e-f4bc-59a0-5aab-021570be2b45@kernel.dk>
Date: Wed, 11 Sep 2019 09:00:36 -0600
MIME-Version: 1.0
In-Reply-To: <20190911145640.30005-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 9/11/19 8:56 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> Jens, please consider these two patches.
> 
> The first is a simple documentation fix, whereas the second has
> filesetup.c:setup_files() honor the offset option in one additional
> case.

Thanks Vincent, both look good. Applied.

-- 
Jens Axboe


