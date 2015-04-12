Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35776 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbbDLKMY (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 12 Apr 2015 06:12:24 -0400
Received: by widdi4 with SMTP id di4so40706150wid.0
        for <fio@vger.kernel.org>; Sun, 12 Apr 2015 03:12:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxg5Sq-VkpBe+4+nK3PdgpGKpVDF3eEacGauWYVKbYtJYQ@mail.gmail.com>
References: <CANt18PxHj5p6f9gXsuKCRDNXwgo_nW0MwD0wM6QbYENBtJd1ww@mail.gmail.com>
 <CALjAwxjUF7R=GbynqFgj5-1D6F-133oQDXvqv5nPKQKaQ0k=yw@mail.gmail.com>
 <CANt18PyJoE7e-MqafAD=oYZfo5x0r2gwnvMsF7VXTE3=mwCm2A@mail.gmail.com>
 <CALjAwxiEv6jd5GuRC2rQsdaiGWZmku_tzS0-qQbQxe_RvVAT=A@mail.gmail.com>
 <CALjAwxhti4K021uqXVAOt53Cr=mbPz0V1Q7q32vPfgW3byAo2g@mail.gmail.com>
 <CANt18PzSgzy7zVOXuY26iz9gH=tnTLZiKSE=i=pGxAWrxgVq6g@mail.gmail.com> <CALjAwxg5Sq-VkpBe+4+nK3PdgpGKpVDF3eEacGauWYVKbYtJYQ@mail.gmail.com>
From: Samuel Shapiro <samuel.sh79@gmail.com>
Date: Sun, 12 Apr 2015 13:12:02 +0300
Message-ID: <CANt18PxZvp4LBDnXEujJc4GSogpsvhP+cu=j=VDPN4-=8+91+Q@mail.gmail.com>
Subject: Re: during fio scenario with verify=meta some jobs fails
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks for the great answer Sitsofe :)
Will stick to md5 verification while testing FS data integrity.

Thanks
Samuel

On Sun, Apr 12, 2015 at 1:06 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 11 April 2015 at 17:48, Samuel Shapiro <samuel.sh79@gmail.com> wrote:
>> Thanks Sitsofe,
>> It make sense, if previous block meta isn't really saved....
>> So maybe the right question to ask,  in which scenarios should I prefer
>> "meta" verification method over "md5" etc...?
>
> Without looking at the source I would guess they will catch different
> issues and have different overheads.
>
> For example, if I use md5 I write a header to each "block" that tells
> me what the data should be. When it comes to verification time I read
> the header and check the body matches the checksum. Reading the body
> and calculating the checksum take time and CPU. If the error is that
> two blocks of the same size (including their headers) have been
> switched I won't catch that because the checksum of the body is still
> correct with respect to the header (this is speculation on my part)...
>
> If I use meta my header contains things like timestamp, block number,
> io sequence number. I don't need to spend time verifying the body and
> unless I used verify_pattern I don't even know what the correct data
> in the body would look like if I were to check/checksum it. I can
> detect identically sized block swaps because the block number and io
> sequence number in the header will be wrong. If a problem is detected
> I've got a better chance of working out where the problem header came
> from (because more meta data is available to me).
>
> If I'm using same sized blocks and I'm worried about entire block
> swaps or I want to do a minimal a check as possible I think you could
> use meta. If I'm more worried about sub block sized data being wrong I
> would say you are better off with one of the checksum routines
> (preferably one that is hardware accelerated). If I'm overwriting my
> data within the same pass and I probably can't use meta any more. meta
> may give me more information about where bad data came from if the
> header is intact and I know how to decode it. However, this is all
> speculation on my part!
>
> --
> Sitsofe | http://sucs.org/~sits/
