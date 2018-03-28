Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37902 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752894AbeC1Vyr (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Mar 2018 17:54:47 -0400
Subject: Re: Status of python3 for fio?
References: <e2032302-c19a-0e4a-2a44-ecb03807b7e7@redhat.com>
 <CALjAwxiaPJ5aY5qLew_e=q9XkY5U0KVJQaEYf5Wzat9yRg65VQ@mail.gmail.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ac16b031-394b-0342-5ab5-4acad7ace5a8@redhat.com>
Date: Wed, 28 Mar 2018 16:54:46 -0500
MIME-Version: 1.0
In-Reply-To: <CALjAwxiaPJ5aY5qLew_e=q9XkY5U0KVJQaEYf5Wzat9yRg65VQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 3/28/18 11:17 AM, Sitsofe Wheeler wrote:
> Hi,
> 
> On 28 March 2018 at 16:45, Eric Sandeen <sandeen@redhat.com> wrote:
>> Fedora is moving more and more towards python3.  (TBH, as a non-python
>> expert, I don't know all the details...)
>>
>> I see that python2.7 is hardcoded in several scripts, and Jens though
>> there were possibly some patches "floating out there" to switch
>> the various scripts to python3.  Does anyone know the status of
>> this work?
> 
> fiologparser_hist.py was made Python 3 compatible but it's unknown
> whether all the other scripts are as ready (I'm going to guess no). The
> hope is that eventually all scripts will be made Python 3 ready but it
> will be up to distros to rename the interpreter to use to one they
> like at packaging time because it's impossible to satisfy all distros
> with a single interpreter line...
> 
> You can see the rationale behind the python2.7 rename here:
> https://github.com/axboe/fio/commit/60023ade47e7817db1c18d9b7e511839de5c2c99
> and here: https://www.spinics.net/lists/fio/msg06746.html (and a
> followup here
> https://www.spinics.net/lists/fio/msg06748.html ).

Ok, thanks.  So, I'm going to try using the automated tools to make them
python3-compatible.

I'm no python guru, so I hope that if I take a semi-dumb approach and send
patches it'll at least be a starting point, if not perfect.

Thanks,
-Eric
