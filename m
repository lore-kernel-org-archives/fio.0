Return-Path: <axboe@kernel.dk>
Subject: Re: json output and normal output in different files?
References: <nogkhs$qkp$1@blaine.gmane.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <120b7e84-d3da-09cc-f835-2cf12e81b7b9@kernel.dk>
Date: Thu, 11 Aug 2016 16:11:09 -0600
MIME-Version: 1.0
In-Reply-To: <nogkhs$qkp$1@blaine.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Saeed <ionictea@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/10/2016 07:31 PM, Saeed wrote:
> Is there a way to enable json output from within a job file and still
> fio have outputting as normal?

You can certainly enable both (--output-format=json,normal), but there's
no way to send it to different files.

-- 
Jens Axboe

