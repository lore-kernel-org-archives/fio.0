Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANKF+jiVEr9kwVQNc8k80mPgcj=tcoSnP85Tj_0m=8X=xz4HeQ@mail.gmail.com>
References: <CANKF+jinANtsmA0XEP_dZ9F-sLxq+QE5zH-i2urEPotm+6W3WQ@mail.gmail.com>
 <CALjAwxijEdKcRWM_+OfDsouOJoeTcL0h47ci+QzvVxp7CQRbAA@mail.gmail.com>
 <CAHndrBnbkstq5L01Qi2Fhb5BoG_E=UbWPMM6=J8Rqk3h6d3uqQ@mail.gmail.com> <CANKF+jiVEr9kwVQNc8k80mPgcj=tcoSnP85Tj_0m=8X=xz4HeQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 14 Jun 2017 07:17:46 +0100
Message-ID: <CALjAwxh04SMjgGhb-9FqLC6mqfS6tRoELerJQen4BVZ-3pDzZA@mail.gmail.com>
Subject: Re: unit testing for fio?
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Brantley West <cbwest@gmail.com>, Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Resending thread explicitly to Jens (thread may be difficult to read
because we have both top and bottom posting)...

On 7 June 2017 at 21:52, Brantley West <cbwest@gmail.com> wrote:
> @vincentfu I'm in the same boat, not familiar with the features and
> caveats of the different options to make an informed recommendation at
> present.
>
> @sitsofe I agree, I think a `make unittest` that is incorporated into
> CI would be wonderful.  Even better - if it generates a code/branch
> coverage report.  Other projects I'm involved with require unit
> testing to provide code & branch coverage for any modified code before
> being merged.  I think a similar strategy would be beneficial,
> however, I'm the least likely to be impacted by such a change in a
> process.  At Nutanix different groups use different tools for
> performance testing and validation, and it depends on who you talk to.
> I've been a heavy Vdbench user (great tool), but am at a crossroads
> where I'm reevaluating tools for a future project.  fio's open
> development process is very appealing to me.
>
> If time allows, I'll test drive a few unit testing frameworks and
> respond on thread w/ my branch.
>
> Jens, do you have any thoughts you can share?
>
> -bw
> C. Brantley West, III
> cbwest@gmail.com
>
>
> On Sat, Jun 3, 2017 at 9:29 AM, Tomohiro Kusumi
> <kusumi.tomohiro@gmail.com> wrote:
>> Hi
>>
>> 2017-06-03 16:07 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
>>> On 2 June 2017 at 20:30, Brantley West <cbwest@gmail.com> wrote:
>>>>
>>>> I'm looking to adopt fio for some storage testing in the near future
>>>> and have noticed a few issues (#377, #378) that seem to be
>>>> math-related.  Assuming these issues get fixed, it seems like unit
>>>> testing would help ensure they stay fixed.  Additionally, fio has a
>>>> lot of useful configuration options, and unit tests seem like a good
>>>> way to test for expected operation when multiple configuration
>>>> parameters are present.
>>>>
>>>> Is a unit test framework something that is worth considering for fio?
>>>> If so, are there any preferences?  It seems there are multiple options
>>>> (check, cunit, unity, etc).
>>>
>>> I think it would be useful if there was an explicit make selftest
>>> target for fio which could do more rigorous checks than my "does it
>>> run?" make test. fio has the odd adhoc test (e.g.
>>> https://github.com/axboe/fio/tree/master/unit_tests ) and now I look I
>>> spy the odd test for checking certain job files for regressions too
>>> (see https://github.com/axboe/fio/tree/master/t/jobs ). It would be
>>> nice to run these and more via CI (travis/appveyor) on commit though
>>> (assuming they finish quickly)...
>>>
>>> Some pieces of fio have been broken out into standalone programs (see
>>> some of them in https://github.com/axboe/fio/tree/master/t/ ) which
>>> might make testing for correctness easier. Perhaps Tomohiro Kusumi
>>> (who has made pieces of fio more standalone) will be able to make
>>> suggestions?
>>
>> Yes.
>> Things under os/ arch/ lib/ oslib/ are mostly stand-alone utility
>> functions now (i.e. you can include them or link to them via your
>> main()), so those are probably easy to do unit testing using cunit or
>> variants.
>>
>> Others more or less have dependencies on fio itself (and there isn't
>> anything wrong with that too), so those are not as easy, or maybe
>> depends on what you mean by unit testing.
>>
>>>
>>> Personally I've used cunit (via the libiscsi project) but I've never
>>> compared all C unit test frameworks. Further, the fio build doesn't
>>> seem to add many dependencies on other libraries (other than for I/O
>>> engines)...
>>>
>>> Way back in 2008 there was a proposal to add a "make check" to fio
>>> (http://maillist.kernel.dk/fio-devel/0584.html ) which looked like it
>>> was readily accepted but it's unclear whether something was actually
>>> produced...
>>>
>>> If you've got any pre-existing checks please post/link them!
>>>
>>> PS: Do you find fio useful at Nutanix and are there any other public
>>> I/O exercisers you folks use?

-- 
Sitsofe | http://sucs.org/~sits/

