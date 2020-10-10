Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] simplify MB/s, IOPS interactive printout code
References: <20201010143510.GA1131765@localhost.localdomain>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6b33d29a-38fa-63b4-75b8-62bb1ef60950@kernel.dk>
Date: Sat, 10 Oct 2020 10:55:06 -0600
MIME-Version: 1.0
In-Reply-To: <20201010143510.GA1131765@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/10/20 8:35 AM, Alexey Dobriyan wrote:
> Use loops(!) instead of hardcoded if-else pairs.
> 
> Make it easier to add DDIR_APPEND.

Applied, thanks.

-- 
Jens Axboe


