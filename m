Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] idle-prof: Fix segment fault issue when run with
 '--idle-prof' and multiple output format normal,json
References: <925A83423110DA4D836092D40AC7A7E8084BAA4F@APYOKXMS108.ap.sony.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dc0afa2f-3880-39a0-0b69-cf95fefa831f@kernel.dk>
Date: Thu, 7 Jun 2018 20:28:21 -0600
MIME-Version: 1.0
In-Reply-To: <925A83423110DA4D836092D40AC7A7E8084BAA4F@APYOKXMS108.ap.sony.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Friendy.Su@sony.com, fio@vger.kernel.org
Cc: No.Tanaka@sony.com, Hajime.Tomura@sony.com
List-ID: <fio@vger.kernel.org>

On 6/5/18 10:17 PM, Friendy.Su@sony.com wrote:
> Original issue:
> 
> ./fio --output-format=normal,json --idle-prof=system jobfile.job
> 
> job1: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=sync, iodepth=1
> fio-3.7-19-ga43f
> Starting 1 process
> Segmentation fault (core dumped)
> 
> Fix solution:
> 
> do fio_idle_prof_cleanup() after all formats of output shown.

Patch looks good, applied, thanks!

-- 
Jens Axboe


