Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v6 0/3] Add a new parameter and fix minimal rate
 calculation.
References: <cover.1611578199.git.glqinhongwei@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <981898a4-43a0-633d-23f0-fc8d340c1589@kernel.dk>
Date: Tue, 26 Jan 2021 08:59:04 -0700
MIME-Version: 1.0
In-Reply-To: <cover.1611578199.git.glqinhongwei@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Hongwei Qin <glqinhongwei@gmail.com>, fio@vger.kernel.org
Cc: sitsofe@gmail.com
List-ID: <fio@vger.kernel.org>

On 1/25/21 5:39 AM, Hongwei Qin wrote:
> v4 -> v6:
> 	Use lower case thinktime_blocks in help.
> 	Modify fio.1 accordingly.
> 
> v3 -> v4:
> 	Use uint32_t for thinktime_blocks_type.
> 	The tests in patch1 has been re-verified.
> 
> v3:
> 	The first patch adds a new parameter thinktime_blocks_type
> 	to control the behavior of thinktime_blocks.
> 	It can be either `complete` or `issue`.
> 	If it is `complete` (default), fio triggers thinktime when
> 	thinktime_blocks number of blocks are **completed**.
> 	If it is `issue`, fio triggers thinktime when thinktime_blocks
> 	number of blocks are **issued**
> 
> 	The second patch updates the compare time if handle_thinktime
> 	sleeps or spin.

Applied, folding patch 3 into patch 1.

-- 
Jens Axboe


