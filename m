Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
In-Reply-To: <552DB434.2060709@kernel.dk>
References: <1429052300-9822-1-git-send-email-dehrenberg@chromium.org>
	<1429052300-9822-3-git-send-email-dehrenberg@chromium.org>
	<552DB434.2060709@kernel.dk>
Date: Wed, 15 Apr 2015 10:49:01 -0700
Message-ID: <CAAK6Zt27UwQrKiqLf_DEAsUsMKrUYPSdSASBoE0q-yQ8wizwMg@mail.gmail.com>
Subject: Re: [PATCH 2/7] Add new writetrim rw= mode for trims preceding writes
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

Thanks for the quick feedback. This should be fixed in v2. What do you think?

On Tue, Apr 14, 2015 at 5:43 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/14/2015 04:58 PM, Dan Ehrenberg wrote:
>>
>> In this new mode, sequential trims and writes are interspersed by first
>> doing a trim at a particular offset, then doing writes starting from
>> that offset until the start of the next trim block, then another trim,
>> etc. This workload is designed to match the requirements of NAND flash,
>> if trims are implemented as erases.
>
>
> At first I found this a little confusing, but now I get it. It's a bit
> different to what other mixed workloads would be. Perhaps rename it to
> 'trimwrite'? Also needs adding to the man page and HOWTO.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

