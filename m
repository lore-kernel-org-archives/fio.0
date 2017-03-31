Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:36450 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdCaGZU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2017 02:25:20 -0400
Received: by mail-qt0-f174.google.com with SMTP id r45so57650530qte.3
        for <fio@vger.kernel.org>; Thu, 30 Mar 2017 23:25:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxiHDO0AwQWNYR4J_TL821hhbjn6J0Arm5p73t5dZotV3w@mail.gmail.com>
References: <CACqzM2CTN9w45owkjvoTR+Ca4QJFvM_MnOZE9+BU+dCxo2nuEQ@mail.gmail.com>
 <CALjAwxgZx+QHcM74ERtj1zUZo1r+aCfgCP8wnhNicJ01b768FA@mail.gmail.com>
 <CACqzM2AmmgacpGd+QVt42=SdqQrDENigb7TUs-x50iuD9KWt6Q@mail.gmail.com> <CALjAwxiHDO0AwQWNYR4J_TL821hhbjn6J0Arm5p73t5dZotV3w@mail.gmail.com>
From: Guruganesh Hegde <guruhegde4u@gmail.com>
Date: Fri, 31 Mar 2017 11:55:19 +0530
Message-ID: <CACqzM2AwbutwGND4PiC+EaH-DHCr=xQiz6HZTApAcjv8qNczxw@mail.gmail.com>
Subject: Re: numberio failure with numjobs=1
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks..
I will try that out

Regards,
Guru

On Fri, Mar 31, 2017 at 11:41 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> (Please use reply to all so mails continue going to the mailing list)
>
> On 31 March 2017 at 07:05, Guruganesh Hegde <guruhegde4u@gmail.com> wrote:
>> Thanks for the suggestions.
>>
>> I will tryout suggested tests and share the observations.
>>
>> The device which I am using is supporting only 4k block size, I will
>> not be able to try different block sizes, however I will try with
>> different sizes(1G or 256M etc).
>
> Bigger blocks that are still a multiple of 4Kbytes should work
> though... Further by default bsrange will only picks block sizes that
> are multiples of the minimum specified blocksize so bsrange=4k-64k
> should pick 4k, 8k, 16k, 32k, 64k (see
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-blocksize-range
> ). Is that clearer?
>
> --
> Sitsofe | http://sucs.org/~sits/
