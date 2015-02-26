Return-Path: <axboe@kernel.dk>
Message-ID: <54EFAA24.8070603@kernel.dk>
Date: Thu, 26 Feb 2015 16:20:04 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: suggestion:  patch to make per-thread IOPS more accurate
References: <596106035.8980737.1421443175599.JavaMail.zimbra@redhat.com> <54B982D7.1070503@kernel.dk> <159806365.11854527.1422052704407.JavaMail.zimbra@redhat.com> <1745095866.10478940.1424039625224.JavaMail.zimbra@redhat.com> <54EF8E70.1000504@gmail.com>
In-Reply-To: <54EF8E70.1000504@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Mark Nelson <mark.a.nelson@gmail.com>, Ben England <bengland@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/26/2015 02:21 PM, Mark Nelson wrote:
> Hi Ben,
> 
> I confess that I'm not using JSON output myself, but I think this would
> be really beneficial when there are a lot of clients (like VMs).
> 
> Jens, would this be an acceptable change?  I think I'd appreciate this
> if I switch over to using the JSON output.

I like the change, my only worry is that it'll break somebody's
parsing... So from that end, perhaps it'd be better to add a new field
instead of reusing the 'iops' field to dump it.

Maybe I'm just being overly cautious here, feel free to tell me I'm wrong.

-- 
Jens Axboe


