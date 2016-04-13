Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:33451 "EHLO
	mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933686AbcDMFi4 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 13 Apr 2016 01:38:56 -0400
Received: by mail-vk0-f68.google.com with SMTP id v68so4995876vka.0
        for <fio@vger.kernel.org>; Tue, 12 Apr 2016 22:38:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <759ED0CCB4AB7D4A897D03A711E4EC4C6F772A98@MX204CL02.corp.emc.com>
References: <759ED0CCB4AB7D4A897D03A711E4EC4C6F771F72@MX204CL02.corp.emc.com>
	<CALjAwximeyPand181Q71B9f0CJgXcFHNGTBheTk2MGQkaf5+dQ@mail.gmail.com>
	<759ED0CCB4AB7D4A897D03A711E4EC4C6F772A98@MX204CL02.corp.emc.com>
Date: Wed, 13 Apr 2016 06:38:54 +0100
Message-ID: <CALjAwxhzP3XrEapHjEK4uY4vYpc0PYBwEE=OTUXFfpgH+eKbMA@mail.gmail.com>
Subject: Re: random writes with different patterns
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Foley, Robert" <robert.foley@emc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 11 April 2016 at 14:54, Foley, Robert <robert.foley@emc.com> wrote:
>
> Thanks for the information about the %o option.
>
> On Saturday, April 09, 2016 1:00 AM, Sitsofe Wheeler [mailto:sitsofe@gmail.com] wrote:
>>>  You could always force a particular pattern to be put into every block by using verify_pattern (https://github.com/axboe/fio/blob/fio-2.8/HOWTO#L1407) and use it's %o option for generating more sophisticated patterns. Another choice would be to change the block size otherwise you're going to struggle to work out what "run" the pattern in the block came from.
>
> I apologize for not mentioning before that we have use cases with compression where we cannot use a repeating pattern.  The %o seems to allow the pattern to vary between blocks, but within the block the pattern repeats.   We really appreciate the use of the randomly generated data bytes by fio.
>
>>>We had some ideas around how to solve this if it is not currently supported.   It might be useful to have an optional "verify_io_stamp" parameter, which would specify a simple 32 or 64 bit integer that could get added to and verified with the verify_header.
>
>>Might you be able to do this by creating a particular verify pattern and specifying a custom header format?
>
> We could create a new verify pattern with a custom header format.  That would give us the ability to save and validate this verify_io_stamp parameter.   But it seems we would lose the ability to specify the different validation types (md5, crc64, crc32, etc).
>
> We really appreciate the flexibility of fio in being able to use different validation types (md5, crc64, crc32, etc) along with randomly generated data, and we would like to leverage those options along with the ability to specify a new verify_io_stamp.  Adding a new parameter for verify_io_stamp seems like the best option to achieve this, but we would appreciate more thoughts or ideas here.

Some sort of "generation" id in the header would allow better
verification when using something like loops (assuming it was being
incremented on a per iteration basis). Perhaps what is needed is some
sort of verify_header_extra_pattern that allows a few extra bytes to
be set in the header and verified later...

However this doesn't seem to solve your entire problem as I understood
it: given the same randseed you want the ability for the same blocks
to be written in the same order but with different pseudorandom data
contents? Further this data must be verifiable in a separate job?
Would changing the buffer_compress_percentage option do?

-- 
Sitsofe | http://sucs.org/~sits/
