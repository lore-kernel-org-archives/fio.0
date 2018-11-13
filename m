Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f181.google.com ([209.85.166.181]:52184 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbeKNJ1y (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Nov 2018 04:27:54 -0500
Received: by mail-it1-f181.google.com with SMTP id m34-v6so21130134iti.1
        for <fio@vger.kernel.org>; Tue, 13 Nov 2018 15:27:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxg130qgxbCqV5Nhd=cef4FbTT7OKiXL7h6Fn0GiQUKGcQ@mail.gmail.com>
References: <CAFF4W0Vv3uqbXhfW4+jBHtvg+F2HGt_D78AXfiTN3ROpsg38_g@mail.gmail.com>
 <CALjAwxgcSO0BCei4LEXLunpQ+gCqL_1Q_wXtEYC_HvyiYbrS_w@mail.gmail.com>
 <CAFF4W0UyzTe5BgFM-T97oHwmBPJ-_C_nZVFiYYrBfJS-m7EM=A@mail.gmail.com> <CALjAwxg130qgxbCqV5Nhd=cef4FbTT7OKiXL7h6Fn0GiQUKGcQ@mail.gmail.com>
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Wed, 14 Nov 2018 04:57:19 +0530
Message-ID: <CAFF4W0VJ5ebVkrcsBu1hju-1JkBo8qtAi+xoukrm-wH5wjNwsw@mail.gmail.com>
Subject: Re: Understanding offset modifier
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Thanks Sitsofe

On 11/13/18, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> (You just restated your original question verbatim which unfortunately
> doesn't move the problem forward. I was hoping you were going to point
> out the exact specific part of the offset modifier concept you were
> struggling with by using a worked example to show what you did
> understand and which part you didn't so we could expand on just that.
> I'll take a stab at explaining things this time but next time try and
> be specific and briefly demonstrate what bits you did understand if
> you're asked for clarification :-)
>
> I'm just going to quote some text because "offset" in a different
> context refers to another option:
>
> From
> https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-readwrite :
> "It is possible to specify the number of I/Os to do before getting a
> new offset by appending :<nr> to the end of the string given. For a
> random read, it would look like rw=randread:8 for passing in an offset
> modifier with a value of 8. If the suffix is used with a sequential
> I/O pattern, then the <nr> value specified will be added to the
> generated offset for each I/O turning sequential I/O into sequential
> I/O with holes. For instance, using rw=write:4k will skip 4k for every
> write. Also see the rw_sequencer option."
>
> So in the above the "offset modifier/suffix" has two different meanings:
> - With random I/O, the offset suffix is saying "do <nr> I/Os
> sequentially before randomly* picking another starting point and then
> doing another <nr> I/Os sequentially"
> - With sequential I/O the offset suffix refers to the "distance to
> skip between I/Os"
>
> Seen another way, depending on context the offset modifier is
> controlling the "the offset (distance) chosen from the first allowable
> position for I/O before doing sequential I/O" or the "offset
> (distance) from the end of the previous I/O".
>
> (Note: I'm skipping over the effect of rw_sequencer in the above to
> keep this discussion shorter)
>
> As to your second question, for many jobs so long as I use the same
> job options verification should work with an offset modifier. For
> example:
>
> fio --name=gappy_verify --size=512k --filename=/tmp/fio.tmp
> --rw=write:4k --verify=crc32c
>
> wrote every other 4k and then verified it. If you're splitting up your
> verifies into separate jobs for some reason, you may find the
> verify_only and do_verify options useful (see
> https://fio.readthedocs.io/en/latest/fio_doc.html#verification ).
>
> Does this help at all?
>
> * This is a simplification but it gives you the idea.
>
> On Tue, 13 Nov 2018 at 01:20, Mohanraj B <bmohanraj91@gmail.com> wrote:
>>
>> Hi,
>>
>> Thanks for the response.
>>
>> I have gone through and worked out the example.
>> Below are my queries:
>> what is offset?
>> How to verify the results if used the :<nr> at the end of the string ?
>>
>> Thanks and Regards,
>> Mohan
>>
>> On 11/7/18, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> > Hi,
>> >
>> > On Wed, 7 Nov 2018 at 11:31, Mohanraj B <bmohanraj91@gmail.com> wrote:
>> >>
>> >> Hello all,
>> >>
>> >>
>> >> https://fio.readthedocs.io/en/latest/fio_man.html#i-o-type
>> >>
>> >> what is offset modifier, some please explain.
>> >> It is possible to specify the number of I/Os to do before getting a
>> >> new offset by appending :<nr> to the end of the string given.
>> >
>> > I guess you mean mean the rw <nr> parameter in the final paragraph in
>> > https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-readwrite
>> > . Can you say what part of that paragraph and the rw_sequencer section
>> > you are struggling to understand and did you work through the
>> > randread:8 and rw=write:4k examples?
>> >
>> > --
>> > Sitsofe | http://sucs.org/~sits/
>> >
>
> --
> Sitsofe | http://sucs.org/~sits/
>

