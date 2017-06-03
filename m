Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:32803 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdFCNa3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 3 Jun 2017 09:30:29 -0400
Received: by mail-oi0-f54.google.com with SMTP id s3so28854471oia.0
        for <fio@vger.kernel.org>; Sat, 03 Jun 2017 06:30:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxijEdKcRWM_+OfDsouOJoeTcL0h47ci+QzvVxp7CQRbAA@mail.gmail.com>
References: <CANKF+jinANtsmA0XEP_dZ9F-sLxq+QE5zH-i2urEPotm+6W3WQ@mail.gmail.com>
 <CALjAwxijEdKcRWM_+OfDsouOJoeTcL0h47ci+QzvVxp7CQRbAA@mail.gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Sat, 3 Jun 2017 16:29:47 +0300
Message-ID: <CAHndrBnbkstq5L01Qi2Fhb5BoG_E=UbWPMM6=J8Rqk3h6d3uqQ@mail.gmail.com>
Subject: Re: unit testing for fio?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Brantley West <cbwest@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi

2017-06-03 16:07 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
> On 2 June 2017 at 20:30, Brantley West <cbwest@gmail.com> wrote:
>>
>> I'm looking to adopt fio for some storage testing in the near future
>> and have noticed a few issues (#377, #378) that seem to be
>> math-related.  Assuming these issues get fixed, it seems like unit
>> testing would help ensure they stay fixed.  Additionally, fio has a
>> lot of useful configuration options, and unit tests seem like a good
>> way to test for expected operation when multiple configuration
>> parameters are present.
>>
>> Is a unit test framework something that is worth considering for fio?
>> If so, are there any preferences?  It seems there are multiple options
>> (check, cunit, unity, etc).
>
> I think it would be useful if there was an explicit make selftest
> target for fio which could do more rigorous checks than my "does it
> run?" make test. fio has the odd adhoc test (e.g.
> https://github.com/axboe/fio/tree/master/unit_tests ) and now I look I
> spy the odd test for checking certain job files for regressions too
> (see https://github.com/axboe/fio/tree/master/t/jobs ). It would be
> nice to run these and more via CI (travis/appveyor) on commit though
> (assuming they finish quickly)...
>
> Some pieces of fio have been broken out into standalone programs (see
> some of them in https://github.com/axboe/fio/tree/master/t/ ) which
> might make testing for correctness easier. Perhaps Tomohiro Kusumi
> (who has made pieces of fio more standalone) will be able to make
> suggestions?

Yes.
Things under os/ arch/ lib/ oslib/ are mostly stand-alone utility
functions now (i.e. you can include them or link to them via your
main()), so those are probably easy to do unit testing using cunit or
variants.

Others more or less have dependencies on fio itself (and there isn't
anything wrong with that too), so those are not as easy, or maybe
depends on what you mean by unit testing.

>
> Personally I've used cunit (via the libiscsi project) but I've never
> compared all C unit test frameworks. Further, the fio build doesn't
> seem to add many dependencies on other libraries (other than for I/O
> engines)...
>
> Way back in 2008 there was a proposal to add a "make check" to fio
> (http://maillist.kernel.dk/fio-devel/0584.html ) which looked like it
> was readily accepted but it's unclear whether something was actually
> produced...
>
> If you've got any pre-existing checks please post/link them!
>
> PS: Do you find fio useful at Nutanix and are there any other public
> I/O exercisers you folks use?
>
> --
> Sitsofe | http://sucs.org/~sits/
