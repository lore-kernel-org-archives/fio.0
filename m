Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36215 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbcDIFE4 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 9 Apr 2016 01:04:56 -0400
Received: by mail-vk0-f53.google.com with SMTP id c4so160260498vkb.3
        for <fio@vger.kernel.org>; Fri, 08 Apr 2016 22:04:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <759ED0CCB4AB7D4A897D03A711E4EC4C6F771F72@MX204CL02.corp.emc.com>
References: <759ED0CCB4AB7D4A897D03A711E4EC4C6F771F72@MX204CL02.corp.emc.com>
Date: Sat, 9 Apr 2016 06:04:54 +0100
Message-ID: <CALjAwxiECbcbTzrDv6QY2zUjq3j5TBQaHLSiZi7MuDsGOUnpqw@mail.gmail.com>
Subject: Re: random writes with different patterns
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Foley, Robert" <robert.foley@emc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 8 April 2016 at 21:01, Foley, Robert <robert.foley@emc.com> wrote:
>
> Suppose at time A we wrote out a pattern using the parameters above.  Later at time B we would like to write the same blocks (offsets) of the test area but with a different pattern of data bytes.  Our understanding is that randseed will seed the generation of both a) the pattern of I/O blocks that we generate as well as b) the pattern of data in the buffers we are writing.  In other words since the randseed controls both a) and b), there is no way for us to get a different data pattern written to the same pattern of blocks (offsets).

You could always force a particular pattern to be put into every block
by using verify_pattern
(https://github.com/axboe/fio/blob/fio-2.8/HOWTO#L1407 ) and use its
%o option for generating more sophisticated patterns. Another choice
would be to change the block size otherwise you're going to struggle
to work out what "run" the pattern in the block came from.

> Does anyone know how to accomplish this with fio?
>
> We had some ideas around how to solve this if it is not currently supported.   It might be useful to have an optional "verify_io_stamp" parameter, which would specify a simple 32 or 64 bit integer that could get added to and verified with the verify_header.

Might you be able to do this by creating a particular verify pattern
and specifying a custom format using %o?

-- 
Sitsofe | http://sucs.org/~sits/
